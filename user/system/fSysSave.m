% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysSave(sys)
% fSysSave.m
% Saves the state of the system.

% sys = The system object

% sys = The system object with updated magnetic field strength values.


% Store the active sensor parameters.
sys.zOffset(sys.SensorNo) = sys.zOffsetActive;
sys.BStore(:,:,sys.SensorNo) = sys.BStoreActive;
sys.BScale(sys.SensorNo,:) = sys.BScaleActive;



% Save to 'sys.mat'
save('data/sys', 'sys');

end

