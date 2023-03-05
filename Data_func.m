function [Data] = Data_func(attachment2, dist, n)
%%
% ------------¡¾simplify the dist¡¿-----------------
rely_data = dist;
a2_n = size(attachment2,2);
read_num = zeros(n,1);%the number of the reading tasks of nodes
write_num = zeros(n,1);%the number of the writing tasks of nodes
for i=1:n
    if ismissing(attachment2(i*2-1,3:end))%write
        if ismissing(attachment2(i*2,3:end))%read
            rely_data(i,:)=zeros(1,n);
            rely_data(:,i)=zeros(n,1);
        else
            read_num(i)=a2_n-sum(ismissing(attachment2(i*2,3:end)))-2;%read num
        end
    else
        write_num(i)=a2_n-sum(ismissing(attachment2(i*2-1,3:end)))-2;%write num
        if ismissing(attachment2(i*2,3:end))
            read_num(i) = 0;% can be delete
        else
            read_num(i) = a2_n-sum(ismissing(attachment2(i*2,3:end)))-2;%read num
        end
    end
end

%%
% ------------¡¾determine the path(row,col)¡¿-----------------
% data rely
tmp_rd_order= find(rely_data' > 0);%according to <col first>
rd_col=zeros(length(tmp_rd_order),1);%the col of the nonzero value in rely_data
rd_row=rd_col;%the row of the nonzero value in rely_data
for i=1:length(tmp_rd_order)
    rd_row(i) = ceil(tmp_rd_order(i)/n);
    rd_col(i) = tmp_rd_order(i)-(ceil(tmp_rd_order(i)/n)-1)*n;
end
%%
% ------------¡¾calculate the control for data-rely¡¿-----------------
Data = zeros(n,n);%2:WR,WW,<; 1:RW,<=; 0:none.
for i=1:length(rd_row)
    if write_num(rd_row(i))>0
        tmp_i_w = attachment2(rd_row(i)*2-1,3:2+write_num(rd_row(i)));
        if read_num(rd_col(i))>0
            tmp_j_r = attachment2(rd_col(i)*2,3:2+read_num(rd_col(i)));
            for k=1:write_num(rd_row(i))
                for t=1:read_num(rd_col(i))  
                    if tmp_i_w(k)==tmp_j_r(t)
                        % ¡¾after writing, read -- <¡¿
                        Data(rd_row(i),rd_col(i))=2;
                        break
                    end
                end
            end
        end
        
        if write_num(rd_col(i))>0
            tmp_j_w = attachment2(rd_col(i)*2-1,3:2+write_num(rd_col(i)));
             for k=1:write_num(rd_row(i))
                for t=1:write_num(rd_col(i))
                    if tmp_i_w(k)==tmp_j_w(t)
                        % ¡¾after writing, write -- <¡¿
                        Data(rd_row(i),rd_col(i))=2;
                        break
                    end
                end
             end
        end 
    end
    
    if read_num(rd_row(i))>0
        tmp_i_r = attachment2(rd_row(i)*2,3:2+read_num(rd_row(i)));
        if write_num(rd_col(i))>0
            tmp_j_w = attachment2(rd_col(i)*2-1,3:2+write_num(rd_col(i)));
            for k=1:read_num(rd_row(i))
                for t=1:write_num(rd_col(i))
                    if tmp_i_r(k)==tmp_j_w(t)
                        %¡¾after reading, write -- <=¡¿
                        Data(rd_row(i),rd_col(i))=max(1,Data(rd_row(i),rd_col(i)));
                    end
                end
            end
        end
    end
        
end
end