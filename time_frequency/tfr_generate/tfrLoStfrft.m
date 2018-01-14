function [tfr,ang] = tfrLoStfrft(x,prec,N,h)
%% �ֲ��Ż��Ķ�ʱ�����׸���Ҷ�任���㣺[tfr,ang] = tfrStfrft(x,prec,N,h)
% ���룺
%           x: �����ʱ�����ݣ�һ�л���һ��
%           prec: FRFT��ת�ǶȾ���
%           N�������Ƶ�򳤶ȣ���Ҫ>=0
%           h����ѡһ�л���һ������Ĵ���������Ҫע��h(0)=1�������޷��ָ��źš�
% �����
%           tfr������õ���STFRFT��
%           ang��STFRFT�ڸ���ʱ�̵���ת�Ƕȣ����ڽ�tfr�Ϲ��Ƶ�˲ʱƵ��ucת��Ϊfc


EDGE_REPEAT = 1;

x = x(:);   tLen = length(x);  t=1:tLen;%������ʼ��
if (nargin < 1),    error('At least 1 parameter is required.');  end
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
angT = zeros(1,tLen);
% �������ʱ�̵������ת��������ʱ������Ӵ���������������
for it=1:tLen,
    ti= t(it); startT = ti - hlength +1; endT = ti + hlength -1;
    if startT<1; startT = 1;end
    if endT>tLen;endT = tLen;end
    taux = startT : endT;
    xtmp = x(taux,1);% Ϊ�˼��ٿ���������ֻ���ݴ����ȵ����ݵ�Ѱ�ҽ�������
    angT(it) = findOptimalFrft(xtmp,pSel);%plot(real(xtmp))
end
% ��ang�����˲�ƽ������
ang = filterDataSafe(angT);%�˲���Ƚ�ƽ�����׳���TFR�����ϴ�����
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
    tfr(indices,it)=x(ti+taux,1).*conj(h(tauh));
    tfr(:,it)=frft(tfr(:,it),ang(it));%����FRFT
    
end


if (nargout==0),
    tfrqview(abs(tfr).^2,x,t,'tfrstft',h);
end
end

function [pOpt] = findOptimalFrft(x,pSel)
% ����pSel�ж�x�źŵ������ת������FRFT�任
% ���������ת����pOpt

G=zeros(length(pSel),length(x));	%��ͬ�����ı任�������
maxAm=0;        %��¼���Ƶ��
for k=1:length(pSel)
    tmp=fracft(x,pSel(k));      %�����׸���Ҷ�任
    G(k,:)=abs(tmp(:));       %ȡ�任��ķ���
    if(maxAm < max(abs(tmp(:))))
        [maxAm,uOpt]=max(abs(tmp(:)));       %��ǰ�����ڵ�ǰ��ĺ������
        pOpt=pSel(k);                %��ǰ���ֵ��Ľ���a
    end
end

%% �����õ����
% subplot(3,1,1);plot(real(x),'.-');title(['angle = ',num2str(pOpt)]);
% subplot(3,1,2:3);imagesc(1:length(x),pSel,G);xlabel('ut');ylabel('angle');axis xy;
% pause(0.05)

end
