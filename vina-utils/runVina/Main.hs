module Main where

import Prelude hiding (FilePath)
import Turtle

import qualified Control.Foldl as Fold

import Filesystem.Path.CurrentOS (encodeString, (</>))

import Data.Text (Text, pack)

parser :: Parser Options
parser = Options <$> optText "receptor" 'r' "Path to file with receptor"
                 <*> opt (Just . fromText) "ligands" 'l' "Path to directory with ligands"
                 <*> optDouble "center_x" 'x' "X coord of assumed site area center"
                 <*> optDouble "center_y" 'y' "Y coord of assumed site area center"
                 <*> optDouble "center_z" 'z' "Z coord of assumed site area center"
                 <*> optDouble "size_x" 'a' "X radius of searching area"
                 <*> optDouble "size_y" 'b' "Y radius of searching area"
                 <*> optDouble "size_z" 'c' "Z radius of searching area"

welcome :: Description
welcome = Description $ "---\n"
                      <> "This script can run AutoDock vina on all .pdbqt files in directory.\n"
                      <> "It assumes vina to be installed in directory listed in system Path.\n"
                      <> "It passes to vina required options only, syntax is similar to vina.\n"

data Options = Options
  { optReceptor :: Text
  , optLigands :: FilePath
  , optX :: Double
  , optY :: Double
  , optZ :: Double
  , optXSide :: Double
  , optYSide :: Double
  , optZSide :: Double
  }

main :: IO ()
main = do
  Options{..} <- options welcome parser
  files <- fold (lsif (\lig -> return $ extension lig == Just "pdbqt") optLigands) Fold.list
  flag <- testdir "outdated"
  if flag then return () else mkdir "outdated"
  mapM_ (\lig -> action optReceptor lig optX optY optZ optXSide optYSide optZSide) files
  where
    action receptor ligand x_center y_center z_center x_size y_size z_size = do
      stdout $ inproc "vina"
        [ "--receptor", receptor
        , "--ligand", pack . encodeString $ ligand
        , "--center_x", showt x_center
        , "--center_y", showt y_center
        , "--center_z", showt z_center
        , "--size_x", showt x_size
        , "--size_y", showt y_size
        , "--size_z", showt z_size
        ] empty
      mv ligand ("outdated" </> filename ligand)
    showt = pack . show
