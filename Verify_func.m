function [rely_satisfy, resource_satisfy, level_verify, Pipeline_resource] = Verify_func(pro, n, Pipeline_rank, Pipeline, dist_rely, block_resource)
rely_satisfy = true;
resource_satisfy = true;
%% level for nodes
level = zeros(n, 1);
for i = 1:Pipeline_rank
    for j = 1:n
        if Pipeline(i, j)==1
            level(j) = i-1;
        end
    end
end
%% Rely verification
count = 0;
for i = n
    for j = 1:n
        if dist_rely(i, j)==1
            if level(i) > level(j)
                rely_satisfy = false;
                count = count + 1;
            end
        elseif dist_rely(i, j)>1
            dist = dist_rely(i, j) / 2;
            if (level(i) + dist-1) >= level(j)
                rely_satisfy = false;
                count = count + 1;
            end
        end
    end
end
%% Resource on each level
Pipeline_resource = zeros(Pipeline_rank ,4);
if pro==1
%%
    for i = 1:n
        i_level = level(i)+1;
        for index = 1:4
            Pipeline_resource(i_level, index) = Pipeline_resource(i_level, index) + block_resource(i, index);
        end
    end
elseif pro==2
%%
    % TCAM + QUALIFY (sum)
    for i = 1:n
        i_level = level(i)+1;
        for index = 1:3:4
            Pipeline_resource(i_level, index) = Pipeline_resource(i_level, index) + block_resource(i, index);
        end
    end
    % HASH + ALU (shared)
    for h = 0:Pipeline_rank-1
        node_h = find(level==h);
        [node_path_h, num_path] = path_func(node_h, dist_rely);
        for index = 2:3
            max_resource = 0;
            for i = 1:num_path
                node_tmp = node_path_h(i,:);
                node_tmp(find(node_tmp==0))=[];
                count_resource = sum(block_resource(node_tmp, index));
                if count_resource > max_resource
                    max_resource = count_resource;
                end
            end
            Pipeline_resource(h+1, index) = max_resource;
        end
    end
end
%% Resource verification
% 1-4 TCAM + HASH + ALU + QUALIFY
resource = max(Pipeline_resource);
if resource(1)>1 || resource(2)>2 || resource(3)>56 || resource(4)>64
    resource_satisfy = false;
end
% 5 fold
for i = 0:15
    if (Pipeline_resource(i+1, 1)+Pipeline_resource(i+17,1))>1
        resource_satisfy = false;
    end
    if (Pipeline_resource(i+1, 2)+Pipeline_resource(i+17,2))>3
        resource_satisfy = false;
    end
end
% 6 num_TCAM
TCAM = find(Pipeline_resource(:,1)==1);
num_TCAM = length(find(mod(TCAM,2)==1));
if num_TCAM>5
    resource_satisfy = false;
end
% 7 once
count = length(find(sum(Pipeline)~=1));
if count~=0
    resource_satisfy = false;
end

%%
level_verify = level;
end