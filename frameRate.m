function [framesPerSecond, timerstart] = frameRate(timerstart)
%FRAMERATE Frame Per Second calculator
%   Calculates frames per second rate between the last and current time the
%   function was run.

        timerstop = double(tic)*10^-9;
        timedifference = (timerstop-timerstart);

        framesPerSecond = 1/timedifference;
        timerstart = timerstop;

end

