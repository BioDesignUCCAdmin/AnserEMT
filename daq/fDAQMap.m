% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function channelMap = fDAQMap(DAQType)
%FDAQMAP Maps the sensor indices to physical DAQ channels. The pinout of
%DAQ cards differ depending on the manfuacturer. Pinout details are readil
%found in the device datasheets and user manuals. Pinouts for the
%National Instruments NI6212/6216 have been already included.
%
% The pinout of DAQ cards differ depending on the manfacturer. 
% Details can be found in DAQ datasheets and user manuals. Pinouts for the
% National Instruments NI6212/6216 have been already included.

% Use a map structure to link channel indices to physical DAQ channels.
ch = containers.Map('KeyType','double','ValueType','double');

if strcmp(DAQType, 'nidaq621X') == 1
    ch(0) = 0;
    ch(1) = 1;
    ch(2) = 4;
    % Add additional sensor
    
elseif strcmp(DAQType, 'mccdaq') == 1
    % MCCDAQ channels mappings go here
   
else
    error('DAQType not supported');

end

channelMap = ch;
end

