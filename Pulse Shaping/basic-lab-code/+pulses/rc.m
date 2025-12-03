function pulse = rc(filterspan, rolloff, n_os, design_type)
%RC This
%   Inputs:
%   filterspan: Filterspan in number of symbols
%   rolloff:
%   n_os: oversampling factor
%   type: freq or time

assert(mod(filterspan,2)==0,'filterspan must be an even number');


pulse = zeros(1,filterspan*n_os);

end

