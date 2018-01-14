function sigs_o = amplitudeFit(sigs, tfr, tfrv, edgeLen)
%% sigs_o = amplitudeFit(sigs, tfr, tfrv, edgeLen) ��������ĸ��������ź�sigs����Ӧ�˲�ǰ�����ؽ��ź�sigs_o
% ���룺
%       sigs�� �ṹ�����飬��ʾ����������ź�
%       tfr : �źŵ�����ʱƵ�ֲ�
%       tfrv�� ʱ���˲�������˲���ֲ�
%       edgeLen����Ե����˥��ĳ��ȣ�ͨ������ΪSTFTʱ���˲���TFR�����ȵ�1/4
% �����sigs_o������sigsһ���ĺ��壬�����޸��˷��ȵ��ӵĵط�

[tLen,sigN] = size(sigs);%����ȷ��
t = 1:tLen; %ʱ�̵�
sigs_o = zeros(size(sigs));% �źų�ʼ��
oTfr = sum(tfrv,3) - tfr.*(sum(abs(tfrv),3)~=0); %���洦��λ��

% �źŻ��������
for k = 1:sigN%�Ը����ź�
    %x = hilbert(sigs(:,k));%��k���������źţ�ϣ�����ر任��ȡ�ź�˲ʱ����
    %��ʵ�źű������һ�������źţ�����ϣ�����ر任ֱ��abs�����źŵķ��ȡ����ֱ����Ϸ��Ⱦ����ˡ�
    x_abs = abs(sigs(:,k));%�����źŵķ���
    % ��������źŵ��Ӳ��ֵķ�ֵ
    [r,c] = find(oTfr~=0);%�ҵ����������Ϊ0�ĵط�
    oTfrk = zeros(size(tfr));    oTfrk(r,c) = tfrv(r,c,k);%ȡ����k�����ڽ�������ط���ֵ
    overlays = sum(abs(oTfrk),1);%�������ʱ�̵ĵ��ӷ���ֵ
    %imagesc(abs(oTfrk));axis xy;figure;plot(overlays);axis tight
    cor_index = find(overlays==0);%�ҵ������֮���������Ϊ��ֵ��֪��
    if length(cor_index)< 3; sigs_o(:,k) = sigs(:,k); break; end
    if length(cor_index) > 2* edgeLen;%���㳬�����ȵ�����²ſ��Բ�ֵ������ֻ��ȡ���м�����ֵ
        %cor_index = cor_index(edgeLen:end - edgeLen);%ȥ����Ե���ֵ�ֵ�������ٲ�ֵ����
        x_abs(1:edgeLen) = x_abs(edgeLen);   x_abs(end - edgeLen:end) = x_abs(edgeLen);%��Ե�޷���ֵ��ֻ��ֱ��ȡֵ
    end
    try %������ϣ��˴��������ֻ�����SIN�������У���Ҫ�����ʽ�Ķ��壬��ͨ�á�
        [fitreS, gofS] = sinFit(cor_index, x_abs(cor_index));%gofS.sse��Ӧ���Ч��
        x_abs_hat = fitreS(t);%��ϵķ�ʽ��ȡ% plot(t,x_abs_hat,'k.-')
        assert(gofS.sse.^2<std(x_abs),'fit error!');%�����ֵ���Ѵ����ѡ��
    catch
        x_abs_hat = interp1(cor_index,x_abs(cor_index),t,'linear');%���Բ�ֵ����õķ�ʽ linear ,
        x_abs_hat = filterAbs(x_abs_hat,20)'; %ƽ������% plot(t,x_abs_hat,'k.-')
    end
    sigs_o(:,k) = sigs(:,k)./x_abs.*x_abs_hat;%���ȵ���
end





end

function [fitresult, gof] = sinFit(x, y)
%CREATEFIT(X,Y):cftool
%  Create a fit.
%  Data for 'mySin' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%  ������� FIT, CFIT, SFIT.

warning('off','iWarnIfSizeMismatch');%�رոþ���

%% Fit: 'mySin'.
[xData, yData] = prepareCurveData( x, y );
% Set up fittype and options.
ft = fittype( 'fourier1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf 0];%���һ����w�ķ�Χ
opts.StartPoint = [0 0 0 0.05];
opts.Upper = [Inf Inf Inf pi];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

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
