clc; clear;
graph = xlsread('./data/attachment3.csv');

n = size(graph,1);
Adj = zeros(n,n);   %ÁÚ½Ó¾ØÕó
degree_out = zeros(n,1);
degree_in = zeros(n,1);

for i=1:n
    for j=2:size(graph,2)
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
