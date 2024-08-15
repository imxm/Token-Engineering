classdef Algo < handle
    % Algorithmic stablecoin system simulation

    properties
        T_a Token
        T_b Token
        USDC Token
        FreeT_a double
        TotalT_a double
        FreeT_b double
        TotalT_b double
        InitialT_bPrice double
        PoolStable LiquidityPool
        PoolVolatile LiquidityPool
        VirtualPool VirtualLiquidityPool
        BaseVirtualPool double
        PoolRecoveryPeriod int32
        NumberOfIterations int64
        ExpRate double = 0.0001
        Sigma double = 0.0001
        PoolFee double = 0.003
        WalletDistribution_stable WalletBalanceGenerator
        WalletDistribution_volatile WalletBalanceGenerator
        PurchaseGenerator_poolStable PurchaseGenerator
        PurchaseGenerator_poolVolatile PurchaseGenerator
        TotalReserves double
    end

    methods
        function simulation = Algo(varargin)
            simulation.T_a = varargin{1};
            simulation.T_b = varargin{2};
            simulation.InitialT_bPrice = varargin{3};
            simulation.TotalT_a = varargin{4};
            simulation.TotalT_b = varargin{5};
            simulation.FreeT_a = varargin{6};
            simulation.FreeT_b = varargin{7};
            simulation.BaseVirtualPool = varargin{8};
            simulation.PoolRecoveryPeriod = varargin{9};
            simulation.NumberOfIterations = varargin{10};
            if nargin > 10
                simulation.ExpRate = varargin{11};
                if nargin > 11
                    simulation.PoolFee = varargin{12};
                    if nargin > 12
                        simulation.Sigma = varargin{13};
                    end
                end
            end

            simulation.initializePools();
            simulation.initializeWalletDistributions(simulation.ExpRate);
            simulation.initializePurchaseGenerators();

            simulation.TotalReserves = simulation.TotalT_a * 0.2;
        end

        function initializePools(self)
            % create 2 pools (T_a - USDC and T_b - USDC) and one virtual
            % pool (T_a - T_b) for the seigniorage process

            Q_a = self.TotalT_a - self.FreeT_a;
            Q_b = self.TotalT_b - self.FreeT_b;
            Q_c = self.InitialT_bPrice * Q_b;

            self.USDC = Token("USDC", true, 1);
            self.PoolStable = LiquidityPool(self.T_a, self.USDC, Q_a, Q_a, ...
            self.PoolFee);
            self.PoolVolatile = LiquidityPool(self.T_b, self.USDC, Q_b, ...
            Q_c, self.PoolFee);

            basePool = self.BaseVirtualPool;
            poolRecoveryPeriod = self.PoolRecoveryPeriod;
            self.VirtualPool = VirtualLiquidityPool(self.T_a, self.T_b, ...
            self.PoolVolatile.getTokenPrice(self.T_b, 1), basePool, ...
            poolRecoveryPeriod);
        end

        function initializeWalletDistributions(self, expRate)
            % initialize 2 wallet distributions

            self.WalletDistribution_stable = ...
            WalletBalanceGenerator(self.TotalT_a, expRate);
            self.WalletDistribution_volatile = ...
            WalletBalanceGenerator(self.TotalT_b, expRate);
        end

        function initializePurchaseGenerators(self)
            % initialize 2 random purchase generators
            initialProbability = 0.5;
            self.PurchaseGenerator_poolStable = ...
            PurchaseGenerator(self.PoolStable, ...
            self.NumberOfIterations, initialProbability, self.Sigma, ...
            self.WalletDistribution_stable);
            self.PurchaseGenerator_poolVolatile = ...
            PurchaseGenerator(self.PoolVolatile, ...
            self.NumberOfIterations, initialProbability, self.Sigma, ...
            self.WalletDistribution_volatile);
        end

        function [T_aPrices, T_bPrices, probA, probB, delta, ...
        totalT_aSupply, totalT_bSupply, freeT_a, freeT_b, TotalReserves] = ...
        runSimulation(self)
            T_aPrices = zeros(self.NumberOfIterations, 1);
            T_bPrices = zeros(self.NumberOfIterations, 1);
            delta = zeros(self.NumberOfIterations, 1);
            totalT_aSupply = zeros(self.NumberOfIterations, 1);
            totalT_bSupply = zeros(self.NumberOfIterations, 1);
            freeT_a = zeros(self.NumberOfIterations, 1);
            freeT_b = zeros(self.NumberOfIterations, 1);
            TotalReserves = self.TotalReserves;

            % main loop
            for i = 1:self.NumberOfIterations

                self.stablePoolRandomPurchase();
                self.volatilePoolRandomPurchase();
                self.virtualPoolArbitrage();
                self.VirtualPool.restoreDelta();
                self.VirtualPool.updateVolatileTokenPrice(...
                self.PoolVolatile.getTokenPrice(...
                self.T_b, self.USDC.PEG));

                if (mod(i, 1000) == 0)
                    self.updateSigma(self.Sigma + 0.00002);
                end

                self.reserveIntervention();

                TotalReserves(i) = self.TotalReserves;

                delta(i) = self.VirtualPool.Delta;
                T_aPrices(i) = self.PoolStable.getTokenPrice(self.T_a, ...
                self.USDC.PEG);
                T_bPrices(i) = self.PoolVolatile.getTokenPrice(self.T_b, ...
                self.USDC.PEG);
                totalT_aSupply(i) = self.TotalT_a;
                totalT_bSupply(i) = self.TotalT_b;
                freeT_a(i) = self.FreeT_a;
                freeT_b(i) = self.FreeT_b;

            end

            probA = self.PurchaseGenerator_poolStable.P;
            probB = self.PurchaseGenerator_poolVolatile.P;

        end

        function stablePoolRandomPurchase(self)
            % stable pool random purchase
            [token, quantity] = ...
            self.PurchaseGenerator_poolStable.rndPurchase(self.FreeT_a, ...
            self.TotalT_a);

            T_aInPool_old = self.PoolStable.Q_a;
            self.PoolStable.swap(token, quantity);
            self.updateFreeT_a(T_aInPool_old);
        end

        function volatilePoolRandomPurchase(self)
            % volatile pool random purchase
            [token, quantity] = ...
            self.PurchaseGenerator_poolVolatile.rndPurchase(self.FreeT_b, ...
            self.TotalT_b);

            T_bInPool_old = self.PoolVolatile.Q_a;
            self.PoolVolatile.swap(token, quantity);
            self.updateFreeT_b(T_bInPool_old);
        end

        function out = virtualPoolArbitrage(self)
            % virtual pool arbitrage
            % The arbitrage operation is deterministic.
            % 1. a wallet is ramdomly choosen
            % 2. if there is an arbitrage opportunity, it is exploited
            % 3. the maximum amount of tokens used in the operation depends
            % on the balance of the wallet
            out = 0;
            [token, quantity] = self.getQuantityRelatedToMaxYield_grad();
            %[token, quantity] = self.getQuantityRelatedToMaxYield();
            if quantity > 0
                if token.is_equal(self.T_a)
                    walletBalance = ...
                    self.WalletDistribution_stable.rndWalletBalance();
                    [t, x] = self.PoolStable.swap(self.USDC, ...
                    min(quantity, walletBalance));
                    self.TotalT_a = self.TotalT_a - x;
                    [t, x] = self.VirtualPool.swap(t, x);
                    self.TotalT_b = self.TotalT_b + x;
                    [~, out] = self.PoolVolatile.swap(t, x);
                else
                    walletBalance = ...
                    self.WalletDistribution_volatile.rndWalletBalance();
                    [t, x] = self.PoolVolatile.swap(self.USDC, ...
                    min(quantity, walletBalance));
                    self.TotalT_b = self.TotalT_b - x;
                    [t, x] = self.VirtualPool.swap(t, x);
                    self.TotalT_a = self.TotalT_a + x;
                    [~, out] = self.PoolStable.swap(t, x);
                end
            end
        end

        function [token, quantity] = getQuantityRelatedToMaxYield(self)
            x = 1;
            q = 0;

            yield1 = self.getArbitrageYield1(x);
            while(yield1 > 0)
                x = x + 1;
                newYield1 = self.getArbitrageYield1(x);
                if yield1 > newYield1
                    q = x - 1;
                    break;
                end
                yield1 = newYield1;
            end

            yield2 = self.getArbitrageYield2(x);
            while(yield2 > 0)
                x = x + 1;
                newYield2 = self.getArbitrageYield2(x);
                if yield2 > newYield2
                    q = x - 1;
                    break;
                end
                yield2 = newYield2;
            end

            if(yield1 > yield2)
                token = self.T_a;
            else
                token = self.T_b;
            end
            quantity = q;
        end

        function [token, quantity] = getQuantityRelatedToMaxYield_grad(self)
            % Initialize variables
            x = 1;
            q = 0;
            learningRate = 10000; % Adjust the learning rate as needed
            epsilon = 1e-5; % Small value to check for convergence

            % Initial yield for the first opportunity
            yield1 = self.getArbitrageYield1(1);

            if yield1 > 0
                % Gradient descent loop for yield1
                while true
                    % Compute gradient for yield1
                    gradient = (self.getArbitrageYield1(x + epsilon*100) - yield1) / epsilon;

                    % Update x using gradient descent
                    x = x + 1 + learningRate * gradient;

                    if x < 1
                        x = 1;
                        learningRate = learningRate / 10;
                    end
                    % Update yield1 for the next iteration
                    newYield1 = self.getArbitrageYield1(x);

                    % Check for convergence
                    if abs(newYield1 - yield1) < epsilon
                        break;
                    end

                    % Update yield1 for the next iteration
                    yield1 = newYield1;
                end
                q = x;
            end

            % Initial yield for the first opportunity
            yield2 = self.getArbitrageYield2(1);

            if yield2 > 0
                % Gradient descent loop for yield2
                while true
                    % Compute gradient for yield2
                    gradient = (self.getArbitrageYield2(x + epsilon) - yield2) / epsilon;

                    % Update x using gradient descent
                    x = x + learningRate * gradient;
                    learningRate = learningRate - 0.1;

                    if x < 1
                        x = 1;
                        learningRate = learningRate / 10;
                    end
                    % Update yield2 for the next iteration
                    newYield2 = self.getArbitrageYield2(x);

                    % Check for convergence
                    if abs(newYield2 - yield2) < epsilon
                        break;
                    end

                    % Update yield2 for the next iteration
                    yield2 = newYield2;
                end
                q = x;
            end

            if(yield1 > yield2)
                token = self.T_a;
            else
                token = self.T_b;
            end
            quantity = q;
        end

        function yield = getArbitrageYield1(self, quantity)
            x = self.PoolStable.computeSwapValue(self.USDC, quantity);
            y = self.VirtualPool.computeSwapValue(self.T_a, x);
            USDC_out = self.PoolVolatile.computeSwapValue(self.T_b, y);
            yield = USDC_out - quantity;
        end

        function yield = getArbitrageYield2(self, quantity)
            x = self.PoolVolatile.computeSwapValue(self.USDC, quantity);
            y = self.VirtualPool.computeSwapValue(self.T_b, x);
            USDC_out = self.PoolStable.computeSwapValue(self.T_a, y);
            yield = USDC_out - quantity;
        end

        function updateFreeT_a(self, Q_a_prev)
            self.FreeT_a = self.FreeT_a - (self.PoolStable.Q_a - Q_a_prev);
        end

        function updateFreeT_b(self, Q_b_prev)
            self.FreeT_b = self.FreeT_b - (self.PoolVolatile.Q_a - Q_b_prev);
        end

        function updateSigma(self, newValue)
            if newValue < 0
                error("Sigma must be positive.");
            end
            self.Sigma = newValue;
            self.PurchaseGenerator_poolStable.setSigma(self.Sigma);
            self.PurchaseGenerator_poolVolatile.setSigma(self.Sigma);
        end

        function reserveIntervention(self)
            if (self.PoolStable.getTokenPrice(self.T_a, self.USDC.PEG) < ...
            self.T_a.PEG * 0.95)
                pool = self.PoolStable;
                s = (sqrt((0.95 + 4*pool.K) / 0.95) - 1) / 2;
                sellQuantity = (pool.K / s) - pool.Q_b;
                if (self.TotalReserves - sellQuantity > 0)
                    pool.swap(self.USDC, sellQuantity);
                    self.TotalReserves = self.TotalReserves - sellQuantity;
                else
                    pool.swap(self.USDC, self.TotalReserves);
                    self.TotalReserves = 0;
                end
            end
        end
    end
end
