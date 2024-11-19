%a simple TTL inverter (npn)
net=nan*ones(5,16);
net(1,1:4)=[1 1 0 0];     %Ui
net(2,1:4)=[1 4 0 5];     %Vcc
net(3,1:4)=[7 1 2 43e3];
net(4,1:4)=[7 3 4 1e3];   %Uo=v3
net(5,1:9)=[16 2 3 0 nan nan 11 50 .01];     %xperiment with betaF and betaR

h=waitbar(0,'Sweeping...');
Ui=linspace(0,5);
tic
for i=1:100
   net(1,4)=Ui(i);
   [G B C D Is Ibl Vs Vvv Vcv Vcc Voa Vbl]=net2mat(net,0,1e-4);  %lowest ~1e-15, hightest ~1e-4
   vn=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
   Uo(i)=vn(3);
   waitbar(i/100)
end
toc      %time for sweeping

close(h)
plot(Ui,Uo,'.-')
xlabel('U_i [V]')
ylabel('U_o [V]')
title('TTL (npn) inverter')
grid
axis equal
axis([0 5 0 5])

figure
plot(Ui,gradient(Uo,Ui),'.-')
xlabel('U_i [V]')
ylabel('\partial U_o/\partial U_i  [V/V]')
title('TTL (npn) inverter')
grid