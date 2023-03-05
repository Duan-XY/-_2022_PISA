clc; clear;
%% 
% Input:
%   attachment1 -- block_resource
%   attachment2
%   attachment3 -- Graph[1:n, 1:n]
% Output:
%   Pipeline_tab_pro1 -- the adjacent table [under constraint in pro1]
%     - Pipeline_rank_pro1 -- the depth of pipeline
%     - verify_rely_pro1 -- result of verification of rely
%     - verify_resource_pro1 -- result of verification of resource
%   Pipeline_tab_pro2 -- the adjacent table [under constraint in pro2]
%     - Pipeline_rank_pro2 -- the depth of pipeline
%     - verify_rely_pro1 -- result of verification of rely
%     - verify_resource_pro1 -- result of verification of resource

%% 0. read Input data
attachment1 = xlsread('./data/attachment1.csv');
attachment2 = readmatrix('./data/attachment2.csv','OutputType','string');
attachment3 = xlsread('./data/attachment3.csv');

%% 1. Graph -> dist_Grpha + level_Graph
% Level_func
%   - dist_func
[Graph, dist_Grpha, level_Graph, degree_out, degree_in, n] = Level_func(attachment3);

%% 2.1 level_Graph -> Control
% Control_func
%   - Level_func
Control = zeros(n, n);
for s = 1:n
    [Control] = Control_func(Control, n, s, attachment3, level_Graph, degree_out);
end
%% 2.2 dist_Grpha -> Data
% Data_func
%   - Level_func
[Data] = Data_func(attachment2, dist_Grpha, n);

%% 3. Control + Data -> Rely
% Rely_func
%   - dist_weight_func
[Rely, dist_rely, level_rely] = Rely_func(n, Data, Control);

%% 4. Resource -> Pipeline
% 4.1 Pro1
% Pipeline_pro1_func
%   - select_NUM_func
%   - select_DP_func
%   - rely_intersect_func
%   - increase_level_func
[Pipeline_tab_pro1, Pipeline_resource_pro1, Pipeline_rank_pro1, Pipeline_pro1, level_pro1, num_TCAM_pro1, ~] = Pipeline_pro1_func(attachment1, n, dist_rely, level_rely);
% 4.2 Pro2
% Pipeline_pro1_func
%   - path_func
%   - select_NUM_func
%   - select_DP_func
%   - rely_intersect_func
%   - increase_level_func
[Pipeline_tab_pro2, Pipeline_resource_pro2, Pipeline_rank_pro2, Pipeline_pro2, level_pro2, num_TCAM_pro2, block_resource] = Pipeline_pro2_func(attachment1, n, dist_rely, level_rely);

%% 5. Verification
% Verify_func
% 5.1 Pro1
[verify_rely_pro1, verify_resource_pro1, ~, ~] = Verify_func(1, n, Pipeline_rank_pro1, Pipeline_pro1, dist_rely, block_resource);
% 5.2 Pro2
[verify_rely_pro2, verify_resource_pro2, ~, ~] = Verify_func(2, n, Pipeline_rank_pro2, Pipeline_pro2, dist_rely, block_resource);

verification = [verify_rely_pro1, verify_resource_pro1; verify_rely_pro2, verify_resource_pro2];

%% 6. write Output data
% csvwrite('Pipeline_tab_pro1.csv', Pipeline_tab_pro1);
% csvwrite('Pipeline_tab_pro2.csv', Pipeline_tab_pro2);

%% 7. Plot digraph*4
% G_plot(Graph, Control, Data, Rely); %svg

%% 8. Clear
clear_func;