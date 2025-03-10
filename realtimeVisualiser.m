% Create audio buffer stream
frameLength = 1024;

% Input File Reader
fileReader = dsp.AudioFileReader( ...
    'test.mp3', ...
    'SamplesPerFrame',frameLength); % Reads frame length of audio each frame
% Soundcard Output Writer
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);

% Create Visualisation object -------------------------------

% TIMESCOPE
scope = timescope( ...
    'SampleRate',fileReader.SampleRate, ...
    'TimeSpan',2, ...
    'BufferLength',fileReader.SampleRate*2*2, ...
    'YLimits',[-1,1], ...
    'TimeSpanOverrunAction',"Scroll");

% CUSTOM VISUALISER
downSampleFactor = 4;
figure(1);
axis([0 frameLength/(downSampleFactor*2) -1 1 -1 1]);
axis vis3d;
orbit = 0;
xticks(0:0.1:1);
yticks(0:0.1:1);
zticks(0:0.1:1);
grid on;

% Create processing chain

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
        figure(1);
        
        %plot3(linspace(0, frameLength/downSampleFactor, frameLength/downSampleFactor)', zeros(frameLength/downSampleFactor,1), plotSignal);
        %hold on;
        %plot3(linspace(0, frameLength/(downSampleFactor*2), frameLength/(downSampleFactor*2))',signalFFT, zeros(frameLength/(downSampleFactor*2),1));
        bar(linspace(0, frameLength/(downSampleFactor*2),frameLength/(downSampleFactor*2))', signalFFT);
        %plot3(linspace(0, frameLength, frameLength)', signalFFT, signal(:,2));
        
        %plot3(linspace(0, frameLength, frameLength)', zeros(frameLength,1), signal(:,2));
        %hold off;
    
        %orbit = orbit + 0.5;
        %camorbit(orbit,0);
        
        grid on;
        xticks(0:frameLength/(downSampleFactor*8):frameLength/downSampleFactor);
        yticks(-1:0.4:1);
        %zticks(-1:0.4:1);
        axis([0 frameLength/(downSampleFactor*2) 0 1]);
        drawnow;
    end
    %scope([signal,mean(reverbSignal,2)])
    frame = frame + 1;
end

% EXIT
release(fileReader)
release(deviceWriter)
release(reverb)
release(scope)