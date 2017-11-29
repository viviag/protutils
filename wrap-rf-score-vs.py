#!/usr/bin/python

# maintaner - viviag@yandex.ru
# TODO: refactor, make safe. Possibly add options (getopt) and sort vina output to pipeline it completely. And check sense. Need mind.
# TODO: easy parsable output.

# Reason to use Python - being in bioinformatics ecosystem.

import os
import sys
import subprocess
from shutil import rmtree

def usage():
  """
  Explicit help message
  """
  print "---"
  print "Specify input directory, protein file and output directory in this order as arguments of cmdline."
  print "---"

def outToPdbqt(filename):
  """
  If result is given actually in .pdbqt but with another extension, rename it because rf-score-vs cannot define type by content. 
  """
  splitedName = os.path.splitext(filename)
  os.rename(filename, splitedName[0]+".pdbqt")

def dock(ligandPath, resultDir, protein, ligand):
  """
  Actually execute rf-score-vs for one item in directory.
  """
  outputF = os.path.join(resultDir, ligand + ".csv")

  cmd = ["./rf-score-vs", ligandPath, "--receptor", protein, "-O", outputF, "-o", "csv"]
  return subprocess.Popen(cmd)

def getOutDatedMax(listing, num):
  """
  Get value what was extremal for another docking method.
  """
  rowStr = ""
  for row in listing:
    if row[0] == num:
      rowStr = row[0] + '\t' + row[1]
  if rowStr != "":
    return rowStr
  print ("No rows with given model number found in rf-score-vs output. Check if data is broken or contact maintaner.")
  print listing
  print nums
  exit()

def getMax(listing):
  """
  Get list of maximal scores with their models.
  """
  max = -10000
  maxRow = []

  for row in listing:
    if float(row[1]) > 0:
      cmp = float(row[1]) - 1000
    else:
      cmp = abs(float(row[1]))
    if cmp > max:
      max = cmp
      maxRow = row
  return maxRow[0] + '\t' + maxRow[1]

def preparePDB(pdbFile):
  """
  Parse vina results to comparable structure
  """
  pdbPreRead = subprocess.check_output(['grep', 'MODEL\|VINA', pdbFile]).split('\n')
  pdbRead = []
  for i in xrange(0, len(pdbPreRead) - 1, 2):
    pdbRead.append((pdbPreRead[i] + ' ' + pdbPreRead[i+1]).split())
# ['MODEL', 1, 'REMARK', 'VINA', 'RESULT', '-9', 0, 0]
  return [[row[1], row[5]] for row in pdbRead]

def prepareCSV(csvFile):
  """
  Parse rf-score-vs results to comparable structure
  """
# [1, 'path/ligand_input', score]
  return [[row[0], row[2]] for row in [i.split(',') for i in csvFile.readlines()[1:]]]

def printResults(vina, rfile, ligandId):
  """
  Count extremal scores and return them.
  """

  print ligandId
  rf = open(rfile, 'r')

  pdbRead = preparePDB(vina)
  csvRead = prepareCSV(rf)

  oldMax = getMax(pdbRead)
  newMax = getMax(csvRead)
  oldNewMax = getOutDatedMax(pdbRead, newMax.split('\t')[0])
  newOldMax = getOutDatedMax(csvRead, oldMax.split('\t')[0])

  rf.close()

  tabStr = (ligandId + '\t' + oldMax + '\t' + newMax + '\t' + oldNewMax + '\t' + newOldMax).split('\t')
  return tabStr

def extractFileName(path):
  """
  File name without extension and path prefix.
  """
  return path.split('/')[-1].split('.')[0]

def generateOutputPath(proteinPath):
  """
  Protein file path with different extension.
  """
  name = extractFileName(proteinPath) + ".tsv"
  path = '/'.join(proteinPath.split('/')[:-1])
  return os.path.join(path, name)

def appendSorted(array, newValue):
  """
  Sort resulting output file by decreasing of old maximum.
  """
  criterionIndex = 2
  for i in range(0, len(array)):
    if float(array[i][criterionIndex]) >= float(newValue[criterionIndex]):
      array.insert(i, newValue)
      return
  array.append(newValue)

def toOutString(array):
  return ['\t'.join(item).replace('\n','').replace('\r','') for item in array]

def main(dataDir, protein, resultDir, outputFile):
  """
  Logics entry point.
  """
  if not os.path.exists(resultDir):
    os.makedirs(resultDir)

  proteinName = extractFileName(protein)

  fileNames = sorted((next(os.walk(dataDir)))[2])
  filePaths = [os.path.join(dataDir, i) for i in fileNames]
  map(outToPdbqt, filePaths)

  print("Output directory for rf-score-vs will be " + resultDir)

  fileNames = sorted((next(os.walk(dataDir)))[2])

  outputFileObject = open(outputFile, 'w')
  print("Output file: " + outputFile)
  outputFileObject.write('Ligand id\tvina_maximum\tscore\trf-score_old_max\tscore\trf-score_maximum\tscore\tvina_new_max\tscore:\n')

  output = []
  for ligandPath in fileNames:
    ligand = extractFileName(ligandPath)
    rescoredPath = os.path.join(resultDir, ligand + ".csv")

    dock(os.path.join(dataDir, ligandPath), resultDir, protein, ligand).wait()

    appendSorted(output, printResults(os.path.join(dataDir, ligandPath), rescoredPath, ligand))

  outData = toOutString(output)
  outputFileObject.write('\n'.join(outData))
  outputFileObject.close()

if __name__ == "__main__":
  if len(sys.argv) >= 4:
    main(sys.argv[1], sys.argv[2], sys.argv[3], generateOutputPath(sys.argv[2]))
  else: usage()
