{-# LANGUAGE OverloadedStrings #-}

module ClickMeStateful ( clickMe ) where

import Data.Text
import React.Flux

import Element

clickMe :: ReactView Text
clickMe =
    defineStatefulView "clickMeStateful" True element_

element_ :: Bool -> Text -> ReactElementM (StatefulViewEventHandler Bool) ()
element_ =
    clickMe_ $ \s -> ([], Just $ not s)
