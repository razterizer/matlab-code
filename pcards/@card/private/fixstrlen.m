function y=fixstrlen(s,n)
% FIXSTRLEN
%   Adds extra spaces to a string.
%   FIXSTRLEN(S,N), where N defines the length of the output.

y=s;
y(end+1:n)=' ';