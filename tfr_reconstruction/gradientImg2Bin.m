function rBin = gradientImg2Bin(img,segs,portion)
% ��ȡ��ȡ���ݶȾ�ֵ��ͼ��ļ��ߣ���ö�ֵͼ���Ա���ڵ�IF���ƶ�ֵͼ����
% segs = 1000; %�ֶ�1000
% portion = 0.8;%����0.8��ֵ��С������--��0����������20%��Ϊ��ֵ��1

riHist = hist(img(:),segs);%����ֱ��ͼ�ֲ�
riPro = cumsum(riHist)/sum(riHist);%�����ܶȷֲ�
ind = find(riPro>portion);
thr = max(img(:))*ind/segs;%��ֵ����thr���־ͱ�����Ϊ0������thr�Ĳ�������Ϊ1
rBin = img>thr(1);

end