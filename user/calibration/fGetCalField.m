% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fGetCalField(sys)
% fGetField.m
% Gathers magnetic field strengths for 'numPoints' number of testpoints for system calibration.

% sys = The system object

% sts = The system object with modified calibration field strength values for a particular sensor. 

% 7x7 grid of points on the Duplo board used in the Anser EMT calibration routine.
numPoints = 49;

% Iterate over the testpoints, prompting the uses to press 'Enter' when testpoint is ready for acquisition
for i = 1:numPoints

	% Prompt and wait for user input.
    fprintf('Point %d.....', i);
    pause;

    % Obtain samples from DAQ
    sys = fSysDAQUpdate(sys);

    % Demodulate the samples to get a set of field strength values
    sys = fSysGetField(sys);

    % Store the field strength values
    sys.BStoreActive(:, i) = sys.BField;
    sys.BField
   
    fprintf('Done\n');
end

fprintf('Point acquisition completed');

% Save the field data to its own file corrensponding to the sensor number.
BStore = sys.BStoreActive;
save(strcat('data/BStore',num2str(sys.SensorNo)), 'BStore');
% Save the system object.
fSysSave(sys);

end