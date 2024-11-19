function godir(fname)
disp godir
%GODIR  Go to directory where the callee is located.
%   GODIR(FNAME) jumps to the directory in which m-file FNAME is located.
%   This is suitable for programs which saves data to a specific directory
%   with an unspecified name in which there are a m-file located.
%   GODIR will jump back to the directory before the jump.
%
%   Ex:  we have a m-file producing data in the directory in which it
%        is located itself. Then you could write:
%
%      ...
%      godir(mfilename)
%      ...
%      godir
%
%   See also EVALIN, ASSIGNIN.

% Copyright (c) 2002-02-13, B. Rasmus Anthin.

global DIRECTORY_GODIR
if nargin  % run in target dir
   to=which(fname);
   DIRECTORY_GODIR.to=to(1:end-length(fname)-3);
   DIRECTORY_GODIR.from=pwd;
   cd(DIRECTORY_GODIR.to);
   global DIRECTORY_GODIR
elseif ~isempty(DIRECTORY_GODIR)
   cd(DIRECTORY_GODIR.from)
   clear global DIRECTORY_GODIR
else
   warning('No previous directory.')
   clear global DIRECTORY_GODIR
end
