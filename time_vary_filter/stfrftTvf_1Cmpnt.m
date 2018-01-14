function s_hat = stfrftTvf_1Cmpnt(sn)
%% ��Ե�����FM�źŵķ�����ʱ���˲���������Ե��������ܵ��ñ�������
% ������ʱƵ���������� TFSAP
% ע�⣺�����źű���Ϊ����FM����������Ƶ����
% ���룺snΪʵ���źţ��������͸��ŵȡ�
% �����s_hatΪ�ؽ���FM�ź�

fftLen = 128; % IF���ƴ�����

% �źų�ʼ��׼��
s = hilbert(sn(:));%ת��Ϊ�����ź�
ifs = zce( s, fftLen);% ˲ʱƵ�ʹ���TFSAP %plot(ifs)
ifsFix = filterIfs(ifs);%ƽ��IF��Ϣ % plot(ifsFix)
ifsFit = linFit(ifsFix); % ���IFֱ�� % plot(ifsFit)
% t = 1:length(ifsFit);plot(t,ifs,'b',t,ifsFix,'k',t,ifsFit,'r');legend('zce','fix','fit');

% �ź��ؽ�
[s_hat,tfr,tfrv ]= stfrft_rec(s,ifsFit,8);%�ؽ�
% figure;subplot(121);imagesc(abs(tfr)); axis xy; 
% subplot(122);imagesc(abs(tfrv)); axis xy; 

s_hat = reshape(s_hat,size(sn,1),size(sn,2));%�����źųߴ粻��



end

function y = linFit(x)
% ֱ�����
t = [1:length(x)]';
[xData, yData] = prepareCurveData( t, x );
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'Bisquare';
[fitresult, gof] = fit( xData, yData, ft, opts );
y = fitresult(t);
end


function y=filterIfs(x,winLen)
% ��IF��Ϣ����ƽ��
if(nargin<2 || isempty(winLen)) winLen=15; end
w=hamming( floor(winLen) ); w=w./sum(w);
abs_mean=mean(x);
y=conv(x-abs_mean,w,'same');
y=y+abs_mean;
% �����˵�IF��Ϣ���ñ�Ե���ķ���������ZCE���Ƶ�IF��Ϣ��Ե
y = [ones(winLen,1)*y(winLen+1);
    y(winLen+1 : end - winLen);
    ones(winLen,1)*y(end - winLen)];

end


function [sigs,tfr,tfrv,ucs] = stfrft_rec(x,ifs,halfLen,h)
%% ���ڶ�ʱ����Ҷ�任ʱ���˲����źŷ��룬����Ӧ�����ȣ�[sigs,tfr,tfrv] = stfrft_rec(x,ifs,halfLen,h)
% ���룺x�������źţ��Ƕ�������ĵ���
%           ifs�������Ǹ���������˲ʱƵ�ʣ�
%           halLen���̶������ȵĴ��볤��
%           h����ѡһ�л���һ������Ĵ���������Ҫע��h(0)=1�������޷��ָ��źš�
% �����sigs������źţ����б�ʾһ���ź�
%           tfr����ά����ֱ��ʾ����������STFRFT��
%           tfrv����ά����ֱ��ʾ����������STFRFT��
%           ucs��STDRFT���и��������Ӧ��Ƶ��ֵ

% �ɵ��ڵĲ���
thr = 0.2;%ʱ���˲����޶�ֵ���������йأ���ֵԽ���źŵķ���˥��Խ����Ҫ�����ȸ������ֵ��������

assert(nargin>=2,'At least 2 parameter is required.');
% ʱ���˲�ʱ�ظ���Ե�ĺ���ƣ�Ϊ�˱���ʱ���˲���Ե˥�����øò�������ѡ����Ϊ1����0
EDGE_REPEAT = 1;%

%������ʼ��
x = x(:);   tLen = length(x);  t=1:tLen; %��ȡʱ�䳤��
fLen = min([tLen, 512]);%Ƶ�����ֱ���Ϊ512
[tmp,sigN] = size(ifs);%��ȡ�źŵ�����
assert(tmp ==  tLen,'Input Length of s must be same as ifs.');%�����ж�
if ( nargin < 3),
    halfLen = min([fLen, 30]);%ʱ���˲�����󴰿ڳ��ȵ�һ��
end
assert(halfLen<length(x)/2,'The max window length must be small than signal length.');
if nargin < 4,
    hlength=floor(fLen/4); hlength=hlength+1-rem(hlength,2); 
    h = tftb_window(hlength);%Ĭ����Hamming
end
% h=h/norm(h);%��֤h(0)=1�����ָܻ��ź�
h = h(:); hrow=length(h); Lh=(hrow-1)/2;%������
if (rem(hrow,2)==0),  error('H must be a smoothing window with odd length.');end

