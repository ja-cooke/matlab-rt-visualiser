classdef SignalProcessing
    %SIGNALPROCESSING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downsampleFactor
        frameLength
    end
    
    methods
        function obj = SignalProcessing(audioPlayer)
            %SIGNALPROCESSING Construct an instance of this class
            %   Detailed explanation goes here
            obj.frameLength = audioPlayer.frameLength;
            obj.downsampleFactor = audioPlayer.downsampleFactor;
        end

        function outputSignal = downsample(obj, inputSignal)
            outputSignal = downsample(inputSignal, obj.downsampleFactor);
        end
        
        function [outputSignal, outputPhase] = fft(obj,inputSignal)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            signalFFT = fft(inputSignal, obj.frameLength/obj.downsampleFactor);
            signalFFT = signalFFT(1:obj.frameLength/(obj.downsampleFactor*2));
            outputSignal = abs(signalFFT)/(obj.frameLength/obj.downsampleFactor);%/max(abs(signalFFT));
            outputPhase = angle(signalFFT);
        end

        function outputSignal = simplefft(obj,inputSignal)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            signalFFT = fft(inputSignal, obj.frameLength/obj.downsampleFactor);
            signalFFT = signalFFT(1:obj.frameLength/(obj.downsampleFactor*2));
            outputSignal = abs(signalFFT)/max(abs(signalFFT));
        end

        function [outputSignal, indices] = reduceFFTData(obj, inputSignal, audioPlayer)
            %REDUCEFFTDATA Choose which values from FFT data should be
            %plotted visually
            %   When an FFT is plotted with a logarithmic frequency axis on
            %   a pixel display, it is likely that the resolution of the
            %   plot with exceed the resolution of the display at higher
            %   values. This function removes data from the FFT for the
            %   plot with higher values removed exponentially more often 
            %   than lower values. 
            %   
            %   This should result in a plot of roughly linearly spaced
            %   data points on the graph corresponding either to the
            %   resolution available to the display, or to the maximum
            %   number of points that the system can plot in real-time.
            
            len = length(inputSignal);
            x = 1:len;
            indices = [];
            i = 1;
            j = 1;
            
            lastElement = 0;
            while(i<len)
                % If this index hasn't already been added
                if x(i) ~= lastElement
                    indices = [indices x(i)];
                    lastElement = x(i);
                end
                % i = 1 + reductionFactor^(j+1) :: rounded down to integer
                % Makes a :: y = e^x + 1 :: shaped curve from which to
                % choose new indexes to include. 
                % Low indices (1, 2, 3...) will almost always be included
                % but higher indices are skipped with increasing frequency.
                i = 1 + floor(power(audioPlayer.reductionFactor,j+1));
                j = j + 1;
            end
            
            outputSignal = inputSignal(indices);
        end
    end
end

