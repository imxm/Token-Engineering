classdef WalletBalanceGenerator < handle
    % This is the random wallet balance generator
    % At every iteration of the simulation, one wallet is randomly
    % chosen. The wallet is represented by a double indicating the token
    % availability (this parameter is used to determine the maximum
    % spending capacity of the user)
    % An exponential distribution is used

    properties
        TotalTokenSupply double
        Rate double
        ExpDistribution % Exponential distribution
    end

    methods
        function walletDistribution = WalletBalanceGenerator(totalFreeTokenSupply, rate)
            % PARAMS
            % total free token supply - double
            % rate (for exponential distribution) - double

            walletDistribution.TotalTokenSupply = totalFreeTokenSupply;
            walletDistribution.Rate = rate;
            walletDistribution.ExpDistribution = walletDistribution.computeExponentialDistribution();
        end

        function randomWalletBalance = rndWalletBalance(self)
            % A wallet is randomly chosen
            randomWalletBalance = random(self.ExpDistribution, 1, 1);
        end

        function distr = computeExponentialDistribution(self)
            % Compute the exponential distribution with given rate
            distr = makedist('Exponential', 'mu', 1/self.Rate);
        end
    end
end
