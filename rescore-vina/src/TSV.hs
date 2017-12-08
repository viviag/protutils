-- This module provides incapsulated interface to write records directly to .tsv files.
module TSV where

import Data.Data

import Data.Monoid ((<>))
import Data.Text (Text)
import qualified Data.Text as Text

class Data a => ToTSV a where
  tsvHeader :: Proxy a -> Text
  tsvHeader p = Text.intercalate "\t" (map Text.pack (names p)) <> ":"

  tsvEntry :: a -> Text

--names = ["Ligand id", "vina_maximum", "score", "rf-score_old_max", "score", "vina_new_max", "score", "rf-score_maximum", "score"]

names :: Data a => Proxy a -> [String]
names p = map (stripRecordPrefix p) (getFieldNames p (undefined :: a))

getFieldNames :: Data a => Proxy a -> a -> [String]
-- (!!) 0 == \list -> list !! 0  
getFieldNames _ = constrFields . (\t -> indexConstr t 1) . dataTypeOf

stripRecordPrefix :: Data a => Proxy a -> String -> String
stripRecordPrefix p = drop (length $ recordName p (undefined :: a))

recordName :: Data a => Proxy a -> a -> String
recordName _ = dataTypeName . dataTypeOf
