close all;
clear all;

demonstrationNumber = 3;

frameRateTarget = 10;

audioPlayer = MusicPlayer(frameRateTarget);
audioPlayer = audioPlayer.start();

% Create Visualisation object -------------------------------

% CUSTOM VISUALISER
barPlotFig = VisualiserPlot(audioPlayer);

% SIGNAL PROCESSOR
processor = SignalProcessing(audioPlayer);

% REAL-TIME ROUTING
frame = 1;
timerstart = double(tic)*10^-9;
framesPerSecond = 15;
while ~isDone(audioPlayer.fileReader)

    % INPUT %
    signal = audioPlayer.getSignal();

    % AUDIO OUTPUT
    audioPlayer.play(signal);

    %% PROCESSING %%
    if (mod(frame,audioPlayer.frameSkip)==0)
        
        % Processing
        plotSignal = processor.downsample(signal(:,1));
        [signalFFT, signalFFTPhase] = processor.fft(plotSignal);
        signalsimpleFFT = processor.simplefft(plotSignal);
        
        %% %%
        % VISUALISER

        switch demonstrationNumber
            case -2
                % Reduction
                [signalFFT, indices] = processor.reduceFFTData(signalFFT, audioPlayer);
                % Plot
                barPlotFig = barPlotFig.linePlot3FA(signalFFT, plotSignal, indices, framesPerSecond);
            case -1
                % Reduction
                [signalFFT, indices] = processor.reduceFFTData(signalFFT, audioPlayer);
                [signalFFTPhase, ~] = processor.reduceFFTData(signalFFTPhase, audioPlayer);
                % Plot
                barPlotFig = barPlotFig.linePlot3fpdBl(signalFFT, signalFFTPhase, indices, framesPerSecond);
            case 0
                % Reduction
                [signalFFT, indices] = processor.reduceFFTData(signalFFT, audioPlayer);
                % Plot
                barPlotFig = barPlotFig.linePlot3fdBl(signalFFT, indices, framesPerSecond);
            case 2
                barPlotFig = barPlotFig.barPlot2f(signalsimpleFFT);
            case 1
                barPlotFig = barPlotFig.barPlot2fl(signalsimpleFFT);
            case 3
                barPlotFig = barPlotFig.linePlot3(plotSignal);
                
        end
        
        % Optimisation
        [framesPerSecond, timerstart] = frameRate(timerstart);
        audioPlayer = audioPlayer.optimise(framesPerSecond);
        
    end
    frame = frame + 1;
end

% EXIT
audioPlayer.stop();