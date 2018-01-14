function [beta0, beta1, beta2, vectij] = gradientVector(img,winLen)
% ���ݹ�ʽ6����beta0/1/2�������beta1��beta2���������෴����Ҫ����Ϊ������beta1��ʾˮƽ����beta2��ʾ��ֱ����
%���ۣ� V = [beta2, beta1];

[maxI,maxJ] = size(img);%maxI��ʾ��ֱ�������ֵ��maxJ��ʾˮƽ�������ֵ
beta0 = zeros(size(img));beta1 = zeros(size(img));beta2 = zeros(size(img));
%������������
% [neibori, neiborj] = neighborIndex(img, winLen, 'mirror');%�����������ֵ���������
% % ��ע���˴����������ֱ���������д����������ѭ��ȥ�������򣬱ȽϽ�ʡѭ��ʱ�䡿
method = 'mirror';
xi = [-winLen:winLen]';yi = xi';
Ax = sum(xi.^2);Ay = sum(yi.^2);
for k1 = 1:maxI
    for k2 = 1:maxJ
        %��������
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
        %cImg = img(neibori{k1,k2},neiborj{k1,k2});%��ͼ��
        cImg = img(h,v);%��ͼ��
        beta0(k1,k2) = sum(cImg(:))/(2*winLen+1).^2;%�����ֵ���ɵõ�beta0
        beta1(k1,k2) = sum(xi.*sum(cImg,2))/Ax/winLen;%ˮƽ�������ۼӣ��ٳ�ˮƽ�±��
        beta2(k1,k2) = sum(yi.*sum(cImg,1))/Ay/winLen;
    end
end

end

% 
% function [neibori, neiborj] = neighborIndex(img, winLen, method)
% % �������������������ͼ��img������뾶winLen
% % method Ϊ'repeat'ʱ��ʾ�߽����ظ����ص㣬���������Ӿ���ȷ���
% % �����ά����neibori/j���������ͼ��img���������ص�ߴ�(2m+1)���ֱ��ʾԭʼͼ��ij������������
% % ���ԣ�
% % img = [1:5;2:6;3:7]
% % [neibori, neiborj] = neighborIndex(img, 1, 'mirror');%�����������ֵ���������
% % cImg11 = img(neibori{1,1},neiborj{1,1})
% 
% % method = 'repeat';%�ظ���Ե--�����ڼ���ˮƽ�ʹ�ֱ�ļ�Ȩϵ��
% % method = 'mirror';%�����Ե--�����ڸ���ԭʼ�źŵ�������ֵ
% % method = 'none';%��������Ե--���������δȷ��
% 
% [maxI,maxJ] = size(img);%maxI��ʾ��ֱ�������ֵ��maxJ��ʾˮƽ�������ֵ
% neibori = cell(size(img));%���洹ֱ��������index
% neiborj = cell(size(img));%����ˮƽ��������index
% 
% for k1 = 1:maxI%ˮƽ����
%     for k2 = 1:maxJ%��ֱ����
%         h = (k1-winLen):(k1+winLen);%���������±�
%         v = (k2-winLen):(k2+winLen);
%         %�±�����-��Ե����
%         if strcmpi(method, 'repeat')%��Сд������
%             h(h<1) = 1; h(h>maxI) = maxI;%�ظ���Ե����
%             v(v<1) = 1; v(v>maxJ) = maxJ;
%         elseif strcmpi(method, 'mirror')%��Сд������
%             h(h<1) = maxI + h(h<1); %С��1�Ĳ��ֲ���maxI��������ֵ
%             h(h>maxI) = h(h>maxI) - maxI;%���ڳ��ȵĲ��ֲ�������1��ʼ
%             v(v<1) = maxJ + v(v<1);
%             v(v>maxJ) = v(v>maxJ) - maxJ;
%         else
%             %Ĭ����none��������Ե����
%         end
%         neibori{k1,k2} = h;%ˮƽ�����index
%         neiborj{k1,k2} = v;%��ֱ�����index
%     end
% end
% 
% end
% 
% 

