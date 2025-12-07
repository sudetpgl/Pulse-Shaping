%Group: Sude Topgül & Antonia Juncu

function [sigma] = get_sigma_with_mf(snr_type, snr_dB, M, X, coderate, mf_pulse)
% %GET_SIGMA_WITH_MF

sigma = 0;
Es = mean(abs(X).^2);
mf_energy = sum(abs(mf_pulse(:)).^2);

switch lower(snr_type)
    case 'ebn0'
        EbN0_lin = 10^(snr_dB/10);
        Eb = Es * coderate / log2(M);
        N0 = Eb / EbN0_lin;
        sigma2 = N0 * mf_energy;

    case 'esn0'
        EsN0_lin = 10^(snr_dB/10);
        N0 = Es / EsN0_lin;
        sigma2 = N0 * mf_energy;

    case 'snr'
        % snr_dB is SNR at sampling point: SNR = Es / sigma2
        SNR_lin = 10^(snr_dB/10);
        sigma2 = Es / SNR_lin;
end

sigma = sqrt(sigma2);
end


