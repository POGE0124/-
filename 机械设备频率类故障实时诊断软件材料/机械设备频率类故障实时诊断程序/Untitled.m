%% clear
clc
close all
clear all
%% ��λԲ��ȡ�˸���
r=5;
angle=0:pi/4:2*pi;
X=r*cos(angle);
Y=r*sin(angle);
plot(X,Y)
%% ��Ȧ��ѭ��
for j=1:8
%% ���Ʋ�������
k_p=3;
k_a=8;
k_b=-1.5;
a=pi/4;
%% ����С����ʼ������յ�����(���Կ����)
x_init=X(j);
y_init=Y(j);
x_end=0;
y_end=0;
%% �������
p_init=sqrt((y_end-y_init)^2+(x_end-x_init)^2);
a_init=a;
b_init=-atan2((y_end-y_init),(x_end-x_init));
%% �յ�����
p_end=0;
a_end=0;
b_end=0;
%% ��ʼ��
p=p_init;
a=a_init;
b=b_init;
x=x_init;
y=y_init;
t=0:0.1:10;
t_d=0.01;
i=1;
%% 
while p>0.01
%% p,a,b�仯�ٶ�
p_speed=-k_p*p*cos(a);
a_speed=k_p*sin(a)-k_a*a-k_b*b;
b_speed=-k_p*sin(a);
p=p_speed*t_d+p;
a=a_speed*t_d+a;
b=b_speed*t_d+b;
v=k_p*p;
w=k_a*a+k_b*b;
theat=-(a+b);
x_speed=cos(theat)*v;
y_speed=sin(theat)*v;
x=x_speed*t_d+x;
y=y_speed*t_d+y;
a_x(i)=x
b_y(i)=y
i=i+1;
end
plot(a_x,b_y)
hold on
end