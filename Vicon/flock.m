g = .6;
loopClock = tic;
ORIGIN = [-1.5;0];  % Origin relative to the one marked on the floor
freq = 10;          % refresh rate of cars
runTime = 10;       % amount of time to run in seconds
numCars = 4;        % number of cars
traces = zeros(2,runTime*freq,numCars+1);    % Create storage matrix
headings = zeros(2,numCars);
tIndex = 1;
dVect = zeros(2,1,numCars);
runClock = tic;
trackDVect = zeros(2,runTime*freq,numCars);
r = 1.75; % Radius of circle to follow
f = 1/200;
phi = pi;
% traces(:,1:runTime*freq/2,end) = repmat([1.5;1.5],1,runTime*freq/2);
% traces(:,runTime*freq/2+1:end,end) = repmat([-1.5;-1.5],1,runTime*freq/2);
while(toc(runClock) < runTime)
    if(toc(loopClock) >= 1/freq)
        loopClock = tic;
        %% Gather data
        Output = MyClient.GetFrame();   % Get current frame from vicon
        for ind = 1:numCars
            tail = MyClient.GetMarkerGlobalTranslation(strcat('CAR',num2str(ind)),'TAIL');
            nose = MyClient.GetMarkerGlobalTranslation(strcat('CAR',num2str(ind)),'NOSE');
            traces(:,tIndex,ind) = tail.Translation(1:2)/1000;
            headings(:,ind) =  nose.Translation(1:2)/1000 - tail.Translation(1:2)/1000;
        end
        if tIndex < runTime*60*freq
            traces(:,tIndex+1,end) = [r*cos(tIndex*2*pi*f + phi);r*sin(tIndex*2*pi*f + phi)];
        end
        %% Calculate desired direction 
        dVect = zeros(2,numCars + 1);
        for ind1 = 1:numCars + 1
            for ind2 = 1:numCars + 1
                dVect(:,ind1) = dVect(:,ind1) + squash(reshape(traces(:,tIndex,ind2),2,1) - reshape(traces(:,tIndex,ind1),2,1));% Desired heading vector
            end
%             trackDVect(:,ind1,tIndex) = dVect(:,ind1);
        end
        %% Tell 'em where to go!
        for ind = 1:numCars
            % Turn headings/dVects into complex numbers to easily find angle
            h = headings(1,ind) + 1i*headings(2,ind);
            d = dVect(1,ind) + 1i*dVect(2,ind);
            head = -1 * angle(h/d)*180/pi * g;
            if (head > 30)
                head = 30;
            elseif(head < -30) 
                head = -30;
            end
            if (ind == 3) || (ind == 4)
                head = head * -1;
            end
            CM(s,ind,127 - abs(head)/2,head)
        end
        %%Increment time index
        tIndex = tIndex + 1;
    end
end
stopAll;
figure
for ind = 1:numCars+1
    hold on
    p = plot3(traces(1,1:end-1,ind),traces(2,1:end-1,ind),1/freq:1/freq:runTime-1/freq);
    %     p = plot(traces(1,:,ind),traces(2,:,ind));
    set(p,'Color',[ind/(numCars+1), ind/(numCars+1), 1-ind/(numCars+1)],'LineWidth',2)
end
title('Traces')
xlabel('X')
ylabel('Y')
zlabel('time')
hold off
% CM(s,0,0);
% track = track/1000;
% figure
% plot(track(1,:),track(2,:))
% xlim([-3.5 3.5])
% ylim([-3.5 3.5])
% title('Roomba Run')
% xlabel('Displacement X (meters)')
% ylabel('Displacement Y (meters)')