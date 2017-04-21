% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run the system for a single sensor.
% Use this script as a reference program for writing EMT applications.


% Place the sensor channels to use in this vector. Add further channels to
% this vector if more sensors are required
sensorsToTrack = [1];

% The DAQ being used. nidaq621X refers to either the NI-USB 6212 or NI-USB
% 6216 acquisition systems.
DAQType = 'nidaq621X';

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, DAQType);

% Give DAQ some time to start.
pause(0.5);

FS = stoploop();
while (~FS.Stop())
   
   % Retrieve the latest information from the DAQ. This call retrieves data
   % from all sensor simultaneously and should be called ONLY ONCE per
   % sensor acquisition.
   sys = fSysDAQUpdate(sys);
   
   % Acquire the position for one sensor, the first in sensorsToTrack
   sys = fGetSensorPosition(sys, sensorsToTrack(1));
   % Copy the position to a local variable and print to screen
   position = sys.positionVector;
   disp(positionVector);
   
   % Call again for a different sensor, where X is the number of the
   % sensor channel. This will overwrite the previous stored position in
   %  the sys.positionVector storage variable.
   % sys = fGetSensorPosition(sys, sensorsToTrack(X));
   
   % Required 1ms delay for DAQ
   pause(0.001);
   clc
end