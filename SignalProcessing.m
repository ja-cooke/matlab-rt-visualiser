classdef SignalProcessing
    %SIGNALPROCESSING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downsampleFactor
        frameLength
    end
    
    methods
        function obj = SignalProcessing(frameLength,downsampleFactor)
            %SIGNALPROCESSING Construct an instance of this class
            %   Detailed explanation goes here
            obj.frameLength = frameLength;
            obj.downsampleFactor = downsampleFactor;
        end

        function outputSignal = downsample(obj, inputSignal)
            outputSignal = downsample(inputSignal, obj.downsampleFactor);
        end
        
        function outputSignal = fft(obj,inputSignal)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            signalFFT = fft(inputSignal, obj.frameLength/obj.downsampleFactor);
            signalFFT = signalFFT(1:obj.frameLength/(obj.downsampleFactor*2));
            outputSignal = abs(signalFFT)/(obj.frameLength/obj.downsampleFactor);%/max(abs(signalFFT));
        end
    end
end

