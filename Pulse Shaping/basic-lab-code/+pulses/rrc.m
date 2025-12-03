function pulse = rrc(filterspan, rolloff, n_os, design_type)
%RRC This
%   Inputs:
%   filterspan: Filterspan in number of symbols
%   rolloff:
%   n_os: oversampling factor
%   type: freq or time

assert(mod(filterspan,2)==0,'filterspan must be an even number');

pulse = zeros(1,n_os*filterspan);

end

