% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

clear all
clc

% Global needed for data gathered by the session DAQ interface. Newly
% acquired DAQ data is passed to this variable during runtime. It is made
% global in order to allow other functions to easily access the data.
global sessionData;

% Calles the setup function for the tracking system. The returned object
% contains all the information regarding the tracking system, including
% coil dimensions, calibration data and the DAQ object.
sys = fSysSetup(['2'], 'nidaq6212');
