% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run the system for a single sensor.
% Use this script as a reference program for writing EMT applications.



% Settings for the tracking system
% List of sensors to initialise.
sensorsToTrack = [2,1];
refreshRate = 100;

% Enable option for OpenIGTLink connection
igtEnable = 1;
transformName = 'ProbeToTracker';

%% Enable OpenIGTLink connection
if(igtEnable == 1)
    slicerConnection = igtlConnect('127.0.0.1', 18944);
    transform.name = transformName;
end

% Initialise the tracking system. Channel 0 is always required.
% Desired channels are passed in a single vector. For only one sensor the
% vector [0, X] is passed, where X is the index of the desired sensor.
sys = fSysSetup(sensorsToTrack, 'nidaq621X');
pause(0.5);

%% Main loop.
% This loop is cancelled cleanly using the 3rd party stoploop function.
FS = stoploop();
while (~FS.Stop())
   tic
   
   % Update the tracking system with new sample data from the DAQ.
   % Calculate the position of a specific sensor in sensorsToTrack.
   % Change the initial condition of the solver to the resolved position
   % (this will reduce solving time on each iteration)
   % Print the position vector on the command line. The format of the
   % vector is [x,y,z,theta,phi]
   sys = fSysDAQUpdate(sys);
   sys = fGetSensorPosition(sys, sensorsToTrack(1));
   disp(sys.positionVector);
   
   % Prepare to transmit sensor position over network.
   if(igtEnable == 1)
     
      % Rigid registration matrix.  
      sys.registration = eye(4,4);    
   
      % Add pi to theta angle. This resolved pointing issues.
      sys.positionVector(4) = sys.positionVector(4) + pi;
      % Convert meters to millimeters. Required for many IGT packages
      sys.positionVector(1:3) = sys.positionVector(1:3) * 1000;
      % Convert from Spherical to Homogenous transformation matrix.
      sys.positionVectorMatrix = fSphericalToMatrix(sys.positionVector); 
      % Applies registration for the IGT coordinate system.      
      transform.matrix = sys.registration * sys.positionVectorMatrix;
      % Generate a timestamp for the data and sent the transform through
      % the OpenIGTLink connection.
      transform.timestamp = igtlTimestampNow();
      igtlSendTransform(slicerConnection, transform);

   end

   toc
   % This pause is required to allow the DAQ background DMA to work.
   pause(0.001);
   clc;
end


%% Save and cleanup
FS.Clear(); 
clear FS;
if(igtEnable == 1)
    igtlDisconnect(slicerConnection);
end