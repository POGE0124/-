%% DNN�ӳ���
function dnn(Input_Data,inputdata_options,hidden)
%% ����
fprintf('ԭʼ����ѵ��������......');
trainData=Input_Data.trainData_original;
trainLabels=Input_Data.trainLabels;
testData=Input_Data.testData_original;
testLabels=Input_Data.testLabels;
sample_num=inputdata_options.sample_num;
classes_num=inputdata_options.classes_num;
%% STEP 1  ԭʼ����ͨ���ѵ��Զ�����������������ȡ
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmaxģ��ѵ������%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%�����������
softlambda = 1e-2; %Ȩֵ�½����� ÿһ�ε������²���ʱ�õ�
softoptions.maxIter = 100;%����������
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune΢������  %%%%%%%%%%%%%%%%%%%%%%%
% ���Զ�������ѧϰ���Ĳ����ѵ�����
stack = cell(3,1);%3x1��Ԫ������
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % Ȩֵ�½�����
options.Method = 'lbfgs'; %��ţ�������ڴ淨
options.alpha=0.05;      %ѧϰ��
options.maxIter =hidden.net_trainParam_epochs;	%����������
%% STEP 4  ��С���ۺ���minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: ���ԭʼѵ�����ݷ��ྫ��
[pred_train_original,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_original = mean(trainLabels(:) == pred_train_original(:));
fprintf('ѵ��ԭʼ���ݷ�����ȷ��: %0.2f%%\n', acc_train_original * 100);
%% STEP 6: ���ԭʼ�������ݷ��ྫ��
[pred_test_original,probability_original] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, testData);
acc_test_original = mean(trainLabels(:) == pred_test_original(:));
fprintf('����ԭʼ���ݷ�����ȷ��: %0.2f%%\n', acc_test_original * 100);
%% ����ԭʼ����ѵ���õĲ���
save para11 stackedAEOptTheta
save para12 netconfig
%% б������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('б������ѵ��������......');
%% STEP 1  ԭʼ����ͨ���ѵ��Զ�����������������ȡ
trainData=Input_Data.trainData_slope;
testData=Input_Data.testData_slope;
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmaxģ��ѵ������%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%�����������
softlambda = 1e-3; %Ȩֵ�½����� ÿһ�ε������²���ʱ�õ�
softoptions.maxIter = 100;%����������
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune΢������  %%%%%%%%%%%%%%%%%%%%%%%
% ���Զ�������ѧϰ���Ĳ����ѵ�����
stack = cell(3,1);%3x1��Ԫ������
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % Ȩֵ�½�����
options.Method = 'lbfgs'; %��ţ�������ڴ淨
options.alpha=0.05;      %ѧϰ��
options.maxIter =hidden.net_trainParam_epochs;	%����������
%% STEP 4  ��С���ۺ���minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: ���ԭʼѵ�����ݷ��ྫ��
[pred_train_slope,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_slope = mean(trainLabels(:) == pred_train_slope(:));
fprintf('ѵ��б�����ݷ�����ȷ��: %0.2f%%\n', acc_train_slope * 100);
%% STEP 6: ���б�ʲ������ݷ��ྫ��
[pred_test_slope,probability_slope] = stackedAEPredict(stackedAEOptTheta, sample_num,...
    hidden.num3,classes_num, netconfig, testData);
acc_test_slope = mean(testLabels(:) == pred_test_slope(:));
fprintf('����б�����ݷ�����ȷ��: %0.2f%%\n', acc_test_slope * 100);
%% ����б������ѵ���õĲ���
save para21 stackedAEOptTheta
save para22 netconfig
%% ��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('��������ѵ��������......');
%% STEP 1  ԭʼ����ͨ���ѵ��Զ�����������������ȡ
trainData=Input_Data.trainData_curvature;
testData=Input_Data.testData_curvature;
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmaxģ��ѵ������%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%�����������
softlambda = 1e-3; %Ȩֵ�½����� ÿһ�ε������²���ʱ�õ�
softoptions.maxIter = 100;%����������
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune΢������  %%%%%%%%%%%%%%%%%%%%%%%
% ���Զ�������ѧϰ���Ĳ����ѵ�����
stack = cell(3,1);%3x1��Ԫ������
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % Ȩֵ�½�����
options.Method = 'lbfgs'; %��ţ�������ڴ淨
options.alpha=0.05;      %ѧϰ��
options.maxIter =hidden.net_trainParam_epochs;	%����������
%% STEP 4  ��С���ۺ���minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: ���ԭʼѵ�����ݷ��ྫ��
[pred_train_curvature,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_curvature = mean(trainLabels(:) == pred_train_curvature(:));
fprintf('ѵ���������ݷ�����ȷ��: %0.2f%%\n', acc_train_curvature * 100);
%% STEP 6: ��������������ݷ��ྫ��
[pred_test_curvature,probability_curvature] = stackedAEPredict(stackedAEOptTheta, sample_num,...
    hidden.num3,classes_num, netconfig, testData);
acc_test_curvature = mean(testLabels(:) == pred_test_curvature(:));
fprintf('�����������ݷ�����ȷ��: %0.2f%%\n', acc_test_curvature * 100);
%% ������������ѵ���õĲ���
save para31 stackedAEOptTheta
save para32 netconfig
%% ��������
save ('classesResult.mat','acc_train_original','acc_test_original','acc_train_slope','acc_test_slope',...
    'acc_train_curvature','acc_test_curvature');
save ('probabilitypred.mat','probability_original','probability_slope','probability_curvature',...
    'pred_test_original','pred_test_slope','pred_test_curvature','testLabels');
