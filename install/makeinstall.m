function makeinstall(varargin)
%MAKEINSTALL  Create installation info for a toolbox.
%   MAKEINSTALL DIR1 DIR2 DIR3 ...  creates a file "info.ins" containing
%   the directory names DIR1, DIR2 ... that are located in the current
%   directory given by PWD and are to be added to the path by the INSTALL
%   program. The current directory should be the base directory of the toolbox.
%   The info file is saved in this directory.
%   The directory entries are not recursive. Eg 'DIR1' doesn't imply that
%   'DIR1/DIR11' and 'DIR1/DIR12' and 'DIR1/DIR12/DIR121' are included.
%   The "info.ins" file is then used by INSTALL or UNINSTALL for adding or
%   removing the directory entries DIR1, DIR2 ... to the matlab path.
%   The base/current directory is always included when using INSTALL/UNINSTALL.
%   Example of usage:
%
%      » cd(fullfile(matlabroot,'toolbox','digitalsim'))
%      » disp(pwd)
%      C:\MATLAB\toolbox\digitalsim
%      » makeinstall gates latches flipflops registers counters
%      »
%
%   See also INSTALL, UNINSTALL, CHECKINSTALL.

% Copyright (c) 2003-07-15, B. Rasmus Anthin.
% Revision 2003-07-16.

INS_DIRS=varargin;
IS_INSTALLED=0;
for i=1:length(INS_DIRS)
   if ~exist(fullfile(pwd,INS_DIRS{i}),'dir')
      error(['Directory ''' fullfile(pwd,INS_DIRS{i}) ''' does not exist.'])
   end
end
save info.ins INS_DIRS IS_INSTALLED