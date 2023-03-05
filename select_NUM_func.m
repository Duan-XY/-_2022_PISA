function [node_increase_tmp] = select_NUM_func(node_tmp, num_stay, num_adj, level_subtree)
num_node = length(node_tmp);
num_select = num_node - num_stay;
node_increase_tmp = [];

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

%%
node_increase_tmp = node_tmp(1:num_select);
end