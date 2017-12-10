### runVina

This tool runs [vina](http://vina.scripps.edu/) on all ligands in a directory. It passes only required options through.

Help message:
```
This script can run AutoDock vina on all .pdbqt files in directory.
It assumes vina to be installed in directory listed in system Path.
It passes to vina required options only, syntax is similar to vina.

Usage: runVina (-r|--receptor RECEPTOR) (-l|--ligands LIGANDS)
               (-x|--center_x CENTER_X) (-y|--center_y CENTER_Y)
               (-z|--center_z CENTER_Z) (-a|--size_x SIZE_X)
               (-b|--size_y SIZE_Y) (-c|--size_z SIZE_Z)

Available options:
  -h,--help                Show this help text
  -r,--receptor RECEPTOR   Path to file with receptor
  -l,--ligands LIGANDS     Path to directory with ligands
  -x,--center_x CENTER_X   X coord of assumed site area center
  -y,--center_y CENTER_Y   Y coord of assumed site area center
  -z,--center_z CENTER_Z   Z coord of assumed site area center
  -a,--size_x SIZE_X       X radius of searching area
  -b,--size_y SIZE_Y       Y radius of searching area
  -c,--size_z SIZE_Z       Z radius of searching area
```
