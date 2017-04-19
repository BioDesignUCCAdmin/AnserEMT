% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysSensor(sys, sensorNo )
% fSysSensor.m
% Changes the state of the system object for processing of different sensor
% This function should be called repeatedly when using two sensors, as the Active calibration is different for each sensor.

% sys      = The system object
% sensorNo = The sensor identifier you would like to switch two. This is NOT the DAQ channel number
switch sensorNo
    case 1
        sys.SensorNo = 1;
        sys.zOffsetActive = sys.zOffset1;
        sys.BScaleActive = sys.BScale1;
        sys.BStoreActive = sys.BStore1;
        sys.estimateInit = sys.estimateInit1;
         
    case 2
        sys.SensorNo = 2;
        sys.zOffsetActive = sys.zOffset2;
        sys.BScaleActive = sys.BScale2;
        sys.BStoreActive = sys.BStore2;
        sys.estimateInit = sys.estimateInit2;
end

