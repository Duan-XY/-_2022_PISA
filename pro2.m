% clc; clear;
% load('temp.mat');
% load('Pipeline_pro1.mat');
% Pipeline_pro1 = Pipeline;
% level_rely_2 = level_rely;

%%  read data
attachment1 = xlsread('./data/attachment1.csv');
block_resource = attachment1(:, 2:5);

%% Initialize attributes for nodes
num_adj = zeros(1, n);
for i = 1:n
    num_adj(1, i) = length(find(dist_rely(i,:)>0));
end

level_subtree = zeros(1, n);
for i = 1:n
    level_tmp = max(dist_rely(i, :));
    if mod(level_tmp, 2)==0
        level_tmp = level_tmp / 2;
    else
        level_tmp = 0;
    end
    level_subtree(1, i) = level_tmp;
end
clear level_tmp;

%%  special nodes
node_TCAM_1 = find(block_resource(:,1)==1);
node_HASH_2 = find(block_resource(:,2)==2);
node_HASH_1 = find(block_resource(:,2)==1);

%%  Initialize
L = 0;
pipeline_count = 0;
num_TCAM = 0;
init_constraint = [1, 2, 56, 64];
constraint = zeros(1,4);
Pipeline_resource = zeros(1, 4);
Pipeline = zeros(1, n);
Pipeline_rank = 0;  % 优化目标
%%
%%%%%%% 2 %%%%%%%%%%
while (pipeline_count < n)
    %%%%%%% 2.1 %%%%%%%%%%
    constraint = init_constraint;
    %%%%%%% 2.2 fold and odd constraint %%%%%%%%%%
    if L>=16 && L<=31
        constraint(1,1) = max(0, 1 - Pipeline_resource(L-16+1, 1));
        constraint(1,2) = max(0, min(2, 3 - Pipeline_resource(L-16+1, 2)));
    end
    if num_TCAM >= 5 && mod(L, 2)==0
        constraint(1,1) = 0;
    end
    %%  Initialize for each L
    node_L = find(level_rely==L);
    [node_path_L, num_path] = path_func(node_L, dist_rely);  % group nodes by path
    node_increase = [];
    node_increase_tmp = [];
    node_tmp = [];
    %% HASH
    index = 2;
    for i = 1:num_path
        constraint_HASH = constraint(1, index);
        %% HASH_1
        node_tmp = node_path_L(i,:);
        node_tmp(find(node_tmp)==0)=[];
        node_tmp = intersect(node_tmp, node_HASH_1);
        if ~isempty(node_tmp)
            if constraint_HASH==0
                node_increase_tmp = node_tmp;  %all
            elseif constraint_HASH==1
                if length(node_tmp) > 1
                    node_increase_tmp = select_func(node_tmp, 1, num_adj, level_subtree);
                end
                constraint_HASH = 0;
            elseif constraint_HASH == 2
                if length(node_tmp) > 2
                    node_increase_tmp = select_func(node_tmp, 2, num_adj, level_subtree);
                    constraint_HASH = 0;
                elseif length(node_tmp) == 2
                    constraint_HASH = 0;
                else
                    constraint_HASH = 1;
                end
            end
        end
        node_increase = union(node_increase, node_increase_tmp);
        %% HASH_2
        node_tmp = node_path_L(i,:);
        node_tmp(find(node_tmp)==0)=[];
        node_tmp = intersect(node_tmp, node_HASH_2);
        if ~isempty(node_tmp)
            if constraint_HASH==0 || constraint_HASH==1
                node_increase_tmp = node_tmp;  %all
            elseif length(node_tmp)>1
                node_increase_tmp = select_func(node_tmp, 1, num_adj, level_subtree);
                constraint_HASH = 0;
            else
                constraint_HASH = 0;
            end
        end
        %% 
        node_increase = union(node_increase, node_increase_tmp);  
    end
    node_L = setdiff(node_L, node_increase);
    [node_path_L, num_path] = path_func(node_L, dist_rely);  % group nodes by path
    %% ALU
    index = 3;
    for i = 1:num_path
        constraint_ALU = constraint(1, index);
        node_tmp = node_path_L(i,:);
        node_tmp(find(node_tmp==0))=[];
        sum_ALU = sum(block_resource(node_tmp,index));
        node_increase_tmp = [];
        if sum_ALU > constraint_ALU
            [node_increase_tmp, ~] = select_AQ_func(node_tmp, num_adj, level_subtree, constraint, index, block_resource);
        end
        node_increase = union(node_increase, node_increase_tmp);
    end
    node_L = setdiff(node_L, node_increase_tmp);
    
    %%  TCAM
    index = 1;
    node_tmp = intersect(node_L, node_TCAM_1);
    if ~isempty(node_tmp)
        if constraint(1,index)==0
            node_increase_tmp = node_tmp;  %all
        elseif mod(L, 2)==0 && num_TCAM>5
            node_increase_tmp = node_tmp;  %all
        elseif length(node_tmp)>1
            node_increase_tmp = select_func(node_tmp, 1, num_adj, level_subtree);
            constraint(1,index) = 0;
        end
    end
    node_increase = union(node_increase, node_increase_tmp);
    node_L = setdiff(node_L, node_increase);
    
    %% QUALIFY
    index = 4;
    sum_QUALIFY = sum(block_resource(node_L,index));
    node_increase_tmp = [];
    if sum_QUALIFY > constraint(1,index)
        node_tmp = node_L;
        [node_increase_tmp, ~] = select_AQ_func(node_tmp, num_adj, level_subtree, constraint, index, block_resource);
    end
    node_L = setdiff(node_L, node_increase_tmp);
    node_increase = union(node_increase, node_increase_tmp);
    %%
    %%%%%%% 2.3.4 increase %%%%%%%%%%
    if ~isempty(node_increase)
        [node_L] = rely_intersect_func(node_increase, node_L, dist_rely);
        [level_rely] = increase_level_func(node_increase, level_rely, dist_rely);
    end
    
    %%  update
    %%%%%%% 2.4 update pipeline + pipeline_resource %%%%%%%%%%
    [node_path_L, num_path] = path_func(node_L, dist_rely);
    for index = 2:3
        max_resource = 0;
        for i = 1:num_path
            node_tmp = node_path_L(i,:);
            node_tmp(find(node_tmp==0))=[];
            count_resource = sum(block_resource(node_tmp, index));
            if count_resource > max_resource
                max_resource = count_resource;
            end
        end
        Pipeline_resource(L+1, index) = max_resource;
    end
    
    index = 1;
    Pipeline_resource(L+1, index) = sum(block_resource(node_L, index));
    index = 4;
    Pipeline_resource(L+1, index) = sum(block_resource(node_L, index));
    %%
    for i = 1:length(node_L)
        Pipeline(L+1, node_L(i)) = 1;
    end
    if mod(L, 2)==0
        if Pipeline_resource(L+1, 1)>0
            num_TCAM = num_TCAM + 1;
        end
    end
    Pipeline_resource = [Pipeline_resource; zeros(1,4)];
    Pipeline = [Pipeline; zeros(1,n)];
    pipeline_count = pipeline_count + length(node_L);
    L = L + 1;
    sum_pipeline = length(find(sum(Pipeline)==1));
    sum_diff = pipeline_count - sum_pipeline;
end

Pipeline_rank = L;
%%
%%%%%%%%% 3 %%%%%%%%%%
Pipeline_col = max(sum(Pipeline'));
Pipeline_tab = zeros(Pipeline_rank, Pipeline_col + 1);
for i = 1:Pipeline_rank
    Pipeline_tab(i, 1) = i-1;
    nodes = find(Pipeline(i,:)>0);
    for j = 1:length(nodes)
        Pipeline_tab(i, j+1) = nodes(j)-1;
    end
end
%% verify
max(Pipeline_resource)

%%
clear nodes;
clear index;
clear i;
clear j;
clear sum_ALU;
clear sum_QUALIFY;



