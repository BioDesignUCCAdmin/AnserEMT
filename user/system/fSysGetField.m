% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysGetField(sys)
% fSysGetField.m
% Demodulates acquired samples to produce a set of magnetic field strengths

% sys = The system object

% sys = The system object with updated magnetic field strength values.

% Number of emitter coils in system.
numCoils = 8;

% The reference coil current sample data
X(:,1) = sys.rawData(:,1);
% The data from the currently selected tracking sensor coil
X(:,2) = sys.rawData(:, 1 + find(sys.Sensors==sys.SensorNo));


% Transpose X for multiplication
X = X';
% Demodulate each frequency component using this matrix fir method.
Y=(X.*sys.G)*sys.E;
% Calculate the amplitude of each component, both current and magnetic field measurements are in here
MagY=2*abs(Y);
% Calculate the phase angle of the field
PhaseY=angle(Y); 



% Calculate the phase between the current and the magnetic field. The helps determine the axial orientation of the sensor.
Phase1 = PhaseY(1,:) - PhaseY(2,:)-sys.DAQPhase; 




% This loop corrects the phase measurement.
% Sometimes randomly the phase changes by pi radiens due to how the 'Angle' function is implemented this loop ensures consistency.
% The phase angle should always be between -pi and pi
for j=1:numCoils;
     if abs(Phase1(j))>pi

     Phase1(j)=-sign(Phase1(j))*(2*pi-abs(Phase1(j)));

     end
end



% Taking the sign of the phase difference and the magnetic field amplitude and a scaling factor, the magnetic field is determined 
BField = sign(Phase1)'.*MagY(2,:)'./sys.fieldGain';

% Store the magnetic strengths in the system object.
sys.BField = BField;
end