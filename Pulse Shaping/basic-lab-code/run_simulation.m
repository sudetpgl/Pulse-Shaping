function [results] = run_simulation(param)
%RUN_SIMULATION Run the simulation of all blocks

version = param.general.app_version;

%% Source
%results.message = param.source.sequence;
results.message = source(param);


%% Source encoding
results.u = source_encoding(param,results.message);
if param.source.cardinality > 0
    results.compression_factor = ...
        (length(results.message)*ceil(log2(param.source.cardinality))) / ...
        (length(results.u));
else
    results.compression_factor = 0;
end


%% Channel encoding
if strcmp(version,'source_coding')
    results.c = results.u;
else
    results.c = channel_encoding(param,results.u);
end

%% Modulation
if strcmp(version, 'source_coding')
    results.x = results.c;
    mod_pad = 0;
else
    [results.x,mod_pad] = modulation(param,results.c);
end


%% Pulse Shaping
if strcmp(version, 'source_coding') || strcmp(version, 'cm')
    results.s = results.x;
    results.s_t = [];
else
    [results.s,results.s_t] = pulse_shaping(param, results.x);
end


%% Carrier Modulation
if strcmp(version, 'source_coding') || strcmp(version, 'cm') || strcmp(version, 'pulse_shaping')
    results.s_hf = results.s;
    results.s_hf_t = [];
else
    [results.s_hf,results.s_hf_t] = carrier_modulation(param,results.s);
end


%% Channel
%results.r_hf = results.s_hf;
%results.r_hf = channel(param,results.s_hf);
if strcmp(version, 'source_coding')
    results.r_hf = results.s_hf;
    results.r_hf_t = [];
else
    [results.r_hf,results.r_hf_t] = channel(param,results.s_hf);
end


%% Carrier Demodulation
if strcmp(version, 'source_coding') || strcmp(version, 'cm') || strcmp(version, 'pulse_shaping')
    results.r = results.r_hf;
    results.r_tmp = [];
    results.r_t = [];
    results.r_tmp_t = [];
else
    [results.r,results.r_tmp,results.r_t,results.r_tmp_t] = ...
        carrier_demodulation(param,results.r_hf);
end



%% Receive Filtering
if strcmp(version, 'source_coding') || strcmp(version, 'cm')
    results.y_os = results.r;
    results.y_os_t = [];
    results.y = results.y_os;
    results.y_with_tails = results.y_os;
    results.y_t = [];
else
    [results.y_os,results.y_os_t] = matched_filter(param,results.r);
    [results.y,results.y_t,results.y_with_tails] = downsampling(param,results.y_os,results.y_os_t);
end




%% Equalizer
if strcmp(version, 'source_coding') || strcmp(version, 'cm') || strcmp(version, 'pulse_shaping')
    results.d = results.y;
else
    results.d = equalizer(param,results.y_with_tails);
end



%% Detection (and demapping)
if strcmp(version, 'source_coding')
    results.L = results.d;
    results.L = results.L(1:end-mod_pad);
else
    results.L = demapping(param,results.d);
    results.L = results.L(1:end-mod_pad);
end


%% Channel Decoding
if strcmp(version, 'source_coding')
    results.u_hat = results.L;
else
    results.u_hat = channel_decoding(param,results.L);
end


% Skip everything else for now
%results.u_hat = results.L;

results.u_ber = sum(results.u_hat ~= results.u)/length(results.u);




% Source decoding
results.message_hat = source_decoding(param,results.u_hat);


min_len = min(length(results.message_hat),length(results.message));
results.end_to_end_ser = sum(results.message_hat(1:min_len) ~= results.message(1:min_len))/min_len;

end