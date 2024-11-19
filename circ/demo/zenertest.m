%zenertest

net=nan*ones(3,7);
net(1,1:4)=[1 1 0 5];               %V
net(2,1:4)=[7 2 0 10];              %R
net(3,1:7)=[16 1 2 nan nan nan 2];  %Z

N=50;
V1=-6;
V2=2;
h=waitbar(0,'Sweeping...');
I=0;
V=linspace(V1,V2,N);
tic
for i=1:N
   net(1,4)=V(i);
   [G B C D Is Ibl Vs Vvv Vcv Vcc Voa Vbl]=net2mat(net,0,100*eps);
   x=[G B;C D]\[Is;Ibl;Vs;Vbl];
   I(i)=-x(end-1);
   waitbar(i/N)
end
toc

close(h)
plot(V,I,'.-')
grid
xlabel V
ylabel I