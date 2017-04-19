% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function rawData = fDAQAcquire(NIDAQ, DAQType)

% Delare sessionData as global to allow scope within this function.
global sessionData

% This implementation utilised the NI-USB 6216 DAQ in Session Mode
if strcmpi(DAQType, 'session')

    % rawData takes the value of the global sessionData variable
    rawData = sessionData;


%% INSERT ALTERNATE DAQ STATEMENT HERE


else
    error('Please specify a interface type (legacy or session)');
end

end