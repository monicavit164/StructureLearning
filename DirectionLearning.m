function [best_dag,score] = DirectionLearning( dag, samples, assessed_samples, nsize, threshold )
%DIRECTIONLEARNING this function learns directions for a generic dag
%knowing the possible parentset. It uses hill climbing to explore the
%possible structures

% function [best_dag,score] = DirectionLearning( dag, parentset, assessed_samples, nsize )
% 
%INPUT  dag = the structure of the bayesian network represented as a binary
%matrix, it can be an empty matrix
%       parentset = the possible parenthood relations expressed as a binary
%       matrix. Ex: parentset(a,b) = 1 means that a can be parent of b.
%       assessed_samples = the training set, examples collected from the
%       monitoring system, expressed using thresholds
%       nsize: the support of the variables, it is a Nx1 vector

ind_correlations = corr(samples);
parentset = abs(triu(ind_correlations,1))>threshold + abs(tril(ind_correlations,-1))>threshold;

score = score_dags(assessed_samples, nsize, {dag});

best_score = score;
best_dag = dag;

%the list of the last 100 already explored dags
maxLenght = 100;
tabuList = {dag, score};
%it counts the number of unsuccessful steps
counter = 0;
counter2 = 0;

maxCounter = 30;

while counter <maxCounter
    dags = generateAllNeighbours(dag, parentset);
    scores = score_dags(assessed_samples, nsize, dags, 'scoring_fn', 'bayesian');
    
    [s, I] = sort(scores, 'descend');
    index = find(cell2num(cellfun(@(x) IsNotMember(x,{tabuList(:,1)}), {dags{I}}, 'UniformOutput',false)),1);
    
    if ~isempty(index)        
        tabuList(mod(counter2, maxLenght)+1,:) = {dags{I(index)}, s(index)};
        counter2 = counter2 + 1;
        if s(index)<=best_score
            counter = counter + 1;
        else
            counter = 0;
            best_score = s(index);
            best_dag = dags{I(index)};
        end
        score = s(index);
        dag = dags{I(index)};
        
    else
        counter = maxCounter;
    end
end

end

