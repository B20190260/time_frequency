%% TFSA���������
% ��tfsa6���洰���в��Ե����н��������ת��Ϊ����ʵ�֣��ص㷽���ǣ�
% 1��Tfsa6>>Tools>>quad..TF anal��>>����ѡ��B-distradition��Ȼ�󿴵���Ҫ��������Ĳ����������д�����=127��ʱ��ֱ���=1������beta=0.1��FFT����128��
% 2��֮�󵽰�װĿ¼���ҵ�quadtfd�鿴���������Խ��������F1������������÷�����tfd = quadtfd( signal, lag_window_length, time_res, kernel [, kernel options] [,fft_length ] );%����kernelΪ��b��ʱ��ʾ�÷ֲ�����Ҫ�Ĳ���Ϊbeta����˾Ϳ��Ը��ݽ����ϵĲ����������ˡ�


%% �źŲ���
clear all;clc; close all;
N=512;
t=1:N;
s1=gsig('lin',0.1,0.4,N,1);%����LFM��ʵ���ź�
figure,plot(t,s1); axis tight;
s2=gsig('cubic',0.1,0.4,N,0);%����LFM��ʵ���ź�
figure; tfrspwv(s2);%TFTB�����亯����������
s3=gsig('step',0.1,0.4,N,0,8);%����LFM��ʵ���ź�
figure; tfrspwv(s3);
s4 = gsig( 'sin', 0.25, 0.02, 128, 1, 1);
figure; tfrspwv(s4);
s5=analyt(s1);%���������ź�
figure; tfrspwv(s5);


%% ����ʱƵ����
tfd = quadtfd(s4, 127, 1, 'emb', 0.1, 0.1);%alpha=0.1,beta=0.1
tfr = tfrspwv(s4);%�����Աȵ�Ч��
figure('Position',[50,50,1200,600]); 
subplot(121);imagesc(tfd);title('Extended Modified B-distribution');
subplot(122);imagesc(tfr);title('SPWVD')
%��ʾkernal
for b=logspace(-3,0,20)
    for a=logspace(-3,0,20)
        bk = quadknl( 'emb', 127, 1 ,a, b);
        surf(bk), pause(0.01)
    end
end
%ʱƵ�ֲ����ƣ���ʵ��ʹ�øû��Ʒ���ȷʵ�����÷ֲ����ÿ���
% ����ʵ���Ϸֲ����ǲ���ô��������
p = tfsapl( s4, tfd);


%% ���ʱƵ�ֲ�
tfd6 = pwvd6(s2,127,1,8);%��ֵ��8����
tfd4 = pwvd4(s2,127,1);
figure('Position',[50,50,1200,600]); 
subplot(121);imagesc(tfd6);title('6r-WVD');
subplot(122);imagesc(tfd4);title('4r-WVD')

%% ģ������
am = ambf(s2,1,127);
figure, surf(abs(am))

%% ˲ʱƵ�ʹ���
s = s3;
if1 = zce( s, 64);plot(t,if1,'b.-'); hold on
if2 = wvpe(s, 127, 1);plot(t,if2,'r.-');
if3 = pwvpe(s,127,1,8);plot(t,if3,'k.-');
if4 = rls(s,0.5);plot(t,if4,'bx-');
if5 = pde(s,2);plot(t,if5,'rx-');
if6 = lms(s,0.5);plot(t,if4,'kx-');
legend('zce','wvpe','pwvpe','rls','pde','lms');axis tight; xlabel('t');ylabel('IF')
%��ʵ�Ͻ�����ò�ƻ���������ʽ��


