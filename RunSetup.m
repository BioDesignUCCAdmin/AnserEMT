clear all
clc

% Global needed for data gathered by the session DAQ interface
global sessionData;

sys = fSysSetup([0,1,4], 'session', 'portable');
