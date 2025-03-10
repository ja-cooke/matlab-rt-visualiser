classdef VisualiserPlot
    %VISUALISERPLOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figureName
        orbit
        frameLength
        downsampleFactor
    end
    
    methods
        function obj = VisualiserPlot(frameLength, downsampleFactor)
            %VISUALISERPLOT Construct an instance of this class
            %   Detailed explanation goes here
            obj.figureName = figure;
            obj.downsampleFactor = downsampleFactor;
            obj.frameLength = frameLength;
            axis([0 frameLength/(obj.downsampleFactor*2) -1 1 -1 1]);
            axis vis3d;
            obj.orbit = 0;
            xticks(0:0.1:1);
            yticks(0:0.1:1);
            zticks(0:0.1:1);
            grid on;
        end
        
        function barPlot2(obj, signal)
            %BARPLOT2 Summary of this method goes here
            %   Detailed explanation goes here
            bar(linspace(0, obj.frameLength/(obj.downsampleFactor * 2),obj.frameLength/(obj.downsampleFactor * 2))', signal);
            
            grid on;
            xticks(0:obj.frameLength/(obj.downsampleFactor*8):obj.frameLength/obj.downsampleFactor);
            yticks(-1:0.4:1);
            axis([0 obj.frameLength/(obj.downsampleFactor*2) 0 1]);
            drawnow;
        end

        function linePlot3(obj, signal)
            plot3(linspace(0, obj.frameLength/obj.downsampleFactor, obj.frameLength/obj.downsampleFactor)', zeros(obj.frameLength/obj.downsampleFactor,1), signal);
            %hold on;
            %plot3(linspace(0, frameLength/(downSampleFactor*2), frameLength/(downSampleFactor*2))',signalFFT, zeros(frameLength/(downSampleFactor*2),1));        
            %plot3(linspace(0, frameLength, frameLength)', signalFFT, signal(:,2));
            %plot3(linspace(0, frameLength, frameLength)', zeros(frameLength,1), signal(:,2));
            %hold off;

            obj.orbit = obj.orbit + 0.5;
            camorbit(obj.orbit,0);
    
            grid on;
            xticks(0:256:obj.frameLength);
            yticks(-1:0.4:1);
            zticks(-1:0.4:1);
            axis([0 obj.frameLength -1 1 -1 1]);
            drawnow;
        end
    end
end

