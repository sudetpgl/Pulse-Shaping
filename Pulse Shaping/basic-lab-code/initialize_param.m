function param = initialize_param(param)
%INITIALIZE_PARAM initializes the parameter of the used blocks

version = param.general.app_version;

param = source.initialize(param);

param = source_encoding.initialize(param);

if ~( strcmp(version,'source_coding') )
    param = channel_encoding.initialize(param);
end

if ~( strcmp(version,'source_coding') )
    param = modulation.initialize(param);
end

if ~( strcmp(version,'source_coding') || strcmp(version,'cm') )
    param = pulse_shaping.initialize(param);
end

if ~( strcmp(version,'source_coding') || strcmp(version,'cm') || strcmp(version,'pulse_shaping') )
    param = carrier_demodulation.initialize(param);
end

if ~( strcmp(version,'source_coding') || strcmp(version,'cm') )
    param = matched_filter.initialize(param);
end

if ~( strcmp(version,'source_coding') )
    param = channel_decoding.initialize(param);
end

if ~( strcmp(version,'source_coding') )
    param = channel.initialize(param);
end

if ~( strcmp(version,'source_coding') || strcmp(version,'cm') || strcmp(version,'pulse_shaping') )
    param = equalizer.initialize(param);
end

end

