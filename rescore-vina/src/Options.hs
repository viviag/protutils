module Options where

import Prelude hiding (FilePath)
import Turtle

parser :: Parser Options
parser = Options <$> opt readFilePath "input" 'i' "Input directory."
                 <*> opt readFilePath "output" 'o' "Output directory. Required"
                 <*> opt readFilePath "receptor"  'r' "Path to receptor to dock in."
  where
    readFilePath = Just . fromText

data Options = Options
  { optInput :: FilePath
  , optOutputDir :: FilePath
  , optReceptor :: FilePath
  }

welcome :: Description
welcome = Description $ "---\n"
                      <> "This tool rescores vina results with rf-score-vs and produce simple TSV report on results.\n"
                      <> "Every file in input directory will be treated as vina output file. It does matter."
                      <> "It assumes vina and rf-score-vs to be installed in directory listed in system Path.\n"
