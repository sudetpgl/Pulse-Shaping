function [output,t] = matched_filter(param,input)
%PULSE_Shaping Summary of this function goes here
%   Detailed explanation goes here


if strcmp(param.matched_filter.type,'none')
    output = input;
    t = [];
else
    [output,t] = matched_filter.filtering(input,param.matched_filter.pulse,...
        param.general.os,param.general.symbol_rate);
end



end