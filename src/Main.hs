{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import React.Flux

import qualified ClickMeOptical as O
import qualified ClickMeStateful as A
import qualified ClickMeStoreful as S

main :: IO ()
main =
    reactRender "root" demoView ()

data Tag1 = T1
data Tag2 = T2

demoView :: ReactView ()
demoView =
    defineView "demo" $ \_ -> do
        h1_ "Views w/ taged store"
        view S.clickMe (T1, "ClickMe #1") mempty
        view S.clickMe (T2, "ClickMe #2") mempty
        view S.clickMe (T1, "Clone of ClickMe #1") mempty

        h1_ "Views w/ store + optics"
        view (O.clickMe get set initial) (1::Int, "ClickMe #1") mempty
        view (O.clickMe get set initial) (2::Int, "ClickMe #2") mempty

        h1_ "Stateful Views"
        view A.clickMe "ClickMe #1" mempty
        view A.clickMe "ClickMe #2" mempty
    where
      get 1 = fst
      get _ = snd
      set 1 x (_, y) = (x, y)
      set _ y (x, _) = (x, y)
      initial = (True, True)
