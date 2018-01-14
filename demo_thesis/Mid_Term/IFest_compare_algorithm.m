function [hif1,hif2] = IFest_compare_algorithm(tfr,delta_freq_samples,min_track_length,max_peaks,lower_prctile_limit)
% �Ա��㷨���ܵ�ͼ�񣬲����ο�����ʵ�֡�

% �㷨����
if nargin < 2; delta_freq_samples= 10; end%IF׷�ٵ��ݶȣ��������Ϊ10��ͼ�����
if nargin < 3;min_track_length=20; end%��̸���IFƬ�γ���

%% �㷨ʵ��
% ����-���� Ƶ�� BDIF �����㷨����Ҫ��֪�źŸ���--����֪ʶ
if nargin < 4;max_peaks = 3; end% �����źŷ���
hif1 = tracks_MCQmethod(tfr,1,delta_freq_samples,min_track_length,max_peaks);% (tf,Fs,delta_limit,min_length,MAX_NO_PEAKS)

% ͼ���ֵ���-���� LPDCL �㷨
if nargin < 5;lower_prctile_limit = 75; end % ���Ե��ڸ������İٷֱ�
hif2 = tracks_LRmethod(tfr,1,delta_freq_samples,min_track_length,lower_prctile_limit);%(tf,Fs,delta_limit,min_length,LOWER_PRCTILE_LIMIT )


end