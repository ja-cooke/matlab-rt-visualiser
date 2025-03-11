close all;

% Global Parameters
frameLength = 2048;
downSampleFactor = 8;
frameSkip = 2;

% Input File
filePath = './TestAudio/Nitepunk-MTV.wav';
%filePath = "./TestAudio/1kHz.wav";

% Input File Reader
fileReader = dsp.AudioFileReader( ...
    filePath, ...
    'SamplesPerFrame',frameLength); % Reads frame length of audio each frame

sampleRate = fileReader.SampleRate;

% Soundcard Output Writer
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);

% Create Visualisation object -------------------------------

% CUSTOM VISUALISER
barPlotFig = VisualiserPlot(sampleRate, frameLength, downSampleFactor);

% SIGNAL PROCESSOR
processor = SignalProcessing(frameLength, downSampleFactor);

% REAL-TIME ROUTING
frame = 1;
while ~isDone(fileReader)
    % INPUT %
    signal = fileReader();

    % AUDIO OUTPUT
    deviceWriter(signal);

    %% PROCESSING %%

    if (mod(frame,frameSkip)==0)
        % Processing
        plotSignal = processor.downsample(signal(:,1));
        signalFFT = processor.fft(plotSignal);
    
        %% %%
        % VISUALISER
        %barPlotFig = barPlotFig.linePlot3(plotSignal);
        barPlotFig = barPlotFig.linePlot2fdBl(signalFFT);
    end
    frame = frame + 1;
end

% EXIT
release(fileReader)
release(deviceWriter)