module PDBQT where

import Prelude hiding (FilePath, words)

import Data.Text (unpack, isInfixOf, words)
import Data.Vector (Vector, fromList)

import Turtle

import Types

getVinaScores :: [Text] -> Vector VinaRecord
getVinaScores contents = fromList $ cons (ids contents) (scores contents)

cons :: [Int] -> [Double] -> [VinaRecord]
cons [] _ = []
cons _ [] = []
cons models vinaScores = zipWith VinaRecord models vinaScores

ids :: [Text] -> [Int]
ids = extractionF 1 "MODEL"

scores :: [Text] -> [Double]
scores = extractionF 3 "VINA RESULT"

extractionF :: Read a => Int -> Text -> [Text] -> [a]
extractionF index grepper contents = map (\lt -> read $ unpack $ lt !! index) $ map words $ filter (isInfixOf grepper) contents
