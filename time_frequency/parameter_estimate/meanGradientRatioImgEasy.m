function rImg = meanGradientRatioImgEasy(beta0,beta1, beta2, beta1fix, beta2fix, winLen)
% ���ݹ�ʽ9����������ͼ��Mean ratio images
% ���ã�rImg = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix);

[maxI,maxJ] = size(beta0);%maxI��ʾ��ֱ�������ֵ��maxJ��ʾˮƽ�������ֵ
method = 'mirror';
% winLen = 2;%������Ǹ���TFDѡ�񣬺�TFD���߿�Ƚ��ƱȽϺá�
ep = 1;%���ֵԽ��Խ����������ٷ�ֵ����������ȡ0.5-1֮��Ϻ�
rImg = zeros(size(beta0));

for k1 = 1:maxI
    for k2 = 1:maxJ
        %% ����̶������ȵ�����
        h = (k1-winLen):(k1+winLen);%���������±�
        v = (k2-winLen):(k2+winLen);
        %�±�����-��Ե����
        if strcmpi(method, 'repeat')%��Сд������
            h(h<1) = 1; h(h>maxI) = maxI;%�ظ���Ե����
            v(v<1) = 1; v(v>maxJ) = maxJ;
        elseif strcmpi(method, 'mirror')%��Сд������
            h(h<1) = maxI + h(h<1); %С��1�Ĳ��ֲ���maxI��������ֵ
            h(h>maxI) = h(h>maxI) - maxI;%���ڳ��ȵĲ��ֲ�������1��ʼ
            v(v<1) = maxJ + v(v<1);
            v(v>maxJ) = v(v>maxJ) - maxJ;
        else
            %Ĭ����none��������Ե����
        end

        %% ��������Ӧ���ڵĵľ�ֵͼ�񣬹�ʽ9
        cImg1 = beta1fix(h,v); cImg2 = beta2fix(h,v);%��ͼ��
        cImg3 = beta1(h,v); cImg4 = beta2(h,v);
        cImen1 = sum(cImg1(:))/(winLen*2+1).^2;cImen2 = sum(cImg2(:))/(winLen*2+1).^2;%��ͼ���ֵ
        cImen3 = sum(cImg3(:))/(winLen*2+1).^2;cImen4 = sum(cImg4(:))/(winLen*2+1).^2;
        rImg(k1,k2) = beta0(k1,k2) * (cImen1.^2 +cImen2.^2) /max([ep,cImen3.^2 +cImen4.^2]);
        %rImg(k1,k2) = (cImen1.^2 +cImen2.^2) /max([ep,cImen3.^2 +cImen4.^2]);

    end
end

rImg(rImg<0)=0; %surf(log10(rImg+1));axis tight
rImg = log10(rImg+1);%ָ�����ź�ȽϷ�������ֱ�۸о�

end

