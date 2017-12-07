-- This module provides incapsulated interface to write records directly to .tsv files.
module TSV where

import Data.Monoid ((<>))
import Data.Proxy
import Data.Text (Text, intercalate)

class ToTSV a where
  tsvHeader :: Proxy a -> [Text] -> Text -- I don't want to use type programming here till it's not really needed. But now it's unsafe. FIXME
  tsvHeader _ names = intercalate "\t" names <> ":"

  tsvEntry :: a -> Text
