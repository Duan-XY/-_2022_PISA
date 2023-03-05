function node_L = rely_intersect_func(node_increase, node_L, dist_rely)
for i = 1:length(node_increase)
    node_i = node_increase(i);
    dist_rely_i = dist_rely(node_i, :);
    node_ij = find(dist_rely_i>0);
    if ~isempty(node_ij)
        node_L = setdiff(node_L, intersect(node_ij, node_L));
    end
end
end