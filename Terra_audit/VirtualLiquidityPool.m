classdef VirtualLiquidityPool < handle
    %VIRTUAL LIQUIDITY POOL model

    properties
        T_stable Token
        T_volatile Token
        P_volatile double
        Delta double
        K double
        BasePool double {mustBeNonnegative}
        PoolRecoveryPeriod {mustBeNonnegative}
        MinSpread double {mustBeNonnegative, mustBeLessThan(MinSpread, 1)} = 0
        RestoreValues double
    end

    methods
        function pool = VirtualLiquidityPool(varargin)
            % VirtualLiquidityPool() Construct an instance of this class
            pool.T_stable = varargin{1};
            pool.T_volatile = varargin{2};
            pool.P_volatile = varargin{3};
            pool.BasePool = varargin{4};
            pool.PoolRecoveryPeriod = varargin{5};
            if nargin > 5
                pool.MinSpread = varargin{6};
            end

            pool.Delta = 0;
            pool.K = pool.BasePool^2;
            pool.RestoreValues = zeros(1, pool.PoolRecoveryPeriod);
        end

        function [outToken, outQuantity] = swap(self, token, quantity)
            % Performs a swap operation within the virtual pool
            outQuantity = self.computeSwapValue(token, quantity);

            if token.is_equal(self.T_stable)
                outToken = self.T_volatile;
                self.updateDelta(quantity);
            elseif token.is_equal(self.T_volatile)
                outToken = self.T_stable;
                self.updateDelta(-outQuantity);
            else
                error("ERROR in swap()\nwrong token type");
            end
        end

        function restoreDelta(self)
            % Update delta value
            self.Delta = self.Delta - self.RestoreValues(1);
            self.RestoreValues(1) = 0;
            self.RestoreValues = circshift(self.RestoreValues, [0, -1]);
        end

        function updateDelta(self, deltaVariation)
            % Adjusts the Delta value based on swap activity
            self.Delta = self.Delta + deltaVariation;
            self.RestoreValues = self.RestoreValues + (deltaVariation / double(self.PoolRecoveryPeriod));
        end

        function updateDelta_improved(self, deltaVariation)
            % Ensure deltaVariation is a scalar double value
            deltaVariation = double(deltaVariation);
            assert(isscalar(deltaVariation), 'deltaVariation must be a scalar.');
        
            self.Delta = self.Delta + deltaVariation;
        
            % Ensure PoolRecoveryPeriod is an integer and calculate halfLength safely
            poolRecoveryPeriod = double(self.PoolRecoveryPeriod); % Ensure it's double for division
            halfLength = round(poolRecoveryPeriod / 2); % Ensures an integer result
        
            if (deltaVariation < 0.05 * self.BasePool)
                % Distribute equally across all RestoreValues
                self.RestoreValues = self.RestoreValues + (deltaVariation / poolRecoveryPeriod);
            else
                % Distribute across the first half, ensuring integer indexing
                distributeAmount = deltaVariation / halfLength;
                for i = 1:halfLength
                    self.RestoreValues(i) = self.RestoreValues(i) + distributeAmount;
                end
            end
        end

        function resetReplenishingSystem(self)
            % Resets the Delta and RestoreValues to their initial state
            self.Delta = 0;
            self.RestoreValues = zeros(1, self.PoolRecoveryPeriod);
        end

        function outQuantity = computeSwapValue(self, token, quantity)
            % Compute the output value for a swap of specified quantity
            if (quantity < 0)
                error("ERROR in swap()\nswap quantity cannot be negative");
            end

            poolStable = self.BasePool + self.Delta;
            poolVolatile = self.K * (1 / self.P_volatile) / (poolStable);

            if token.is_equal(self.T_stable)
                outQuantity = poolVolatile - self.K * (1 / self.P_volatile) / ((poolStable + quantity));
            elseif token.is_equal(self.T_volatile)
                outQuantity = poolStable - self.K * (1 / self.P_volatile) / ((poolVolatile + quantity));
            else
                error("ERROR in swap()\nwrong token type");
            end
        end

        function updateVolatileTokenPrice(self, newPrice)
            % Update volatile token price (oracles)
            self.P_volatile = newPrice;
        end
    end
end
