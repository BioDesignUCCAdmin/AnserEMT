% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run a real-time fast-fourier tranform a single sensor.
% Use this script as a starting point for visually inspecting the field
% strengths of the tracking system.

% Channel no of the DAQ to inspect. Look at the DAQ pin mapping
channelNo = 2;
refreshRate = 200;


figure;
FS=stoploop();
while (~FS.Stop())
    
    ft = fft(sessionData(:,channelNo));
    plot((1:(length(ft)/2))./2500, 20*log10(abs(ft(1:(length(ft)/2)))/length(ft)));
    
    
    ylim([-120,0]) 
    xlim([0,1])
    pause(1/refreshRate);
end
