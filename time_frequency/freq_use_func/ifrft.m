function y = ifrft(x, p, N)
% ������1�������Զ���任���ȣ�~2������������FFTЧ����ͬ~
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Fractional Fourier Transform
%	y = ifrft(x, p, N)
%	x  : Signal under analysis���źų������Ϊż��������任�����档
%	p  : Fractional Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3; N = length(x); end

x = x / sqrt(N);%���Żָ�
x = fftshift(x);%λ�ƻָ�
% y = frft_org(x,-p);
y = fracft(x,-p);
y = y(1:N);

end
