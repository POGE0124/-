% function main()
%% ��������ڴ桢���ں�����������
clc
clear all
close all
%% ������ִ��ʱ��: T   ��ʱ��ʼ
tic
%% �������ݲ�������
inputdata_options.classes_num=3;%�������࣬��������Add_Original_Data�����еı�ǩҲ��Ҫ��
inputdata_options.sample_total=10000;%����������,��������ģ����Ǳ�����sample_num��������
inputdata_options.sample_num=14;%�������������������
inputdata_options.n_columns=1000;%����ά�ȣ����������

%% ����ԭʼ����
fprintf('���ڼ�������......');
[Input_Data]=Add_Original_Data(inputdata_options);
%% ����AEģ�Ͳ���
hidden.num1=13;%��һ������Ԫ����
hidden.num2=22;%�ڶ�������Ԫ����
hidden.num3=40;%����������Ԫ����
hidden.net_trainParam_epochs=500;%��������
hidden.learn_rare=0.01;%AEѧϰ�ʣ�0-1֮�䣬Խ��Խ���׹���ϣ�ԽС�����ٶ�Խ����
%% ѡ�������߽�ģ��������Ԥ��
n=input('��ѡ��1�����߽�ģ������2������Ԥ�⣩��');
switch n
    case 1
%% ����DNN�ӳ���
dnn(Input_Data,inputdata_options,hidden);

%% ����ֵ��Ϊ�������ݵ��ܲ��Ծ���
load probabilitypred
pred1_2= pred_test_original;
pred2_2= pred_test_slope;
pred3_2= pred_test_curvature;
%����ֵ��һ��
original=exp(probability_original);
probability_original_1=zeros(size(original,1),size(original,2));
for i=1:size(original,2)
        for j=1:size(original,1)
        probability_original_1(j,i)=original(j,i)/sum(original(:,i));
        end
end
slope=exp(probability_slope);
probability_slope_1=zeros(size(slope,1),size(slope,2));
for i=1:size(slope,2)
        for j=1:size(slope,1)
        probability_slope_1(j,i)=slope(j,i)/sum(slope(:,i));
        end
end
curvature=exp(probability_curvature);
probability_curvature_1=zeros(size(curvature,1),size(curvature,2));
for i=1:size(curvature,2)
        for j=1:size(curvature,1)
        probability_curvature_1(j,i)=curvature(j,i)/sum(curvature(:,i));
        end
end
% n=input('��ѡ��1��δ��һ��������2����һ������');
n=1;
switch n
    case 1
%        probability_original=probability_original;
%        probability_slope=probability_slope;
%        probability_curvature=probability_curvature;
    case 2
       probability_original=probability_original_1;
       probability_slope=probability_slope_1;
       probability_curvature=probability_curvature_1;
    otherwise
        disp('�������');
end

%�ҳ���������ֵ��Ϊ������
[predp1,xulie1]=max(probability_original);
[predp2,xulie2]=max(probability_slope);
[predp3,xulie3]=max(probability_curvature_1);

predpp=[predp1;predp2;predp3];
predppp=max(predpp);
fenlei=zeros(1,length(testLabels));
for i=1:length(testLabels)
if predppp(i)==predp1(i)
    fenlei(i)=xulie1(i);
elseif predppp(i)==predp2(i)
    fenlei(i)=xulie2(i);
elseif predppp(i)==predp3(i)
    fenlei(i)=xulie3(i);
