load rectifier
%Example of a twoway AC rectifier

N=100;
f=50; %50 Hz
t=linspace(0,2/f,N);      %sweeping over 2*T
V0=10;
VV=V0*sin(2*pi*f*t);
h=waitbar(0,'Sweeping...');
tic
for i=1:N
   net(1,4)=VV(i);
   [G,B,C,D,Is,Ibl,Vs]=net2mat(net,0,10*eps);
   x=[G B;C D]\[Is;Vs];
   Vo(i)=x(3);
   waitbar(i/N)
end
toc    %time for sweeping

close(h)
figure
plot(t*1e3,VV,'.-',t*1e3,Vo,'.-')
grid
xlabel('t [ms]')
ylabel('V [V]')
legend('V_S [V]','V_{out} [V]',0)