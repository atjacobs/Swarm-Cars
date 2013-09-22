
ORIGIN = [-1.5;0];
RADIUS = [1.5]*1000;
CM(s,127,0);
tTurn = tic;
turning = 0;
track = [];
runTime = 30;
runClock = tic;
% pause(3);
while(toc(runClock) < runTime)
    % Gather data
    Output = MyClient.GetFrame();
    PC1N = MyClient.GetMarkerGlobalTranslation('CAR1','NOSE');
    LOC = PC1N.Translation(1:2);
    track = [track, LOC];
    if ~turning
        if(norm(LOC-ORIGIN) > RADIUS)    % If outside circle
            tTurn = tic();
            CM(s,100,-30) % Turn slowly for 1.5 sec
            turning = 1;
%             pause(1.5);
%             CM(s,127,0);    % Go straight for 1 sec
%             pause(1);
        else
            CM(s,127,4);
        end
    end
    if turning
        if (toc(tTurn) > 1.5) & (toc(tTurn) < 2.5)
            CM(s,127,0);
        elseif (toc(tTurn) >= 2.5)
            turning = 0;
        end
    end
%     disp(toc(runClock))
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