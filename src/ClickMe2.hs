{-# LANGUAGE OverloadedStrings #-}

module ClickMe2 ( clickMe2 ) where

import Data.Text
import React.Flux

clickMe2 :: ReactView Text
clickMe2 =
    defineStatefulView "clickMe2" True clickMe_

clickMe_ :: Bool -> Text -> ReactElementM (StatefulViewEventHandler Bool) ()
clickMe_ state message =
    h3_ [ style [("color", if state then "red" else "blue")]
        , on "onClick" . const $ \s -> ([], Just $ not s)
        ]
    $ elemText message
