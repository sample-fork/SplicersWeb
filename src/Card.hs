{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Card where

import Data.Text (Text(..), unpack)
import Data.Monoid ((<>))

data Card = Card { title :: Text
                 , rules :: Text
                 , dominance :: Int
                 , cardType :: CardType
                 , subType :: Text
                 , gene1 :: Gene
                 , gene2 :: Gene
                 , startMatter :: Int
                 , startCards :: Int
                 , flavor :: Text
                 , designer :: Text
                 , illustration :: Text
                 } deriving (Show)

data CardType = Ting
              | Event
              | Biom
              | Mutation
              | Splicer
                deriving (Show, Read)

data Gene = Sinister
          | Artificial
          | Nautic
          | Leaf
          | Bug
          | Land
          | Feather
          | Small
          | Other Text
          | NoGene
            deriving (Show)

mkCard ::  Text -> Text -> Int -> Text -> Text -> Text -> Text -> Int -> Int -> Text -> Text -> Text -> Card
mkCard title rules dominance cardType subType gene1 gene2 startMatter startCards flavor designer illustration =
  case cardType of
  "Ting" -> mkTing title rules dominance subType gene1 gene2 flavor designer illustration
  "Event" -> mkEvent title rules subType flavor designer illustration
  "Biom" -> mkBiom title rules dominance subType flavor designer illustration
  "Mutation" -> mkMutation title rules subType flavor designer illustration
  "Splicer" -> mkSplicer title rules subType startMatter startCards flavor designer illustration
  _ -> error $ unpack ("Unknown card type '" <> cardType <> "'") 

textToGene :: Text -> Gene
textToGene geneText =
  case geneText of
  "Artificial" -> Artificial
  "Nautic" -> Nautic
  "Leaf" -> Leaf
  "Bug" -> Bug
  "Land" -> Land
  "Feather" -> Feather
  "Small" -> Small
  x -> Other x

mkTing title rules dominance subType gene1 gene2 flavor designer illustration =
  Card { title = title
       , rules = rules
       , dominance = dominance
       , cardType = Ting
       , subType = subType
       , gene1 = textToGene gene1
       , gene2 = textToGene gene2
       , startMatter = 0
       , startCards = 0
       , flavor = flavor
       , designer = designer
       , illustration = illustration
       }

mkEvent title rules subType flavor designer illustration =
  Card { title = title
       , rules = rules
       , dominance = 0
       , cardType = Event
       , subType = subType
       , gene1 = NoGene
       , gene2 = NoGene
       , startMatter = 0
       , startCards = 0
       , flavor = flavor
       , designer = designer
       , illustration = illustration
       }

mkBiom title rules domination subType flavor designer illustration =
  Card { title = title
       , rules = rules
       , dominance = 0
       , cardType = Biom
       , subType = subType
       , gene1 = NoGene
       , gene2 = NoGene
       , startMatter = 0
       , startCards = 0
       , flavor = flavor
       , designer = designer
       , illustration = illustration
       }

mkMutation title rules subType flavor designer illustration =
  Card { title = title
       , rules = rules
       , dominance = 0
       , cardType = Mutation
       , subType = subType
       , gene1 = NoGene
       , gene2 = NoGene
       , startMatter = 0
       , startCards = 0
       , flavor = flavor
       , designer = designer
       , illustration = illustration
       }

mkSplicer title rules subType startMatter startCards flavor designer illustration =
  Card { title = title
       , rules = rules
       , dominance = 0
       , cardType = Splicer
       , subType = subType
       , gene1 = NoGene
       , gene2 = NoGene
       , startMatter = startMatter
       , startCards = startCards
       , flavor = flavor
       , designer = designer
       , illustration = illustration
       }
