{-# LANGUAGE OverloadedStrings #-}

module ClickMeStateful ( clickMe ) where

import Data.Text
import React.Flux

import qualified Element

clickMe :: ReactView Text
clickMe =
    defineStatefulView "clickMeStateful" False clickMe_

clickMe_ :: Bool -> Text -> ReactElementM (StatefulViewEventHandler Bool) ()
clickMe_ =
    Element.clickMe_ $ \state -> ([], Just $ not state)
