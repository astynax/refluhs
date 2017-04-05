{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

module ClickMeStoreful ( clickMe ) where

import Control.DeepSeq
import Data.Text
import Data.Typeable
import GHC.Generics
import React.Flux

import Element

data ToggleAction tag = Toggle deriving (Generic)

instance NFData (ToggleAction tag)

data ClickMeStore tag = ClickMeStore Bool

instance Typeable tag => StoreData (ClickMeStore tag) where
    type StoreAction (ClickMeStore tag) = ToggleAction tag
    transform _ (ClickMeStore x) = pure $ ClickMeStore $ not x

clickMe
    :: forall tag. Typeable tag
    => ReactView (tag, Text)
clickMe =
    defineControllerView "clickMe" store
    $ element_ dispatchToggle
  where
    store = mkStore (ClickMeStore True :: ClickMeStore tag)
    dispatchToggle = [SomeStoreAction store Toggle]

element_
    :: ViewEventHandler
    -> ClickMeStore tag
    -> (tag, Text)
    -> ReactElementM ViewEventHandler ()
element_ dispatch (ClickMeStore state) (_, message) =
    clickMe_ dispatch state message
