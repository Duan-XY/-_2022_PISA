clc; clear;
graph = xlsread('./data/attachment3.csv');

level_graph;  % level(n, 1)--层高数组

%% n
num = 0;
for s = 1
    [Control, num, Q] = Control_find(n, s, graph, level, degree_out, degree_out_max, num);
end

%%
function [Control, num, Q] = Control_find(n, s, graph, level, degree_out, degree_out_max, num)
Control = zeros(n, n);
Q = zeros(degree_out(s),n);
adj_s = graph(s,:);
adj_s(1) = []; %删去起始点
adj_s(isnan(adj_s))=[];  %删去NaN数据
%%%%%%%%%%% 1 %%%%%%%%%%%
if isempty(adj_s) || length(adj_s)==1
    return
end
%%%%%%%%%%% 2 %%%%%%%%%%%
for i = 1:length(adj_s)
    w = adj_s(i)+1;
    Qw = [w];
    adj_w = graph(w,:);
    adj_w(1) = []; %删去起始点
    adj_w(isnan(adj_w))=[];  %删去NaN数据
    for j = 1:length(adj_w)
        v = adj_w(j)+1;
        if isempty(find(Qw==v))
            Qw = [Qw, v];
        end
    end
    Q(i, 1:length(Qw)) = Qw;
end
%%%%%%%%%%% 3 - 7 %%%%%%%%%%%
num = 0;
while(sum(sum(Q))~=0)
    num = num + 1;
    %%%%%%%%%%% 3 %%%%%%%%%%%
    h_min = inf;
    next = s;
    for i = 1:length(adj_s)
        w = adj_s(i)+1;
        Qw = Q(i,:);
        Qw(find(Qw==0))=[];
        for j = 1:length(Qw)
            v = Qw(j);
            if level(v)<h_min
                level(v);
                h_min = level(v);
                next = v;
            end
        end
    end
%     if next==s
%         break;
%     end 
    %%%%%%%%%%% 4 %%%%%%%%%%%
    C = false;
    In_w = ones(length(adj_s),1);
    for i = 1:length(adj_s)
        w = adj_s(i)+1;
        if isempty(find(Q(i,:)==next))
            In_w(i) = 0;
            C = true;
        end
    end
    In_w
    next
    %%%%%%%%%%% 5 %%%%%%%%%%%
    adj_next = graph(next,:);
    adj_next(1) = []; %删去起始点
    adj_next(isnan(adj_next))=[];  %删去NaN数据
    if ~isempty(adj_next)
        for k = 1:size(adj_next)
            t = adj_next(k)+1;
            for i = 1:length(adj_s)
                w = adj_s(i)+1;
                if In_w(i)==1
                    Qw = Q(i,:);
                    Qw(find(Qw==0))=[];
                    if isempty(find(Qw==t))
                        Qw = [Qw, t];
                    end
                    Q(i, 1:length(Qw)) = Qw;
                end
            end
        end
    end
    %%%%%%%%%%% 6 %%%%%%%%%%%
    if C
        Control(s, next)=1;
    end
    for i = 1:length(adj_s)
        w = adj_s(i)+1;
        if In_w(i)==1
            Qw = Q(i,:);
            Qw(find(Qw==0))=[];
            Qw(find(Qw==next)) = [];
            Q(i,:) = zeros(1,n);
            Q(i, 1:length(Qw)) = Qw;
        end
    end
    num
end

end

