function [output] = channel_encoding(param,input)
%CHANNEL_ENCODING Summary of this function goes here
%   Detailed explanation goes here


switch param.channel_coding.type
    case 'none'
        output = input;
    case 'rep'
        k = param.channel_coding.k;
        n = param.channel_coding.n;
        num_frames = ceil(length(input)/k);
        output = uint8(zeros(1,num_frames*n));
        for i = 1:num_frames
            if i == num_frames
                tmp = input((i-1)*k+1:end);
                in = zeros(1,k);
                in(1:length(tmp)) = tmp;
                output((i-1)*n+1:i*n) = channel_encoding.repetition(in,n,k);
            else
                output((i-1)*n+1:i*n) = channel_encoding.repetition(input((i-1)*k+1:i*k),n,k);
            end
        end
    otherwise
        error('Not Supported yet');
end

end

