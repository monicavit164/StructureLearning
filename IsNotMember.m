function ret = IsNotMember( matrix, cells )
%ISNOTMEMBER Summary of this function goes here
%   Detailed explanation goes here
%cells = cells{:};
x = find(cellfun(@(x) isequal(x,matrix), cells{:}),1);
if x 
    ret = 0;
else ret = 1;

end

