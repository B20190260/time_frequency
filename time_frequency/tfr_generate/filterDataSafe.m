function y=filterDataSafe(x,winLen)
% �ڱ�������x���˲��������¶����ݽ����˲�ƽ������
if(nargin<2 || isempty(winLen)) winLen=10; end

w=hamming( floor(winLen*2) ); w=w./sum(w);

x = [x(1)*ones(1,winLen), x, x(end)*ones(1,winLen)];%��Ե����Է�ֹ�˲����µı�Ե����

x_mean=mean(x);
y=conv(x-x_mean,w,'same');
y=y+x_mean;
y = y(winLen+1:end - winLen);
end