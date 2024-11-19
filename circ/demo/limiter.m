load limiter
%Example of a simple voltage limiter

schplot(sch)
drawnow
[G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl]=net2mat(net);
[vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
valplot(sch,vn,ivs,ivv,icv,icc,ioa)
[net,nodes]=sch2net(sch);  %converting schematic to netlist

N=50;     %number of steps for voltage sweep
V1=-5;    %start sweep voltage
V2=5;     %end sweep voltage
h=waitbar(0,'Sweeping...');
Vo=0;
VV=linspace(V1,V2,N);
tic
for i=1:N
   net(1,4)=VV(i);
   [G,B,C,D,Is,Ibl,Vs]=net2mat(net);
   x=[G B;C D]\[Is;Vs];
   Vo(i)=x(2);
   waitbar(i/N)
end
toc    %time for sweeping

close(h)
figure
plot(VV,Vo,'.-')
grid
xlabel('U_1 [V]')
ylabel('U_{out} [V]')