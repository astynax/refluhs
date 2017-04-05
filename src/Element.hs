{-# LANGUAGE OverloadedStrings #-}

module Element ( clickMe_ ) where

import Data.Text
import React.Flux

clickMe_
    :: a -> Bool -> Text
    -> ReactElementM a ()
clickMe_ handler state message =
    h3_ [ style [("color", if state then "red" else "blue")]
        , on "onClick" $ const handler
        ]
    $ elemText message
