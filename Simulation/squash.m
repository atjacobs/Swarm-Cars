function [outVect] = squash(inVect)
d = norm(inVect);       % Input norm
if d == 0 
    outVect = [0;0];    % Return zero if zero distance
else
    tmpV = inVect/d;    % Normalize vector
    outVect = tmpV * (-.7 + d/(d+0.214285714285714)); % "squash" vector
end