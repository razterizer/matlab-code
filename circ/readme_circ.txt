Circuit Simulation Toolbox Ver. 1.1
===================================
Date: 2003-09-23.
Author: B. Rasmus Anthin.



WHAT IS IT
----------

This toolbox contains routines for creating netlists from schematics
 and creating a linear system for solving netlists. It also contains
a schematic design and simulation tool and a model library database
utility so that you can add your own component models. You can
simulate some non-linear devices as well.



INSTALLATION
------------
>> Go directly to step 3 if this is the first time you install this toolbox!<<

0. When in matlab; go to the .../circ/ directory and run UNINSTALL.
   (If any directories in connection to this toolbox remain in the matlab
    path, then remove them from the path manually by using EDITPATH).

1. Next, you have to backup any files you've added to the toolbox or changes
   made to existing files (must not be redistributed without my
   approval!).

2. After this is done, completely delete the existing toolbox directory.

3. Place the circ.#.#.zip archive file in the directory where you want
   to keep this toolbox. If you place it under "c:/matlab/" then the toolbox
   will appear in the directory "c:/matlab/circ/". According to the example
   in step 0, you should place it in the directory given by
      » fullfile(matlabroot,'toolbox')
   but it is up to you where you wish to keep this toolbox (however consistency
   is a good thing).

4.1. Linux/Unix: Install by writing "gunzip -xvzf circ.#.#.zip" (you can use
   "unzip" as well).

4.2. Windows: Copy the entire archive to the directory using
   Total Commander available from "http://www.ghisler.com" or use WinZip.

4.3. Other systems: Use some pack program for zip-files to extract
   the toolbox dir-tree where you want to keep it. If you can't do this
   then please mail me about it "e8rasmus@etek.chalmers.se" and I'll try
   to help you.

5. Update your matlab path by going to the circ toolbox base directory.
   This could for example be:
      » cd(fullfile(matlabroot,'toolbox','circ'))
   Then simply type:
      » install
   If this doesn't work, see the help for INSTALL for further details.

If you would encounter any problems in any the above steps, the please
contact me "e8rasmus@etek.chalmers.se" and I'll do my best to help you
through.



GETTING STARTED
---------------

To get an idea of the formats used for schematic matrices and netlist matrices
I suggest that you read the help for SCH2NET and NET2MAT thouroughly.
To get a full list of functions available in this toolbox simply type
"help space".

To only create a circuit design, the write something like

» sch=ecsim;

After you have created your design with the circuit simulator tool, just
exit the program and the output variable "sch" will automatically correspond
to the circuit you just drew. Now, to get the circuit back into the simulator
just type

» ecsim(sch)

or

» sch=ecsim(sch);

The latter will update the schematic matrix when you change something.
Now the circuit will be shown just as you left it earlier. It might though
have been fitted to the axis so you might have to increase the axis limits
with the "axis" button on the menu if you're going to add something more.
When you feel ready for simulation, just press "simulate" and you'll be
able to choose between steady-state, sweep and transient analysis, the
latter won't work because this is just a demo. You may have to purchase the
full version to be able to perform a transient analysis. But this depends on
demand and interest.

To add a model you've created to the library, just type

» cmlib add

and you'll have to enter its name and location. If you change your mind
and want to remove a model from the list, simply write

» cmlib rm

and select which model id you want to remove. To get a list, just write

» cmlib



IMPORTANT NOTES
---------------
The NET2MAT routine can sometimes get stuck for certain parameter values.
If sweeping (manually with a for-loop or by using EC-SIM) try change the
stepsize. A simple trick like changing the stepsize to some product with
"pi/3" often does the trick. A more obvious approach would be to increase
the maximum allowed relative error EPS0 for NET2MAT. EC-SIM constantly
EPS0=1e-10. I'll improve this later.


UPDATES AND VERSIONS
--------------------

It should be noticed however that this is a beta version. This is my plans
for future updates:

1. Fix text-alignments for the plotting of steady-state values.
2. Being able to flip "multilegged" components (other than op-amps) in a
   smart way.
3. Avoid getting infinite conductances when having zero impedances.
4. Increase the sensitivity and stability of the NR-solver.
5. Make it possible to define hierarchies of blocks (multi-level blocks).
6. Include nonlinear capacitance (inherent model).
7. Include nonlinear VCVS (inherent model, (for MOS-FETs)).
8. Complete the bipolar transistor small signal models (need point 6.).
9. Increase the resolution for the logartihmic sweep (non-decadic).
10. Automatically add dots when line crossings occur.
11. Turning the EC-SIM into shareware.

I think that would be all for now...



Ver 1.0:
The first version: Seems to work.

Ver 1.1:
Fixed a bug concerning the node-numbering in the NET2MAT routine.
Previously, a netlist containing block-components that are not connected to
any other inherent component (such as resistors etc) but only to are connected
to terminals of other block-components will not be regardes as global nodes at
all and the node voltages for such nodes will only be regarded as a local node
voltage. An error will thus show when attempting to apply VALPLOT for such
a circuit.
I've also altered EC-SIM so that the sweeping of a particular component won't
affect its value in the schematic. Previous version would update the value
for a component in the schematic with the end value from the sweeping
for no reason.


So there will be more updates coming that's for sure. Until next update,
have fun!!!


EOF.