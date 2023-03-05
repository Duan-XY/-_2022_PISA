% clc; clear;
graph = xlsread('./data/attachment3.csv');

n = size(graph,1);
Adj=zeros(n,n);
degree_out = zeros(n,1);
degree_in = zeros(n,1);
degree_out_max = size(graph,2);

for i=1:n
    for j=2:degree_out_max
        degree_out(i)=degree_out(i)+1;
        if isnan(graph(i,j))
            degree_out(i)=degree_out(i)-1;
            break
        else
            Adj(i,graph(i,j)+1)=1;
            degree_in(graph(i,j)+1)=degree_in(graph(i,j)+1)+1;
        end
    end
end

%%
[dist]=myfloyd(Adj);
node0 = find(degree_in==0);
level = dist(node0,:);
if length(node0)>1
    level = max(level);
end
level = level';
 