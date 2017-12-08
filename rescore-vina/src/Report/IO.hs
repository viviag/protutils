module Report.IO where

import Prelude hiding (FilePath)
import Turtle

import qualified Control.Foldl as Fold

import qualified Data.Text.Lazy as Text
import qualified Data.Text.Lazy.Encoding as Text

import Types
import Utils
import Report.Pure

generateReportEntry :: FilePath -> FilePath -> FilePath -> IO ReportEntry
generateReportEntry ligandPath rescoredPath ligandName = do
  csvFile <- Text.encodeUtf8 . Text.fromStrict <$> readTextFile rescoredPath
  pdbqtFile <- fold (input ligandPath) Fold.list
  
  return $ builtReport csvFile pdbqtFile (showPath ligandName)
