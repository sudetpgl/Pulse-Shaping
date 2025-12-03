function [output,t] = pulse_shaping(param,input)
%PULSE_Shaping Summary of this function goes here
%   Detailed explanation goes here

assert(param.pulse_shaping.is_initialized);

if strcmp(param.pulse_shaping.type,'none')
    output = input;
    t = [];
else
    [output,t] = pulse_shaping.conv_pulse(input,param.pulse_shaping.pulse,...
        param.general.os,param.general.symbol_rate);
end


end