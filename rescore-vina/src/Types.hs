{-# LANGUAGE DeriveDataTypeable #-}
module Types where

import Data.Data

import Data.Csv
import Data.Text (intercalate)

import Prelude hiding (FilePath)
import Turtle

import TSV
import Utils

data VinaRecord = VinaRecord
  { vinaRecordModel :: Int
  , vinaRecordScore :: Double
  }

instance Eq VinaRecord where
  first == second = vinaRecordScore first == vinaRecordScore second

instance Ord VinaRecord where
  compare first second = compare (vinaRecordScore first) (vinaRecordScore second)

data RfRecord = RfRecord
  { rfRecordModel :: Int
  , rfRecordOrigin :: FilePath
  , rfRecordScore :: Double
  }

instance Eq RfRecord where
  first == second = rfRecordScore first == rfRecordScore second

instance Ord RfRecord where
  compare first second = compare (rfRecordScore first) (rfRecordScore second)

instance FromField FilePath where
  parseField = fmap fromText . parseField
instance ToField FilePath where
  toField fpath = toField $ fromEither $ toText fpath

instance FromNamedRecord RfRecord where
    parseNamedRecord m = RfRecord <$> m .: "MODEL" <*> m .: "name" <*> m .: "RFScoreVS_v2"
instance ToNamedRecord RfRecord where
    toNamedRecord (RfRecord model origin score) = namedRecord [
        "MODEL" .= model, "name" .= origin, "RFScoreVS_v2" .= score]

data ReportEntry = ReportEntry
  { reportEntryLigandId :: Text
  , reportEntryVinaMax :: Int
  , reportEntryVinaScore :: Double
  , reportEntryRfOldMax :: Int
  , reportEntryRfOldScore :: Double
  , reportEntryVinaNewMax :: Int
  , reportEntryVinaNewScore :: Double
  , reportEntryRfMax :: Int
  , reportEntryRfScore :: Double
  } deriving Data

instance Eq ReportEntry where
  first == second = reportEntryVinaMax first == reportEntryVinaMax second

instance Ord ReportEntry where
  compare first second = compare (reportEntryVinaMax first) (reportEntryVinaMax second)

instance ToTSV ReportEntry where
  -- FIXME: here user of TSV lib must manually preserve ordering of fields to match header.
  tsvEntry ReportEntry{..} =  intercalate "\t" [ reportEntryLigandId
                                               , showt reportEntryVinaMax
                                               , showt reportEntryVinaScore
                                               , showt reportEntryRfOldMax
                                               , showt reportEntryRfOldScore
                                               , showt reportEntryVinaNewMax
                                               , showt reportEntryVinaNewScore
                                               , showt reportEntryRfMax
                                               , showt reportEntryRfScore]
