function [tfr,ang] = tfrCoStfrft(x,prec,N,h)
%% �ֲ��Ż��Ķ�ʱ�����׸���Ҷ�任���㣺[tfr,ang] = tfrCoStfrft(x,prec,N,h)
% ���룺
%           x: �����ʱ�����ݣ�һ�л���һ��
%           prec: FRFT��ת�ǶȾ���
%           N�������Ƶ�򳤶ȣ���Ҫ>=0
%           h����ѡһ�л���һ������Ĵ���������Ҫע��h(0)=1�������޷��ָ��źš�
% �����
%           tfr������õ���STFRFT��
%           ang��STFRFT�ڸ���ʱ�̵���ת�Ƕȣ����ڽ�tfr�Ϲ��Ƶ�˲ʱƵ��ucת��Ϊfc
% ��д����ȥ�ˡ�����������δ��ɣ�����ʹ�á�


x = fmlin(128,-0.1,-0.45) + fmlin(128,0.0,0.45);%�����ź�
sigN = 2;%�ź���������Ҫ����Ϊ���룬��Ҫ��Ҫ֪ʶ�ж��ź�������

EDGE_REPEAT = 1;

x = x(:);   tLen = length(x);  t=1:tLen;%������ʼ��
% if (nargin < 1),    error('At least 1 parameter is required.');  end
if (nargin < 2),    prec = 0.1;     end;
if (nargin < 3),    N=tLen;     end;
if (nargin < 4),
    if (N<0),    error('N must be greater than zero.');end;
    hlength=floor(N/4);
    hlength=hlength+1-rem(hlength,2);
    h = tftb_window(hlength);
end
h = h(:);
hrow=length(h); Lh=(hrow-1)/2;
if (rem(hrow,2)==0),  error('H must be a smoothing window with odd length.');end
% h=h/norm(h);%��֤h(0)=1�����ָܻ��ź�
pSel = 0.5:prec:1.5;%������ת�Ƕȴ�ѡ�������

tfr= zeros (N,tLen) ;midN = round(N/2);
angT = zeros(sigN,tLen);ang = zeros(sigN,tLen);
% �������ʱ�̵������ת��������ʱ������Ӵ���������������
for it=1:tLen,
    ti= t(it); startT = ti - hlength +1; endT = ti + hlength -1;
    if startT<1; startT = 1;end
    if endT>tLen;endT = tLen;end
    taux = startT : endT;
    xtmp = x(taux,1);% Ϊ�˼��ٿ���������ֻ���ݴ����ȵ����ݵ�Ѱ�ҽ�������
    angT(:,it) = findOptimalFrfts(xtmp,pSel,sigN);%plot(real(xtmp))
end
% ��ang�����˲�ƽ������
for k = 1:sigN
    ang(k,:)=filterDataSafe(angT(k,:));%�˲���Ƚ�ƽ�����׳���TFR�����ϴ�����
end
% ang = filterDataSafe(angT);%�˲���Ƚ�ƽ�����׳���TFR�����ϴ�����
% plot(t,angT,'.-',t,ang,'r.-');

% �Ը���ʱ�̽���FRFT�任
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
    % ����ԭʼSTFT
    xtmp = zeros(N,1);
    xtmp(indices) = x(ti+taux,1).*conj(h(tauh));
    for k = 1:sigN
        tfr(:,it)=tfr(:,it) + frft(xtmp,ang(k,it));%����FRFT
    end
end


if (nargout==0),
    tfrqview(abs(tfr).^2,x,t,'tfrstft',h);
end
end


function [pOpts] = findOptimalFrfts(x,pSel,sigN)
% �������м�ֵ����Ϊ��ǰ�����ת�Ƕ�

% ����
thr = 0.05;%��ֵ��Ե�������о�
winLen = 4;%������ڳ���


