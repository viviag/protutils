##Protutils
Prot_ein util_itie_s

These are differently conjuncted tools for docking procedure automation.
They are written under Linux and for Linux. With Haskell I will be able to support Windows automatically but not for now.

Members:
Peter Vlasov, PhD, IST Austria, SMTB Alumni - supervising, usability, biological sense.
Vit Guzeev, GetShopTV, SMTB Alumni - code.

###Content annotation:
 * _runVina_ - utility to run autodock-vina on all files in a directory.
   Requires autodock-vina installed somethere in users 'Path'.
 * _babelStreamer_ - converts all molecules from any supported by babel format in given directory to `.pdbqt` and prepare them for docking.
   Requires openbabel installed in 'Path' and scripts `prepare_ligand4.py` from _MGLTools_ in directory where script is run.
 * _wrap-rf-score-vs_ - rescores all vina results with (rf-score-vs)[https://github.com/oddt/rfscorevs_binary] and produce simple `.tsv` report on results.
   Requires _rf-score-vs_ in run directory.

###TODO:
 * Write presentable documentation and usages.
 * Rewrite code in Haskell

