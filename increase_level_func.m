function [level_rely] = increase_level_func(node_increase, level_rely, dist_rely)
%%
% node_increase(i)
% verify whether adj(i) satisfy the **rely constraint**
%   if not, increase the level of adj(i)
%%
for i = 1 : length(node_increase)
    v = node_increase(i);
    level_rely(v) = level_rely(v) + 1;
    dist_v = dist_rely(v,:);
    adj_v = find(dist_v > 0);
    if ~isempty(adj_v)
        for j = 1 : length(adj_v)
            w = adj_v(j);
            dist_vw = dist_v(w);
            if mod(dist_vw,2)==0
                if level_rely(w) == (level_rely(v)+dist_vw/2-1)
                    level_rely(w) = level_rely(w) + 1;
                end
            elseif level_rely(w) < level_rely(v)
                level_rely(w) = level_rely(w) + 1;
            end
        end
    end
end
end