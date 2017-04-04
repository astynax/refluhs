{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.DeepSeq
import Data.Proxy
import GHC.Generics
import React.Flux

import ClickMe
import ClickMe2
import ClickMe3

main :: IO ()
main =
    reactRender "root" demoView ()

instance Generic (Proxy "1")
instance NFData (Proxy "1")

instance Generic (Proxy "2")
instance NFData (Proxy "2")

demoView :: ReactView ()
demoView =
    defineView "demo" $ \_ -> do
        h1_ "Views w/ taged store"
        view clickMe (Proxy :: Proxy "1", "ClickMe #1") mempty
        view clickMe (Proxy :: Proxy "2", "ClickMe #2") mempty
        view clickMe (Proxy :: Proxy "1", "Clone of ClickMe #1") mempty

        h1_ "Views w/ store + optics"
        view (clickMe3 get set initial) (1 :: Int, "ClickMe #1") mempty
        view (clickMe3 get set initial) (2 :: Int, "ClickMe #2") mempty

        h1_ "Stateful Views"
        view clickMe2 "ClickMe #1" mempty
        view clickMe2 "ClickMe #2" mempty
    where
      get 1 = fst
      get _ = snd
      set 1 x (_, y) = (x, y)
      set _ y (x, _) = (x, y)
      initial = (True, True)
