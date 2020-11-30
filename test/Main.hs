{-# LANGUAGE TemplateHaskell #-}

module Main where

import Hedgehog
import Hedgehog.Main
import AbstractInContext

prop_test :: Property
prop_test = property $ do
  doAbstractInContext === "AbstractInContext"

main :: IO ()
main = defaultMain [checkParallel $$(discover)]
