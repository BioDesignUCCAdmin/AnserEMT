function sys = fSysDAQUpdate(sys)
% fDAQUpdate.m
% Retrieves new sample data from the DAQ

% sys = The system object

% sys = The system object with updated sample data.



% Call fDAQAcquire to retrieve sample data. Assign this data to the system variable
sys.rawData = fDAQAcquire(sys.NIDAQ, sys.DAQType);

end