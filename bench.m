while (1)
    timerstart = double(tic)*10^-9;
    timerstop = double(tic)*10^-9;
    timedifference = (timerstop-timerstart);

    framesPerSecond = 1/timedifference;
    display(framesPerSecond);
end