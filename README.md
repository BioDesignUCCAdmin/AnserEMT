# Anser EMT
## An open source electromagnetic tracking platform


## Getting started

### Prerequisites
- This guide assumes you have a fully assembled Anser system utilising either a supported National Instruments for Measurement Computing acquisition system.
- You have electrically verified the system is operational and that the transmitter coils are powered.
- You have set the sensor amplifier gains correctly and that the DAQ is receiving unclipped voltage signals on connected channels
- You have a 64-bit version of Matlab installed with the Data Acquisition and Optimisition toolboxes installed.
  - (Note that Measurement Computering hardware requires Matlab R2017a or above)
- You have the appropriate driver for your DAQ installed on the PC.
  
  
### System initialisation
1. Connect the DAQ to the PC. Ensure the device is recognised in windows device manager.
2. Launch Matlab and navigate to the directory of this readme file.
3. Open 'RunSetup.m' script. Ensure the correct DAQ type string is used in the file.
4. Run 'RunSetup.m'.

After a brief pause you should see some messages followed by the 'System initialised'.
The tracking system is now ready for use.

### Channel calibration

Each sensor channel must be calibrated before first use. For optimum system accuracy it is recommended that a calibration be performed whenever the system electronics have been adjusted or moved. This will reduce error from unintentional amplifier gain changes induced by opening the system enclosure.

1. Connect the DAQ to the PC. Ensure the device is recognised in windows device manager
2. Launch Matlab and navigate to the directory of this readme file.
3. Run 'RunCalibration.m'. Ensure the correct DAQ type is used in the file.
4. Select the sensor channel to calibrate.
5. Follow the on-screen prompts to collect the calibration points.
6. The system will self calibrate after collecting the final point. The printed error (mm) gives an idea of the quality of the calibration. An error of ~0.5-1.2mm is acceptable. Better accuracy can be achieved by adjusting the height of the sensor and repeating the procedure.

The calibration data is automatically saved to the 'sys' structure and saved to the '/data' folder. Sensors connected to this channel can now be tracked by the system (see **Tracking**).

### Tracking

Once a sensor channel has been calibrated it can be used to track the position of the sensor in the working volume of the tracking system. The following tutorial assumes you have calibrated channel 1 of the tracking system.

1. Connect the DAQ to the PC. Ensure the device is recognised in windows device manager
2. Launch Matlab and navigate to the directory of this readme file.
3. Run 'RunSensorBasic.m'. Ensure the correct DAQ type is used in the file.
4. The system should initialise and positions should start printing in the console
5. Click the OK button on the on-screen prompt to stop tracking.

Use this file as a reference for writing EMT applications.

## Aside: a note on the code structure

The system utilises a code structure based on the passing and returning of
a single structure called 'sys'. This large structure contains all the parameters
necessary for system operation.

The structure is passed as an arguement and returned as a value in many functions. This is performed in order to avoid the use of global variables. Matlab traditionally passes function arguments by value, and not by reference as in other languages. This would normally mean a large structure like 'sys' would introduce unnecessary memory copies as the structure is passed back and forth between functions. This is **not** the case in Matlab, as the interpreter intelligently checks and only performs copies of structure members if they are changed within a function [0]. Little to no performance penalties are incurred.

[0] https://uk.mathworks.com/matlabcentral/answers/96960-does-matlab-pass-parameters-using-call-by-value-or-call-by-reference


