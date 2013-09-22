WB = .127;      % Car wheelbase (in inches)
numBots = 6;    % Number of swarm robots in simulation
V = .1;         % Robot velocity
runTime = 30;   % Time to run simulation
arenaR = 10;     % Radius of arena
dT = .05;       % Time step
traces = zeros(2,runTime/dT + 1,numBots);   % Empty array to store trajectories in
traces(:,1,:) = [arenaR/4*randn(1,1,numBots);arenaR/4*randn(1,1,numBots)]; % Give random start locations
strVals = zeros(1,1,numBots);     % Initialize steering to straight
strVals = strVals + .1;
heading = 2*randn(1,1,numBots);   % Initialize a random heading for 'bots
for ind = 1:runTime/dT
    dVect = zeros(2,1,numBots);
    % Find desired direction for each robot
    for ind1 = 1:numBots
        for ind2 = 1:numBots 
            dVect(:,1,ind1) = dVect(:,1,ind1) + squash(traces(:,ind,ind2) - traces(:,ind,ind1));% Desired heading vector
        end
    end
%     heading = heading + strVals;
%     traces(:,ind + 1,:) = t.races(:,ind,:) + V*dT*[cos(heading);sin(heading)];
    traces(:,ind + 1,1:end-1) = traces(:,ind,1:end-1) + dT*dVect(:,1,1:end-1);
    traces(:,ind+1,end) = traces(:,ind,end) + V*dT*[cos(heading(1,1,end));sin(heading(1,1,end))];
    heading(1,1,end) = heading(1,1,end) + .001;
end
figure
for ind = 1:numBots
    hold on
    p = plot3(traces(1,:,ind),traces(2,:,ind),0:dT:runTime);
    %     p = plot(traces(1,:,ind),traces(2,:,ind));
    set(p,'Color',[ind/numBots, ind/numBots, 1-ind/numBots],'LineWidth',2)
end
hold off
title('Swarm sim (no ackerman dynamics yet)')
xlabel('X')
ylabel('Y')
zlabel('time')
% axis equal