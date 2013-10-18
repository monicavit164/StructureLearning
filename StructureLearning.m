function [bnet] = StructureLearning( samples, dataset, nsize, threshold, indicators_labels )
%STRUCTURELEARNING this function learn the structure of a bayesian network
%starting from monitored data. Original values are continuous but are then
%discretized using thresholds.
% function [bnet] = StructureLearning( samples, dataset, nsize, threshold )
% 
%INPUT  samples = the set of examples collected through the monitoring
%system. It is an MxN matrix where M is the number of examples and N is the
%number of indicators.
%       dataset = the set of examples collected through the monitoring
%       system expressed using thresholds. It is an MxN matrix where M is
%       the number of examples and N is the number of indicators.
%       nsize = number of discrete values the variables can get. It can be
%       a single value or a vector
%       threshold = the correlation strenght between variables to be
%       considered when learning the dag structure
%
%OUTPUT bnet = the bayesian network completed with structure and parameters

%%
%find DAG not-oriented graph using correlation
dag = zeros(size(samples,2));

assessed_samples = dataset';

%setting the number of values that each node can take
if(length(nsize) == 1)
    %a single value for all the nodes is specified
    nsize = zeros(1,size(dag,2)) + nsize;
%else
    %a different value is specified for each single node
 %   node_sizes = str2num(nsize);
end

%% DAG AND DIRECTION LEARNING
disp('Learning structure and direction for the bayesian network: STARTED');
[best_dag,score] = DirectionLearning( dag, samples, assessed_samples, nsize, threshold );
disp('Learning structure and direction for the bayesian network: COMPLETED');

%% BAYESIAN NETWORK PARAMETERS LEARNING
disp('Learning parameters for the bayesian network: STARTED');
bnet = ParametersLearning( best_dag, nsize, assessed_samples );
disp('Learning parameters for the bayesian network: COMPLETED');


%% DRAW RESULTS
%indicators_labels = {'U(V1)' 'U(V2)' 'U(V3)' 'U(S1)' 'U(S2)' 'R(V1)' 'R(V2)' 'R(V3)' 'PE(V1)' 'PE(V2)' 'PE(V3)' 'E(V1)' 'E(V2)' 'E(V3)' 'E(S1)' 'E(S2)'};
drawNetwork(bnet.dag, '-nodeLabels',  indicators_labels);
end
    

