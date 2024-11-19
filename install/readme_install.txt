Installation Toolbox Ver. 2.2
=============================
Date: 2003-07-22.
Author: B. Rasmus Anthin.



WHAT IS IT
----------

This is actually not a toolbox but a group of files enabling you to
do easy to use installation "programs" for your toolboxes.

MAKEINSTALL  creates an installation information file in the base
directory of your toolbox. The info file contains info about which
directories will be installed to the matlab path.

INSTALL  uses this information file to install the dirs into the matlab
path.

UNINSTALL  uninstalls the toolbox from the matlab path.

CHECKINSTALL  shows directories that will be installed to or uninstalled
from the matlab path. It also shows if the toolbox is installed to the
matlab path or not.

I hope these files will make it easier for everyone with not too great
knowledge about matlab to install your toolboxes in a very painless way.
Just write in your readme-file that all they have to do is to run INSTALL
when they are in the toolbox directory.
When you've made a new version of your toolbox, just state that they should
run UNINSTALL, remove the previous installation from the HD, extract the new
installation into their toolbox dir, cd to the toolbox and run INSTALL once
again. (That is if you have altered the directory structure of your toolbox).
It cannot be much easier than this.



UPDATES AND BUGFIXES
--------------------

Ver 1.0:
Seems to work as it should.

Ver 2.0:
Found out that the path is not saved after the changes made to it
by INSTALL or UNINSTALL.
Also fixed the checking for info.ins so that it only looks for it
at the current directory.

Ver 2.1:
Clearer error messages for the pathdef.m related errors. Appended with:
'try "install -".'
'try "uninstall -".'
respectively.

Ver 2.2:
If running INSTALL when already installed, a warning rather than an error
will be shown, and INSTALL will attempt to install again. The same goes
for the UNINSTALL program.


EOF.