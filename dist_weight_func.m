function [dist_rely]=dist_weight_func(Rely, n)
% a -- adjacent matrix
% n -- dimesion of a
% dist(i, j) -- the path with **rely weight** from i to j
dist_rely = Rely;
for k=1:n
    for i=1:n
        for j=1:n
            if i~=j && dist_rely(i,k)>0 && dist_rely(k,j)>0
                r_ik = mod(dist_rely(i, k),2);
                r_kj = mod(dist_rely(k, j),2);
                if r_ik==0
                    if r_kj==0
                        dist_rely(i,j) = max(dist_rely(i,j), dist_rely(i,k)+dist_rely(k,j));
                    else
                        dist_rely(i,j) = max(dist_rely(i,j), dist_rely(i,k));
                    end
                else if r_kj==0
                        dist_rely(i,j) = max(dist_rely(i,j), dist_rely(k,j));
                    else
                        dist_rely(i,j) = max(dist_rely(i,j), 1);
                    end
                end
            end
        end
    end
end
end

