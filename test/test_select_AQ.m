clear;
node_tmp = [2, 5, 8];
num_adj = [30, 40, 0, 0 , 10, 0, 0, 10];
level_subtree = [0, 4, 0, 0, 8, 0, 0, 5];
constraint = [1, 2, 7, 64];
index = 3;
block_resource = zeros(8, 4);
block_resource(2, index) = 3;
block_resource(5, index) = 1;
block_resource(8, index) = 3;


% node_increase_tmp = select_func(node_tmp, 1, num_adj, level_subtree);
[node_increase_tmp, TransferMatrix] = select_AQ_func(node_tmp, num_adj, level_subtree, constraint, index, block_resource)