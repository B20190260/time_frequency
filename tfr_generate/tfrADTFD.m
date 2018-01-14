function tfr= tfrADTFD(s,alpha1,alpha2,winLen)
%% ���� adaptive directional filtering distribution��tfr = tfrADTFD(s,alpha1,alpha2,winLen)
% �ο���Boashash B, Khan N A, Ben-Jabeur T. Time�Cfrequency features for
% pattern recognition using high-resolution TFDs: A tutorial review [J].
% Digital Signal Processing, 2015, 40(2015): 1-30.  ��4.2��
% ������x ������ʵ�����߸�������һά��
% alpha1/2�� alpha1��DGF�˵�a������alpha2��DGF��b������
%                   �ֱ����DGF��t��f�����չ��ͨ������aС(=2)��b��(=12)�õ������Ժ�ǿ�Ļ����ˡ�
% winLen�� DGF�˵Ĵ�С����������С��
% tfr���������ʱƵ�ֲ��������ʵ������

s = s(:);%ά��ƥ��

%% �����źŵ�WVD
times=1; % Ƶ�ʲ��������ʱ����������չ����
tfrWvd = quadtfd(s, length(s)-1, 1, 'wvd',length(s)*times);%���һ��������ʾFFT����


%% WVD�˲�--�õ��Ľ����TFR
alpha=0.6; %Ĭ��EMBD����
if length(s)>200;     alpha=0.25;   end
% ѡ��EMBD�ˣ��ο�[1] Barkat B, Boashash B. A high-resolution quadratic
% time-frequency distribution for multicomponent signals analysis [J]. IEEE
% Transactions on Signal Processing, 2001, 49(10): 2232-9. 
t=-floor(winLen/2):floor(winLen/2);%�˵ļ���ʱ��
h1=1./((cosh(t).^2).^alpha); h1=h1/sum(h1);
h2=1./((cosh(t).^2).^alpha); h2=h2/sum(h2);
embKer=h1'*h2;%EMBD�ǿɷ���ˣ���˿���ֱ����������˼��ɡ�
tfrEmbd=filter2(embKer,tfrWvd);%�õ�EMBD��


%% ������������DGF�˾���
endAngle=180; %�ܵ���ת�Ƕ�
stepAndle=3;%��ת�˵���ת�ǶȲ���
% ������ת�� rotKer
[x,y]=meshgrid(-1:2/winLen:1,-1:2/winLen:1);
rotKer = cell(endAngle/stepAndle);
for k=0:endAngle/stepAndle-1
    angle=pi*k*stepAndle/endAngle;
    
    xr=x*cos(angle)-y*sin(angle);%��ʽ52
    yr=x*sin(angle)+y*cos(angle);
    
    ker=exp((-1/2)*(((alpha1*xr).^2)+(alpha2*yr).^2));
    ker=ker.*(1-alpha2*alpha2*yr.^2);
    ker=ker/sum(sum(abs(ker)));
    rotKer{k+1} = ker;
end


%% ʹ�ÿ��پ���ķ���ʵ�ֹ�ʽ53--55�еľ������
[fLen,tLen]=size(tfrEmbd);
safeSize = paddedsize(size(tfrEmbd));%����FFT2�ı��ճ���
Ftfr = fft2(double(tfrEmbd), safeSize(1), safeSize(2));%Ƶ��ʵ�֣�������ȼ���Ƶ��%imagesc(log10(1+abs(fftshift(Ftfr))))
FtfrAbs = fft2(double((abs(tfrEmbd))), safeSize(1), safeSize(2));%����abs���ʱƵ�ֲ�Ƶ��
% subplot(121);imagesc(log(1+abs(fftshift(Ftfr))));subplot(122);imagesc(log(1+abs(fftshift(FtfrAbs))));
absResult=zeros([safeSize(1)-length(ker) safeSize(2)-length(ker) endAngle/stepAndle]);%��������FtfrAbs�ĵ������к˵ľ������ľ�������ѡ��Ƕ�
cmplxResult=absResult;%��������Ftfr�ĵ������к˵ľ������ľ������ڱ�����
for k=0:endAngle/stepAndle-1
    kerk = rotKer{k+1};
    Fkerk = fft2(double(kerk), safeSize(1), safeSize(2));%DGF��Ƶ�򣬲���Ƶ��˻�ʵ�֡���һ���������ǰ��Ԥ������ɵġ�
    
    Fmutiple = Fkerk.*Ftfr;%Ƶ��˻�ʵ�־��
    tfr_kerk = real(ifft2(Fmutiple));%�л��ص�ʱ��
    cmplxResult(:,:,k+1)=(tfr_kerk(round(length(kerk)/2):end-round(length(kerk)/2), round(length(kerk)/2):end-round(length(kerk)/2)));
    Fmutiple = Fkerk.*FtfrAbs;
    tfr_kerk =( abs(ifft2(Fmutiple))).^2;%����ֻ����ABSֵ��Ϊ���
    absResult(:,:,k+1)=(tfr_kerk(round(length(kerk)/2):end-round(length(kerk)/2), round(length(kerk)/2):end-round(length(kerk)/2)));
end
% Ѱ�Ҿ��ֵ���ĽǶ��µļ�����
[~,a]=max(absResult,[],3);%��ʽ55���������ֵ��ת�Ƕ�������ת�Ƕȵ�����

%% �������
tfr_opt=zeros(size(tfrEmbd));
for m=1:fLen %����ÿһ��ʱƵ�㣬ѡ�������ת�Ƕ��µ�ֵ
    for n=1:tLen
        tfr_opt(m,n)=cmplxResult(m,n,a(m,n));%ѡ�������ת�Ƕȵ�����õ��ķ����Դtfrֵ������
    end
end

%% �ٴ�ʹ��EMBD�˲�������÷ֱ��ʽ���
tfr=filter2(embKer,tfr_opt);
tfr(tfr<0)=0;




end


function PQ = paddedsize(AB, CD, PARAM)
%PADDEDSIZE Computes padded sizes useful for FFT-based filtering.
% PQ = PADDEDSIZE(AB), where AB is a two-element size vector,
% computes the two-element size vector PQ = 2*AB.
%
% PQ = PADDEDSIZE(AB, 'PWR2') computes the vector PQ such that
% PQ(1) = PQ(2) = 2^nextpow2(2*m), where m is MAX(AB).
%
% PQ = PADDEDSIZE(AB, CD), where AB and CD are two-element size
% vectors, computes the two-element size vector PQ. The elements
% of PQ are the smallest even integers greater than or equal to
% AB + CD -1.
%
% PQ = PADDEDSIZE(AB, CD, 'PWR2') computes the vector PQ such that
% PQ(1) = PQ(2) = 2^nextpow2(2*m), where m is MAX([AB CD]).
%
%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.5 $  $Date: 2003/08/25 14:28:22 $
if nargin == 1
    PQ = 2*AB;
elseif nargin == 2 && ~ischar(CD)
    PQ = AB + CD - 1;
    PQ = 2 * ceil(PQ / 2);
elseif nargin == 2
    m = max(AB); % Maximum dimension.
    % Find power-of-2 at least twice m.
    P = 2^nextpow2(2*m);
    PQ = [P, P];
elseif nargin == 3
    m = max([AB CD]); %Maximum dimension.
    P = 2^nextpow2(2*m);
    PQ = [P, P];
else
    error('Wrong number of inputs.')
end
end

