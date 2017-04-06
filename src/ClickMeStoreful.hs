{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

module ClickMeStoreful ( clickMe ) where

import Control.DeepSeq
import Data.Text
import Data.Typeable
import GHC.Generics
import React.Flux

import qualified Element

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
    defineControllerView "clickMeStoreful" store
    $ clickMe_ dispatchToggle
  where
    store = mkStore (ClickMeStore False :: ClickMeStore tag)
    dispatchToggle = [SomeStoreAction store Toggle]

clickMe_
    :: ViewEventHandler
    -> ClickMeStore tag
    -> (tag, Text)
    -> ReactElementM ViewEventHandler ()
clickMe_ dispatch (ClickMeStore state) (_, message) =
    Element.clickMe_ dispatch state message
