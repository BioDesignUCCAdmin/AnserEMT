% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function rawData = fDAQAcquire()

% Delare sessionData as global to allow scope within this function.
global sessionData

% rawData takes the value of the global sessionData variable
rawData = sessionData;

end