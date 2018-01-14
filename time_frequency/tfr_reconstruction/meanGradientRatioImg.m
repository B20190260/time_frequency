function rImg = meanGradientRatioImg(beta0,beta1, beta2, beta1fix, beta2fix)
% ���ݹ�ʽ9����������ͼ��Mean ratio images
% ���ã�rImg = meanGradientRatioImg(beta0, beta1, beta2, beta1fix, beta2fix);

[maxI,maxJ] = size(beta0);%maxI��ʾ��ֱ�������ֵ��maxJ��ʾˮƽ�������ֵ
method = 'mirror';
iniLen = 3;%������Ǹ���TFDѡ�񣬺�TFD���߿�Ƚ��ƱȽϺá�
ep = 1e-2;%��ֵ���������ֵ̫��
sigmoid = @(x) 4*iniLen*(1./(1+exp(-0.2*x)) - 0.5) + 1;%����--���ڳ��ȣ�����Ӧ����

veci=zeros(size(beta0));
vecj=zeros(size(beta0));
rImg = zeros(size(beta0));

for k1 = 1:maxI
    for k2 = 1:maxJ
        %% ����̶������ȵ�����
        h = (k1-iniLen):(k1+iniLen);%���������±�
        v = (k2-iniLen):(k2+iniLen);
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
        %% ��������Vectorͼ���ֵ�����ת������Ȼ���������Ӧ��������󣨾��ΰ����Ĳ���ֵΪ1��
        cImg1 = beta1fix(h,v);%��ͼ��
        cImg2 = beta2fix(h,v);%��ͼ��
        veci(k1,k2) = sum(cImg1(:))/(2*iniLen+1).^2;
        vecj(k1,k2)  = sum(cImg2(:))/(2*iniLen+1).^2;
        winLen = sigmoid(veci(k1,k2).^2 + vecj(k1,k2).^2);%������Ӧ����
        %[neibor,radius,squre] = neighborRectangleIndex(winLen, -vecj(k1,k2), -veci(k1,k2));%Ѱ�������±�
        [neibor,radius,squre] = neighborRectangleIndex(winLen, vecj(k1,k2), veci(k1,k2));%Ѱ�������±�
        
        %% ��ȡԭͼ���е���ͼ���������
        h = (k1-radius):(k1+radius);%���������±�
        v = (k2-radius):(k2+radius);
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
        %% ��ͼ�鿴��ȷ���
        if veci(k1,k2).^2 +vecj(k1,k2).^2 > 50
            figure(1);clf;subplot(121)
            imagesc(beta0);axis xy; grid on;
            itmp = zeros(size(beta0));itmp(h, v) =neibor;
            subplot(122);imagesc(itmp); axis xy; grid on; hold on;
            [x,y] = meshgrid(1:length(beta0),1:length(beta0));%��ͼר����������
            quiver(x(:),y(:),vecj(:),veci(:),'r');axis tight;%���ƴ�����ͼ
        end
        
        %% ��������Ӧ���ڵĵľ�ֵͼ�񣬹�ʽ9
        cImg1 = beta1fix(h,v).*neibor; cImg2 = beta2fix(h,v).*neibor;%��ͼ��
        cImg3 = beta1(h,v).*neibor; cImg4 = beta2(h,v).*neibor;
        cImen1 = sum(cImg1(:))/squre;cImen2 = sum(cImg2(:))/squre;%��ͼ���ֵ
        cImen3 = sum(cImg3(:))/squre;cImen4 = sum(cImg4(:))/squre;
        %rImg(k1,k2) = beta0(k1,k2) * (cImen1.^2 +cImen2.^2) /max([ep,cImen3.^2 +cImen4.^2]);
        rImg(k1,k2) = (cImen1.^2 +cImen2.^2) /max([ep,cImen3.^2 +cImen4.^2]);
        % ������Ӧ�������⣬����һ��cImen1�Ƿ�������һ��Զ����cImen3���Ͼ����귭ת�ˣ�����

        %[veci(k1,k2),vecj(k1,k2)]
    end
end

%% �������
% [x,y] = meshgrid(1:length(beta0),1:length(beta0));%��ͼר����������
% figure; quiver(x(:),y(:),vecj(:),veci(:));axis tight;%���ƴ�����ͼ
% figure; surf(sigmoid(veci.^2 + vecj.^2));axis tight;%���ƴ������ݴ�С
% figure; imshow(rImg>5); axis xy;axis tight;%���ƴ������ݴ�С


end


function [neibor,radius,squre] = neighborRectangleIndex(winLen, veci, vecj)
% ����������ε������������winLen��ʾ�����ȣ����η���[veci, vecj]
% ����һά������Ϊ�±꼴�ɣ�����������beta1��beta2�ľ�ֵ�Լ�rImg��


safeGuard = 0.5;%���ձ�Ե
method = 'mirror';
if abs(veci)>abs(vecj)
    winHei = abs(winLen*vecj/veci);%ȡ����ֵ����֤������>�߶�
else
    winHei = abs(winLen*veci/vecj);
end
% ���ȶ�Ӧ�������򣬸߶ȴ�ֱ��������
radius = round(sqrt(winHei.^2 + winLen.^2));%�����ķ��ΰ뾶
ind = -radius:radius;
[indi, indj] = meshgrid(ind,ind);%��������

veci = veci/sqrt(veci.^2 + vecj.^2);
vecj = vecj/sqrt(veci.^2 + vecj.^2);
fun1 = @(x,y) (veci * x + vecj * y + winLen + safeGuard);%���ձ�Ե
fun2 = @(x,y) (veci * x + vecj * y - winLen - safeGuard);
fun3 = @(x,y) (-veci * y + vecj * x + winHei + safeGuard);
fun4 = @(x,y) (-veci * y + vecj * x - winHei - safeGuard);
% ezplot(fun1); axis equal; grid on; hold on;
% ezplot(fun2); axis equal; grid on; hold on;
% ezplot(fun3); axis equal; grid on; hold on;
% ezplot(fun4); axis equal; grid on; hold on;
% axis([-radius,radius,-radius,radius]);plot([0,veci],[0,vecj],'r-')

neibor = fun1(indi,indj)>0 &  fun2(indi,indj)<0 & fun3(indi,indj)>0 & fun4(indi,indj)<0;
squre = sum(neibor(:)==1);%���


end


