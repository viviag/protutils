#!/usr/bin/python

#TODO: pass options to both called programs by cmdargs.
#TODO: have it on github.com (and correct versioning system for development also).
#TODO: propose it into mgltools or openbabel when complete.
#TODO: interfaces - options instead of args (if safe). -h option. maybe configs.
#It seems to be real start of pipeline work.

#TODO: build as package, maybe make iPython note - some dependency resolving system needed.
#TODO in general: bioinf tools @Stackage@ - on pip maybe. As far as i go - prepare easy text UIs.

import os
import sys
import subprocess

def usage():
  """
  Explicit help message.
  """
  print "First argument defines ligand/receptor preparation - if it's 'ligand' it will prepare it as ligands. Otherwise as receptors."
  print "Second argument is directory with molecules in different supported by babel formats."
  print "Third optional argument is output directory."

def extractFileName(path):
  """
  File name without extension and path prefix.
  """
  return path.split('/')[-1].split('.')[0]

def extractFileExt(path):
  """
  File extension
  """
  return path.split('.')[-1]

def convert(inputDir, outputDir, molecule, mol_type, ext):
  """
  Converts given ligand with given extension to .pdb and then prepare it to docking (to .pdbqt).
  Uses babel as program from system path and need installed mgltools and prepare_ligand4 script in working directory.
  """
  input = os.path.join(inputDir, molecule + "." + ext)
  media_output = os.path.join(outputDir, molecule + ".pdb")
  output = os.path.join(outputDir, molecule + ".pdbqt")

  #Make correct option forwarding.
  cmd_babel = ["babel", "-i", ext, input, "-o", "pdb", media_output, "-h", "-r"]
  subprocess.Popen(cmd_babel).wait()
  if mol_type == "receptor":
    cmd_prepare = ["./prepare_receptor4.py", "-r", media_output, "-o", output]
  else:
    cmd_prepare = ["./prepare_ligand4.py", "-l", media_output, "-o", output]
  return (subprocess.Popen(cmd_prepare), media_output)

def main(inputDir, outputDir, mol_type):
  """
  Logics entry point.
  """
  if os.path.exists(outputDir):
    print "Found target directory here. Maybe it's result of previous run, please check."
    exit(0)

  os.makedirs(outputDir)

  filePaths = os.walk(inputDir).next()[2]
  extensions = map(extractFileExt, filePaths)
  molecules = map(extractFileName, filePaths)

  for (molecule, ext) in zip(molecules, extensions):
    (process, media) = convert(inputDir, outputDir, molecule, mol_type, ext)
    process.wait()
    os.remove(media)

if __name__ == "__main__":
  if len(sys.argv) >= 4:
    main(sys.argv[2], sys.argv[3], sys.argv[1])
  elif len(sys.argv) == 3:
    main(sys.argv[2], os.path.join(sys.argv[2], "prepared"), sys.argv[1])
  else: usage()
