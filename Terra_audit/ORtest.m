% Load the simulation results - adjust the file name as necessary
load('simulation_results_simplified.mat');

% Initialize an array to store the iteration number where the price falls below $0.5 for the first time in each simulation
firstBelowHalfIterations = zeros(numSimulations, 1);

% Iterate over each simulation in results_P_a
for s = 1:numSimulations
    % Access the price data for the current simulation
    priceData = results_P_a{s};
    
    % Find the iteration where the price falls below $0.5 for the first time
    belowHalfIdx = find(priceData < 0.5, 1, 'first');
    
    % Check if there is at least one occurrence
    if ~isempty(belowHalfIdx)
        firstBelowHalfIterations(s) = belowHalfIdx;
    else
        % If the price never falls below $0.5, we assign a placeholder value (e.g., -1)
        firstBelowHalfIterations(s) = -1;
    end
end

% Display the iteration number for each simulation
disp('Iteration where the price falls below $0.5 for the first time in each simulation:');
for s = 1:numSimulations
    if firstBelowHalfIterations(s) ~= -1
        fprintf('Simulation %d: %d\n', s, firstBelowHalfIterations(s));
    else
        fprintf('Simulation %d: Price never falls below $0.5\n', s);
    end
end
