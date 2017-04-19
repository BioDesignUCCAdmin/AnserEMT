% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysDAQUpdate(sys)
% fDAQUpdate.m
% Retrieves new sample data from the DAQ

% sys = The system object

% sys = The system object with updated sample data.



% Call fDAQAcquire to retrieve sample data. Assign this data to the system variable
sys.rawData = fDAQAcquire(sys.NIDAQ, sys.DAQType);

end