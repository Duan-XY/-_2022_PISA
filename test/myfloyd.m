function [a]=floyd(a)
% 寻找i,j两点最长路径
% 输入：a—邻接矩阵，元素(aij)是顶点i到j之间的直达距离，可以是有向的
% sb—起点的标号；db—终点的标号
% 输出：dist—最长路的距离；% path—最长路的路径
n=size(a,1);
% for i=1:n   %path矩阵的初始化
%     for j=1:n
%         path(i,j)=j;
%     end
% end

for k=1:n
    for i=1:n
        for j=1:n
            if i~=j && a(i,k)>0 && a(k,j)>0
                if a(i,j)<a(i,k)+a(k,j)
                    a(i,j)=a(i,k)+a(k,j);
%                     path(i,j)=k;
                end
            end
        end
    end
end

% level=zeros(n,1);
% for i = 1:size(node0,1)
%     for j = 1:n
%         level(j,1) = max(level(j,1), a(node0(i),j));
%     end
% end
