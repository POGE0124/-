function[options]=Creat_AE_Mode(inputdata_options,hidden,trainData)
%% �Զ����������
%�Զ���������һ���޼ල��ѧϰ�㷨�����÷��򴫲��㷨��bp�㷨���������ֵ��������ֵ
%������������ӣ�ÿ����Ԫ�����ĵݼ����Զ�����������ѧϰ�����ݵ�һЩѹ����ʾ��
%�����һ������600ά��ʾ1200ά�����ݣ��������������һ��ά�Ϳ��Ա�ʾ1200ά������
%��������֮�������Ծͱ�Ȼ�����˺ܶ࣬����˵�Զ�����������ѧϰ������������Ե�һ�ֱ�ʾ������
%@���������������õĺ�����Ĭ�ϵ�performFcn��mse������ѡ��Ҳֻ�����֣�
%1��mae Mean absolute error 2��mse Mean squared error
%3��msereg Mean squared error w/reg 4������sse
%@Ȩֵѧϰ�㷨�������У�1�����������ݶ��½�����traingdm��,
%2��L-M�Ż��㷨��trainlm��,3�����������ݶȷ���traingdm��
%�����������ֻ������У�traindx,trainda�ȡ�
%@�ڵ㴫�ݺ�������Ԫ��������������У�1��˫�����к�����tansig��
%2��������s�ͺ�����logsig��3�����Ժ�����purelin��
%% ȡ������
learn_rare=hidden.learn_rare;
sample_total=inputdata_options.sample_total;
sample_num=inputdata_options.sample_num;
classes_num=inputdata_options.classes_num;
n_columns=inputdata_options.n_columns;
%%  STEP1 ������һ���Զ������� %%%%%%%%%%%%%%%%%%%%%
net1=feedforwardnet(hidden.num1);
         net1.name = 'Autoencoder';
         net1.layers{1}.name = 'Encoder'; 
         net1.layers{2}.name = 'Decoder';
         net1.layers{1}.initFcn = 'initwb';
         net1.layers{2}.initFcn = 'initwb';
         net1.inputWeights{1,1}.initFcn = 'rands';
         net1.inputWeights{2,1}.initFcn = 'rands'; 
         net1.biases{1}.initFcn='initzero';
         net1.biases{2}.initFcn='initzero';
         net1.initFcn = 'initlay';  
         net1.performFcn='mse';
         net1.trainFcn='traingdm';
         net1.layers{1}.transferFcn='tansig';
         net1.layers{2}.transferFcn='tansig';
         net1.trainParam.epochs=hidden.net_trainParam_epochs; %ѵ������
         net1.trainParam.mc=0.05; %����
         net1.trainParam.lr=learn_rare;%ѧϰ��
net1=init(net1);   %��ʼ������
[net1]=train(net1,trainData,trainData); %ѵ������  
%% ��ȡ��һ��������%%%%%%%%%%
%��ȡ���������Ȩֵ��ƫ��
options.w1=net1.iw{1,1}; % ֻҪ���������Ȩֵ���ɣ���������ֻ����ѵ����ʱ������
options.b1=net1.b{1};      % ѵ����ı��������ƫ�õ��ڣ�hidden_num1*1��
a1=options.w1*trainData+options.b1*ones(1,n_columns*classes_num);
feature1=tansig(a1);  %��˫�����м�����õ���һ���������
%%  STEP2�����ڶ����Ա����� %%%%%%%%%%%%%%
net2=feedforwardnet(hidden.num2);       
             net2.name = 'Autoencoder';
             net2.layers{1}.name = 'Encoder';
             net2.layers{2}.name = 'Decoder';
             net2.layers{1}.initFcn = 'initwb';
             net2.layers{2}.initFcn = 'initwb';
             net2.inputWeights{1,1}.initFcn = 'rands';
             net2.inputWeights{2,1}.initFcn = 'rands';
             net2.biases{1}.initFcn='initzero';
             net2.biases{2}.initFcn='initzero';
             net2.initFcn = 'initlay';
             net2.performFcn='mse';
             net2.trainFcn='traingdm';       
             net2.layers{1}.transferFcn='tansig';
             net2.layers{2}.transferFcn='tansig';
             net2.trainParam.epochs=hidden.net_trainParam_epochs;
             net2.trainParam.mc=0.05; 
             net2.trainParam.lr=learn_rare;
net2=init(net2);
net2=train(net2,feature1,feature1);
%% ��ȡ�ڶ���������%%%%%%%%%%
options.w2=net2.iw{1,1};
options.b2=net2.b{1};  
a2=options.w2*feature1+options.b2*ones(1,n_columns*classes_num);
feature2=tansig(a2);
%% STEP 3�����������Ա�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
net3=feedforwardnet(hidden.num3);%�����������Ա���������Ԫ����hidden.num3
        net3.name = 'Autoencoder';
        net3.layers{1}.name = 'Encoder';
        net3.layers{2}.name = 'Decoder';
        net3.layers{1}.initFcn = 'initwb';
        net3.layers{2}.initFcn = 'initwb';
        net3.inputWeights{1,1}.initFcn = 'rands';
        net3.inputWeights{2,1}.initFcn = 'rands';
        net3.biases{1}.initFcn='initzero';    
        net3.biases{2}.initFcn='initzero' ;
        net3.initFcn = 'initlay';
        net3.performFcn='mse';
        net3.trainFcn='traingdm'; 
        net3.layers{1}.transferFcn='tansig';
        net3.layers{2}.transferFcn='tansig';
        net3.trainParam.epochs=hidden.net_trainParam_epochs;
        net3.trainParam.mc=0.05; 
        net3.trainParam.lr=learn_rare;
net3=init(net3);
net3=train(net3,feature2,feature2);
%% ��ȡ������������%%%%%%%%%%
options.w3=net3.iw{1,1};
options.b3=net3.b{1};
a3=options.w3*feature2+options.b3*ones(1,n_columns*classes_num);
options.feature3=tansig(a3);