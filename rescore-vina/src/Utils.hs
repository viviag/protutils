module Utils where

import Prelude hiding (FilePath)

import Data.Text (pack, Text)
import Filesystem.Path.CurrentOS (FilePath, encodeString)

showt :: Show a => a -> Text
showt = pack . show

fromEither :: Either a a -> a
fromEither (Right a) = a
fromEither (Left a) = a

fromRightCustom :: Either a b -> String -> b
fromRightCustom (Right b) _ = b
fromRightCustom (Left _) msg = error msg

fromJustCustom :: Maybe a -> String -> a
fromJustCustom (Just b) _ = b
fromJustCustom Nothing msg = error msg

showPath :: FilePath -> Text
showPath = pack . encodeString
