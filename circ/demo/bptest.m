n=nan;
clear j Vo
sch=[0 0 n n n n n n
   0 3+j n n n n n n
   1 2j 0 n n n n 10
   7 2j 2+2j n n n n 100
   8 2+2j 3+2j n n n n 1.6e-6
   -2 3+2j 3+4j n n n n n
   -2 6+4j 6+1.5j n n n n n
   8 3+3j 6+3j n n n n 1.28e-9
   7 3+4j 6+4j n n n n 1e3
   -1 3+3j n n n n n n
   -1 6+3j n n n n n n
   10 3+j 3+2j 6+1.5j n n n n
   -2 6+1.5j 7+1.5j n n n n n
   -3 7+1.5j n n n n n n];
schplot(sch)
net=sch2net(sch);
%[G B C D Is Ibl Vs Vvv Vcv Vcc Voa Vbl]=net2mat(net,0);
%[vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
%valplot(sch,vn,ivs,ivv,icv,icc,ioa)

w=logsp(1,1e7);
h=waitbar(0,'Sweeping frequency...');
tic
for i=1:length(w);
   [G B C D Is Ibl Vs Vvv Vcv Vcc Voa Vbl]=net2mat(net,w(i)/2/pi);
   [vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
   Vo(i)=vn(4);     %node 4 is the output terminal
   waitbar(i/length(w))
end
toc      %time elapsed when sweeping

close(h)
figure
semilogx(w,20*log10(abs(Vo/10)),'.-')
xlabel('\omega [rad/s]')
ylabel('|H(j\omega)| [dB]')
title('Bode plot')
grid