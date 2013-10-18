function [ table ] = inferenceModule(new_bnet, testingData, infVar)
%This function provide instruments for infer values of not specified
%variables
%   function [  ] = inferenceModule(testingData)
%
%INPUT  testData = path of the file containing the test set

%% INFERENCE
%this part should be modified so that I can choice which node/nodes I want
%to infer???
% 

%creating a testing set using the same mapping of the training set
%testData = load(testingData)+1;  %work between 1 and variables support)
%load('files/bayesNetParam', 'new_bnet');
load('observationMap', 'map');

testCases = num2cell(testingData');

% inference with junction tree engine
engine = jtree_inf_engine(new_bnet);

if nargin>2
    evidence = cell(1, size(testCases,1));
    for iter = 1:size(testCases,2)  % iter is the number of data points
        %k = randi(size(testCases,1), 1);   % generate a random variable to infer in the set of available variables
        for i = 1:size(testCases,1)
            if(i~=infVar)
                evidence{i}  = testCases{i,iter};
            end
        end        
        % add the evidence to the engine
        [engine, loglik] = enter_evidence(engine, evidence);
        % compute posterior probability P(ESPD|SPD1,SPD2,SPD3,...)
        marg{iter} = marginal_nodes(engine, infVar);
        %disp([find(marg{iter}.T==max(marg{iter}.T),1), testCases{k, iter}]);        
    end
    table = marg;

else    
    table = zeros(size(testCases,1), 4);
    %testCases([1 20],:) = testCases([20 1], :);
    for k = 1:size(testCases,1)
        score = 0;
        evidence = cell(1, size(testCases,1));
        for iter = 1:size(testCases,2)  % iter is the number of data points
            %k = randi(size(testCases,1), 1);   % generate a random variable to infer in the set of available variables
            for i = 1:size(testCases,1)
                if(i~=k)
                    evidence{i}  = testCases{i,iter};
                end
            end
            
            % add the evidence to the engine
            [engine, loglik] = enter_evidence(engine, evidence);
            % compute posterior probability P(ESPD|SPD1,SPD2,SPD3,...)
            marg{iter} = marginal_nodes(engine, k);
            %disp([find(marg{iter}.T==max(marg{iter}.T),1), testCases{k, iter}]);
            if(map{k}(find(marg{iter}.T==max(marg{iter}.T),1)) == map{k}(testCases{k, iter}))
                score = score +1;
            end
        end
        %variable, income links, outcome links, score
        disp(['Number of successfull estimation: ', num2str(score), ' over ', num2str(size(testCases,2))]);
        table(k,:) = [k, sum(new_bnet.dag(:,k)), sum(new_bnet.dag(k,:)), score/size(testCases,2)];
    end
end

%to find the real value: load observationmap and get observation map(i=variable)

disp('END');

end