% ������ת�����Ͷ�ӦFRFT��Ƶ��
ps = zeros(size(ifs)); ucs = zeros(size(ifs));
for is = 1:sigN
    [~,uc,p] = fftIflaw2frftIflaw(ifs(:,is),fLen);
    %�����������һ��Ƶ��ֵΪnan�ĵط���Ҫô������Ϊ0Ҫô������Ϊ����ķ�nanֵ
    ucs(:,is) = mod(round(uc),fLen)+1;%uc��Ϊ�±����Ϊ����
    ps(:,is) = p;
end


tfr= zeros(fLen,tLen,sigN) ;midN = round(fLen/2);% TFR������ʼ��
sigs = zeros(tLen,sigN);tfrv = zeros(fLen,tLen,sigN) ;
for it=1:tLen,
    ti= t(it); tau=max([-midN+1,-Lh,-ti+1]):min([midN-1,Lh,tLen-ti]);
    if EDGE_REPEAT
        %taux = [tau(1)*ones(1,tau(end) - abs(tau(1))),tau,tau(end)*ones(1,abs(tau(1))-tau(end))];%�ظ���ԵΪ��Եֵ
        taux = [zeros(1,tau(end) - abs(tau(1))), tau,zeros(1,abs(tau(1))-tau(end))];%�ظ���ԵΪ��ǰֵ
        tauh = 1:hrow;%ȫ���ظ�
        indices= (midN-Lh) : (midN + Lh);%ֵ�ظ�����
    else
        taux = tau;
        tauh = Lh+1+tau;
        indices= rem(midN+tau-1,fLen)+1;
    end
    % ����ԭʼSTFRFT
    stmp = zeros(tLen,1);
    stmp(indices)=x(ti+taux,1).*conj(h(tauh));
    %�Ը����ź�ʱ���˲�
    for is = 1:sigN
        %��ʱ��Ƶ�׵��˲�
        tfr(:,it,is)=frft(stmp,ps(it,is));%����FFT�ף���ÿ��ʱ��
        ftfr = tvfIter(tfr(:,it,is), ucs(it,is), thr, halfLen);%Ƶ���˲���Ƶ��ľ��δ����ʵ��ſ����ơ�
        %�ź�ʱ��ֵ�ָ�
        st = ifrft(ftfr,ps(it,is));%�˲�������ݷ��任
        sigs(it,is) = st(midN);%������������м�ֵ���˲��ָ���Ҳ�����м�ֵ
        %plot(t,real(stmp),'b.-',t,real(st),'r.-')%�����ź�
        tfrv(:,it,is) = ftfr;
        % ������ת����
        if ps(it,is)<0
            tfr(1:fLen,it,is) = tfr(fLen:-1:1,it,is);%����У��Ϊ��ȷ��ֵ��Χ
            tfrv(1:fLen,it,is) = tfrv(fLen:-1:1,it,is);
            ucs(it,is) = fLen - ucs(it,is);%����У���������STFRFTƵ��
        end
    end
end

end


function y = tvfIter(x, ind, thr, maxLen)
% �������Ƶ������x����ind��������������ҵ���ֵ�߽磬֮���������ݹ�0��
% �߽�Ķ��壺���ֵС����ֵedgeThr*max���Ǽ�Сֵ�ĵ㡣������ҵ��ļ�ֵ�㳬��maxLen�������
edgeThr = 0.4; %��Ե
Len = length(x);
y = zeros(size(x));%Ĭ�϶���0
y(ind) = x(ind); maxAbs = abs(x(ind));%�������ֵ
%% ��ǰ����
absp = maxAbs;
for len = 0:maxLen %ע����Ҫ����0���ȵ�
    indc = mod(ind-len,Len) + 1; %�������
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp); break;  end%�߽絽������
    y(indc) = x(indc);%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end
%% ��������
absp = maxAbs;
for len = 0:maxLen 
    indc = mod(ind+len,Len) + 1; %���ұ���
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp); break;  end%�߽絽����������Ҫ��Ϊ�����ƽ������
    y(indc) = x(indc);%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end

end


function [fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen)
% [fc,uc,popt] = fftIflaw2frftIflaw(iflaw,fLen)
%% ��STFT�任��˲ʱƵ��iflawת��ΪSTFRFT�任��˲ʱƵ��
% ����iflaw���źŵ�˲ʱƵ�ʣ�fLen����Ƶ�ʲ���������
% ���fc��ʾ�źŵ�˲ʱƵ�ʣ�uc��ʾ�źŵ�˲ʱ������Ƶ�ʣ�popt�Ǹ������FRFT��ѽ���
% ��Ҫע��������ﷵ�ص�fc��uc���������Ƶ������㣬Ҫʹ����Ҫ���䡾ȡ�������롿

