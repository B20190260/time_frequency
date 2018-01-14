function [tfd] = tfrAFS(s)
% ����Adaptive Fractional Spectrogram��[tfd] = tfdAFS(s)
% ��AFS���¼����źŵ�ʱƵ�ֲ���������ź���ò�Ҫ̫�������������ָ���������Ƽ�����С��512��
% �ο���Khan N A, Boashash B. Instantaneous Frequency Estimation of
% Multicomponent Nonstationary Signals Using Multiview Time-Frequency
% Distributions Based on the Adaptive Fractional Spectrogram [J]. IEEE Signal Processing Letters, 2013, 20(2): 157-60.
% ������s�ǳ���ΪL��һά������tfd�Ǽ�����ʱƵ�ֲ�
% tfd��һ����ʵ������

s = s(:).';%ά��ƥ��

L=10;
M=20;
time=2;
II_g=zeros([time*length(s) length(s) L]);
II_hn=II_g;
II_hm=II_g;
II_rect=II_g;
II_hn1=II_g;
II_hm1=II_g;
II_rect1=II_g;

i=0;
for k=0:1:L-1
    %��ÿһ��������ִ��6����ת�Ƕȵ�FRFT�任�����յ�ѡ�����L*6������Ӧ����ѡ������ֵ��Ϊ�����
    i=i+1;
    w=gausswin(i*12+1+M,2);
    % ��ͬ�����ĸ�˹�������任��������ת�ǶȻ����Լ������Ӿ��ȣ�ʵ��ԭ��Ƚϼ򵥡�
    w_1=fracft(w, 0.05); %0.05
    w_2=fracft(w, 0.1);  %0.1
    w_3=fracft(w, 0.15); %0.15
    
    II_g(:,:,i)    = sp(conj(s)',time*length(s), w);
    II_hn(:,:,i)   = sp(conj(s)',time*length(s), w_1);
    II_hm(:,:,i)   = sp(conj(s)',time*length(s), w_2);
    II_rect(:,:,i) = sp(conj(s)',time*length(s), w_3);
    
    w_1=fracft(w, -0.05); %0.05
    w_2=fracft(w, -0.1);  %0.1
    w_3=fracft(w, -0.15); %0.15
    
    II_hn1(:,:,i)   = sp(conj(s)',time*length(s), w_1);
    II_hm1(:,:,i)   = sp(conj(s)',time*length(s), w_2);
    II_rect1(:,:,i) = sp(conj(s)',time*length(s), w_3);
end

% ��֮����ѡ���������к˵ı任������һ��ֵ��Ϊ����ķ���
I_max1=max(max(max(max(II_g,[],3),max(II_hn,[],3)),max(II_hm,[],3)),max(II_rect,[],3));
I_max2=max(max(max(max(II_g,[],3),max(II_hn1,[],3)),max(II_hm1,[],3)),max(II_rect1,[],3));
tfd1=max(I_max1,I_max2);
tfd=tfd1(1:end/2,:);

end

function TFD_sp = sp(s, M, h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Spectrogram
% <INPUTs>
% s    : Input signal. This can be real or analytic.
% M    : Number of Frequency bins (FFT Length).
% h    : The Lag window name. See help of the Matlab function "window" to
%        list all available windows.
%
% <OUTPUTs>
% TFD_sp : The Spectrogram.
%
% <EXAMPLE>
% x = gsig('lin', 0.45, 0.01, 256, 0);
% TFD = sp(x, 512, hamming(63));
% figure; imagesc(abs(TFD'));
%
% More details and examples are provided in TFSAP Toolbox, which can be
% obtained from: http://booksite.elsevier.com/9780123984999/toolbox.php

%% Check for Errors
[L1, M, N] = input_logical_errors(s, length(h), M);
L = (L1-1)/2;

%% Computing the Signal Kernel and Smoothing in the Time-Lag Domain
K_TL = zeros (M, N);
for n = 1:N,
    tau = -min([round(M/2)-1,L,n-1]):min([round(M/2)-1,L,N-n]);
    ind = rem(M+tau,M)+1;
    K_TL(ind,n)=s(n+tau).*conj(h(L+1+tau))/norm(h(L+1+tau));
end
TFD_sp = abs(fft(K_TL)).^2;

end


function [L, M, N] = input_logical_errors(s, L, M)
%% Check for Logical Errors
N = length(s);
if L >= N
    L = N - 1; disp('Window length is truncated to N-1')
end
if M < N
    M = N; disp('FFT length is extended to N')
end
if rem(L,2) == 0
    L = L - 1; disp('Window length must be odd, thus it is truncated to L-1')
end
if(L <= 0)
    error('Window length must be positive');
end
if(M <= 0)
    error('FFT length must be positive');
end
end









