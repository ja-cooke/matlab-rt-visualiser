function [fig, orbit] = barPlot2(frameLength)
%2DBARPLOT Summary of this function goes here
%   Detailed explanation goes here

downSampleFactor = 4;
fig = figure(1);
axis([0 frameLength/(downSampleFactor*2) -1 1 -1 1]);
axis vis3d;
orbit = 0;
xticks(0:0.1:1);
yticks(0:0.1:1);
zticks(0:0.1:1);
grid on;

end

