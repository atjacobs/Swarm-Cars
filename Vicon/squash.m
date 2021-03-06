function [outVect] = squash(inVect)
% This functions receives an input vector and outputs a vector
% and changes it's magnitude, possibly even the sign of the magnitude.
% This is used by plugging in the distance vector between two agents.
% The output is then the "forcing" vector--it pulls agents closer if
% they are beyond their desired lattice distance and pushes them if they
% are closer, similar to Van der Waals forces. 
d = norm(inVect);       % Input norm
if d == 0 
    outVect = [0;0];    % Return zero if zero distance
else
    tmpV = inVect/d;    % Normalize vector
    outVect = tmpV * (-.7 + d/(d+0.214285714285714)); % "squash" vector
end
