% Create audio buffer stream
frameLength = 2048*4;
% Input File Reader
fileReader = dsp.AudioFileReader( ...
    'TestAudio/test.mp3', ...
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
figure(1);
axis([0 frameLength -1 1 -1 1]);
axis vis3d
orbit = 0;
xticks(0:0.1:1);
yticks(0:0.1:1);
zticks(0:0.1:1);
grid on;

% Create processing chain


% REAL-TIME ROUTING
while ~isDone(fileReader)
    % INPUT %
    signal = fileReader();

    % AUDIO OUTPUT
    deviceWriter(signal);

    %signalFFT = fft(signal(:,2), frameLength);
    %signalFFT = abs(signalFFT)/max(abs(signalFFT));

    % VISUALISER
    figure(1);
    
    plot3(linspace(0, frameLength, frameLength)', signal(:,1), zeros(frameLength,1));
    %plot3(linspace(0, frameLength, frameLength)',signalFFT, zeros(frameLength,1));
    %plot3(linspace(0, frameLength, frameLength)', signalFFT, signal(:,2));
    hold on;
    plot3(linspace(0, frameLength, frameLength)', zeros(frameLength,1), signal(:,2));
    hold off;

    orbit = orbit + 0.5;
    camorbit(orbit,0);
    
    grid on;
    xticks(0:256:frameLength);
    yticks(-1:0.4:1);
    zticks(-1:0.4:1);
    axis([0 frameLength -1 1 -1 1]);
    drawnow;
    %scope([signal,mean(reverbSignal,2)])
end

% EXIT
release(fileReader)
release(deviceWriter)
release(reverb)
release(scope)