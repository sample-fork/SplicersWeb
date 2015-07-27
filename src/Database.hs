{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.PostgreSQL.Simple
import Data.Text (Text(..), unpack)
import Data.ByteString.Char8 (pack)
import Control.Monad (forM_)
import Card
import System.Environment (lookupEnv)

friendsNames :: Connection -> IO [(Only Text)]
friendsNames conn = do
  xs <- query_ conn "select name from friends"
  return xs

friendsAges :: Connection -> IO [(Text, Int)]
friendsAges conn = do
  xs <- query_ conn "select name,age from friends"
  return xs

temp = do
  (Just db_url) <- lookupEnv "DATABASE_URL"
  conn <- connectPostgreSQL db_url

  execute_ conn "CREATE TABLE IF NOT EXISTS friends (name varchar(80), age int);"
  execute_ conn "INSERT INTO friends VALUES ('Erik', 27);"
  execute_ conn "INSERT INTO friends VALUES ('Niklas', 32);"

  putStrLn "\nOnly names:"
  names <- (friendsNames conn)
  forM_ names $ \(Only name) ->
    putStrLn $ unpack name

  putStrLn "\nNames and ages:"
  ages <- (friendsAges conn)
  forM_ ages $ \(name,age) ->
    putStrLn $ unpack name ++ " is " ++ show (age :: Int)

-- export DATABASE_URL="dbname=splicers user=erik"

getCards :: IO [Card]
getCards = do
  (Just db_url) <- lookupEnv "DATABASE_URL"
  conn <- connectPostgreSQL (pack db_url)
  cards <- query_ conn "SELECT title,rules FROM card;"
  return $ map (\(t,r) -> Card t r) cards


