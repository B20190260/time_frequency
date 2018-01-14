function [sigs,tfr,tfrv] = stftSeparation(x,ifs,halfLen,h)
%% ���ڶ�ʱ����Ҷ�任ʱ���˲����źŷ��룬�̶������ȣ�[sigs,tfr,tfrv] = stftSeparation(x,ifs,halfLen,h)
% ���룺x�������źţ��Ƕ�������ĵ���
%           ifs�������Ǹ���������˲ʱƵ�ʣ������ǹ�һ����-0.5��0.5�ģ�Ҳ������1-N������Ƶ�ʡ�
%           halLen���̶������ȵĴ��볤��
%           h����ѡһ�л���һ������Ĵ���������Ҫע��h(0)=1�������޷��ָ��źš�
% �����sigs������źţ����б�ʾһ���ź�
%           tfr������õ���STFT��
%           tfrv����ά����ֱ��ʾ����������STFT��


assert(nargin>=2,'At least 2 parameter is required.');
% ʱ���˲�ʱ�ظ���Ե�ĺ���ƣ�Ϊ�˱���ʱ���˲���Ե˥�����øò�������ѡ����Ϊ1����0
EDGE_REPEAT = 1;%

%������ʼ��
x = x(:);   tLen = length(x);  t=1:tLen; %��ȡʱ�䳤��
fLen = min([tLen, 512]);%Ƶ�����ֱ���Ϊ512
if max(ifs(:))<1; % Ƶ��ֵ��1����˵���ǹ�һ��Ƶ�ʣ�ת��Ϊ1-fLen֮��
    ifs = mod(round(ifs*fLen), fLen)+1; 
end
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

tfr= zeros(fLen,tLen) ;midN = round(fLen/2);% TFR������ʼ��
sigs = zeros(tLen,sigN);tfrv = zeros(fLen,tLen,sigN);
for it=1:tLen,
    ti= t(it); tau=max([-midN+1,-Lh,-ti+1]):min([midN-1,Lh,tLen-ti]);
    if EDGE_REPEAT
        %taux = [tau(1)*ones(1,tau(end) - abs(tau(1))),tau,tau(end)*ones(1,abs(tau(1))-tau(end))];%�ظ���ԵΪ��Եֵ
        taux = [zeros(1,tau(end) - abs(tau(1))), tau,zeros(1,abs(tau(1))-tau(end))];%�ظ���ԵΪ��ǰֵ
        tauh = 1:hlength;%ȫ���ظ�
        indices= (midN-Lh) : (midN + Lh);%ֵ�ظ�����
    else
        taux = tau;
        tauh = Lh+1+tau;
        indices= rem(midN+tau-1,fLen)+1;
    end
    % ����ԭʼSTFT
    tfr(indices,it)=x(ti+taux,1).*conj(h(tauh));
    stmp = tfr(:,it);%������źŷ���
    tfr(:,it)=fft(stmp);%����FFT�ף���ÿ��ʱ��
    %�Ը����ź�ʱ���˲�
    for is = 1:sigN
        %��ʱ��Ƶ�׵��˲�
        indrnd = mod(ifs(it,is)-halfLen : ifs(it,is)+halfLen,fLen)+1;
        ftfr = zeros(tLen,1);%��������
        ftfr(indrnd) = tfr(indrnd,it);%Ƶ���˲���Ƶ��ľ��δ�
        %�ź�ʱ��ֵ�ָ�
        st = ifft(ftfr);%�˲�������ݷ��任
        sigs(it,is) = st(midN);%������������м�ֵ���˲��ָ���Ҳ�����м�ֵ
        %plot(t,real(stmp),'b.-',t,real(st),'r.-')%�����ź�
        tfrv(:,it,is) = ftfr;
    end
end

end

