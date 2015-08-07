{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Rendering where

import Control.Monad (foldM, mapM_)
import Data.Text.Internal (Text)
import Data.Text (unpack, pack)
import Data.Monoid ((<>))
import Card
import Lucid

css :: Text -> Html ()
css name = link_ [rel_ "stylesheet", type_ "text/css", href_ name]

allCSS :: Html ()
allCSS = do (css "/files/styles.css")
            (css "/files/card.css")
            (css "http://fonts.googleapis.com/css?family=Karla:400,700,400italic,700italic")

renderPage :: Html () -> Html ()
renderPage body = do head_ $ allCSS
                     body_ $ body

renderFrontPage :: Html ()
renderFrontPage = renderPage $ do h1_ "Splicers"
                                  h2_ "An open source collectible card game"
                                  ul_ $ do
                                    li_ $ a_ [href_ "/cards"] "Cards"
                                    li_ $ a_ [href_ "/add-card"] "Add a card"

renderCards :: [Card] -> Html ()
renderCards cards = renderPage $ mapM_ renderCard cards

svg path = embed_ [src_ path, type_ "image/svg+xml"]

renderCard :: Card -> Html ()
renderCard card =
  case (cardType card) of
  Ting -> renderTing card
  Event -> renderEvent card
  Biom -> renderBiom card
  Mutation -> renderMutation card
  Splicer -> renderSplicer card

illustrationDiv :: Card -> Html ()
illustrationDiv card =
  div_ [class_ "illustration"] $ do
    img_ [src_ (illustration card)]

typesDiv :: Text -> Text -> Int -> Html ()
typesDiv cardType subType dominance = do
  div_ [class_ "types"] $ do
    div_ [class_ "dominance"] $ do
      span_ $ toHtml (show dominance)
    span_ $ toHtml $ cardType <> subPart
      where subPart = case subType of
              "" -> ""
              _ -> " - " <> subType

flavorText :: Card -> Html ()
flavorText card = p_ [class_ "flavor"] $ toHtml (flavor card)

renderTing :: Card -> Html ()
renderTing card = 
  do div_ [class_ "card ting"] $ do
       div_ [class_ "title"] $ toHtml (title card)
       div_ [class_ "cost"] $ do
         svg "/files/cost.svg"
         span_ $ toHtml (show (cost card))
       illustrationDiv card
       typesDiv "ting" (subType card) (dominance card)
       div_ [class_ "ability"] $ do
         with (svg "/files/gen_artificial.svg") [class_ "gene1"]
         with (svg "/files/gen_plant.svg") [class_ "gene1"]
         span_ $ toHtml (rules card)
         flavorText card 

renderEvent :: Card -> Html ()
renderEvent card = 
  do div_ [class_ "card event"] $ do
       div_ [class_ "title"] $ toHtml (title card)
       div_ [class_ "cost"] $ do
         svg "/files/cost.svg"
         span_ $ toHtml (show (cost card))
       illustrationDiv card
       typesDiv "event" (subType card) 0
       div_ [class_ "ability"] $ do
         span_ $ toHtml (rules card)
         flavorText card 

renderBiom :: Card -> Html ()
renderBiom card = 
  do div_ [class_ "card biom"] $ do
       div_ [class_ "title"] $ toHtml (title card)
       div_ [class_ "windom"] $ toHtml (show (dominance card))
       div_ [class_ "cost"] $ do
         svg "/files/cost.svg"
         span_ $ toHtml (show (cost card))
       illustrationDiv card
       typesDiv "biom" (subType card) 0
       div_ [class_ "ability"] $ do
         span_ $ toHtml (rules card)
         --flavorText card 

renderMutation :: Card -> Html ()
renderMutation card = 
  do div_ [class_ "card mutation"] $ do
       div_ [class_ "title"] $ toHtml (title card)
       illustrationDiv card
       typesDiv "mutation" (subType card) 0
       div_ [class_ "ability"] $ do
         span_ $ toHtml (rules card)
         flavorText card 

renderSplicer :: Card -> Html ()
renderSplicer card = 
  do div_ [class_ "card splicer"] $ do
       div_ [class_ "title"] $ toHtml (title card)
       div_ [class_ "cost"] $ do
         svg "/files/cost.svg"
         span_ $ toHtml (show (cost card))
       illustrationDiv card
       typesDiv "splicer" (subType card) 0
       div_ [class_ "matter"] $ do
         svg "/files/cost.svg"
         span_ $ toHtml (show (startMatter card))
       div_ [class_ "carddraw"] $ do
         svg "/files/carddraw.svg"
         span_ $ toHtml (show (startCards card))
       div_ [class_ "ability"] $ do
         span_ $ toHtml (rules card)
         flavorText card

field name helpText inputType defaultValue =
  div_ $ do span_ (toHtml name)
            input_ [ type_ inputType
                   , name_ name
                   , value_ defaultValue
                   ]
            span_ (toHtml helpText)

renderAddCard :: Html ()
renderAddCard =
  renderPage $ do
    form_ [action_ "submit-card"] $ do
      field "title" "" "text" ""
      field "rules" "" "text" ""
      field "domination" "" "number" "0"
      field "cost" "" "number" "0"
      field "cardType" " (Ting, Biom, Event, Mutation, Splicer)" "text" "Ting"
      field "subType" " (i.e. Animal, Plant...)" "text" ""
      field "gene1" "" "text" ""
      field "gene2" "" "text" ""
      field "startMatter" "" "number" "4"
      field "startCards" "" "number" "4"
      field "flavor" "" "text" ""
      field "designer" "" "text" ""
      field "illustration" " (URL)" "text" ""
      br_ []
      input_ [type_ "submit", value_ "Submit"]

renderSubmittedCard :: Text -> Html ()
renderSubmittedCard title =
  renderPage $ do
    p_ $ toHtml $ "The card " <> title <> " was added!"
    a_ [href_ "/cards"] "Cards"

renderAddFakeData :: Html ()
renderAddFakeData = do
  renderPage $ p_ "Added fake data!"

