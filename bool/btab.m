function btab(y,varargin)
%BTAB  Prints a truth-table.
%   BTAB(Y,VARS) or
%   BTAB(Y,X1,X2,...) where Xn is generated by NBC(N) or GRAYC(N),
%   and Y is the boolean function generated by X, that is: Y=Y(X)=Y(X1,...).
%   The input is a cell array of bool-class variables or the correct amount
%   of bool-class variables.
%
%   See also NBC, GRAYC.
%

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-28, 2002-11-29

if nargin<2, error(nargchk(2,2,1)),end
if nargin==2
   for i=1:length(varargin{1})
      M(:,i)=double(varargin{1}{i})';
      names{i}=['x' num2str(i)];
   end
else
   for i=1:nargin-1
      M(:,i)=double(varargin{i})';
      names{i}=inputname(i+1);
   end
end
names{end+1}=inputname(1);
showtab(double(y),M,names)

%---

function showtab(y,x,names)
for i=1:length(names)
  len(i)=length(names{i});
end

fprintf \n

hline(names)

fprintf('|')
for i=1:size(x,2)
   fprintf([' ' names{i} ' ']);
end
fprintf([' |  ' names{end} '(*) |\n']);

hline(names)

for i=1:length(x)
   fprintf('|')
   for j=1:size(x,2)
      fprintf([' %i' blanks(len(j))],x(i,j));
   end
   fprintf([' |  %i' blanks(len(end)) '   |'],y(i));
   fprintf \n;
end
hline(names)
fprintf \n

%---

function hline(names)
dash='-';
fprintf('+')
for i=1:length(names)
  len(i)=length(names{i});
end
for i=1:length(names)-1
   fprintf(dash(ones(1,len(i)+2)))
end
fprintf('-+')
fprintf(dash(ones(1,len(end)+2+3)))
fprintf('-+')
fprintf \n;
