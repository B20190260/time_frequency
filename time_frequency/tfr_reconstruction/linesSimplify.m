function linesSim = linesSimplify(linesOrg)
%% �������������lineeOrg����ȥ�ز�������Ҫԭ���ǣ�
% ����IfLineSegmentDetection��⵽��lines���������������Զ�ĳ����������������ֵ���ܴ��ںܶ���ֵͬ��������������Ҫȥ����ͬ��ֵ��
% ������Ҫ�ֱ��ж�������������Ӧ����������û�п����Ƕ����߶εģ�����ǣ�����Ҫ�������ܵ��߶Σ�����Ǵ���

num=1;%��ȷ���߶��±�
for k = 1:length(linesOrg)
    %% ��ȡ�������ڵĺ�����ֵ
    x = linesOrg{k}(:,1);
    y = linesOrg{k}(:,2);
    xu = sort(unique(x));%�ҳ�x�е�����������������ǣ�xu�϶�����
    if length(xu)<5
        continue;
    end
    yut = {};yu = [];
    %% ȡ���к������Ӧ��������ֵ��unique+sort�Է������Ĳ���
    for m = 1:length(xu)
        yu_temp = unique(y(x==xu(m)));%�ҵ�����x=xu(m)��yֵ
        yut{m} = sort(yu_temp);%��ȡ������xu��Ӧ��yuֵ
    end
    %% �ж������Ƿ���Ҫ����һ��x��Ӧ���ֵ��������������Ǵ���
    err = 0;%�޴���
    for m = 1:length(yut)
        if length(yut{m}) ==1%ֻ��һ��ֵ
            yu(m) = yut{m};
        elseif length(yut{m}) >= yut{m}(end) - yut{m}(1)+1%�������ڣ�����ǰ��unique�ˣ����ڵĿ����Բ���
            yu(m) = mean(yut{m});
        else %���������������ɢ��������ֵ����Ӧ���������߶Σ���Ǵ���
            if m==1
                yu(m) = min(yut{m});%ȡ���һ���߶�
            else
                try
                    ind = floor(min(abs(yut{m} - yu(m-1))));%���ǰһ��ֵ�������
                    yu(m) = yut{m}(ind);%ȡ���ǰһ��ֵ�ĵ�
                catch
                    yu(m) = yut{1}(1);%ȡ��һ����
                end
            end
            %fprintf('�߶�-%d-�������ܴ��ڴ��󣬰�������߶Σ���������ֵ���¼����߶Σ�\n',k);
            err = 1;%�д���
            %break;
        end
    end
%     if err==0%�����д�����߶�
        linesSim{num} = [xu,yu'];%����߶�
        num = num+1;
%     end
%     plot(xu,yu','b.-'); hold on; grid on;
end

end