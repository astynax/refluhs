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

import Element

data ToggleAction key = Toggle key deriving (Generic)

instance NFData key => NFData (ToggleAction key)

type Getter key a = key -> a -> Bool
type Setter key a = key -> Bool -> a -> a

data ClickMeStore key a =
    ClickMeStore (Getter key a) (Setter key a) a

instance (Typeable key, Typeable a) => StoreData (ClickMeStore key a) where
    type StoreAction (ClickMeStore key a) = ToggleAction key
    transform (Toggle k) (ClickMeStore get set x) =
        pure . ClickMeStore get set $ set k (not $ get k x) x

clickMe
    :: forall key a. (Typeable key, NFData key, Typeable a)
    => Getter key a -> Setter key a -> a -> ReactView (key, Text)
clickMe get set x =
    defineControllerView "clickMe" store
    $ element_ dispatchToggle
  where
    store = mkStore (ClickMeStore get set x :: ClickMeStore key a)
    dispatchToggle key = [SomeStoreAction store $ Toggle key]

element_
    :: (key -> ViewEventHandler)
    -> ClickMeStore key a
    -> (key, Text)
    -> ReactElementM ViewEventHandler ()
element_ dispatch (ClickMeStore get _ state) (key, message) =
    clickMe_ (dispatch key) (get key state) message
