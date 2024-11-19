function y=num2scic(x,n,unit);
if imag(x)
   y={[num2sci(abs(x),n) unit], ['\angle' num2sci(180/pi*angle(x),3) '\circ']};
else
   y=[num2sci(x,n) unit];
end