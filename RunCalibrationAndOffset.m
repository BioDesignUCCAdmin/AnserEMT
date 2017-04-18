% RunCalibrationAndOffset.m
% Runs the calibration script for the Anser EMT system

% Select which sensor channel you will use for calibration. Each sensor must be calibrated seperatly due to differences in amplifier properties
sensorNo = input('Enter the sensor to Calibrate: ');

sys = fSysSensor(sys,sensorNo);
sys = fGetCalField(sys);

sys = fCalibrate(sys);


rmsErrorBz = fCheck(sys)

sys.ztestpoint = sys.ztestpoint - sys.zOffsetActive;
sys = fCalibrate(sys);
rmsErrorBz = fCheck(sys)

sys = fSysSave(sys);

