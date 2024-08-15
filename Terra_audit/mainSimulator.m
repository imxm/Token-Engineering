numberOfIterations = 1000;
T_a = Token("TokenA", true, 1);
T_b = Token("TokenB");
initialT_bPrice = 100;
totalT_a = 10000000;
totalT_b = 10000000;
freeT_a = 8000000;
freeT_b = 8000000;
walletExpRate = 0.00003;
poolFee = 0.003;

% Define parameter values to iterate over
sigma_values = [0.0001, 0.0005, 0.001];
poolRecoveryPeriod_values = [24, 36, 48];
baseVirtualPool_values = [100000, 500000, 1000000];

% Number of simulations for each parameter combination
numSimulations = 10;

% Initialize cell arrays to store results
results_P_a = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_P_b = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_probA = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_probB = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_delta = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_totalT_aSupply = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_totalT_bSupply = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_freeT_a = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);
results_freeT_b = cell(length(sigma_values), length(poolRecoveryPeriod_values), length(baseVirtualPool_values), numSimulations);

% Initialize waitbar for progress display
totalSimulations = length(sigma_values) * length(poolRecoveryPeriod_values) * length(baseVirtualPool_values) * numSimulations;
progressBar = waitbar(0, 'Running Simulations...', 'Name', 'Simulation Progress');

% Nested loops to iterate over parameter values and run simulations
currentIteration = 0;
for i = 1:length(sigma_values)
    for j = 1:length(poolRecoveryPeriod_values)
        for k = 1:length(baseVirtualPool_values)
            for s = 1:numSimulations
                % Set current parameter values
                current_sigma = sigma_values(i);
                current_poolRecoveryPeriod = poolRecoveryPeriod_values(j);
                current_baseVirtualPool = baseVirtualPool_values(k);
                
                % Run simulation with current parameter values
                sim = AlgorithmicStablecoinSimulation(T_a, T_b, initialT_bPrice, totalT_a, totalT_b, freeT_a, freeT_b, current_baseVirtualPool, current_poolRecoveryPeriod, numberOfIterations, walletExpRate, poolFee, current_sigma);
                
                % Store results
                [results_P_a{i, j, k, s}, results_P_b{i, j, k, s}, results_probA{i, j, k, s}, results_probB{i, j, k, s}, results_delta{i, j, k, s}, results_totalT_aSupply{i, j, k, s}, results_totalT_bSupply{i, j, k, s}, results_freeT_a{i, j, k, s}, results_freeT_b{i, j, k, s}] = sim.runSimulation();
                
                % Update progress display
                currentIteration = currentIteration + 1;
                progress = currentIteration / totalSimulations;
                waitbar(progress, progressBar, sprintf('Simulation Progress: %.2f%%', progress * 100));
            end
        end
    end
end

% Save results to a MAT-file
save('simulation_results_collapse.mat', 'results_P_a', 'results_P_b', 'results_probA', 'results_probB', 'results_delta', 'results_totalT_aSupply', 'results_totalT_bSupply', 'results_freeT_a', 'results_freeT_b', 'sigma_values', 'poolRecoveryPeriod_values', 'baseVirtualPool_values', 'numSimulations', 'numberOfIterations');

% Close the progress bar
close(progressBar);