if max(iflaw)>0.5 %�����������iflaw������Ƶ�ʵ㣬�Ƚ����һ����ʵ������Ƶ�ʵ�
    if max(iflaw)>1; iflaw = iflaw/fLen; end
    iflaw(iflaw>0.5) = iflaw(iflaw>0.5)-1;
end

% ����iflaw��ȡб�ʣ������õ�FRFT��ת�Ƕ�
kgen = diff(iflaw);% IF�ĵ�����б��k
% kgenl = [kgen(1);kgen];kgenr = [kgen;kgen(end)];
% kgen = (kgenl+kgenr)/2;
%ĳһ�����б��������б�ʺ���б�ʵľ�ֵ����ʵ����ֻȡkgenlҲӰ�첻��
popt = real(-acot(kgen*fLen)*2/pi);
% poptl = [popt(1);popt];poptr = [popt;popt(end)];
% popt = (poptl+poptr)/2;
popt = [popt(1);popt];%��Ҳ��֪��Ϊʲô��������������ĸ�����С

% ����ʵ��Ƶ�ʵ��Լ����ƫ��ֵ
fc = real(iflaw*fLen); 
uc = real(iflaw*fLen .* sin(popt*pi/2));%ʵ��FRFT��Ƶ��


end



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


function frac_x = fracft(x, theta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fractional Fourier Transform
%	frac_x = fracft(x, theta) with scale of sqrt(length(x))
% 
%	x      : Signal under analysis
%	theta  : Fractional Angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Main Program
N = length(x); M = floor(N/2);
theta = mod(theta,4);
if (theta==0)
  frac_x = x;
  return
elseif (theta==1)
  frac_x = fft([x(M+1:N); x(1:M)])/sqrt(N);
  frac_x = [frac_x(M+2:N); frac_x(1:M+1)]; % [[[--a sample delay related to fft--]]]
  return
elseif (theta==2)
  frac_x = flipud(x);
  return
elseif (theta==3)
  frac_x = ifft([x(M+1:N); x(1:M)])*sqrt(N);
  frac_x = [frac_x(M+2:N); frac_x(1:M+1)];
  return
end
if (theta > 2)
  x = flipud(x);
  theta = theta - 2;
end
if (theta > 1.5)
  x = fft([x(M+1:N); x(1:M)])/sqrt(N);
  x = [x(M+2:N); x(1:M+1)];
  theta = theta - 1;
end
if (theta < 0.5)
  x = ifft([x(M+1:N); x(1:M)])*sqrt(N);
  x = [x(M+2:N); x(1:M+1)];
  theta = theta + 1;
end

%% Interpolation using Sinc
P = 3;
x = interp_sinc(x, P);
x = [zeros(2*M,1) ; x ; zeros(2*M,1)];

%% Axis Shearing
phi   = theta*pi/2;
alpha = cot(phi);
beta  = csc(phi);
%%% First: Frequency Shear
c = 2*pi/N*(alpha-beta)/P^2;
NN = length(x); MM = (NN-1)/2; n = (-MM:MM)';
x2 = x.*exp(1i*c/2*n.^2);
% %%% Second: Time Shear
c = 2*pi/N*beta/P^2;
NN = length(x2); MM = (NN-1)/2;
interp = ceil(2*abs(c)/(2*pi/NN));
xx = interp_sinc(x2,interp)/interp;
n = (-2*MM:1/interp:2*MM)';
h = exp(1i*c/2*n.^2);
x3 = conv(xx, h, 'same');
if (isreal(xx) && isreal(h)); x3 = real(x3); end
center = (length(x3)+1)/2;
x3 = x3(center-interp*MM:interp:center+interp*MM);
x3 = x3*sqrt(c/2/pi);
%%% Third: Frequency Shear
c =  2*pi/N*(alpha-beta)/P^2;
NN = length(x3); MM = (NN-1)/2; n = (-MM:MM)';
frac_x = x3.*exp(1i*c/2*n.^2);

%% Output Signal
frac_x = frac_x(2*M+1:end-2*M);
frac_x = frac_x(1:P:end);
frac_x = exp(-1i*(pi*sign(sin(phi))/4-phi/2))*frac_x;



end

function x_r = interp_sinc(x, a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolation using anti-aliasing filter (Sinc Interpolation)
% x_r = interp_sinc(x, a)
% 
% x      : Signal under analysis
% a      : Resample ratio, equivalent to P/Q in the built in function
%         "resample"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
N = length(x);       % Original number samples
M = a*N - a + 1;     % New number of samples
temp1 = zeros(M,1);  %
temp1(1:a:M) = x;    % Adding a-1 zeros between samples

%% Creating the Sinc function
n = -(N-1-1/a):1/a:(N-1-1/a); h = sinc(n(:));

%% Filtering in the Frequency Domain
x_r = conv(temp1, h, 'same');
if (isreal(temp1) && isreal(h)); x_r = real(x_r); end
end


