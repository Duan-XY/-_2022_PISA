function [node_path_L, num_path] = path_func(node_L, dist_rely)
num_node_L = length(node_L);
node_path_L = zeros(num_node_L, num_node_L);
count = 0;
num_path = 0;
%% 
while count < num_node_L
    num_path = num_path+1;
    node_tmp = node_L(1);
    node_v_adj = find(dist_rely(node_tmp, :)>0);
    if ~isempty(node_v_adj)
        node_tmp = union(node_tmp, intersect(node_v_adj, node_L));
    end
    node_L = setdiff(node_L, node_tmp);
    node_path_L(num_path, 1:length(node_tmp)) = node_tmp;
    count = count + length(node_tmp);
end
end