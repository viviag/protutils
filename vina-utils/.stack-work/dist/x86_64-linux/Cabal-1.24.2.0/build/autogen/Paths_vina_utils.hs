{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_vina_utils (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/bin"
libdir     = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/lib/x86_64-linux-ghc-8.0.2/vina-utils-0.1"
dynlibdir  = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/lib/x86_64-linux-ghc-8.0.2"
datadir    = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/share/x86_64-linux-ghc-8.0.2/vina-utils-0.1"
libexecdir = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/libexec"
sysconfdir = "/home/vit/Documents/Work/Sci/Ist_Austria/Software/protutils/.stack-work/install/x86_64-linux/lts-9.14/8.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "vina_utils_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "vina_utils_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "vina_utils_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "vina_utils_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "vina_utils_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "vina_utils_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
