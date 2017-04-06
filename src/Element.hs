{-# LANGUAGE OverloadedStrings #-}

module Element ( clickMe_ ) where

import Data.Text
import React.Flux

clickMe_ :: handler -> Bool -> Text -> ReactElementM handler ()
clickMe_ handler state message =
    div_ [ classNames [ ("clickme", True)
                      , ("clickme_active", state) ]
         , on "onClick" $ const handler
         ]
    $ elemText message
