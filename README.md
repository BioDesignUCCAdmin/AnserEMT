# Anser EMT
## An open source electromagnetic tracking platform

## Structure

The system utilises a code structure based on the passing and returning of
a single structure called 'sys'. This large structure contains all the parameters
necessary for system operation.

The structure is passed as an arguement and returned as a value in many functions. This is performed in order to avoid the use of global variables. Matlab traditionally passes function arguements by value, and not by reference as in other languages. This would normally mean a large structure like 'sys' would introduce unneccesary memory copys as the structure is passed back and forth between functions. This is *not* the case in Matlab, as the interpreter intelligently checks and only performs copies of structure members if they are changed within a function [0].

[0] https://uk.mathworks.com/matlabcentral/answers/96960-does-matlab-pass-parameters-using-call-by-value-or-call-by-reference

## Getting started

### Prerequisites
- This guide assumes you have a fully assembled Anser system utilising either a supported National Instruments for Measurement Computing acquisition system.
- You have electrically verified the system is operational and that the transmitter coils are powered.
- You have set the sensor amplifier gains correctly and that the DAQ is receiving unclipped voltage signals on connected channels
- You have a 64-bit version of Matlab installed with the Data Acquisition and Optimisition toolboxes installed.
  - (Note that Measurement Computering hardware requires Matlab R2017a or above)
- You have the appropriate driver for your DAQ installed on the PC.
  
  
### System initialisation
- Connect the DAQ to the PC. Ensure the device is recognised in windows device manager.
- Launch Matlab and navigate to the directory of this readme file.
- Open 'RunSetup.m' script. Ensure the correct DAQ type string is used.
- Run 'RunSetup.m'.

After a brief pause you should see a warning message followed by the message 'System initialised'.
You are now ready to use the tracking system



