function y = frft(x, p, N)
% ������1�������Զ���任���ȣ�~2������������FFTЧ����ͬ~
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fractional Fourier Transform
%	frac_x = fracft(x, theta) with scale of sqrt(length(x))
%	x      : Signal under analysis���źų������Ϊż��������任�����档
%	theta  : Fractional Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3; N = length(x); end

x = [x(:); zeros(N-length(x),1)];
y = fracft(x,p);
% y = frft_org(x,p);
y = y * sqrt(N);%���Żָ�
y = fftshift(y);%λ�ƻָ�
% M = floor(N/2);
% y = [y(M+1:N); y(1:M)];

end

