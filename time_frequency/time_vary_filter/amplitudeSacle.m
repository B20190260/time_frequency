function sigs_o = amplitudeSacle(sigs, tfr, tfrv)
%% sigs_o = amplitudeSacle(sigs, tfr, tfrv) ��������ĸ��������ź�sigs����Ӧ�˲�ǰ�����ؽ��ź�sigs_o
% ���룺
%       sigs�� �ṹ�����飬��ʾ����������ź�
%       tfr : �źŵ�����ʱƵ�ֲ�
%       tfrv�� ʱ���˲�������˲���ֲ�
% �����sigs_o������sigsһ���ĺ��壬�����޸��˷��ȵ��ӵĵط�
% ����ʧ�洦��֪����δ�������δ���ƣ������á�

[~,sigN] = size(sigs);%����ȷ��
sigs_o = sigs;% �źų�ʼ��
oTfr = sum(tfrv,3) - tfr.*(sum(abs(tfrv),3)~=0); %���洦��λ��

% �źŻ��������
for k = 1:sigN%�Ը����ź�
    % ��������źŵ��Ӳ��ֵķ�ֵ
    [r,c] = find(oTfr~=0);%�ҵ����������Ϊ0�ĵط�
    oTfrk = zeros(size(tfr));    oTfrk(r,c) = tfrv(r,c,k);%ȡ����k�����ڽ�������ط���ֵ
    sacleS = sum(oTfrk,1);%�������ʱ�̵ĵ��ӷ���ֵ
    N0Number = sum(oTfrk~=0,1) + 1;%�ҵ���0�������
    sacle = sacleS./N0Number;
    inder = find(sacle~=0);%�ҵ���Ϊ0��λ�þ����е��ӵ�λ��
    sacle = 1 + filterAbs(sacle, 15);
    %subplot(211);imagesc(abs(oTfrk));axis xy;subplot(212);plot(abs(sacle));axis tight
    %hold on;plot(abs(sum(tfrv(:,:,1))),'r')
    sigs_o(inder,k) = sigs(inder,k)./sacle(inder).';%���ȵ���
end



end

function abs_smooth=filterAbs(x,winLen)
%---------------------------------------------------------------------
% filter IF law by convolving with Hamming window
%---------------------------------------------------------------------
if(nargin<2 || isempty(winLen)) winLen=15; end

w=hamming( floor(winLen) ); w=w./sum(w);

abs_mean=mean(x);
abs_smooth=conv(x-abs_mean,w,'same');
abs_smooth=abs_smooth+abs_mean;

end
