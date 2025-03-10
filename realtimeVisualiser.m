% Global Parameters
frameLength = 1024;
downSampleFactor = 4;

% Input File Reader
fileReader = dsp.AudioFileReader( ...
    'test.mp3', ...
    'SamplesPerFrame',frameLength); % Reads frame length of audio each frame
% Soundcard Output Writer
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);

% Create Visualisation object -------------------------------

% CUSTOM VISUALISER
barPlotFig = VisualiserPlot(frameLength, downSampleFactor);

% REAL-TIME ROUTING
frame = 1;
while ~isDone(fileReader)
    % INPUT %
    signal = fileReader();

    % AUDIO OUTPUT
    deviceWriter(signal);

    %% PROCESSING %%
    %signalFFT = fft(signal(:,2), frameLength);
    %signalFFT = abs(signalFFT)/max(abs(signalFFT));

    if (mod(frame,4)==0)
        % Downsample Plot 
        plotSignal = downsample(signal(:,1), downSampleFactor);
        signalFFT = fft(plotSignal, frameLength/downSampleFactor);
        signalFFT = signalFFT(1:frameLength/(downSampleFactor*2));
        signalFFT = abs(signalFFT)/max(abs(signalFFT));
    
        %% %%
        % VISUALISER
        barPlotFig.barPlot2(signalFFT);
    end
    frame = frame + 1;
end

% EXIT
release(fileReader)
release(deviceWriter)