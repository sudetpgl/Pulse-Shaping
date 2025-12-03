function [output] = demapping(param,input)
%DETECTION Summary of this function goes here
%   Detailed explanation goes here

assert(param.demapping.is_initialized)

switch param.demapping.type
    case 'none'
        output = input;
    case 'hard'
        if strcmp(param.modulation.type, 'dpsk')
            output = demapping.hd_diff(input,param.modulation.X,...
                param.modulation.label);
        else
            output = demapping.hd(input,param.modulation.X,...
                param.modulation.label);
        end
    case 'soft'
        if ~isfield(param.channel, 'N0')
            % simulation without channel
            N0 = eps;
        else 
            N0 = param.channel.N0;
        end
        output = demapping.sd(input,param.modulation.X,...
            param.modulation.label,N0);
    otherwise
        error('Not Supported yet');
end

end

