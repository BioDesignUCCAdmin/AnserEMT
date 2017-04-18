% Run the system for a single sensor
% SETTINGS
trackingSensor = 1;
refSensor = 4;

N = 1000;
SlicerEnable = 0;
StorageEnable = 0;
transformName = 'ProbeToTracker';





%% Variables for positions
positionStorage1 = zeros(N, 5);
slicerStorage1 = zeros(4, 4, N);



%% Enable Slicer
if(SlicerEnable == 1)
    slicerConnection = igtlConnect('127.0.0.1', 18944);
    transform.name = transformName;
end


sys = fSysSetup([0,trackingSensor, refSensor], 'session', 'portable');
% Give the DAQ time to startup;
pause(3);

%% Main position tracking loop 
i = 1;
j = 1;
while (1)
   tic 
   sys = fSysDAQUpdate(sys);
   
   positionVector1 = fGetSensorPosition(sys, 2);
   positionStorage1(i, :) = positionVector1;
   sys.estimateInit1 = positionVector1;
   disp(positionVector1);
   
   
   
   
   %% Extra processing goes here (before being sent to Slicer)
   
    
   
   
   if(SlicerEnable == 1)
     
       
        sys.SlicerT = [ 0.9996   -0.0169    0.0229   72.3403;...
    0.0174    0.9996   -0.0220  163.1285;...
   -0.0225    0.0224    0.9995 -114.8978;...
         0         0         0    1.0000];
       

      
   %% Prepare position for Slicer
      % Add pi for Slicer position.
      positionVector1(4) = positionVector1(4) + pi;
      % Convert meters to millimeters.
      positionVector1(1:3) = positionVector1(1:3) * 1000;
      % Convert from Spherical to Homogenous rotation matrix.
      positionMatrix = fSphericalToMatrix(positionVector1); 
      
      
      transform.matrix = sys.SlicerT * positionMatrix;
      transform.timestamp = igtlTimestampNow();
      igtlSendTransform(slicerConnection, transform);
      slicerStorage1(:, :, i) = transform.matrix;
   end
   
   
   %% Save positions every N iterations
   if (StorageEnable == 1) && (i == N)
       save(strcat('savedpoints/sensor1_Position', num2str(j)), 'positionStorage1');
       save(strcat('savedpoints/sensor1_Slicer', num2str(j)), 'slicerStorage1');
       i = 1;
       j = j + 1;
   end
   
   toc
   i = i + 1;
   pause(0.001);
   clc;
end


%% Save and cleanup



if(SlicerEnable == 1)
    igtlDisconnect(slicerConnection);
end