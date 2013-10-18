function [ bnet ] = ParametersLearning( dag, nsize, trainingData )
%PARAMETERSLEARNING this function is used to learn parameters of a
%bayesian network from a set of training data 

% function [bnet] = bayesianEstimation(dag, nsize, trainingData)
% 
%INPUT  dag = the structure of the bayesian network represented as a binary
%matrix
%       nsize = number of discrete values the variables can get. It can be
%       a single value or a vector
%       trainingData = the training set, examples collected from the
%       monitoring system
%
%OUTPUT bnet = a bayesian network structure


%% STRUCTURE BUILDING

% create a Bayesian network with random parameters
bnet = mk_bnet(dag, nsize, 'discrete', 1:1:size(dag,2), 'observed', 1:1:size(dag,2));
seed = 0;
rand('state', seed);    

for i = 1:size(dag,2)
    bnet.CPD{i} = tabular_CPD(bnet, i);
end

%bnet successfully created from DAG!

 
%% PARAMETERS COMPUTATION
% 
% 
%trainData = load(trainingData) + 1; %work between 1 and variables support)
cases = num2cell(trainingData);

bnet = learn_params(bnet, cases);


end

