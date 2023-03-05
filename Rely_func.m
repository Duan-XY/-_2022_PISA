function [Rely, dist_rely, level_rely] = Rely_func(n, Data, Control)
%% Rely matrix
Rely = max(Data, Control);   % 1 -- <=; 2 -- <
node0 = find(sum(Rely)==0);  % 366
% 
[dist_rely] = dist_weight_func(Rely, n);
%% level of dist_rely
level_rely = dist_rely(node0,:);
if length(node0)>1
    level_rely = max(level_rely);
end
level_rely(find(level_rely==1))=0;
level_rely = level_rely(find(level_rely~=1))/2;
level_rely = level_rely';
end