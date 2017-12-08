module Report.Pure where

import Prelude hiding (FilePath)
import Turtle

import qualified Data.Csv as CSV
import qualified PDBQT

import Data.ByteString.Lazy (ByteString)
import qualified Data.Vector as Vec

import Types
import Utils

builtReport :: ByteString -> [Line] -> Text -> ReportEntry
builtReport csv pdbqt ligand =
  ReportEntry
    { reportEntryLigandId = ligand
    , reportEntryVinaMax = vinaRecordModel vina
    , reportEntryVinaScore = vinaRecordScore vina
    , reportEntryRfOldMax = rfRecordModel $ findCsv vina
    , reportEntryRfOldScore = rfRecordScore $ findCsv vina
    , reportEntryVinaNewMax = vinaRecordModel $ findPdbqt rf
    , reportEntryVinaNewScore = vinaRecordScore $ findPdbqt rf
    , reportEntryRfMax = rfRecordModel rf
    , reportEntryRfScore = rfRecordScore rf
    }
  where
    vina = vinaMax pdbqt
    rf = rfMax csv
    findCsv vinaVec = findCsvMax csv vinaVec
    findPdbqt rfVec = findPdbqtMax pdbqt rfVec

csvVec :: ByteString -> Vec.Vector RfRecord
csvVec csvF = snd $ fromRightCustom (CSV.decodeByName csvF) "Corrupted csv file on input."

pdbVec :: [Line] -> Vec.Vector VinaRecord
pdbVec pdbqt = PDBQT.getVinaScores (map lineToText pdbqt)

oldMax :: Ord a => Vec.Vector a -> a
oldMax pdb = Vec.minimum pdb

newMax :: Ord a => Vec.Vector a -> a
newMax csv = Vec.maximum csv

oldNewMax :: Vec.Vector VinaRecord -> RfRecord -> VinaRecord
oldNewMax pdb new =
  fromJustCustom (Vec.find (\old -> rfRecordModel new == vinaRecordModel old) pdb)
                "Cannot find data on model id in pdbqt file - check data or contact maintaner"

newOldMax :: Vec.Vector RfRecord -> VinaRecord -> RfRecord
newOldMax csv old =
  fromJustCustom (Vec.find (\new -> vinaRecordModel old == rfRecordModel new) csv)
                "Cannot find data on model id in csv file - check data or contact maintaner"

rfMax :: ByteString -> RfRecord
rfMax csvFile = newMax $ csvVec $ csvFile

vinaMax :: [Line] -> VinaRecord
vinaMax pdbqtFile = oldMax $ pdbVec $ pdbqtFile

findCsvMax :: ByteString -> VinaRecord -> RfRecord
findCsvMax csvFile pdbqtMax = newOldMax (csvVec $ csvFile) pdbqtMax

findPdbqtMax :: [Line] -> RfRecord -> VinaRecord
findPdbqtMax pdbqtFile csvMax = oldNewMax (pdbVec $ pdbqtFile) csvMax
