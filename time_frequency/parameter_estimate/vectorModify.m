function [beta1fix,beta2fix] = vectorModify(beta1,beta2)
% ���ݹ�ʽ8�����ݶ�������beta1��beta2
% �����ķ��������������������ң�Ҳ������Ϊͼ������ϵ����ͬ������ת����ͬ�ɣ���Ӧ�ò�Ӱ����ۡ�

beta1fix = zeros(size(beta1));beta2fix = zeros(size(beta2));%��ʼ��

% % 13���޵�ʸ������
% [quad13] = find(beta1.*beta2>=0);
% beta1fix(quad13) = beta2(quad13);
% beta2fix(quad13) = -beta1(quad13);
% % 24���޵�ʸ������
% [quad24] = find(beta1.*beta2<0);
% beta1fix(quad24) = -beta2(quad24);
% beta2fix(quad24) = beta1(quad24);

% 12���޵�ʸ������
quad12 = find(beta1>=0);
beta1fix(quad12) = beta2(quad12);
beta2fix(quad12) = -beta1(quad12);
% 34���޵�ʸ������
quad34 = find(beta1<0);
beta1fix(quad34) = -beta2(quad34);
beta2fix(quad34) = beta1(quad34);

end

