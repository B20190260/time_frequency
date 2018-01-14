function [tfr] = tfrStft(x,N,h)
%% ��ʱ����Ҷ�任��[tfr,f] = tfrStft(x,N,h)
% ���룺
%           x: �����ʱ�����ݣ�һ�л���һ��
%           N�������Ƶ�򳤶ȣ���Ҫ>=0
%           h����ѡһ�л���һ������Ĵ���������Ҫע��h(0)=1�������޷��ָ��źš�
% �����
%           tfr������õ���STFT��
%           f��STFT���и��������Ӧ��Ƶ��ֵ

x = x(:);   xrow = length(x);  t=1:xrow;%������ʼ��
if (nargin < 1),    error('At least 1 parameter is required.');  end
if (nargin < 2),    N=xrow;     end;
if (nargin < 3),
    if (N<0),    error('N must be greater than zero.');end;
    hlength=floor(N/4);
    hlength=hlength+1-rem(hlength,2);
    h = tftb_window(hlength);
end
% if (2^nextpow2(N)~=N),    fprintf('For a faster computation, N should be a power of two.\n'); end;
h = h(:); 
hrow=length(h); Lh=(hrow-1)/2;
if (rem(hrow,2)==0),  error('H must be a smoothing window with odd length.');end
% h=h/norm(h);%��֤h(0)=1�����ָܻ��ź�

tfr= zeros (N,xrow) ;midN = round(N/2);
for icol=1:xrow,
    ti= t(icol); tau=-min([midN-1,Lh,ti-1]):min([midN-1,Lh,xrow-ti]);
    indices= rem(midN+tau-1,N);
    tfr(indices,icol)=x(ti+tau,1).*conj(h(Lh+1+tau));
    tfr(:,icol)=fft(tfr(:,icol));%����FFT�ף���ÿ��ʱ��
end

if (nargout==0),
    tfrqview(abs(tfr).^2,x,t,'tfrstft',h);
end
end