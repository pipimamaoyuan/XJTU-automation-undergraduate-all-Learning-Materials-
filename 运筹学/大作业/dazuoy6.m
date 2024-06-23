% Create an n×n matrix to represent the transmission probability between n nodes
n = 100; % can be modified to any positive integer
P = rand(n,n); % randomly generate numbers between 0 and 1 as transmission probabilities

[S, s] = greedy(P, 5);
disp(S);
disp(s);
% Define a function to simulate the information transmission process and return the final number of transmission nodes


% Define a function to calculate the average transmission effect of a given initial node set and return the average number of transmission nodes
% Define a function to greedily select the initial node set and return the optimal solution and the corresponding average number of transmission nodes
function [S, s] = greedy(P, k)
    % P is the transmission probability matrix, k is the size of the initial node set
    n=100;
    % Initialize the initial node set to an empty set
    S = [];
    
    % Initialize the average number of transmission nodes to 0
    s = 0;
    
    % Iterate k times, each time select an unselected node that maximizes the increase in the average number of transmission nodes
    for i = 1:k
        % Initialize the maximum increment to 0
        max_delta = 0;
        % Initialize the best candidate node to 0
        best_candidate = 0;
        % Traverse all unselected nodes, calculate their increments, and find out the node corresponding to the maximum increment
        for j = 1:n
            if ~ismember(j, S)
                % Calculate the average number of transmission nodes after adding j
                new_s = evaluate(P, [S, j]);
                % Calculate increment
                delta = new_s - s;
                % If the increment is greater than the current maximum increment, update the maximum increment and the best candidate node
                if delta > max_delta
                    max_delta = delta;
                    best_candidate = j;
                end
            end
        end
        % Add the best candidate node to the initial node set and update the average number of transmission nodes
        S = [S, best_candidate];
        s = s + max_delta;
    end
    
    % Return the optimal solution and the corresponding average number of transmission nodes
end

% Call greedy function, select 5 initial nodes, and output results

function s = evaluate(P, S)
    % P is the transmission probability matrix, S is the initial node set
    % Set simulation times
    N = 100; % can be modified to any positive integer
    n=100;
    % Initialize total number of transmission nodes to 0
    total_s = 0;
    
    % Perform N simulations and add up the number of transmission nodes for each simulation
    for i = 1:N
        total_s = total_s + simulate(P, S);
    end
    
    % Calculate the average number of transmission nodes and return the result
   
    % Calculate the average number of transmission nodes and return the result
    s = total_s / N;
end




function s = simulate(P, S)
    % P is the transmission probability matrix, S is the initial node set
    % Create an n×1 vector to represent the activation state of n nodes
    % 0 means unactivated, 1 means activate
    n=100;
    A = zeros(n,1);

    % Activate initial nodes
    A(S) = 1;

    % Set transmission times
    T = 5; % can be modified to any positive integer

    % Perform transmission process
    for t = 1:T
        % Find out the currently activated nodes
        active_nodes = find(A == 1);
        % For each activated node, try to activate its neighbor nodes
        for u = active_nodes'
            % Find out the currently unactivated neighbor nodes
            inactive_neighbors = find(A == 0);
            % For each unactivated neighbor node, activate it with a certain probability
            for v = inactive_neighbors'
                % Generate a random number, if it is less than the transmission probability, activate the node
                r = rand;
                if r < P(u,v)
                    A(v) = 1;
                end
            end
        end
    end

    % Calculate the final number of transmission nodes
    s = sum(A);
end

