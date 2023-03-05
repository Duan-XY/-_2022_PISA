clc;clear;
% graph=[0,1,3;1,3,4;2,3,4;3,4,NaN;4,NaN,NaN];
graph=[0,1,NaN;1,2,5;2,3,NaN;3,4,NaN;4,NaN,NaN;5,6,8;6,7,NaN;7,3,NaN;8,7,NaN];
n = size(graph, 1);
Adj=zeros(n,n);
degree_out = zeros(n,1);
degree_in = zeros(n,1);
degree_out_max = size(graph,2);

for i=1:n
    for j=2:3
        degree_out(i)=degree_out(i)+1;
        if isnan(graph(i,j))
            degree_out(i)=degree_out(i)-1;
            break
        else
            Adj(i,graph(i,j)+1)=1;
            degree_in(graph(i,j)+1)=degree_in(graph(i,j)+1)+1;
        end
    end
    %Adj(i,:)=Adj(i,:).*degree_out(i);
end
           
G=digraph(Adj);
plot(G)

%%
[dist] = myfloyd(Adj);
node0 = find(degree_in==0);
level = dist(node0,:);
if length(node0)>1
    level = max(level);
end
level = level';

num = 0;
Control = zeros(n, n);
for s = 1:n
    [Control, num, Q] = Control_func(Control, n, s, graph, level, degree_out, degree_out_max, num);
end
