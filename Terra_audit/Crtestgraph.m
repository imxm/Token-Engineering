% Assuming results_P_a is already loaded into the workspace
% If not, you can load it using:
% load('simulation_results_pr.mat', 'results_P_a');

% Determine the number of simulations based on the size of results_P_a
numSimulations = numel(results_P_a);

% Create a new figure for plotting
figure;
hold on; % Hold on to plot multiple lines on the same graph

% Loop through each simulation result contained in the cell array and plot it
for s = 1:numSimulations
    simulationData = results_P_a{s}; % Extract the vector for the current simulation
    plot(simulationData, 'DisplayName', sprintf('Simulation %d', s)); % Plot with a legend entry
end

hold off; % Release the plot hold

% Add a title and axis labels to the plot for clarity
title('Token A Price Over Time Across Simulations');
xlabel('Iteration Number');
ylabel('Price of Token A');

% Add a legend to the plot
% Note: With 30 simulations, the legend might be crowded. Consider this line optional or adjust as needed.
legend('Location', 'bestoutside'); % Adjust legend location as per your preference

% Turn on the grid for better readability
grid on;
