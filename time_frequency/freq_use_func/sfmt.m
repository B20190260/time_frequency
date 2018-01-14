function [X, s_hat] = sfmt(s, k0, l0 )
%% ���ҵ�Ƶ�任��������k0/l0ʱ��ʾ����ָ��λ�õ�ֵ��
% �ο�����־��, �¾�, ��ѩ, et al. ������ɢ���ҵ�Ƶ�任�Ķ�������ҵ�Ƶ�źŲ������Ʒ���[J]. ϵͳ��������Ӽ���, 2012(10): 1973-1979.
% ���룺sԭʼ�źţ�һ�л���һ��
% �����X��SFMT�׻��ߵ���ֵ��s_hat������SFMT�׷�ֵ��Ӧ��SFM�ź�
% ���Խű�1��% clear all; clc
% N = 128;
% k0 = 1;
% l0 = 16;
% t = [0:N-1]';
% s = exp(1i*l0/k0*sin(2*pi*k0*t/N));%plot(t,real(s),'.-') %��ʽ5����֪k0��l0ʱ�ָ�ԭʼ�źŵķ���
% % stft = tfrstft(s);imagesc(abs(stft));
% [X,s_hat] = sfmt(s);
% stft = tfrstft(s_hat);imagesc(abs(stft));%���Է��ִ˴���ȷ
% ���Խű�2��
% s = fmsin(128);
% [X, s_hat] = sfmt(s);
% stft = tfrstft(s_hat);imagesc(abs(stft));%���Է��ִ˴�����ȷ>>�ڴ���f0������»����

% ������ʼ��
s = s(:);
N = length(s);
t = [0:N-1]';
norfmsin =@(k,l,t,N) exp(-1j*l/k*sin(2*pi*k*t/N));% Ȩ���ź�

if nargin>=2%����>=2ʱֻ�����ض����ֵ
    assert(k0<=N && k0>=1 && mod(k0,1)==0 , '�����k0����Ϊ�����ҷ�ΧΪ1��N֮�䣡');
    assert(l0<=N && l0>=1 && mod(l0,1)==0 , '�����l0����Ϊ�����ҷ�ΧΪ1��N֮�䣡');
    fms = norfmsin(k0,l0,t,N);%����Ȩ���ź�
    X = sum(s.*fms);
else%�����������SFMT��
    X = zeros(N);
    for k = 1:1:N
        for l = 1:1:N
            fms = norfmsin(k,l,t,N);%����Ȩ���ź�
            X(k,l) = sum(s.*fms);
        end
    end
%     surf(abs(X));axis tight; xlabel('l'); ylabel('k')
    [ko,lo] = find(X == max(X(:)));
    s_hat = norfmsin(ko,-lo,t,N);%����Ȩ���ź�
end



end
