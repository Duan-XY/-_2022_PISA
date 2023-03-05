%%   �������
% 1. �жϵ�һ����Ʒ�Ż򲻷ţ�
% 2. �ж���һ����Ʒ�ǷŻ��ǲ��ţ�M[i,c]=M[i-1,c] or M[i,c]= M[i-1,c-w(i)]+v(i)��
% 3. �ظ�2��
% 4. �ҳ���Щ��Ʒ��

% Capacity % ����������
% Weight   % ��Ʒ��������
% Value    % ��Ʒ��Ӧ�ļ�Ǯ��
% NumberOfObject = length(Weight);% ��Ʒ�ĸ���
% 
%%
function [ObjectState, TransferMatrix] = knapsack_problem(Capacity, Weight, Value, NumberOfObject)
TransferMatrix=[];%����״̬ת�ƾ���
ObjectState=[];   %��������Ʒ��״̬
%% 1.�жϵ�һ����Ʒ�Ż򲻷ţ�
for FlagTemp=1:(Capacity+1)
        if Weight(NumberOfObject)<FlagTemp
                TransferMatrix(NumberOfObject,FlagTemp)=Value(NumberOfObject) ;
        else
                TransferMatrix(NumberOfObject,FlagTemp)=0;
        end
end
%%
%2.�ж���һ����Ʒ�ǷŻ��ǲ��ţ�����ʱ��F[i,v]=F[i-1,v]����ʱ��F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+w_i}��
%3.�ظ�2.
for FlagTempExternal=NumberOfObject-1:-1:1
        for FlagTemp=1:(Capacity+1)
                if FlagTemp<=Weight(FlagTempExternal)
                        TransferMatrix(FlagTempExternal,FlagTemp)=TransferMatrix(FlagTempExternal+1,FlagTemp);
                else
                        if TransferMatrix(FlagTempExternal+1,FlagTemp)>TransferMatrix(FlagTempExternal+1,FlagTemp-Weight(FlagTempExternal))+Value(FlagTempExternal)
                                TransferMatrix(FlagTempExternal,FlagTemp)=TransferMatrix(FlagTempExternal+1,FlagTemp);
                        else
                                TransferMatrix(FlagTempExternal,FlagTemp)=TransferMatrix(FlagTempExternal+1,FlagTemp-Weight(FlagTempExternal))+Value(FlagTempExternal);
                        end
                end
        end
end

%% TransferMatrix

%4.�ҳ���Щ��Ʒ��
FlagTempExternal=Capacity+1;
for FlagTemp=1:NumberOfObject-1
        if TransferMatrix(FlagTemp,FlagTempExternal)==TransferMatrix(FlagTemp+1,FlagTempExternal)
                ObjectState(FlagTemp)=0;
        else
                ObjectState(FlagTemp)=1;
                FlagTempExternal=FlagTempExternal-Weight(FlagTemp);
        end
end
if TransferMatrix(NumberOfObject,FlagTempExternal)==0
        ObjectState(NumberOfObject)=0;
else
        ObjectState(NumberOfObject)=1;
        
end

end
