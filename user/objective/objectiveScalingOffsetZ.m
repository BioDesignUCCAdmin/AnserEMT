function [Bdiff]=objectiveScalingOffsetZ(parameters, calFieldCoil, coilIndex, sys)
% objectiveScalingOffsetZ.m
% Objective function for the calibration procedure.
% The function calculates the field error between the sensed flux and modelled flux, at a set of known predefined testpoints.
% Calculation are performed on each emitter coil individually as indicated by 'coilIndex'.

% parameters   = The vector of variable parameters [zoffset, Bscale] for the LMA algorithm.
    % zoffset indicates the most recent estimation of the error between ideal and actual sensor position
    % Bscale is the most recent estimation of the calibration scaling factor required to fit the realworld magnetic field with the model.
% calFieldCoil = The vector of magnetic field strengths of size 'numCalPoints'. Each strength value in this vector represents the field strength at an individual testpoint due to a single emitter coil of index 'coilIndex'.
% coilIndex    = The index of the coil currently being analysed
% sys          = The system object

% Bdiff        = A vector of length 'numCalPoints'. Contains the magnetic field strength differences in the z-direction between the model and sensed fields, due to a single emitter coil 'coilIndex'.


% Extract the variable parameters for readability
zoffset = parameters(1)
Bscale  = parameters(2)


% The number of calibration points using the Duplo board
numCalPoints = 49;


% Extract the [x,y,z] positions for readability
x = sys.xtestpoint;
y = sys.ytestpoint;
% Adds the z-offset (if any) to account for errors in the axial positioning of the sensor in the calibration adapter. A zoffset typically occurs due to the uncertainty in positioning the sensor at precisly the correct height during calibration.
z = sys.ztestpoint-zoffset; 


% Calculate magnetic field at each testpoint with the mathematical current-filament model due a single emitter coil (coilIndex).
for i = 1:numCalPoints;
    [Hx(i,:),Hy(i,:),Hz(i,:)]= spiralCoilFieldCalcMatrix(1,sys.xcoil(coilIndex,:),sys.ycoil(coilIndex,:),sys.zcoil(coilIndex,:),x(i),y(i),z(i));
end


% Scale the result with the most recent estimate of the calibration scaling factor.
Bz = sys.u0 * Hz * Bscale; 


% Vectorise each component.
BVectorised = Bz;


% Returns the difference between the sensed and modelled flux in the z-direction at each test point, due toa single PCB emitter coil..
Bdiff = (calFieldCoil - BVectorised');
