{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

module ClickMeOptical
    ( Getter
    , Setter
    , clickMe
    ) where

import Control.DeepSeq
import Data.Text
import Data.Typeable
import GHC.Generics
import React.Flux

import qualified Element

data ToggleAction key = Toggle key deriving (Generic)

instance NFData key => NFData (ToggleAction key)

type Getter key state = key -> state -> Bool
type Setter key state = key -> Bool -> state -> state

data ClickMeStore key state =
    ClickMeStore
    (Getter key state)
    (Setter key state)
    state

instance (Typeable key, Typeable state)
         => StoreData (ClickMeStore key state) where

    type StoreAction (ClickMeStore key state) = ToggleAction key

    transform (Toggle key) (ClickMeStore get set oldState) =
        let newState = set key (not $ get key oldState) oldState
        in pure $ ClickMeStore get set newState

clickMe
    :: forall key state. (Typeable key, NFData key, Typeable state)
    => Getter key state
    -> Setter key state
    -> state
    -> ReactView (key, Text)
clickMe get set x =
    defineControllerView "clickMeOptical" store
    $ clickMe_ dispatchToggle
  where
    store = mkStore (ClickMeStore get set x :: ClickMeStore key state)
    dispatchToggle key = [SomeStoreAction store $ Toggle key]

clickMe_
    :: (key -> ViewEventHandler)
    -> ClickMeStore key state
    -> (key, Text)
    -> ReactElementM ViewEventHandler ()
clickMe_ dispatch (ClickMeStore get _ state) (key, message) =
    Element.clickMe_ (dispatch key) (get key state) message
