function solution = fSysDecodeField(sys)
% fSysDecodeField.m
% Resolved the sensor position from the a set of 

% sys      = The system object

% solution = A 5-DOF vector containing the postion and orietation of the sensor.


% Create a function handle with the necessary data for the solver
% 'currentPandO' is specified as the variable parameter. This is a 5-DOF vector.
% 'sys' is the system object
% 'sys.BField' is the most recent set of demodulated magnetic field strengths.
objectiveCoil3D = @(currentPandO)objectiveCoilSquareCalc3D(currentPandO, sys, sys.BField);
    
    % Set the boundry conditions for the solver.
    if strcmpi(sys.model, 'portable')
        lowerbound = [-.25, -.25, 0, -2*pi, -2*pi];
        upperbound = [.25, .25, 0.5, 2*pi, 2*pi];
    else
        error('Please specify the hardware setup being used') 
    end

    % Initialises the least squares solver.
    [solution,resnorm_store]= lsqnonlin(objectiveCoil3D, sys.estimateInit,lowerbound,upperbound,sys.lqOptions);
    % Check if the residual is small enough
    if resnorm_store>sys.residualThresh; 
        % Try again with a different initial condition, the angles are different here in the initial estimate (adding Pi to each angle)
        [solution,resnorm_store]= lsqnonlin(objectiveCoil3D, sys.estimateInit+[0, 0, 0, pi, pi],lowerbound,upperbound,sys.lqOptions); 
        % If it still fails, give up and use the initial estimate as the solution.
        if resnorm_store>sys.residualThresh; 
            solution = sys.estimateInit;
        end
    end
end