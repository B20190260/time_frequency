%% �������źŵ���λ�ָ�
% fmlin��fmsin�ĳ�ʼ��λָ����û�У��޷�ʵ�֣����Ҫ���Ļ���Ҫ�����źű��ʽ��

clear all; clc;
%% ������ʼ��
N = 128;
F0 = 0.1;
K = (0.4-F0)/N;
flin = @(t,p) exp(1i*(2*pi*F0*t + pi*K*t.^2 + p));%LFM���ʽ

%% �źŲ���
% figure(1)
pO = pi;
t = 1:N;
s_org = flin(t,pO);%tfrsp(s_org.');
% subplot(211);plot(real(s_org)); axis tight;
s = awgn(s_org,10,'measured');
% subplot(212);plot(real(s)); axis tight;

%% ��֤MMSE�ĵ�����
% pT = 0:0.001:2*pi;
% for pt = 1:length(pT)
%     sT = flin(t,pT(pt));
%     err(pt) = std(sT - s);
%     %err(pt) = sum((sT - s).^2);
% end
% plot(pT,err,'kx-');axis tight; grid on; xlabel('phase'); ylabel('MSE'); hold on;% legend('p_{org} = 0','p_{org} = 1','p_{org} = 2','p_{org} = 3','p_{org} = 4','p_{org} = 5');
% % ���ۣ�����������λ��һ����0-2pi���ǵ����ģ�ֻ��һ����ֵ�㣬����������ʱ��Խ�����Ҫ2piλ��


%% ��λ����
% figure(2)
% err=inf;
% p_hat = pi;
% miu = 0.99999;
% while err(end) > 1e-3*std(s)
%     sh = flin(t,p_hat(end));
%     er1 = sh - s;
%     p_vec = (er1 - mean(er1)).*(1j*sh - 1j * mean(sh));
%     p_dir = mean(p_vec);
%     miu = miu;
%     p_hat(end+1) = p_hat(end) - miu * p_dir; %ѭ��
%     subplot(211);plot(abs(p_hat));axis tight; title('abs(p)')
%     err(end+1) = std(er1);
%     subplot(212);plot(err); axis tight; title('stdErr')
%     pause(0.01)
% end
% p_hat = p_hat(end);%ģ����λ������
% s_hat = flin(t,p_hat);
% subplot(211);plot(real(s)); axis tight;


%% MSE���㹫ʽ���ο���ʱ���˲����źźϳɡ�ʽ7.10
sh = flin(t,0);%������һ����ʼ��λ����
% figure;tfrsp(sh.');%���Է��ֳ�ʼ��λ����Ӱ��TFRWV��ֵ
pf = sum(s.*conj(sh));
pf = pf/abs(pf);% ��ʽ
sh = sh.*pf;
subplot(211);plot(t,real(s_org),'k.-',t,real(s),'gx-', t,real(sh),'ro-'); axis tight; legend('ԭʼ�ź�','�����ź�','�ָ��ź�');
subplot(212);plot(t,imag(s_org),'k.-',t,imag(s),'gx-', t,imag(sh),'ro-'); axis tight; legend('ԭʼ�ź�','�����ź�','�ָ��ź�');
% >>���У���
