% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysSensor(sys, selectSensorNo )
% fSysSensor.m
% Changes the state of the system object for processing of different sensor

% sys      = The system object
% sensorNo = The sensor identifier you would like to switch two. This is NOT the DAQ channel number
sys.SensorNo = selectSensorNo;
sys.zOffsetActive = sys.zOffset(sys.SensorNo);
sys.BScaleActive = sys.BScale(sys.SensorNo,:);
sys.BStoreActive = sys.BStore(:,:,sys.SensorNo);

