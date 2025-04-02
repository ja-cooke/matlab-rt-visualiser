classdef VisualiserPlot
    %VISUALISERPLOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figureName
        orbit = 0;
        frameLength
        downsampleFactor
        sampleRate
    end
    
    methods
        function obj = VisualiserPlot(audioPlayer)
            %VISUALISERPLOT Construct an instance of this class
            %   Detailed explanation goes here
            obj.figureName = figure("WindowStyle","docked");
            obj.sampleRate = audioPlayer.sampleRate;
            obj.downsampleFactor = audioPlayer.downsampleFactor;
            obj.frameLength = audioPlayer.frameLength;
            axis([0 audioPlayer.frameLength/(obj.downsampleFactor*2) -1 1 -1 1]);
            axis vis3d;
            xticks(0:0.1:1);
            yticks(0:0.1:1);
            zticks(0:0.1:1);
            grid on;
        end
        
        function obj = barPlot2(obj, signal)
            %BARPLOT2 Summary of this method goes here
            %   Detailed explanation goes here
            
            bar(linspace(0, obj.frameLength/(obj.downsampleFactor * 2), ...
                obj.frameLength/(obj.downsampleFactor * 2))', signal);

            grid on;
            xticks(0:obj.frameLength/(obj.downsampleFactor*8):obj.frameLength/obj.downsampleFactor);
            yticks(-1:0.4:1);
            axis([0 obj.frameLength/(obj.downsampleFactor*2) 0 1]);

            drawnow;
        end

        function obj = barPlot2f(obj, signal)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, length(signal))';

            bar(freqAxis, signal);

            grid on;
            xticks(0:freqRes*16:nyquist);
            yticks(-1:0.4:1);
            axis([0 nyquist/obj.downsampleFactor 0 1]);
            drawnow;
        
        end

        function obj = barPlot2fl(obj, signal)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, length(signal))';

            bar(freqAxis, signal);

            % Set the x-axis to logarithmic scale
            set(gca, 'XScale', 'log');

            grid on;
            xticks([10 50 100 200 500 1000 2000 5000 10000 20000]);
            yticks(-1:0.4:1);
            axis([10 nyquist/obj.downsampleFactor 0 1]);
            drawnow;
        
        end

        function obj = barPlot2fdBl(obj, signal)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, length(signal))';

            signal = 20*log10(signal);

            bar(freqAxis, signal, "BaseValue",-100);

            % Set the x-axis to logarithmic scale
            set(gca, 'XScale', 'log');

            grid on;
            xticks([10 50 100 200 500 1000 2000 5000 10000 20000]);
            yticks(-120:6:6);
            axis([10 nyquist/obj.downsampleFactor -60 3]);
            drawnow;
        
        end

        function obj = linePlot2fdBl(obj, signal)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, length(signal))';

            signal = 20*log10(signal);

            plot(freqAxis, signal, "Marker","o", "LineStyle","none", "MarkerEdgeColor",'r');

            % Set the x-axis to logarithmic scale
            set(gca, 'XScale', 'log');

            grid on;
            xticks([10 50 100 200 500 1000 2000 5000 10000 20000]);
            yticks(-120:6:6);
            axis([10 nyquist/obj.downsampleFactor -60 3]);
            drawnow;
        
        end

        function obj = linePlot3fdBl(obj, signal, indices, fps)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, (obj.frameLength/obj.downsampleFactor)/2)';

            freqAxis = freqAxis(indices);

            signal = 20*log10(signal);

            plot3(freqAxis, zeros(length(freqAxis)), signal, ... 
                "Marker","o", "LineStyle","none", "MarkerEdgeColor",'r');

            % Set the x-axis to logarithmic scale
            set(gca, 'XScale', 'log');

            grid on;
            xticks([20 50 100 200 500 1000 2000 5000 10000 20000]);
            yticks(-1:0.4:1);
            zticks(-120:6:6);
            
            axis([20 nyquist/obj.downsampleFactor -1 1 -60 3]);

            obj.orbit = obj.orbit + 0.5;
            camorbit(obj.orbit,0);

            fps_text = sprintf('FPS: %.2f', fps); % Format the FPS text
            text(0.1, 0.9, fps_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');

            points_text = sprintf('Data Points: %.2f', length(indices)); % Format the FPS text
            text(0.7, 0.9, points_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');
            
            xlabel("Frequency (Hz)");
            zlabel("Magnitude (dBFS)");

            drawnow;
        
        end

        function obj = linePlot3fpdBl(obj, signal, phase, indices, fps)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, (obj.frameLength/obj.downsampleFactor)/2)';

            freqAxis = freqAxis(indices);

            signal = 20*log10(signal);

            plot3(freqAxis, zeros(length(freqAxis)), signal, ... 
                "Marker","o", "LineStyle","none", "MarkerEdgeColor",'r');
            hold on;
            plot3(freqAxis, phase/pi, ones(length(freqAxis))*-60, ...
                "Marker","|", "LineStyle",":", "Color",'r');
            hold off;

            % Set the x-axis to logarithmic scale
            set(gca, 'XScale', 'log');

            grid on;
            xticks([20 50 100 200 500 1000 2000 5000 10000 20000]);
            yticks(-1:0.4:1);
            zticks(-120:6:6);
            
            axis([20 nyquist/obj.downsampleFactor -1 1 -60 3]);

            obj.orbit = obj.orbit + 0.5;
            camorbit(obj.orbit,0);

            fps_text = sprintf('FPS: %.2f', fps); % Format the FPS text
            text(0.1, 0.9, fps_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');

            points_text = sprintf('Data Points: %.2f', length(indices)); % Format the FPS text
            text(0.7, 0.9, points_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');
            
            xlabel("Frequency (Hz)");
            zlabel("Magnitude (dBFS)");

            drawnow;
        
        end

        function obj = linePlot3FA(obj, signal_f, signal_t, indices, fps)
            % Frequency Axis
            nyquist = (obj.sampleRate/2);
            freqRes = (nyquist/obj.downsampleFactor) / (obj.frameLength/obj.downsampleFactor);
            freqAxis = linspace(freqRes, nyquist/obj.downsampleFactor, (obj.frameLength/obj.downsampleFactor)/2)';

            freqAxis = freqAxis(indices);
            freqAxis = log10(freqAxis);

            signal = 20*log10(signal_f);

            plot3(freqAxis, zeros(length(freqAxis), 1), signal, ... 
                "Marker","o", "LineStyle","none", "MarkerEdgeColor",'r');
            hold on;

            signal_t = downsample(signal_t, 32);
            signal_t = interp(signal_t, 16);
            plot3(linspace(log10(20),freqAxis(end),length(signal_t))', signal_t, ones(length(signal_t),1)*-60, ...
                "Marker","none", "LineStyle","-", "Color",[0.3010 0.7450 0.9330]);
            hold off;

            % Set the x-axis to logarithmic scale
            %set(gca, 'XScale', 'log');

            grid on;
            freqTickValues = [20 50 100 200 500 1000 2000 5000 10000 20000];
            xticks(log10(freqTickValues));
            xticklabels(freqTickValues);
            yticks(-1:0.4:1);
            zticks(-120:6:6);
            
            axis([log10(20) log10(nyquist/obj.downsampleFactor) -1 1 -60 3]);

            obj.orbit = obj.orbit + 0.5;
            camorbit(obj.orbit,0);

            fps_text = sprintf('FPS: %.2f', fps); % Format the FPS text
            text(0.1, 0.9, fps_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');

            points_text = sprintf('Data Points: %.2f', length(indices)); % Format the FPS text
            text(0.7, 0.9, points_text, 'Units', 'normalized', 'FontSize', 12, 'Color', 'red');
            
            xlabel("Frequency (Hz)");
            zlabel("Magnitude (dBFS)");

            drawnow;
        
        end

        function obj = linePlot3(obj, signal)
            plot3(linspace(0, ...
                obj.frameLength/obj.downsampleFactor, ...
                obj.frameLength/obj.downsampleFactor)', ...
                zeros(obj.frameLength/obj.downsampleFactor,1), ...
                signal);
            %hold on;
            %plot3(linspace(0, frameLength/(downSampleFactor*2), frameLength/(downSampleFactor*2))',signalFFT, zeros(frameLength/(downSampleFactor*2),1));        
            %plot3(linspace(0, frameLength, frameLength)', signalFFT, signal(:,2));
            %plot3(linspace(0, frameLength, frameLength)', zeros(frameLength,1), signal(:,2));
            %hold off;
    
            grid on;
           
            axis([0 obj.frameLength/obj.downsampleFactor -1 1 -1 1]);

            xticks(0:64:obj.frameLength/obj.downsampleFactor);
            yticks(-1:0.4:1);
            zticks(-1:0.4:1);

            obj.orbit = obj.orbit + 0.5;
            camorbit(obj.orbit,0);

            drawnow;
        end
    end
end

