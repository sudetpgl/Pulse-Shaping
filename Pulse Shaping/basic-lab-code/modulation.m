function [output,num_pad] = modulation(param,input)
%MODULATION Summary of this function goes here
%   Detailed explanation goes here

assert(param.modulation.is_initialized)

if strcmp(param.modulation.type, 'none')
    output = input;
    num_pad = 0;
    return
end

%% Checks
m = log2(param.modulation.M);
if mod(length(input),m) ~= 0
    num_pad = m - mod(length(input),m);
    input = [input, zeros(1,num_pad)];
else
    num_pad = 0;
end
    

%% Map input data to constellation symbols
switch param.modulation.type
    case {'ook', 'ask', 'psk', 'qam'}
        output = modulation.map_to_constellation(input,param.modulation.X,...
            param.modulation.label);
    case 'dpsk'
        output = modulation.map_to_diff_constellation(input,...
            param.modulation.X,param.modulation.label);
end

end

