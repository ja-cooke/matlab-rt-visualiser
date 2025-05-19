classdef MusicPlayer
    %MUSICPLAYER Responsible for reading and playing audio files
    
    properties
        frameLength
        downsampleFactor
        frameSkip
        reductionFactor
        sampleRate
        deviceWriter
        fileReader
        frameRateTarget
    end
    
    methods
        function obj = MusicPlayer(frameRateTarget)
            %MUSICPLAYER Construct an instance of this class
            %   
            % Global Parameters -- PROJECT SETTINGS
            obj.frameLength = 1024; %1024; %512
            obj.downsampleFactor = 1; % 4
            obj.frameSkip = 4;
            obj.reductionFactor = 1.01;
            obj.frameRateTarget = frameRateTarget;

        end
        
        function obj = start(obj)
            %START Start reading audio and set up output
            %   
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
        
        % Chooses a reduction factor to help achieve the target frame rate
        function obj = optimise(obj, framesPerSecond)
            if (framesPerSecond < obj.frameRateTarget && obj.reductionFactor < 2)
                obj.reductionFactor = obj.reductionFactor + 0.01;
            elseif (obj.reductionFactor > 1.01)
                obj.reductionFactor = obj.reductionFactor - 0.01;
            end
        
        end
        
        % Stop playing audio and release the soundcard
        function obj = stop(obj)
            % EXIT
            release(obj.fileReader);
            release(obj.deviceWriter);
        end
    end
end

