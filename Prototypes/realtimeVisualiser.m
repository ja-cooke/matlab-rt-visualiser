close all;

% Global Parameters
%frameLength = 1024;
%downSampleFactor = 1;
%frameSkip = 4;
%reductionFactor = 1.2;

% Input File
%filePath = './TestAudio/LEMONADE.wav';
%filePath = "./TestAudio/100Hz.wav";

% Input File Reader
%fileReader = dsp.AudioFileReader( ...
%    filePath, ...
%    'SamplesPerFrame',frameLength); % Reads frame length of audio each frame

%sampleRate = fileReader.SampleRate;

% Soundcard Output Writer
%deviceWriter = audioDeviceWriter( ...
%    'SampleRate',fileReader.SampleRate);

audioPlayer = MusicPlayer();
audioPlayer.start();

% Create Visualisation object -------------------------------

% CUSTOM VISUALISER
barPlotFig = VisualiserPlot(sampleRate, frameLength, downSampleFactor);

% SIGNAL PROCESSOR
processor = SignalProcessing(frameLength, downSampleFactor);

% REAL-TIME ROUTING
frame = 1;
while ~isDone(fileReader)

    timerstart = double(tic)*10^-9;
   
    % INPUT %
    signal = fileReader();

    % AUDIO OUTPUT
    deviceWriter(signal);

    %% PROCESSING %%

    if (mod(frame,frameSkip)==0)
        % Processing
        plotSignal = processor.downsample(signal(:,1));
        signalFFT = processor.fft(plotSignal);
        
        % Reduction
        [signalFFT, indices] = processor.reduceFFTData(signalFFT, reductionFactor);
        
        %% %%
        % VISUALISER
        barPlotFig = barPlotFig.linePlot3fdBl(signalFFT, indices);
        framesPerSecond = frameRate(timerstart);
        
        %performanceAdjust(fileReader, deviceWriter);
        
    end
    frame = frame + 1;
end

% EXIT
%release(fileReader)
%release(deviceWriter)
audioPlayer.stop();