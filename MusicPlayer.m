classdef MusicPlayer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frameLength
        downsampleFactor
        frameSkip
        reductionFactor
        sampleRate
        deviceWriter
        fileReader
    end
    
    methods
        function obj = MusicPlayer()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            % Global Parameters
            obj.frameLength = 1024; %1024; %512
            obj.downsampleFactor = 2; % 4
            obj.frameSkip = 2;
            obj.reductionFactor = 1.2;
        end
        
        function obj = start(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            % Input File
            filePath = './TestAudio/LEMONADE.wav';
            %filePath = './TestAudio/test.mp3';
            %filePath = './TestAudio/Nitepunk-MTV.wav';
            %filePath = "./TestAudio/100Hz.wav";

            % Input File Reader
            obj.fileReader = dsp.AudioFileReader( ...
                            filePath, ...
                            'SamplesPerFrame',obj.frameLength); % Reads frame length of audio each frame

            obj.sampleRate = obj.fileReader.SampleRate;

            % Soundcard Output Writer
            obj.deviceWriter = audioDeviceWriter( ...
                            'SampleRate',obj.fileReader.SampleRate);
        end

        function signal = getSignal(obj)
            signal = obj.fileReader();
        end

        function  obj = play(obj, signal)
            obj.deviceWriter = obj.deviceWriter(signal);
        end

        function obj = optimise(obj, framesPerSecond)
            if (framesPerSecond < 14 && obj.reductionFactor < 2)
                obj.reductionFactor = obj.reductionFactor + 0.01;
            elseif (obj.reductionFactor > 1.01)
                obj.reductionFactor = obj.reductionFactor - 0.01;
            end
        
        end

        function obj = stop(obj)
            % EXIT
            release(obj.fileReader);
            release(obj.deviceWriter);
        end
    end
end

