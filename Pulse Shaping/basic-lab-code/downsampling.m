function [output,t,output_with_tails] = downsampling(param,input,time)
%DE_OVERSAMPLING Summary of this function goes here
%   Detailed explanation goes here

if param.downsampling
    [output,t] = matched_filter.sampling(input,time,param.general.os,...
        param.pulse_shaping.filterspan,param.matched_filter.filterspan);
    
    % cutting tails from filtering in channel and carrier demodulation
    filterspan = 0;
    if isfield(param, 'carrier_demodulation')
        if isfield(param.carrier_demodulation, 'filterspan')
            filterspan = filterspan + param.carrier_demodulation.filterspan;
        end
    end
    if param.channel.is_bandwidth_limited
        filterspan = filterspan + param.channel.filterspan;
    end
    
    output_with_tails = output;
    
    if param.pulse_shaping.filterspan == 1
        % do nothing
    else
        tmp = param.pulse_shaping.filterspan/2 + param.matched_filter.filterspan/2;
        output = output(tmp+1:end-tmp+1);
        t = t(tmp+1:end-tmp+1);
    end
    output = output(filterspan/2+1:end-filterspan/2);
    t = t(filterspan/2+1:end-filterspan/2);
else
    output = input;
    output_with_tails = output;
    t = [];
end

end

