function [node_increase_tmp, TransferMatrix] = select_DP_func(node_tmp, num_adj, level_subtree, constraint, index, block_resource)
num_node = length(node_tmp);
node_increase_tmp = [];
value = [];
%% sort node_tmp
%=====1. num_adj low -> high             =====
%=====      2. level_subtree low -> high =====

length_node_tmp = length(node_tmp);
for i = 1 : (length_node_tmp-1)
    for j = i+1 : length_node_tmp
        node_i = node_tmp(i);
        node_j = node_tmp(j);
        if num_adj(node_i) > num_adj(node_j)
            t = node_tmp(j);
            node_tmp(j) = node_tmp(i);
            node_tmp(i) = t;
        else if num_adj(node_i) == num_adj(node_j)
                if level_subtree(node_i) > level_subtree(node_j)
                    t = node_tmp(j);
                    node_tmp(j) = node_tmp(i);
                    node_tmp(i) = t;
                end
            end
        end
    end 
end

%% get value(1,n) and resource(1,n) -> bag
for i = 1:length(node_tmp)
    value(1,i) = i;
end
resource_node = block_resource(node_tmp, index)';

[node_tmp_state, TransferMatrix] = knapsack_problem(constraint(1,index), resource_node, value, length_node_tmp);


%%
node_increase_tmp = node_tmp(find(node_tmp_state==0));

end