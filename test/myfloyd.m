function [a]=floyd(a)
% Ѱ��i,j�����·��
% ���룺a���ڽӾ���Ԫ��(aij)�Ƕ���i��j֮���ֱ����룬�����������
% sb�����ı�ţ�db���յ�ı��
% �����dist���·�ľ��룻% path���·��·��
n=size(a,1);
% for i=1:n   %path����ĳ�ʼ��
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
