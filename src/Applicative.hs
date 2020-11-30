-- |
module Applicative where

import Control.Monad (ap)
import Prelude hiding (sequence)

sequence :: [IO a] -> IO [a]
sequence [] = return []
sequence (c : cs) = do
  x <- c
  xs <- sequence cs
  return (x : xs)

sequence' :: [IO a] -> IO [a]
sequence' [] = return []
sequence' (c : cs) = return (:) `ap` c `ap` sequence' cs

try :: IO [()]
try = sequence' [print "a", print "b"]

transpose :: [[a]] -> [[a]]
transpose [] = repeat []
transpose (xs : xss) = zipWith (:) xs (transpose xss)

-- transpose ([[1,2,3], [4,5,6], [7,8,9]])

zapp :: [a -> b] -> [a] -> [b]
zapp (f : fs) (x : xs) = f x : zapp fs xs
zapp _ _ = []

transpose' :: [[a]] -> [[a]]
transpose' [] = repeat []
transpose' (xs : xss) = repeat (:) `zapp` xs `zapp` transpose' xss

data Exp v
  = Var v
  | Val Int
  | Add (Exp v) (Exp v)

data Env v = Env v

eval :: Exp v -> Env v -> Int
eval (Var x) env = fetch x env
eval (Val i) _ = i
eval (Add p q) env = eval p env + eval q env

fetch :: a -> Env a -> Int
fetch = undefined
