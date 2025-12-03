function [output,t] = channel(param,input)
%PULSE_Shaping Summary of this function goes here
%   Detailed explanation goes here

%no difference between continious and discrete here

% fliter with bandpass filter
if param.channel.is_bandwidth_limited
    output2 = conv(input,param.channel.channel_impulse_response);
else
    output2 = input;
end

% add awgn noise

switch param.channel.type
    case 'none'
        output = output2;
    case 'awgn' 
        if strcmp(param.carrier_modulation.type,'none')
            output = channel.awgn(output2, param.channel.N0);
        else
            output = channel.awgn_bandpass(output2, param.channel.N0);
        end
    otherwise
        error('Not Supported yet');
end

if strcmp(param.pulse_shaping.type,'none')
    t = [];
else
    n = length(output);
    
    T_s = 1/param.general.symbol_rate;

    t = linspace(0,T_s/param.general.os*n,n);
end


end