pOpts = ones(sigN,1);
edgeLen = ceil(length(x)/4);%������Ե�״��
xres = [x(1)*ones(edgeLen,1);x(:);x(end)*ones(edgeLen,1)];
% figure(1);subplot(sigN+1,1,1);t = 1:length(xres); plot(t,real(xres),'.-');hold on;
for k = 1:sigN
    % ����
    [frt,pOpt,uOpt,~] = findOptimalFrft(xres,pSel);%��ȡ��ǿ�����ķֲ�ֵ
    frtm = signalFilterIter(frt, uOpt, thr, winLen);%ȥ����ǿ����
    pOpts(k) = pOpt;%������ֵ
    xk = ifrft(frtm,pOpt);
    xtmp = xres - xk;%����в�
    xres = [xtmp(edgeLen + 1)*ones(edgeLen,1);xtmp(edgeLen + 1:end - edgeLen);xtmp(end - edgeLen)*ones(edgeLen,1)];%ÿ�ζ�ȥ����Եֵ
    
    %�������
%     figure(1);subplot(sigN+1,1,k);plot(t,xk,'rx-');
%     figure(1);subplot(sigN+1,1,k+1);t = 1:length(xres); plot(t,real(xres),'.-');hold on
%     figure(2); plot(t,abs(frt),'b.-',t,abs(frtm),'rx-')
end

end




function [frt,pOpt,uOpt,maxAm] = findOptimalFrft(x,pSel)
% ����pSel�ж�x�źŵ������ת������FRFT�任
% ���������ת�Ƕ��µ�FRFT�任 frt�������ת�Ƕ� pOpt�����ֵ���ڵ�λ�� uOpt�� ����ֵ maxAm

G=zeros(length(pSel),length(x));	%��ͬ�����ı任�������
maxAm=0;        %��¼���Ƶ��
for k=1:length(pSel)
    tmp=frft(x,pSel(k));      %�����׸���Ҷ�任
    tmp_abs = abs(tmp);
    G(k,:)=tmp_abs;       %ȡ�任��ķ���
    %mtmp = mean(tmp_abs);    kurtosis= sum((tmp_abs-mtmp).^4)/sum((tmp_abs-mtmp).^2)%�����̬
    if(maxAm < max(tmp_abs))
        frt = tmp;%���FRFT�任���ֵ
        [maxAm,uOpt]=max(tmp_abs);       %��ǰ�����ڵ�ǰ��ĺ������
        pOpt=pSel(k);                %��ǰ���ֵ��Ľ���a
    end
end

%% �����õ����
% subplot(3,1,1);plot(real(x),'.-');title(['angle = ',num2str(pOpt)]);
% subplot(3,1,2:3);imagesc(1:length(x),pSel,G);xlabel('ut');ylabel('angle');axis xy;
% pause(0.05)

end


function y = signalFilterIter(x, ind, thr, maxLen)
% �������Ƶ������x����ind��������������ҵ���ֵ�߽磬����ֵ���ݶ���0��
% �߽�Ķ��壺���ֵС����ֵedgeThr*max���Ǽ�Сֵ�ĵ㡣������ҵ��ļ�ֵ�㳬��maxLen�������
edgeThr = 0.2; %��Ե
Len = length(x);
y = x;%Ĭ�϶���0
y(ind) = x(ind); maxAbs = abs(x(ind));%�������ֵ
%% ��ǰ����
absp = maxAbs;
for len = 0:maxLen %ע����Ҫ����0���ȵ�
    indc = mod(ind-len,Len) + 1; %�������
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp);   end%�߽絽������
    y(indc) = 0;%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end
%% ��������
absp = maxAbs;
for len = 0:maxLen 
    indc = mod(ind+len,Len) + 1; %���ұ���
    absc = abs(x(indc));
    if maxAbs<absc; maxAbs = absc; end
    if (absc < maxAbs*thr); break; end %������ֵ
    if (absc < maxAbs * edgeThr) && (absc > absp);   end%�߽絽����������Ҫ��Ϊ�����ƽ������
    y(indc) = 0;%���ڵ�������˲��������
    absp = absc; %��¼���ڵ�ķ�ֵ
end

end




