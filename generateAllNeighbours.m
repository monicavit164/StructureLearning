function [dags] = generateAllNeighbours( start, parentSet )
%GENERATEALLDAGS this function generate all the dags that can be obtained
%by adding, deleting or reversing an edge from an initial structure

%   function [dags] = generateAllNeighbours( start, parentSet )
%
%INPUT  start: the initial structure to mutate, it is a binary NxN matrix
%       parentSet: the set of possible parents for each node, it is a
%       binary NxN matrix
%
%OUTPUT dags = the set of all possible dags generated changing a single
%value in the start matrix

dags = {};

%find all the edges that can be removed
[m,n] = find(start == 1);
for i = 1:length(m)
    d_temp = start;
    d_temp(m(i),n(i)) = 0;
    if acyclic(d_temp, 1)
        dags{length(dags)+1} = d_temp;
    end
end

%find all the edges that can be added or reversed
[m,n] = find((start == 0).*(parentSet == 1));
for i = 1:length(m)
    d_temp = start;
    d_temp(m(i),n(i)) = 1;
    d_temp(n(i),m(i)) = 0;
    if acyclic(d_temp, 1)
        dags{length(dags)+1} = d_temp;
    end
end
    

end
