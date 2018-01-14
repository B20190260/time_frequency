function [amf, wv]=QTFR_Compare_autoTerm_corssTerm(sig,N,Fs)
%% ���������ź�sig��WVD��IAF,�����ƶԱ�ͼ

% ����
sig = sig(:).';
[amf, wv]=wvdClean(sig,N);% ����AF��

if nargout >= 1; return; end %ֻ��Ҫ�����������ͼ

%% ����WVD
t = (0:(N-1))/Fs; 
f = linspace(0,Fs/2,N);
figure('Name','WVD');
imagesc(t,f,log10(1+abs(wv)));axis xy; colormap('Cool')
xlabel('ʱ��/\mus');ylabel('Ƶ��/MHz');
set_gca_style([7,7]);grid off;
% figure;tfsapl(real(sig),wv,'Grayscale','on'); 

%% ����ģ��ͼ
% �˴������껹��ȷ����μ���
v = linspace(-Fs/2,Fs/2,N);
tau = linspace(-t(end),t(end),N);
figure('Name','IAF');
imagesc(v,tau,log10(1+abs(amf)));colormap('Cool')%axis xy; 
ylabel('ʱ��/\mus');xlabel('������/MHz');
set_gca_style([7,7]);grid off;




end

function [amb, tfrep] = wvdClean(x,N)
% Wigner Ville Distribution
%  No windowing or time-resolution variablility
% ���amb��IAF������tfrep ����WVD����

analytic_sig_ker = signal_kernal(x);
tfrep = real(1./N.*fft(ifftshift(analytic_sig_ker,1), N, 1));
amb = fftshift(1./N.*fft(analytic_sig_ker, N, 2),2);

end


function analytic_sig_ker = signal_kernal(x)
% Matlab programs to develop points learned in the understanding of
% time-frequency distributions
% This is a signal kernel function.
%    Both real and analytic versions.
%   K(n,m) = z(n+m)z*(n-m)
% where, z() is the analytic associate of real input signal s()
%    n is the sampled or discrete time
%    m is the sample or disrete lag
% Nathan Stevenson
% April 2004
%

N = length(x);

if mod(length(x),2) == 0
    true_X = fft(x);
    analytic_X = [true_X(1) 2.*true_X(2:N/2) true_X(N/2+1) zeros(1,N/2-1)];
    analytic_x = ifft(analytic_X);
else
    true_X = fft(x);
    analytic_X = [true_X(1) 2.*true_X(2:ceil(N/2)) zeros(1,floor(N/2))];
    analytic_x = ifft(analytic_X);
end

analytic_sig_ker = zeros(N,N);
for m = -round(N/2-1):1:round(N/2-1);
    analytic_sig_ker(m+round(N/2)+1,:) = sig_ker_corr(analytic_x,m);
end

end


function sig_ker_m = sig_ker_corr(x,m)
% A correlation function to aid in the creation
% of the signal kernel.
% Nathan Stevenson
% SPR June 2004

N = length(x);
z_nmm = [zeros(1,N+m) x zeros(1,N-m)];
z_npm = [zeros(1,N-m) x zeros(1,N+m)];
ker_nm = z_npm.*conj(z_nmm);
sig_ker_m = ker_nm(N+1:2*N);
end
