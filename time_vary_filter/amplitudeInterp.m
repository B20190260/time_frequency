function sigs_o = amplitudeInterp(sigs, sifs, enLen, edgeLen)
%% sigs_o =amplitudeInterp(sigs, sifs, enLen, edgeLen) ��������ĸ��������ź�sigs����Ӧ�˲�ǰ�����ؽ��ź�sigs_o
% ���룺
%       sigs�� �ṹ�����飬��ʾ����������ź�
%       sifs : �źŸ���������˲ʱƵ��
%       enLen : IF�������չ���룬�ڸþ����ڶ����в�ֵ
%       edgeLen����Ե����˥��ĳ��ȣ�ͨ������ΪSTFTʱ���˲���TFR�����ȵ�1/4
% �����sigs_o������sigsһ���ĺ��壬�����޸��˷��ȵ��ӵĵط�

[tLen,sigN] = size(sigs);%����ȷ��
t = 1:tLen; %ʱ�̵�
sigs_o = zeros(size(sigs));% �źų�ʼ��

enLarge = ones(enLen);%IF����������չ����
for k=1:sigN;    tfrv(:,:,k) = imdilate(tfrideal(sifs(:,k)),enLarge);    end
stfr = sum(tfrv,3);%��ʱƵ�ֲ�

% �źŻ��������
for k = 1:sigN%�Ը����ź�
    %x = hilbert(sigs(:,k));%��k���������źţ�ϣ�����ر任��ȡ�ź�˲ʱ����
    %��ʵ�źű������һ�������źţ�����ϣ�����ر任ֱ��abs�����źŵķ��ȡ����ֱ����Ϸ��Ⱦ����ˡ�
    x_abs = abs(sigs(:,k));%�����źŵķ���
    % ��������źŵ��Ӳ��ֵķ�ֵ
    oTfrk = tfrv(:,:,k).*stfr - tfrv(:,:,k);%ȡ����k�����ڽ�������ط���ֵ
    overlays = sum(abs(oTfrk),1);%�������ʱ�̵ĵ��ӷ���ֵ
    %imagesc(abs(oTfrk));axis xy;figure;plot(overlays);axis tight
    cor_index = find(overlays==0);%�ҵ������֮���������Ϊ��ֵ��֪��
    if length(cor_index)< 3; sigs_o(:,k) = sigs(:,k); continue; end
    if length(cor_index) > 2* edgeLen;%���㳬�����ȵ�����²ſ��Բ�ֵ������ֻ��ȡ���м�����ֵ
        %cor_index = cor_index(edgeLen:end - edgeLen);%ȥ����Ե���ֵ�ֵ�������ٲ�ֵ����
        x_abs(1:edgeLen) = x_abs(edgeLen);   x_abs(end - edgeLen:end) = x_abs(edgeLen);%��Ե�޷���ֵ��ֻ��ֱ��ȡֵ
    end
    x_abs_hat = interp1(cor_index,x_abs(cor_index),t,'linear');%���Բ�ֵ����õķ�ʽ linear ,
    x_abs_hat = filterAbs(x_abs_hat,20)'; %ƽ������% plot(t,x_abs_hat,'k.-')
    sigs_o(:,k) = sigs(:,k)./x_abs.*x_abs_hat;%���ȵ���
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
