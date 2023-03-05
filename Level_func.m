function [Graph, dist, level, degree_out, degree_in, n] = Level_func(attachment3)
%%
n = size(attachment3,1);   % num of nodes
Graph = zeros(n,n);    % adjacent matrix
degree_out = zeros(n,1); 
degree_in = zeros(n,1);
degree_out_max = size(attachment3,2);
node0 = find(degree_in==0);
%% degree_in & degree_out
for i=1:n
    for j=2:degree_out_max
        degree_out(i)=degree_out(i)+1;
        if isnan(attachment3(i,j))
            degree_out(i)=degree_out(i)-1;
            break
        else
            Graph(i,attachment3(i,j)+1)=1;
            degree_in(attachment3(i,j)+1)=degree_in(attachment3(i,j)+1)+1;
        end
    end
end

%% level of Graph
[dist] = dist_func(Graph, n);
level = dist(node0,:);
if length(node0)>1
    level = max(level);
end
level = level';

end