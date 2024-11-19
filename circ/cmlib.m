function out=cmlib(action,id)
%CMLIB  Circuit Model Library utility.
%   The circuit model library contains information about circuit blocks
%   (models) that the user has defined and are located in the directory "model"
%   under the directory tree of this toolbox (see CHECKINSTALL).
%   The library database is used to keep track on these models so that they can
%   be pointed at in the netlist or schematic matrix. The governing routines
%   will identify the correct model with the pointers in the netlist by making
%   use of the CMLIB database handling utility. Pointers in the database can be
%   modified, added or removed by using any of the following arguments:
%      CMLIB ADD      adds a block entry to the database
%      CMLIB RM       removes a block entry from the database
%      CMLIB CHG      changes a block entry or its pointer value in the database
%      CMLIB LIST     lists entries in the database (same as just CMLIB)
%
%   The following are used to retrieve specific information about a certain block
%   model:
%      BNET = CMLIB('net',NET)     gets the underlying netlists for a given block
%      TERM = CMLIB('term',ID)     gets the names of each terminal in order of
%                                  occurence
%      PARAM = CMLIB('param',ID)   gets parameter names for a given block
%      DEF = CMLIB('def',ID)       gets default values for the parameters PARAM
%      SYMB = CMLIB('symb',ID)     gets schematic symbol information (see below)
%      NAME = CMLIB('name',ID)     gets the name for the model
%
%   where NET is a specific row of the netlist and is a block component
%   with type 16. Thus NET is of size (1x24). ID is the model pointer as given by
%   NET(7).
%
%   Terminals to the model have to be the first nodes to be enumerated and in
%   order of occurence n1-n5 in net(2:6) such that the first rows and columns in
%   the G (conductance) matrix corresponds to the terminal nodes of the block.
%   Each model function must have the following 5 outputs:
%
%      * NET   : Netlist containing sub-circuit elements [matrix].
%      * TERM  : Names of terminals used [cellstr].
%      * PARAM : Names of model parameters [cellstr].
%      * DEF   : Default values for model parameters [vector].
%      * SYMB  : Information for plotting its schematic symbol [struct].
%        - PATCH    : Symbol patches [cellvector of vectors of complex].
%                     The unit is [2 grid units].
%        - PATCHCOL : Colors for patches [cellvector of rgb vectors].
%        - LINE     : Symbol lines [cellvector of vectors of complex].
%                     The unit is [2 grid units].
%        - LINECOL  : Colors for lines [cellvector of rgb vectors].
%        - LABEL    : Component designation label [char].
%        - ENUM     : Enumeration class [int].
%                     -3, 1..11 for intrinsic components.
%                     16 and above for new classes (block).
%        - TERM     : Terminal coordinates [vector of complex].
%                     The unit is [2 grid units].
%        - ROTAX    : Rotational axis as defined by its terminals
%                     by entering the order indicies [4 x int].
%                     The axis is the line with points
%                     mean(T1,T2) and mean(T3,T4).
%                     The symbol should be based upon the case where
%                     the line is horizontal with positive terminals
%                     to the left (entered first).
%        - DX       : Coordinate from center of rotation to the label
%                     (when rotational axis is horizontal).
%                     The center of rotation is the center of of the
%                     rotational axis ROTAX. [2 grid units]
%        - ANG      : Angular offset for label [deg].
%        - ORTHO    : Only rotate component in 90 degree steps [0/1].
%
%   One grid unit equals 1/2 data unit.
%   Furthermore, the model file must create an empty net if input to the
%   model is omitted.
%   It should be mentioned that you can only build blocks in one level, ie
%   it is not possible to create a block by using other blocks.
%
%   See also ECSIM, SCH2NET, NET2MAT.

% Copyright (c) 2003-08-21, B. Rasmus Anthin.
% Revision 2003-08-22, 2003-08-23, 2003-08-27, 2003-09-02, 2003-09-09,
%          2003-09-10, 2003-09-11.

global matpath          %this is to avoid LOAD and WHICH.
if isempty(matpath)
  matpath=which(mfilename);
  matpath=matpath(1:end-8);
end
savefile=fullfile(matpath,'cmlib.mat');

global lib               %this is to avoid LOAD and EXIST.
if isempty(lib)
   if exist(savefile,'file')
      load(savefile)
   else
      lib=[];
   end
