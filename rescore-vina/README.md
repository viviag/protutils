### rescore-vina

This package takes [vina](http://vina.scripps.edu) output, rescores it with [rf-score-vs](https://github.com/oddt/rfscorevs_binary) and produce simple `.tsv` report.

Requires vina and rf-score-vs installed in `Path`.

Help message:
```
This tool rescores vina results with rf-score-vs and produce simple TSV report on results.
Every file in input directory will be treated as vina output file. It does matter.
It assumes vina and rf-score-vs to be installed in directory listed in system Path.

Usage: rescore-vina (-i|--input INPUT) (-o|--output OUTPUT)
                    (-r|--receptor RECEPTOR)

Available options:
  -h,--help                Show this help text
  -i,--input INPUT         Input directory.
  -o,--output OUTPUT       Output directory. Required
  -r,--receptor RECEPTOR   Path to receptor to dock in.                            
```
