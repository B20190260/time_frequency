function [hat_y,r_n]=omp(s,T,N,K)
%  OMP�㷨�ĵĺ���: hat_y=omp(s,T,N)
%  s-������T-�۲���󣨻ָ����󣩣�N-������С�� K-�ź�ϡ���
% ����ʵ�ֲο����ף�Joel A. Tropp .et
%  Signal Recovery From Random Measurements Via Orthogonal Matching
%  Pursuit��IEEE TRANSACTIONS ON INFORMATION THEORY, VOL. 53, NO. 12,
%  DECEMBER 2007.
% ��1�θĽ���ÿ������в�����Ϳ������ڶ�����źŵ����ƥ����ȡ��
% ������ÿһ���������Ը����źŷ�����ʽ���벻ͬ�Ļָ�����T����ÿ��ȡ��һ������������Ĳв�������ȡ��һ��������



Size=size(T);                                     %  �۲�����С
M=Size(1);                                        %  ����
hat_y=zeros(1,N);                                 %  ���ع�������(�任��)����                     
Aug_t=[];                                         %  ��������(��ʼֵΪ�վ���)
r_n=s;                                            %  �в�ֵ

for times=1:K;                                    %  �������������ᳬ��ϡ���ԣ�
    for col=1:N;                                  %  �ָ����������������
        product(col)=abs(T(:,col)'*r_n);          %  �ָ�������������Ͳв��ͶӰϵ��(�ڻ�ֵ) 
    end
    [val,pos]=max(product);                       %  ���ͶӰϵ����Ӧ��λ��
    Aug_t=[Aug_t,T(:,pos)];                       %  ��������
    T(:,pos)=zeros(M,1);                          %  ѡ�е������㣨ʵ����Ӧ��ȥ����Ϊ�˼��Ұ������㣩
    aug_y=(Aug_t'*Aug_t)^(-1)*Aug_t'*s;           %  ��С���ˣ�ʹ�в���С����ʵ���ﱣ������λ�����Ϣ
    r_n=s-Aug_t*aug_y;                            %  �в�
    pos_array(times)=pos;                         %  ��¼���ͶӰϵ����λ��
    
    if (abs(aug_y(end))^2/norm(aug_y)<0.05)       %  ����Ӧ�ض���***��Ҫ��������ֵ��
        break;
    end
end

hat_y(pos_array)=aug_y;                           %  �ع�������

end