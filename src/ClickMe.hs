{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

module ClickMe ( clickMe ) where

import Control.DeepSeq
import Data.Text
import Data.Typeable
import GHC.Generics
import React.Flux

data ToggleAction tag = Toggle deriving (Generic)

instance NFData tag => NFData (ToggleAction tag)

data ClickMeStore tag = ClickMeStore Bool

instance Typeable tag => StoreData (ClickMeStore tag) where
    type StoreAction (ClickMeStore tag) = ToggleAction tag
    transform _ (ClickMeStore x) = pure $ ClickMeStore $ not x

clickMe
    :: forall tag. (Typeable tag, NFData tag)
    => ReactView (tag, Text)
clickMe =
    defineControllerView "clickMe" store
    $ clickMe_ dispatchToggle
  where
    store = mkStore (ClickMeStore True :: ClickMeStore tag)
    dispatchToggle = [SomeStoreAction store Toggle]

clickMe_
    :: ViewEventHandler
    -> ClickMeStore tag
    -> (tag, Text)
    -- ^ message
    -> ReactElementM ViewEventHandler ()
clickMe_ dispatch (ClickMeStore state) (_, message) =
    h3_ [ style [("color", if state then "red" else "blue")]
        , on "onClick" . const $ dispatch
        ]
    $ elemText message
