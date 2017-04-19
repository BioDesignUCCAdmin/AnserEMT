% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% fDAQSetup: Configures the Data Acquisition Unit to the settings specified by the user
% sampleFreq = The desired sampling frequency of the DAQ device
% channels   = An array of channels identifiers for DAQ inputs
% DAQType    = A string describing the type of DAQ/Interface being used. by default the NI-USB DAQ is utilised with the Session interface
% numSamples = The desired number of samples to gather for each sampling interval
 
% Configuration for the NI-USB 6216 DAQ 
if (strcmpi(DAQType, 'SESSION')) 
    
    % Fixes clock synchronisation issue with DAQmx 14.0+
    daq.reset
    daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
    
    
    NIDAQ = daq.createSession('ni');

    % For the Anser EMT system
    % Channel 1 is the emitter coil current sense.
    % Channels 2, 3...is connected to the amplifier output of a tracking sensor
    % Each channel is configured as a single-ended input.

    ch1 = addAnalogInputChannel(NIDAQ,'Dev1', channels(1), 'Voltage');
    ch1.TerminalConfig = 'SingleEnded';
    ch2 = addAnalogInputChannel(NIDAQ,'Dev1', channels(2), 'Voltage');
    ch2.TerminalConfig = 'SingleEnded';
    if(length(channels) == 3)
        ch3 = addAnalogInputChannel(NIDAQ,'Dev1', channels(3), 'Voltage');
        ch3.TerminalConfig = 'SingleEnded';
    end

    % Set the sampling frequency, samples per scan and
    NIDAQ.Rate = sampleFreq;
    NIDAQ.NumberOfScans = numSamples;

    % Set the DAQ to raise an internal event flag each time numSample samples are gathered
    NIDAQ.NotifyWhenDataAvailableExceeds = numSamples;
    
    % Set the DAQ to acquire samples continuously
    NIDAQ.IsContinuous = true;
    % Create a function handle to dataListen.m to
    myListen = @(src, event)dataListen(src, event);
    % Set the handle to execute when the 'DataAvailable' event flag occurs
    lh = addlistener(NIDAQ,'DataAvailable', myListen);
    % Start the data acquisiton in the background.
    NIDAQ.startBackground();

else
    error('DAQ Type incorrectly specified')
end


end