end
end
figure
plot(fenlei,'r*');
% �����������ݵ�ʵ�����
hold on
plot(testLabels,'b+');
title('�����ںϽ��');
h=legend('Ԥ��','ʵ��','location','northwest');
set(h,'Box','off');
set(h,'Fontsize',12);
%����ֵ��Ϊ���������ܲ��Ծ���
accProb = mean(testLabels(:) == fenlei(:));
%% ���߼������ںϲ���
pred2=zeros(1,length(testLabels));
for i=1:length(testLabels)
    if pred1_2(i)==1&&pred2_2(i)==1&&pred3_2(i)==1
    pred2(i)=1;
    elseif pred1_2(i)==2&&pred2_2(i)==2&&pred3_2(i)==2
    pred2(i)=2;   
    elseif pred1_2(i)==3&&pred2_2(i)==3&&pred3_2(i)==3
    pred2(i)=3;   
    else
        if (pred1_2(i)==1&&pred2_2(i)==1)||(pred1_2(i)==1&&pred3_2(i)==1)||...
                (pred2_2(i)==1&&pred3_2(i)==1)
        pred2(i)=1;
        elseif  (pred1_2(i)==2&&pred2_2(i)==2)||(pred1_2(i)==2&&pred3_2(i)==2)||...
                (pred2_2(i)==2&&pred3_2(i)==2)
        pred2(i)=2;    
        elseif  (pred1_2(i)==3&&pred2_2(i)==3)||(pred1_2(i)==3&&pred3_2(i)==3)||...
                (pred2_2(i)==3&&pred3_2(i)==3)
        pred2(i)=3;  
        else
            if i>9
                s=zeros(1,10);
                sum1=0;
                sum2=0;
                sum3=0;
                for j=1:10
                     s(j)=pred2(i-j);
                     if s(j)==1
                         sum1=sum1+1;
                     elseif s(j)==2
                         sum2=sum2+1;
                     else
                         sum3=sum3+1;
                     end                     
                end
                A=[sum1,sum2,sum3];
                maxRes=max(A);
                if maxRes==1
                  pred2(i)=1; 
                elseif maxRes==2
                  pred2(i)=2; 
                else
                    pred2(i)=3; 
                end
            else
                pred2(i)=1;    
            end
        end
    end
end
figure
plot(pred2,'r*');
% �����������ݵ�ʵ�����
hold on
testLabels=Input_Data.testLabels;
plot(testLabels,'b+');
title('���߼��ںϽ��')
h=legend('Ԥ��','ʵ��','location','northwest');
set(h,'Box','off');
set(h,'Fontsize',12);
% ���߼��ں��ܲ��Ծ���
acc = mean(testLabels(:) == pred2(:));
%% ����ִ����ʱ��
T=toc;

%% �������ݵ�xls�����ȥ
fprintf('���ڱ�������......\n');
sgc_exist = exist('DNNresult.xls', 'file');
if sgc_exist==0
 c=2;
 save c c
else 
load c
c=c+1;
save c c 
end
d = {'����γ��','������', '����1��Ԫ��','����2��Ԫ��','����3��Ԫ��','AEѧϰ��','��������',...
    'ѵ��ԭʼ������','����ԭʼ������','ѵ��б�ʷ�����',...
    '����б�ʷ�����','ѵ�����ʷ�����','�������ʷ�����','�Ը��ʵ��ܷ�����','�Ծ��ߵ��ܷ�����',...
    '������ʱ��(����)'};
xlswrite('DNNresult.xls', d, 'result', 'A1');
load classesResult;
xlswrite('DNNresult.xls', inputdata_options.n_columns,'result', strcat('A',num2str(c)))
xlswrite('DNNresult.xls', inputdata_options.sample_num, 'result', strcat('B',num2str(c)))
xlswrite('DNNresult.xls', hidden.num1, 'result', strcat('C',num2str(c)))
xlswrite('DNNresult.xls', hidden.num2, 'result', strcat('D',num2str(c)))
xlswrite('DNNresult.xls', hidden.num3, 'result', strcat('E',num2str(c)))
xlswrite('DNNresult.xls', hidden.learn_rare, 'result', strcat('F',num2str(c)))
xlswrite('DNNresult.xls', hidden.net_trainParam_epochs, 'result', strcat('G',num2str(c)))
xlswrite('DNNresult.xls', acc_train_original * 100, 'result', strcat('H',num2str(c)))
xlswrite('DNNresult.xls',  acc_test_original * 100, 'result', strcat('I',num2str(c)))
xlswrite('DNNresult.xls', acc_train_slope * 100, 'result', strcat('J',num2str(c)))
xlswrite('DNNresult.xls', acc_test_slope * 100, 'result', strcat('K',num2str(c)))
xlswrite('DNNresult.xls', acc_train_curvature * 100, 'result', strcat('L',num2str(c)))
xlswrite('DNNresult.xls',  acc_test_curvature * 100, 'result', strcat('M',num2str(c)))
xlswrite('DNNresult.xls', accProb * 100, 'result', strcat('N',num2str(c)))
xlswrite('DNNresult.xls', acc * 100, 'result', strcat('O',num2str(c)))
xlswrite('DNNresult.xls', fix(T/3600)*60+fix(mod(T,3600)/60), 'result', strcat('P',num2str(c)));

