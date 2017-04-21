% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% fDAQSetup: Configures the Data Acquisition Unit to the settings specified by the user
% sampleFreq = The desired sampling frequency of the DAQ device
% channels   = An array of channels identifiers for DAQ inputs
% DAQType    = A string describing the type of DAQ/Interface being used. by default the NI-USB DAQ is utilised with the Session interface
% numSamples = The desired number of samples to gather for each sampling interval
function DAQ = fDAQSetup(sampleFreq, sensors, DAQType, numSamples)


    
% Acquire the channels mapping for the DAQ currently in use.
channelMap = fDAQMap(DAQType);
daq.reset;

% National Instruments DAQ specific options.

if strcmp(DAQType, 'nidaq621X') == 1
    % Fixes clock synchronisation issue with DAQmx 14.0+ driver
    daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
    % Create the National Instruments DAQ session
    DAQ = daq.createSession('ni');
else
    error('DAQ Type %s is not valid', DAQType);
end

% Channel 0 is the emitter coil current sense. This is always initialised.
% Channels 1, 2...are connected to the amplifier output of each sensor
% Each channel is configured as a single-ended input.
ch(1) = addAnalogInputChannel(DAQ,'Dev1', 0, 'Voltage');
ch(1).TerminalConfig = 'SingleEnded';
for i = 1:length(sensors)
    ch(i+1) = addAnalogInputChannel(DAQ,'Dev1', channelMap(sensors(i)), 'Voltage');
    ch(i+1).TerminalConfig = 'SingleEnded';
end

% Set the sampling frequency, samples per scan and
DAQ.Rate = sampleFreq;
DAQ.NumberOfScans = numSamples;

% Set the DAQ to raise an internal event flag each time numSample samples are gathered
DAQ.NotifyWhenDataAvailableExceeds = numSamples;

% Set the DAQ to acquire samples continuously
DAQ.IsContinuous = true;
% Create a function handle to dataListen.m to
myListen = @(src, event)dataListen(src, event);
% Set the handle to execute when the 'DataAvailable' event flag occurs
lh = addlistener(DAQ,'DataAvailable', myListen);
% Start the data acquisiton in the background.
DAQ.startBackground();



end