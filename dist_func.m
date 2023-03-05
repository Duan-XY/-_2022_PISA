function [dist]=dist_func(a, n)
% a -- adjacent matrix
% n -- dimesion of a
% dist(i, j) -- the longest path from i to j
dist = a;
for k=1:n
    for i=1:n
        for j=1:n
            if i~=j && dist(i,k)>0 && dist(k,j)>0
                if dist(i,j)<dist(i,k)+dist(k,j)
                    dist(i,j)=dist(i,k)+dist(k,j);
                end
            end
        end
    end
end

