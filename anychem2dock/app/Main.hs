module Main where

import Prelude hiding (FilePath)
import Turtle

import Control.Foldl as Fold hiding (mapM_, fold)

import Filesystem.Path.CurrentOS (encodeString)

import Data.Maybe (fromMaybe)
import Data.Text (Text, pack)

parser :: Parser Options
parser = Options <$> opt (Just . fromText) "input" 'i' "Input directory."
                 <*> optional (opt (Just . fromText) "output" 'o' "Output directory.")
                 <*> switch  "receptor"  'r' "Treat put in files as receptors and use prepare_receptor4."
                 <*> switch  "extend-babel"  'e' "Extend babel running with -h and -r parameters."

data Options = Options
  { optInput :: FilePath
  , optOutput :: Maybe FilePath
  , optReceptor :: Bool
  , optExtend :: Bool
  }

welcome :: Description
welcome = Description $ "---\n"
                      <> "This tool converts any supported by openbabel format to pdb and then prepare it for docking with AutoDock vina.\n"
                      <> "Given input directory expected not to contain any non-chemical file. But it doesn't really matter."
                      <> "It assumes vina and MGLTools scripts prepare_ligand4 and prepare_receptor4 to be installed in directory listed in system Path.\n"

receptorAction :: FilePath -> FilePath -> Shell Line
receptorAction media outF = inproc "prepare_receptor4.py" ["-r", showt media, "-o", showt outF] empty

ligandAction :: FilePath -> FilePath -> Shell Line
ligandAction media outF = inproc "prepare_ligand4.py" ["-l", showt media, "-o", showt outF] empty

showt :: FilePath -> Text
showt = pack . encodeString

convert :: Bool -> FilePath -> Bool -> FilePath -> IO ()
convert receptor outputDir extend molPath = do
  stdout $ babelAction molExt (media_output molName)
  if receptor
    then stdout $ receptorAction (media_output molName) (outputF molName)
    else stdout $ ligandAction (media_output molName) (outputF molName)
  rm (media_output molName)
  where
    molExt = fromMaybe "sdf" (extension molPath)
    molName = basename molPath
    media_output name = outputDir </> name <.> "pdb"
    outputF name = outputDir </> name <.> "pdbqt"
    
    babelAction :: Text -> FilePath -> Shell Line
    babelAction ext media = if extend
      then inproc "babel" [ "-i", ext, showt molPath
                            , "-o", "pdb", showt media
                            , "-h", "-r"] empty
      else inproc "babel" [ "-i", ext, showt molPath
                            , "-o", "pdb", showt media] empty

main :: IO ()
main = do
  Options{..} <- options welcome parser
  files <- fold (lsif ((fmap isRegularFile) . stat) optInput) Fold.list
  mktree (outputDir optInput optOutput)
  mapM_ (convert optReceptor (outputDir optInput optOutput) optExtend) files
  where
    outputDir idir odir = (fromMaybe (idir </> fromText "prepared") odir)
