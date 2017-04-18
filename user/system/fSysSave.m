function sys = fSysSave(sys)
% fSysSave.m
% Saves the state of the system.

% sys = The system object

% sys = The system object with updated magnetic field strength values.


% Store the active sensor parameters. Anser currently supports two sensors
switch sys.SensorNo
    
    case 1
        sys.zOffset1 = sys.zOffsetActive;
        sys.BStore1 = sys.BStoreActive;
        sys.BScale1 = sys.BScaleActive;
        sys.estimateInit1 = sys.estimateInit;
    case 2
        sys.zOffset2 = sys.zOffsetActive;
        sys.BStore2 = sys.BStoreActive;
        sys.BScale2 = sys.BScaleActive;
        sys.estimateInit2 = sys.estimateInit;
end

% Save to 'sys.mat'
save('data/sys', 'sys');

end

