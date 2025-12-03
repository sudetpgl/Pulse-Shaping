function [y,t] = sampling(y_os,t_os,os,filterspan_pulse,filterspan_mf)
%SAMPLING Summary of this function goes here
%   Detailed explanation goes here

if filterspan_pulse == 1
    y = zeros(1,(length(y_os)+1)/os - 1);
    t = zeros(size(y));
else
    y = zeros(1,(length(y_os)+1)/os);
    t = zeros(size(y));
end



end
