module Report.IO where

import Prelude hiding (FilePath)
import Turtle

import qualified Control.Foldl as Fold

import Data.ByteString.Lazy (ByteString)

import qualified Data.Csv as CSV
import qualified Data.Text.Lazy as Text
import qualified Data.Text.Lazy.Encoding as Text
import qualified Data.Vector as Vec

import Types
import Utils
import qualified PDBQT

generateReportEntry :: FilePath -> FilePath -> FilePath -> IO ReportEntry
generateReportEntry ligandPath rescoredPath ligandName = do
  csvFile <- Text.encodeUtf8 . Text.fromStrict <$> readTextFile rescoredPath
  pdbqtFile <- fold (input ligandPath) Fold.list
  
  return ReportEntry
    { reportEntryLigandId = showPath ligandName
    , reportEntryVinaMax =
        vinaRecordModel $ oldMax $ pdbVec $ pdbqtFile
    , reportEntryVinaScore =
        vinaRecordScore $ oldMax $ pdbVec $ pdbqtFile
    , reportEntryRfOldMax =
        rfRecordModel $ newOldMax (csvVec $ csvFile)
                                  (oldMax $ pdbVec $ pdbqtFile)
    , reportEntryRfOldScore =
        rfRecordScore $ newOldMax (csvVec $ csvFile)
                                  (oldMax $ pdbVec $ pdbqtFile)
    , reportEntryVinaNewMax =
        vinaRecordModel $ oldNewMax (pdbVec $ pdbqtFile)
                                    (newMax $ csvVec $ csvFile)
    , reportEntryVinaNewScore =
        vinaRecordScore $ oldNewMax (pdbVec $ pdbqtFile)
                                    (newMax $ csvVec $ csvFile)
    , reportEntryRfMax =
        rfRecordModel $ newMax $ csvVec $ csvFile
    , reportEntryRfScore =
        rfRecordScore $ newMax $ csvVec $ csvFile
    }
  
  where
    csvVec :: ByteString -> Vec.Vector RfRecord
    csvVec csvF = snd $ fromRightCustom (CSV.decodeByName csvF) "Corrupted csv file on input."
    pdbVec :: [Line] -> Vec.Vector VinaRecord
    pdbVec pdbqt = PDBQT.getVinaScores (map lineToText pdbqt)
    oldMax pdb = Vec.minimum pdb
    newMax csv = Vec.maximum csv
    oldNewMax pdb new =
      fromJustCustom (Vec.find (\old -> rfRecordModel new == vinaRecordModel old) pdb)
                     "Cannot find data on model id in pdbqt file - check data or contact maintaner"
    newOldMax csv old =
      fromJustCustom (Vec.find (\new -> vinaRecordModel old == rfRecordModel new) csv)
                     "Cannot find data on model id in csv file - check data or contact maintaner"
