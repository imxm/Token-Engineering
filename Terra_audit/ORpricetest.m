% Load the simulation results file if not already in the workspace
load('simulation_results_collateral.mat', 'results_P_a');

% Assuming each cell contains a vector of prices, we can iterate and plot them
figure; % Create a new figure
hold on; % Hold on to plot multiple lines
for i = 1:numSimulations
    plot(results_P_a{i}); % Plot the price data from each simulation
end
hold off;

% Add title and labels
title('Token A Price Simulation Results');
xlabel('Iteration');
ylabel('Price of Token A');