dt=fix(clock);
fprintf('ʱ���¼��%d�� %d�� %d�� %dʱ %d�� %d��\n',dt(1),dt(2),dt(3),dt(4),dt(5),dt(6)); 
fprintf('����������ʱ��: %dh��%dmin, %ds\n',fix(T/3600),fix(mod(T,3600)/60),...
    fix(mod(mod(T,3600),60)));
%% ����Ԥ��
    case 2
        disp('����Ԥ�⣡');
        %�����������
        load para11
        load para12
        stackedAEOptTheta1=stackedAEOptTheta;
        netconfig1=netconfig;
        load para21
        load para22
        stackedAEOptTheta2=stackedAEOptTheta;
        netconfig2=netconfig;
        load para31
        load para32
        stackedAEOptTheta3=stackedAEOptTheta;
        netconfig3=netconfig;
        %Ԥ�����ڴ�
        pred2=zeros(1,length(Input_Data.testLabels));
        %ԭʼ�����������
        for i=1:length(Input_Data.testLabels)
        [pred_test_original,probability_original] = stackedAEPredict(stackedAEOptTheta1, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig1, Input_Data.testData_original(:,i));
        pred1_2=pred_test_original;
        %б�������������
        [pred_test_slope,probability_slope] = stackedAEPredict(stackedAEOptTheta2, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig2, Input_Data.testData_slope(:,i));
        pred2_2=pred_test_slope;
        %���������������
        [pred_test_curvature,probability_curvature] = stackedAEPredict(stackedAEOptTheta3, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig3, Input_Data.testData_curvature(:,i));
        pred3_2=pred_test_curvature;
    %���߼������ںϲ���
    if pred1_2==1&&pred2_2==1&&pred3_2==1
    pred2(i)=1;
    elseif pred1_2==2&&pred2_2==2&&pred3_2==2
    pred2(i)=2;   
    elseif pred1_2==3&&pred2_2==3&&pred3_2==3
    pred2(i)=3;   
    else
        if (pred1_2==1&&pred2_2==1)||(pred1_2==1&&pred3_2==1)||...
                (pred2_2==1&&pred3_2==1)
        pred2(i)=1;
        elseif  (pred1_2==2&&pred2_2==2)||(pred1_2==2&&pred3_2==2)||...
                (pred2_2==2&&pred3_2==2)
        pred2(i)=2;    
        elseif  (pred1_2==3&&pred2_2==3)||(pred1_2==3&&pred3_2==3)||...
                (pred2_2==3&&pred3_2==3)
        pred2(i)=3;  
        else
            if i>9
                s=zeros(1,10);
                sum1=0;
                sum2=0;
                sum3=0;
                for j=1:10
                     s(j)=pred2(i-j);
                     if s(j)==1
                         sum1=sum1+1;
                     elseif s(j)==2
                         sum2=sum2+1;
                     else
                         sum3=sum3+1;
                     end                     
                end
                A=[sum1,sum2,sum3];
                maxRes=max(A);
                if maxRes==1
                  pred2(i)=1; 
                elseif maxRes==2
                  pred2(i)=2; 
                else
                    pred2(i)=3; 
                end
            else
                pred2(i)=1;    
            end
        end
    end
    fprintf('��%d�����ݵĹ������: %d\n', i,pred2(i));
    pause(1);  
        end
    otherwise
        disp('�������');
