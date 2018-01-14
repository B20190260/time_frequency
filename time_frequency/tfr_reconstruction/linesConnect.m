function linesCon = linesConnect(linesOrg,expDis)
%  ���ݶ˵����Ͷ˵��ݶȽ���ƴ�ӣ�ֻ�����ھ���curveModify�����������߶���Ϣ
% ���Ҫֱ������linesSimplify�����Ĳ�������Ҫ��conMatrix�µ�linesOrg{k}.line()�޸�ΪlinesOrg{k}()����Ϊcell�ṹ��ͬ��

% ������룬ֻ��һ��������������
if length(linesOrg)<2;
%     return linesOrg;
end

%% �������Ӿ���
con = conMatrix(linesOrg,expDis);
conVec = transMatrix2Struct(con);

%% ��������
for k=1:length(conVec)
    linesCon{k} = [];
    for m = 1:length(conVec{k})
        line = linesOrg{conVec{k}(m)}.line;%��ȡ����
        linesCon{k} = [linesCon{k};line];%����ƴ��
    end
end

end

function con = conMatrix(linesOrg,expDis)
%% �����ڽӾ���conn����ĳ�����߶ο�������ʱ���ǵĽ�������Ϊ1

% ��������
interNum = 1;%������������������������֮ǰ��curveModify�����й�
% expDis = 50;%�����ļ�����룬��������������п��ܱ���Ϊ������
% ���LxLSʱѡ��100�����SSѡ��40�Ϻá�
floEps = 0.1;%�ݶȵ������ֵ������Ϊ��ˮƽ�߶�

con = eye(length(linesOrg));%���Ӿ�����������������ӦԪ�ؽ�����1
for k1 = 2:length(linesOrg)
    for k2 = 1:(k1-1)%ֻ��Ҫ�����ж�
        %��������k1��k2�Ŀ�������
        x1 = linesOrg{k1}.line(:,1);x2 = linesOrg{k2}.line(:,1);
        if length(intersect(x1,x2))>interNum%���ڹ��ཻ��ֵ�������������ӵ�
            continue;
        end
        y1 = linesOrg{k1}.line(:,2);y2 = linesOrg{k2}.line(:,2);
        %plot(x1,y1,'r.-',x2,y2,'b.-');legend('k1','k2');
        if x1(1)<x2(1)% k1��ǰ
            interVec = [x2(1) - x1(end), y2(1) - y1(end)];%����ݶ�
            preVec = [1,y1(end) - y1(end-1)];%ǰ���ݶ�
            proVec = [1,y2(2) - y2(1)]; %����ݶ�
        else %k2��ǰ
            interVec = [x1(1) - x2(end), y1(1) - y2(end)];%����ݶ�
            preVec = [1,y2(end) - y2(end-1)];%ǰ���ݶ�
            proVec = [1,y1(2) - y1(1)]; %����ݶ�
        end
        
        if abs(proVec(2))<floEps & abs(preVec(2))<floEps & interVec(1)<5
            %������Ϊ�ǡ���Ƶ�źš����Ӵ������Ǵ˴���û�漰�����������ݲ�����
        end
        
        interAbs = norm(interVec,'fro');%�������
        interVec = interVec/interVec(1);%����ݶȣ���һ��Ϊx����1���������ж�
        if (proVec(2)*preVec(2)<0 | interVec(2)*proVec(2)<0 | interVec(2)*preVec(2)<0 ) & ...
                (abs(proVec(2))>2*floEps | abs(preVec(2))>2*floEps | abs(interVec(2))>2*floEps)
            continue;%����������������ӣ��з�ˮƽ�ݶȵ��Ƿ���һ��
            %�оݿ����޸�Ϊ��
            %min([proVec(2)*preVec(2),interVec(2)*proVec(2),interVec(2)*preVec(2)])<0&max(abs([proVec(2),preVec(2),interVec(2)]))>2*floEps
        end
        %cor=min(min(corrcoef([interVec;preVec;proVec]')))%%�������������ϵ����ֻ������1�����ʺ������б�
        %����������
        maxdif = max(abs([interVec(2) - preVec(2), interVec(2) - proVec(2), preVec(2) - proVec(2)]));
        maxVec = max(abs([interVec(2), proVec(2), preVec(2)]));
        rel = expDis/interAbs * maxVec/maxdif; %����������interAbs�ɷ��ȣ���maxdif�ɷ���
        %relԽ���������߶�Խ�п�������
        if rel>1
            con(k1,k2) = 1;%k1��k2Ӧ������
        end
    end
end

end


function conV = transMatrix2Struct(con)
% �������con���Ӿ���ת��Ϊcell�������������ߵ�����
[col,raw] = find(con==1);

if length(col)<1%��û���ཻ��
    conV = num2cell(1:length(con));
    return;
end

num = 1;
while length(raw) >0
    conV{num} = [col(1),raw(1)];
    col(1) = [];%ɾ��Ԫ��
    raw(1) = [];
    flag = 0;
    while flag == 0%һֱ�������ڿ��Ժϲ���Ϊֹ
        flag=1;%Ѱ��֮ǰ��Ĭ��û��
        k = 1;
        while k <= length(raw)
            setT = [col(k),raw(k)];%���е�����
            if sum(ismember(setT,conV{num}))>0
                conV{num} = [conV{num},setT];%������ϲ�
                col(k) = [];
                raw(k) = [];
                %k = k-1;%matlabѭ���Ĳ��淶������Ҫ����
                flag=0;%���ڿ��Ժϲ���
            else
                k = k+1;
            end
        end
    end
    num = num+1;
end

for k=1:length(conV)
    conV{k} = unique(conV{k});%����ϲ�ʱ���ظ�������
end

end










