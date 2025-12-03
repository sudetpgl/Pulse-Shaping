function [output] = channel_decoding(param,input)
%CHANNEL_DECODING Summary of this function goes here
%   Detailed explanation goes here
assert(param.channel_decoding.is_initialized == 1)
switch param.channel_coding.type
    case 'none'
        output = input;
    case 'rep'
        k = param.channel_coding.k;
        n = param.channel_coding.n;
        
        num_frames = ceil(length(input)/n);
        output = uint8(zeros(1,num_frames*k));
        for i = 1:num_frames
            if strcmp(param.channel_coding.decoder,'hard')
                output((i-1)*k+1:i*k) = channel_decoding.hard_repetition(...
                    input((i-1)*n+1:i*n),n,k);
            end
            if strcmp(param.channel_coding.decoder,'soft')
                output((i-1)*k+1:i*k) = channel_decoding.soft_repetition(...
                    input((i-1)*n+1:i*n),n,k);
            end
        end
    case 'viterbi'
        traceback_length = param.channel_decoding.traceback_length
        
        initial_costs = 0;
        size_branches = size(param.channel_coding.branches)
        branch_num = size_branches(1);
        number_of_blocks = floor(length(input)/traceback_length/branch_num);
        %initialisiere output
        
        for m = 1:number_of_blocks
            input_block = input(1+(m-1)*traceback_length*branch_num:m*traceback_length*branch_num);
            [output_decoded, initial_costs] = channel_decoding.viterbi_channel_decoding(param.channel_coding.branches, input_block, [0,1] , initial_costs,param.channel_decoding.viterbi.states,param.channel_decoding.viterbi.output);
        
            output(1+(m-1)*(traceback_length):m*(traceback_length)) = output_decoded;
        end
    otherwise 
        error('Not Supported yet');
end

end

