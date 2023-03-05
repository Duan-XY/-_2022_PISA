%====================================
%生成有向图
%====================================
clc;clear;
num = xlsread('./data/attachment3.csv');
s = []; %源数组
t = []; %目标数组

% s = [1 1 2];
% t = [2 3 3];
% G = digraph(s,t)

for i = 1:size(num,1)
    for j = 2:size(num,2)
        if (isnan(num(i,j)) == 1)
            break
        end
        s = [s, num(i,1)+1];
        t = [t, num(i,j)+1];
    end
end

G = digraph(s,t)
 
plot(G)



