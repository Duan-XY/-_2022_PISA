%%   问题分析
% 1. 判断第一个物品放或不放；
% 2. 判断下一个物品是放还是不放；M[i,c]=M[i-1,c] or M[i,c]= M[i-1,c-w(i)]+v(i)；
% 3. 重复2；
% 4. 找出这些物品。

% Capacity % 背包的容量
% Weight   % 物品的重量。
% Value    % 物品对应的价钱。
% NumberOfObject = length(Weight);% 物品的个数
% 
%%
function [ObjectState, TransferMatrix] = knapsack_problem(Capacity, Weight, Value, NumberOfObject)
TransferMatrix=[];%定义状态转移矩阵
ObjectState=[];   %背包里物品的状态
%% 1.判断第一个物品放或不放；
for FlagTemp=1:(Capacity+1)
        if Weight(NumberOfObject)<FlagTemp
                TransferMatrix(NumberOfObject,FlagTemp)=Value(NumberOfObject) ;
        else
                TransferMatrix(NumberOfObject,FlagTemp)=0;
        end
end
%%
%2.判断下一个物品是放还是不放；不放时：F[i,v]=F[i-1,v]；放时：F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+w_i}；
%3.重复2.
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

%4.找出这些物品。
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
