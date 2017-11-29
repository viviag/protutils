#!/usr/bin/python

import sys
import os
import subprocess

def usage():
  print "All parameters are similar to minimal running of vina, but it expect directory instead of ligand. And these are not options, type only values."

def run(receptor, ligand, center_x, center_y, center_z, size_x, size_y, size_z):
  cmd = ["vina"
        , "--receptor", receptor
        , "--ligand", ligand
        , "--center_x", center_x
        , "--center_y", center_y
        , "--center_z", center_z
        , "--size_x", size_x
        , "--size_y", size_y
        , "--size_z", size_z]
  subprocess.Popen(cmd).wait()

def main(receptor, ligandDir, center_x, center_y, center_z, size_x, size_y, size_z):
  ligands = os.walk(ligandDir).next()[2]
  for ligand in ligands:
    run(receptor, os.path.join(ligandDir, ligand), center_x, center_y, center_z, size_x, size_y, size_z)

if __name__ == "__main__":
  if len(sys.argv) >= 9:
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8])
  else: usage()

