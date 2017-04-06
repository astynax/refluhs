{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Monoid
import React.Flux

import qualified ClickMeOptical  as O
import qualified ClickMeStateful as X
import qualified ClickMeStoreful as S

main :: IO ()
main =
    reactRender "root" demoView ()

data Tag1 = T1
data Tag2 = T2

demoView :: ReactView ()
demoView =
    defineStatefulView "demo" "ClickMe" $ \message _ -> do
        input_ [ "className" $= "input-message"
               , "value" @= message
               , on "onChange"
                 $ \evt _ -> ([], Just $ target evt "value")
               ]

        h1_ "Taged store"
        view S.clickMe (T1, message <> " #1") mempty
        view S.clickMe (T2, message <> " #2") mempty
        view S.clickMe (T1, message <> " #1") mempty

        h1_ "Store + optics"
        let
            get (Left _)   (x, _) = x
            get _          (_, y) = y
            set (Left _) x (_, y) = (x, y)
            set _        y (x, _) = (x, y)
            initial               = (False, False)
            clickMe               = O.clickMe get set initial
        view clickMe (Left  (), message <> " #1") mempty
        view clickMe (Right (), message <> " #2") mempty

        h1_ "Stateful"
        view X.clickMe (message <> " #1") mempty
        view X.clickMe (message <> " #2") mempty
