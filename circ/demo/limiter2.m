%Example of a simple voltage limiter using zeners

net=nan*ones(4,16);
net(1,1:4)=[1 1 0 10];
net(2,1:4)=[7 1 2 1e3];
net(3,1:7)=[16 2 3 nan nan nan 13];
net(4,1:7)=[16 0 3 nan nan nan 13];


N=50;     %number of steps for voltage sweep
V1=-10;   %start sweep voltage
V2=10;    %end sweep voltage
h=waitbar(0,'Sweeping...');
Vo=0;
VV=linspace(V1,V2,N);
tic
for i=1:N
   net(1,4)=VV(i);
   [G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl]=net2mat(net,0,10*eps);
   x=[G B;C D]\[Is;Ibl;Vs;Vbl];
   Vo(i)=x(2);
   waitbar(i/N)
end
toc    %time for sweeping

close(h)
plot(VV,Vo,'.-')
grid
xlabel('V_S [V]')
ylabel('V_{out} [V]')
axis equal