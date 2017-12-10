### anychem2dock

This tool apply [openbabel](http://openbabel.org/wiki/Main_Page) and then [MGLtools](http://mgltools.scripps.edu/downloads) scripts (`prepare_ligand4` or `prepare_receptor4`) to all files in given directory.

It requires babel and these two scripts installed locally in `Path`.

Usage copied from help:
```
This tool converts any supported by openbabel format to pdb and then prepare it for docking with AutoDock vina.
Given input directory expected not to contain any non-chemical file. But it doesn't really matter.
It assumes vina and MGLTools scripts prepare_ligand4 and prepare_receptor4 to be installed in directory listed in system Path.


Usage: anychem2dock (-i|--input INPUT) [-o|--output OUTPUT] [-r|--receptor] [-e|--extend-babel]
                    
Available options:
  -h,--help                Show this help text
  -i,--input INPUT         Input directory.
  -o,--output OUTPUT       Output directory (optional - if missing will create `prepared` subdir in input directory).
  -r,--receptor            Treat put in files as receptors and use prepare_receptor4.
  -e,--extend-babel        Extend babel running with -h and -r parameters.
                                                         
```
