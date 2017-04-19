function sys = fCalibrate(sys)
% fCalibrate.m
% Performes a system calibration based on a set of predefined test points. A vector of scaling factors (One for each emitter coil) is generated.

% sys = The system object

% sys = The system object with updated internal calibration scaling factors

% The number of emitter coils in the system
numCoils = 8;

% Load the magnetic field strengths sensed by the tracking coil at each testpoint.
loader = load(strcat('data/BStore', num2str(sys.SensorNo)));
sys.BStoreActive = loader.BStore;


% Define initial estimate of parameters for the solver
% First parameter is the mm offset in the z-direction. Assume no offset initially (= 0)
% Second parameter is the scaling factor for the magnetic field strength. Unity scaling is assumed initially (= 1)
paraEst=[0 1];

% Define least squares algorithm parameters for the LMA solver
options = optimset('TolFun',1e-22,'TolX',1e-7,'MaxFunEvals',2000,'MaxIter',2000); 

% Initialise a vector to store the z-offset values calculated by the solver for each emitter coil. 
zOffsetAllCoils = [0,0,0,0,0,0,0,0];

% Iterate the solver over each emitter coil to generate a z-offset and magnetic field scaling value for that coil.
for coilNo = 1:numCoils

	% Extract the field strengths at each testpoints due to coil 'coilNo'
	calFieldCoil=sys.BStoreActive(:,coilNo)';

	% Create new function handle for the emitter coil 'coilNo'.
	% 'params' is specified as the variable parameter vector for the function. i.e. the algorithm will vary this vector for the minimisation process.
	% calFieldCoil is a vector of the field strengths due to coil 'coilNo' sensed at each of the testpoints
    scalingOffsetZ = @(params)objectiveScalingOffsetZ(params, calFieldCoil, coilNo, sys);
    
    % Initialise the solver.
	[fittedParams, resnorm] = lsqnonlin(scalingOffsetZ, paraEst,[],[],options); 

	% The first entry of 'fittedParams' is the calculated z-offset
	zOffsetAllCoils(coilNo) = fittedParams(1); %store results
    
    % The second entry of 'fittedParams' is magnetic field scaling factor
    sys.BScaleActive(coilNo) = fittedParams(2);
end

% Gets the mean z-offset from the coils.
sys.zOffsetActive = mean(zOffsetAllCoils);

% Save calibration values to file CalibrationX.mat where X is the selected sensor.
zOffset = sys.zOffsetActive
BScale = sys.BScaleActive
save(strcat('data/Calibration', num2str(sys.SensorNo)), 'zOffset', 'BScale');

% Save the system object.
sys = fSysSave(sys);

end