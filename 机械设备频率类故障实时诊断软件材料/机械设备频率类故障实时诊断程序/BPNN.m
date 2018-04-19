function [rate ,rate_test]=BPNN(trainData,testData)
% clc
% clear all;
% close all; 
% bpResult=[];
% bpResult_test=[];
% for k=1:20       

% tic;           



% load trainData.mat;
% load testData.mat;

X=trainData;
[X,s1]=mapminmax(X,0,1);

t1=[1 0 0 0 0 0 0 0 0 0]';
t2=[0 1 0 0 0 0 0 0 0 0]';
t3=[0 0 1 0 0 0 0 0 0 0]';
t4=[0 0 0 1 0 0 0 0 0 0]';
t5=[0 0 0 0 1 0 0 0 0 0]';
t6=[0 0 0 0 0 1 0 0 0 0]';
t7=[0 0 0 0 0 0 1 0 0 0]';
t8=[0 0 0 0 0 0 0 1 0 0]';
t9=[0 0 0 0 0 0 0 0 1 0]';
t10=[0 0 0 0 0 0 0 0 0 1]';
T=[repmat(t1,1,100),repmat(t2,1,100),repmat(t3,1,100),repmat(t4,1,100),repmat(t5,1,100),repmat(t6,1,100),...
    repmat(t7,1,100),repmat(t8,1,100),repmat(t9,1,100),repmat(t10,1,100)];

net =newff(minmax(X),[100,10],{'logsig','logsig'},'traingdx');
% net.inputweights{1,1}.initFcn='rands';
% net.layers{1}.initFcn='rands';
net.trainParam.show=100;
net.trainParam.epochs = 3000; 
net.trainParam.goal=1e-5; %ѵ��Ŀ�� 
net.trainParam.lr=0.1;%ѧϰ��
net.trainParam.mc=0.05; %����
net=init(net);%�����ʼ��
[net,tr] =train(net,X,T); %ѵ������

 y=sim(net,X); %�������;
 e=T-y; %���
disp('������')
perf=mse(e)  %%�������
%  y1 = full(compet(y)) ;  %%%%%%%%%% %�������
y(y>0.99)=1;
y(y<=0.99)=0;
y1=y;
 y2=vec2ind(y1);%����ֵ������ֵ
% figure
% plot(y2,'r*')
% title('BP��������ϵļ�����')
pp_lab=[repmat(1,1,100),repmat(2,1,100),repmat(3,1,100),repmat(4,1,100),repmat(5,1,100),...
    repmat(6,1,100),repmat(7,1,100),repmat(8,1,100),repmat(9,1,100),repmat(10,1,100)];



  for i=1:1000      
result(i)=~sum(abs(y2(i)-pp_lab(i)));     %������ȷ��ʾΪ1��

  end
rate=sum(result)/length(result);   %������ȷ��
fprintf('����BP������training���Ϸ�����ȷ�ʣ� %f%%\n',rate*100);
testData=mapminmax('apply',testData,s1);
y_test=sim(net,testData);

err_test=T-y_test;
disp('�������:');
perf_test=mse(err_test)

y_test(y_test>0.99)=1;
y_test(y_test<=0.99)=0;
y1_test=y_test;
 y2_test=vec2ind(y1_test);%����ֵ������ֵ
% figure
% plot(y2_test,'r*')
% title('BP������TESTING���ϵļ�����')
% pp_lab=[repmat(1,1,100),repmat(2,1,100),repmat(3,1,100),repmat(4,1,100),repmat(5,1,100),...
%     repmat(6,1,100),repmat(7,1,100),repmat(8,1,100),repmat(9,1,100),repmat(10,1,100)];



  for i=1:1000      
result_test(i)=~sum(abs(y2_test(i)-pp_lab(i)));     %������ȷ��ʾΪ1��

  end
rate_test=sum(result_test)/length(result_test);   %������ȷ��
fprintf('����BP������testing���Ϸ�����ȷ�ʣ� %f%%\n',rate_test*100);
end
% time=toc;         % ��¼����ʱ��
% rate(k);

% bpResult=[bpResult,rate*100];
% save bpResult.mat;
% bpResult_test=[bpResult_test,rate_test*100];
% save bpResult_test.mat;
% end
%  figure
% plot(bpResult,'g-o');
% hold on
% plot(bpResult_test,'r-*');
% legend('train','test');
% title('bp train and test accuracy ')
% xlabel('�������');
% ylabel('׼ȷ��');
 

