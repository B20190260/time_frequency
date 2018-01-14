function [linesInfo,errInfo] = curveModify(lines,N,stretch)
%% �޸��ͼ����ȡ��������Ϣ����Ҫ�޸���������������⣺
% 1�����߶˵�ķֲ����⣬���������ֲ����ֵ��Ϊ���ߵ���ֵ��
% 2����ֱ�������ŵ��������⣬��Ҫ������ϵ�ֱ�ߺ��������߶��޷��������������������˿��Խ��䶪��
% �����linesInfo���ṹ��cell��������Աline��ʾ�����������߶���Ϣ��type��ʾ�÷��������ͣ�
% ���룺N��ʾ��������

warning off;%�ر����ʱ����ʾ
% stretch = 1;%�����ӳ���LLS�ź�����Ϊ15���Իָ�

linesInfo = {};%��cell
errInfo = {};
for k=1:length(lines)
    line = lines{k};%��ȡ����������
    %[~,ind] = sort(line(:,1));line = line(ind,:);   %���պ�������plot(line(:,1),line(:,2),'.-');hold on
    %% �޸�line����ķֲ�ͽ�������
    
    
    x_min = max([min(line(:,1))-stretch,1]); x_max = min([max(line(:,1))+stretch,N]);
    x = x_min:x_max;%������--�����ӳ������������ӳ�winLen���ȽϺá�
    %% ֱ�ߺ�����������ϲ��ж���ע��ֲ������
    [fitreL, gofL] = linFit(line(:,1), line(:,2));%plot(x,fitreL(x),'kx-')
    [fitreS, gofS] = sinFit(line(:,1), line(:,2));%plot(x,fitreS(x),'r+-')
    resMax = 20*length(line);%���ܳ���5*���ȣ����￼�ǵ�����*2���ص�����*2������*4���ѡ�
    
    %% ����ȴ������ߵ�����
    if gofS.sse>resMax && gofL.sse>resMax %Sum of squares due to error
        fprintf('����%d����δʶ�𣬴���������\n',k);
        %% ������ڷ�������ԭ��
        errInfo{end+1} = line;
        continue;
    end
    
    %% �����������ж�������ֱ�߻���SIN����
    if gofL.sse<gofS.sse || isnan(gofL.sse) %2�����ʱ��LIN����ͨ������sse��nan
        line = [x',fitreL(x)];
        type = 'lin';%'sin', 'line','undefined'
        fun = fitreL;%���ϵ��
    else
        line = [x',fitreS(x)];
        type = 'sin';%'sin', 'line','undefined'
        fun = fitreS;%���ϵ��
    end
    linesInfo{end+1} = struct('line', line, ...%��������Ҫ����������ô��
        'type', type,...
        'fun', fun);%'sin', 'line','undefined'
end

%% �������
% for k = 1:length(linesInfo)
%     plot(linesInfo{k}.line(:,1),linesInfo{k}.line(:,2),'.-');hold on; 
% end
end

function [fitresult, gof] = sinFit(x, y)
%CREATEFIT(X,Y):cftool
%  Create a fit.
%  Data for 'mySin' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%  ������� FIT, CFIT, SFIT.

%% Fit: 'mySin'.
[xData, yData] = prepareCurveData( x, y );
% Set up fittype and options.
ft = fittype( 'fourier2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf -Inf -Inf 0.01];%��������������ϵ�Ƶ���½磬����½�̫С������ϵ�ֱ��
opts.StartPoint = [0 0 0 0 0 0.02];%����ֵ����Ҫ����Ҫ�����ȷ���У���
opts.Upper = [Inf Inf Inf Inf Inf pi];
% Fit model to data.
try
    [fitresult, gof] = fit( xData, yData, ft, opts );
catch
    fitresult = [];gof.sse = inf;
end
    
end

function [fitresult, gof] = linFit(x, y)
%CREATEFIT(X,Y)
%  Data for 'linFit' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%  ������� FIT, CFIT, SFIT.

%% Fit: 'linFit'.
[xData, yData] = prepareCurveData( x, y );
% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'Bisquare';
% Fit model to data.
try
    [fitresult, gof] = fit( xData, yData, ft, opts );
catch
    fitresult = [];gof.sse = inf;
end

end