end
fprintf('�������');
%% %%%%%%%%%%%%%%%%%%%%%%

%% �������н�����ݵ�txt��
% ordinal=1;%��ʼ���������д���
% load ordinal;
% load classesResult;
% fid=fopen('DNNresult.txt','at');   
% fixx=fopen('DNNresult.','at');  
% fprintf(fid,'��%d�����н����\n',ordinal); 
% dt=fix(clock);
% fprintf(fid,'ʱ���¼��%d�� %d�� %d�� %dʱ %d�� %d��\n',dt(1),dt(2),dt(3),dt(4),dt(5),dt(6)); 
% fprintf(fid,'������: %d\n', inputdata_options.sample_num);
% fprintf(fid,'������Ԫ��: һ��:%d ���㣺%d ���㣺%d\n', hidden.num1,hidden.num2,,,,
%hidden.num3);
% fprintf(fid,'AEѧϰ��: %d\n', hidden.learn_rare);
% fprintf(fid,'��������: %d\n', hidden.net_trainParam_epochs);
% 
% fprintf(fid,'ѵ��ԭʼ���ݷ�����ȷ��: %0.3f%%\n', acc_train_original * 100);
% fprintf(fid,'����ԭʼ���ݷ�����ȷ��: %0.3f%%\n', acc_test_original * 100);
% fprintf(fid,'ѵ��б�����ݷ�����ȷ��: %0.3f%%\n', acc_train_slope * 100);
% fprintf(fid,'����б�����ݷ�����ȷ��: %0.3f%%\n', acc_test_slope * 100);
% fprintf(fid,'ѵ���������ݷ�����ȷ��: %0.3f%%\n', acc_train_curvature * 100);
% fprintf(fid,'�����������ݷ�����ȷ��: %0.3f%%\n', acc_test_curvature * 100);
% fprintf(fid,'������Ϊ���������ܵĲ��Ծ�ȷ��: %0.3f%%\n', accProb * 100);
% fprintf(fid,'���߼��ں��ܵĲ��Ծ�ȷ��: %0.3f%%\n', acc * 100);
% fprintf(fid,'����������ʱ��: %dh��%dmin, %ds\n',fix(T/3600),fix(mod(T,3600)/60),...
%     fix(mod(mod(T,3600),60)));
% ordinal=ordinal+1;
% save ordinal ordinal

%Over




%%ԭʼ����
% [predp1,xulie1]=max(probability_original);
% % ����ԭʼ���ݷ���ĸ���ֵ
% x=1:length(xulie1);
% figure
% scatter(x,probability_original(1,:),'k')
% hold on
% scatter(x,probability_original(2,:),'b')
% hold on
% scatter(x,probability_original(3,:),'r')
% title('ԭʼ���ݷ������ֵ')
% xlabel('����');
% ylabel('����');
% h=legend('��������','����1����','����2����','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);

% % б������
% [predp2,xulie2]=max(probability_slope);
% % ����б�����ݷ���ĸ���ֵ
% x=1:length(xulie2);
% figure
% scatter(x,probability_slope(1,:),'k')
% hold on
% scatter(x,probability_slope(2,:),'b')
% hold on
% scatter(x,probability_slope(3,:),'r')
% title('б�����ݷ������ֵ')
% xlabel('����');
% ylabel('����');
% h=legend('��������','����1����','����2����','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);
% 
% % ��������
% [predp3,xulie3]=max(probability_curvature_1);
% % �����������ݷ���ĸ���ֵ
% x=1:length(xulie2);
% figure
% scatter(x,probability_curvature(1,:),'k')
% hold on
% scatter(x,probability_curvature(2,:),'b')
% hold on
% scatter(x,probability_curvature(3,:),'r')
% title('�������ݷ������ֵ');
% xlabel('����');
% ylabel('����');
% h=legend('��������','����1����','����2����','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);
