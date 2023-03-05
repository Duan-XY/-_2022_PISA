clear;
n = 9;
Rely_test = zeros(n,n);
Rely_test(1,3)=1;
Rely_test(1,2)=2;
Rely_test(2,4)=1;
Rely_test(3,8)=2;
Rely_test(8,9)=2;
Rely_test(4,5)=2;
Rely_test(4,6)=2;
Rely_test(5,7)=1;
Rely_test(6,7)=2;

G = digraph(Rely_test);
plot(G)

node = find(sum(Rely_test)==0);
[dist_rely_test]=Weight_dist_func(Rely_test, n);
level_rely = dist_rely_test(node,:);
level_rely(find(level_rely==1))=0;
level_rely = level_rely(find(level_rely~=1))/2;

node_increase = [4];
level_rely1 = increase_level_func(node_increase, level_rely, dist_rely_test);

node_increase = [5,6];
level_rely2 = increase_level_func(node_increase, level_rely1, dist_rely_test);
[level_rely;level_rely1;level_rely2]

% level_rely = level_rely';