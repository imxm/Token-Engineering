numberOfIterations = 100000;
T_a = Token("TokenA", true, 1);
T_b = Token("TokenB");
initialT_bPrice = 100;
totalT_a = 10000000;
totalT_b = 10000000;
freeT_a = 8000000;
freeT_b = 8000000;
walletExpRate = 0.00003;
poolFee = 0.003;

% Set single values for parameters instead of arrays
current_sigma = 0.0001; % Starting value value for sigma
current_poolRecoveryPeriod = 24; % Single value for poolRecoveryPeriod
current_baseVirtualPool = 100000; % Single value for baseVirtualPool

% Update number of simulations
numSimulations = 30;

% Predefine the size of results arrays for memory allocation efficiency
results_P_a = cell(numSimulations, 1);
results_P_b = cell(numSimulations, 1);
results_probA = cell(numSimulations, 1);
results_probB = cell(numSimulations, 1);
results_delta = cell(numSimulations, 1);
results_totalT_aSupply = cell(numSimulations, 1);
results_totalT_bSupply = cell(numSimulations, 1);
results_freeT_a = cell(numSimulations, 1);
results_freeT_b = cell(numSimulations, 1);

% Initialize waitbar for progress display with fewer updates
progressBar = waitbar(0, 'Running Simulations...', 'Name', 'Simulation Progress');
waitbarUpdateInterval = max(1, round(numSimulations / 100)); % Update the waitbar at most 100 times

for s = 1:numSimulations
    % Run simulation with current parameter values
    sim = AlgorithmicStablecoinSimulation(T_a, T_b, initialT_bPrice, totalT_a, totalT_b, freeT_a, freeT_b, current_baseVirtualPool, current_poolRecoveryPeriod, numberOfIterations, walletExpRate, poolFee, current_sigma);
    
    % Store results
    [results_P_a{s}, results_P_b{s}, results_probA{s}, results_probB{s}, results_delta{s}, results_totalT_aSupply{s}, results_totalT_bSupply{s}, results_freeT_a{s}, results_freeT_b{s}] = sim.runSimulation();
    
    % Efficiently update progress display
    if mod(s, waitbarUpdateInterval) == 0 || s == numSimulations
        waitbar(s / numSimulations, progressBar, sprintf('Simulation Progress: %.2f%%', s / numSimulations * 100));
    end
end

% Save results to a MAT-file
save('simulation_results_pr.mat', 'results_P_a', 'results_P_b', 'results_probA', 'results_probB', 'results_delta', 'results_totalT_aSupply', 'results_totalT_bSupply', 'results_freeT_a', 'results_freeT_b', 'current_sigma', 'current_poolRecoveryPeriod', 'current_baseVirtualPool', 'numSimulations', 'numberOfIterations');

% Close the progress bar
close(progressBar);
