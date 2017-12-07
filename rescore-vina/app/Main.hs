module Main where

import qualified Control.Foldl as Fold
import Filesystem.Path hiding (append, empty)

import Data.List
import Data.Proxy

import Prelude hiding (FilePath)
import Turtle

import TSV
import Report.IO (generateReportEntry)
import Types
import Utils
import Options

dock :: FilePath -> FilePath -> FilePath -> IO ()
dock ligand outputPath receptor =
  sh $ inproc "rf-score-vs" [ showPath ligand
                            , "--receptor" , showPath receptor
                            , "-O", showPath outputPath, "-o", "csv"] empty

main :: IO ()
main = do
  Options{..} <- options welcome parser
  mktree optOutputDir

  files <- listFiles optInput
  mapM_ (\oldName -> mv oldName (dropExtension oldName <.> "pdbqt")) files

  correctFiles <- listFiles optInput

  append (outputFile optReceptor optOutputDir "tsv") (return $ unsafeTextToLine (tsvHeader (Proxy @ReportEntry) names))
  
  unsortedRecords <- mapM (\lig -> do
    printf (fp%"\n") (basename lig)
    dock lig (outputFile lig optOutputDir "csv") optReceptor
    generateReportEntry lig (outputFile lig optOutputDir "csv") (basename lig)
    ) correctFiles

  -- It's algorithm downshifting. I'm using sort on formed list instead sorting in stream. FIXME
  mapM_ (append (outputFile optReceptor optOutputDir "tsv")) (map (return . unsafeTextToLine . tsvEntry) $ reverse . sort $ unsortedRecords)

  where
    listFiles dir = fold (lsif ((fmap isRegularFile) . stat) dir) Fold.list
    outputFile path outputDir ext = outputDir </> basename path <.> ext
    names = ["Ligand id", "vina_maximum", "score", "rf-score_old_max", "score", "vina_new_max", "score", "rf-score_maximum", "score"]