end
if ~nargin
   action='  ';
end
switch(lower(action(1:2)))
case 'ad'    %add
   i=length(lib)+1;
   [fname,fpath]=uigetfile(fullfile(matpath,'model','*.m'),'choose circuit model');
   if isempty(lib)
      lib(i).id=1;
   else
      id=setdiff(1:i,[lib.id]);
      lib(i).id=id(1);
   end
   if sum(fname)
      lib(i).name=input('Model name : ','s');
      lib(i).file=fname;
      save(savefile,'lib')
   end
case 'rm'   %remove
   i=input('Select model ID to remove : ');
   i=find([lib.id]==i);
   i=setdiff(1:length(lib),i);
   lib=lib(i);
   save(savefile,'lib')
case 'ch'   %change
   while 1
      i=input('Select model ID to change : ');
      i=find([lib.id]==i);
      if ~isempty(i)
         break
      else
         warning('Entered Lib-ID does not exist.')
      end
   end
   while 1
      id=default(input(['Lib-ID [' num2str(lib(i).id) '] : ']),lib(i).id);
      if ~any([lib.id]==id) | lib(i).id==id
         lib(i).id=id;
         break
      else
         warning('Entered Lib-ID already exists.')
      end
   end
   lib(i).name=default(input(['Model name [' lib(i).name '] : '],'s'),lib(i).name);
   ps=find(lib(i).file==filesep);
   if isempty(ps)
      init='*.m';
   else
      init=[lib(i).file(1:ps(end)) '*.m'];
   end
   [fname,fpath]=uigetfile(init,'choose circuit model');
   if sum(fname)
      lib(i).file=fname;
      save(savefile,'lib')
   end
case 'li'   %list
   nlen=size(char({lib.name}),2);
   plen=size(char({lib.file}),2);
   J=sort([lib.id]);
   disp(' ')
   disp([blanks(3) 'Lib-ID    Name'  blanks(max(nlen+1,4)) 'File'])
   for j=J
      i=find([lib.id]==j);
      fprintf(blanks(9-length(num2str(lib(i).id))))
      fprintf('%i',lib(i).id)
      fprintf(blanks(5))
      fprintf('%s',lib(i).name)
      fprintf(blanks(nlen-length(lib(i).name)+5))
      fprintf('%s',lib(i).file)
      fprintf \n
   end
   disp(' ')
   disp([blanks(3) 'Lib-ID    Terminals'])
   for j=J
      i=find([lib.id]==j);
      [net,term]=feval(lib(i).file(1:end-2));
      fprintf(blanks(9-length(num2str(lib(i).id))))
      fprintf('%i',lib(i).id)
      fprintf(blanks(5))
      fprintf('%s',term{1})
      for k=2:length(term)
         fprintf(' ,%s',term{k})
      end
      fprintf \n
   end
   disp(' ')
   disp([blanks(3) 'Lib-ID    Parameters'])
   for j=J
      i=find([lib.id]==j);
      [net,term,param,def]=feval(lib(i).file(1:end-2));
      fprintf(blanks(9-length(num2str(lib(i).id))))
      fprintf('%i',lib(i).id)
      fprintf(blanks(5))
      fprintf('%s(%s)',param{1},num2stre(def(1)))
      for k=2:length(param)
         fprintf(' ,%s(%s)',param{k},num2stre(def(k)))
      end
      fprintf \n
   end
   disp(' ')
case 'ne'   %net
   net=id;
   i=find([lib.id]==net(7));
   out=feval(lib(i).file(1:end-2),net);
case 'te'   %term
   i=find([lib.id]==id);
   [foo,out]=feval(lib(i).file(1:end-2));
case 'pa'   %param
   i=find([lib.id]==id);
   [foo,foo,out]=feval(lib(i).file(1:end-2));
case 'de'   %def
   i=find([lib.id]==id);
   [foo,foo,foo,out]=feval(lib(i).file(1:end-2));
case 'sy'   %symb
   i=find([lib.id]==id);
   [foo,foo,foo,foo,out]=feval(lib(i).file(1:end-2));
case 'en'   %enum
   i=find([lib.id]==id);
   [foo,foo,foo,foo,foo,out]=feval(lib(i).file(1:end-2));
case 'na'   %name
   i=find([lib.id]==id);
   out=lib(i).name;
otherwise
   cmlib list
end
