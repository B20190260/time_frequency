% ����Matlabʵ�ֻ���任�����������ߵ��Զ�ʶ��̫���ˣ���ʵ�ã�
clc;clear all;close all;
%% ģ���ѷ�
n=200;
m=200;
x=ones(n,m);
h=1;

A1=40;
phi1=180;
baseline1=100;
for i=1:200;
    y1=A1*(sin(i*2*pi/200-phi1*pi/180))+baseline1;
    x(round(y1),i)=0;
    for j=round(y1)-h:round(y1)+h;
        x(j,i)=0;
    end
end

% ���뽷������
gray = x;
gray = imnoise(x,'salt & pepper',0.1);
% figure;
% imshow(gray);
% axis on;
% ylabel('y/���ص�');
% xlabel('x/���ص�');
% set(gcf,'Units','centimeters','Position',[2 2 15 18]);
% set(gca,'FontName','Times New Roman','FontSize',8)
% set(gca,'Units','centimeters','Position',[3 3 3 8]);%����xy����ͼƬ��ռ�ı�������ʼλ��
% set(get(gca,'XLabel'),'FontSize',8);%ͼ������Ϊ8 point
% set(get(gca,'YLabel'),'FontSize',8);

%% ��������
range = 100;
img = ones(n+2*range,m);
[nn mm] = size(img);
img(range+1:range+n,1:m) = gray;
% W = 2*pi/m;%ò�Ʋ�û���õĲ���
% figure;
% imshow(img);

% num = 0;
% for ii = 1:nn;
%     for jj = 1:mm;
%         if(img(ii,jj) == 0);
%             num = num+1;
%         end
%     end
% end

%% ��ͳ����任
counter = zeros(range,360,n);
for i = 1:n
    for j = 1:m
        if(gray(i,j) == 0)
            for baseline = 1:n
                for fy = 1:360%��ȷ��360��ÿ��һ��ֵ
                    if(sin(j*2*pi/m-fy*pi/180)==0)
                        A=0;
                    else
                        A=(i-baseline)/(sin(j*2*pi/m-fy*pi/180));
                    end
                    if(A>0 && A+baseline<=n && baseline-A>=1 && A<range);
                        AA=uint8(round(A));
                        counter(AA,fy,baseline)=counter(AA,fy,baseline)+1;
                    end
                end
            end
        end
    end
end
[Amax, indmax] = max(counter(:));
[amplitude,phase,baseline] = ind2sub(size(counter), indmax);


[x,y,z]=size(counter);
X=1:x;
Y=1:y;
Z=1:z;
[x1,y1,z1]=meshgrid(Y,X,Z);
figure;
slice(x1,y1,z1,counter,phase,amplitude,baseline);
colormap hot
shading interp
xlabel('\phi');
ylabel('A');
zlabel('y0');

figure;
contourslice(x1,y1,z1,counter,[0,phase/2,phase,phase+(360-phase)/2,360],[0,amplitude,n/2],[0,baseline,n]);
xlabel('\phi');
ylabel('A');
zlabel('y0');


figure;
pham=zeros(x,y);
pham=counter(:,:,baseline);
[x2,y2]=meshgrid(Y,X);
pcolor(x2,y2,pham);
colormap hot
shading interp
title('3ά�ռ䴹ֱ����');
xlabel('\phi');
ylabel('A');

figure;
phbase=zeros(y,z);
phbase=reshape(counter(amplitude,:,:),360,n);
[y3,z3]=meshgrid(Z,Y);
pcolor(z3,y3,phbase);
colormap hot
shading interp
title('3ά�ռ�ǰ��ͼ');
xlabel('\phi');
ylabel('y0');

figure;
ambase=zeros(x,z);
%ambase=reshape(n,counter(:,phase,:),n);
for i=1:x;
    for j=1:z;
        ambase(i,j)=counter(i,phase,j);
    end
end
%ambase=counter(:,phase,:);
[x4,z4]=meshgrid(Z,X);
pcolor(z4,x4,ambase);
colormap hot
shading interp
title('3ά�ռ�����ͼ');
xlabel('A');
ylabel('y0');
set(gca,'xdir','rev');

figure;
imshow(gray,[]);
axis on;
XX=1:m;
YY=amplitude*sin(2*pi.*XX/m-phase*pi/180)+baseline;
hold on;
plot(XX,YY,'red');
xlabel('x/����');
ylabel('y/����');








