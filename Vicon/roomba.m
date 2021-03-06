% This script generates a behavior that Jeff affectionately calls
% 'Roomba Mode', where the agent stays within a certain radius.
% Define the circle we want to stay in.
ORIGIN = [-1.5;0]; 	% Circle origin
RADIUS = [1.5]*1000;	% Radius of circle
% Create the serial port before running this.  Call it "s"
CM(s,127,0);		% Set the agent to initial state.
turning = 0;		% Initially NOT turning.
track = [];		% Storage array
runTime = 30;		% Time to run this
runClock = tic;		% Keep track of run time
tTurn = tic;		% Keep track of turn time.
while(toc(runClock) < runTime)
    % Gather data from Vicon system
    Output = MyClient.GetFrame();
    PC1N = MyClient.GetMarkerGlobalTranslation('CAR1','NOSE');
    LOC = PC1N.Translation(1:2);
    track = [track, LOC];
    if ~turning
        if(norm(LOC-ORIGIN) > RADIUS)    % If outside circle
            tTurn = tic();
            CM(s,100,-30) % Turn slowly
            turning = 1;
        else
            CM(s,127,4); % Go straight! (4 is a trim value)
        end
    end
    if turning
        if (toc(tTurn) > 1.5) & (toc(tTurn) < 2.5)
            CM(s,127,0);  % After turning for 1.5 seconds, go straight for at least a second.
        elseif (toc(tTurn) >= 2.5)
            turning = 0;
        end
    end
end
CM(s,0,0);
track = track/1000;
figure
plot(track(1,:),track(2,:))
xlim([-3.5 3.5])
ylim([-3.5 3.5])
title('Roomba Run')
xlabel('Displacement X (meters)')
ylabel('Displacement Y (meters)')
