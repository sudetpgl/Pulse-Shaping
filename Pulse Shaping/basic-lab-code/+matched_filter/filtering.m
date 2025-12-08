%Group: Sude Topgül & Antonia Juncu

function [y_os,t] = filtering(r, mf_pulse, n_os, symbol_rate)
% FILTERING: we take the convolution of the matched filter pulse with the
% recieved signal r(t). We get the filtered signal y_os, which is still
% oversampled. Its peaks show where the symbols should be sampled. This
% peaks are, where the shaple of the matched filter and the recieved signal
% match perfectly

    y_os = zeros(1,length(mf_pulse)+length(r)-1);
    t = zeros(size(y_os));

    os_rate = symbol_rate * n_os;    % T = 1/os_rate

    y_full = conv(mf_pulse, r, 'full');
    y_os = y_full(1:length(r));       % cut of the unnecessary tail after convolution

    N = length(y_os);
    t = 0:(1/os_rate):(N-1)/os_rate;  % the last sampling time is (N-1)*T

 

end

