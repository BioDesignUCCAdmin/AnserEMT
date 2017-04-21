# AnserEMTCode
Code for running the Anser EMT system

##Structure
The system utilises a code structure based on the passing and returning of
a single structure called 'sys'. This large structure contains all the parameters
necessary for system operation.

The structure as passed as an arguement and returned as a value in many functions. This is
performed in order to avoid the use of global variables. Matlab traditionally
passes function arguements by value, and not by reference as in other languages. This would normally mean a large structure like 'sys'
would introduce unneccesary memory copys as the structure is passed back and forth between functions. This is *not* the case in Matlab,
as the interpreter intelligently checks and only performs copies of structure members if they are changed within a function [0].

[0] https://uk.mathworks.com/matlabcentral/answers/96960-does-matlab-pass-parameters-using-call-by-value-or-call-by-reference
