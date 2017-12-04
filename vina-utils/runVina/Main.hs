{-# LANGUAGE OverloadedStrings #-}
module Main where

import Prelude hiding (FilePath)
import Turtle

import Control.Foldl as Fold hiding (mapM_, fold)

import Filesystem.Path.CurrentOS (encodeString)

import Data.Text (Text, pack)

parser :: Parser (Text, FilePath, Double, Double, Double, Double, Double, Double)
parser = (,,,,,,,) <$> optText "receptor" 'r' "Path to file with receptor"
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

main :: IO ()
main = do
  (receptor, ligands, x_center, y_center, z_center, x_radius, y_radius, z_radius) <- options welcome parser
  files <- fold (lsif (\lig -> return $ extension lig == Just "pdbqt") ligands) Fold.list
  mapM_ (\lig -> stdout $ action receptor lig x_center y_center z_center x_radius y_radius z_radius) files
  print $ showt x_center
  where
    action receptor ligand x_center y_center z_center x_size y_size z_size = inproc "vina"
        [ "--receptor", receptor
        , "--ligand", pack . encodeString $ ligand
        , "--center_x", showt x_center
        , "--center_y", showt y_center
        , "--center_z", showt z_center
        , "--size_x", showt x_size
        , "--size_y", showt y_size
        , "--size_z", showt z_size
        ] empty
    showt = pack . show
