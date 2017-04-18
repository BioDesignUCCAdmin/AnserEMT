while(1)
figure
while (1)
    
    ft = fft(sessionData(:,3));
    plot((1:(length(ft)/2))./2500, 20*log10(abs(ft(1:(length(ft)/2)))/length(ft)));
    
    
 %    ylim([-10,0]) 
%     xlim([0,1])
    pause(0.005);
end
end