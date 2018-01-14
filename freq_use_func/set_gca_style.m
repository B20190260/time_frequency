function set_gca_style(winSize, figType)
% ���ô��ڴ�С��������Ա����ճ����word��

if(nargin<1 || isempty(winSize)) winSize=[10,8]; end
axis tight;box on; grid on;%title('')%ͨ��word���治��Ҫtitle

FONT_TYPE='Times-Roman';
FONT_SIZE=10.5;
set(gca,'FontName',FONT_TYPE,'FontSize',FONT_SIZE,'color','white');
%     set(gca,'ytick',[0:0.04:0.2]);
%     set(gca,'xtick',[0:40:180]);    
% % ����ͼ��ռ��ȫ���Է��㿽�������⣬���Բ���һ�����ַ���֮һ��
% imshow(abs(TFD_ADTFD),[],'border','tight','initialmagnification','fit')
% set(gca, 'position', [0 0 1 1 ]);

% set(gcf,'WindowStyle','normal');%��ֹ�޸ĺ��ø���λ��
set(gcf,'unit','centimeters','position',[5 5 winSize(1) winSize(2)],'color','none')
% print -dmeta %����ʸ��ͼ

% ͼ����������ϵ����Ҫռ��ȫ��
if(nargin>1 && ischar(figType)) %Ϊ�˼���֮ǰ�ĳ��������ж�
    switch(lower(figType))
        case 'img';
            axis xy; axis off;set(gca, 'position', [0 0 1 1 ]);colormap('hot');
        otherwise;
    end
end

end

