module Main exposing (main)

{- Generate Project Names
      Tasks Remaining
      [x] Set up Layout
          [ ] View to show name
          [x] Button to generate

      [x] Import adjective list
      [x] Import noun list
      [x] Generate simple 2-piece name
      [ ] Generate multiple-word name
      [ ] Generate alliterative name

   Nouns and Adjectives list taken from
   https://github.com/aceakash/project-name-generator
-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import GeneratesProjectNames



-- MODEL


type alias Model =
    { generatedName : Maybe String
    }



-- INIT


init : {} -> ( Model, Cmd Message )
init _ =
    ( { generatedName = Nothing }
    , Cmd.none
    )



-- VIEW


view : Model -> Browser.Document Message
view model =
    { title = "Generate Project Name"
    , body =
        [ layout [] <|
            column [ height fill, width fill ] <|
                [ titleView
                , row [ height fill, width fill ]
                    [ menuView model
                    , generatedNameView model
                    ]
                ]
        ]
    }


generatedNameView : Model -> Element Message
generatedNameView model =
    el [ centerX, centerY, Font.size 48 ] (text <| Maybe.withDefault "NO NAME GENERATED" model.generatedName)


titleView : Element Message
titleView =
    row
        [ width fill
        , padding 20
        , Border.color (rgb 0 0 0)
        , Border.width 1
        ]
        [ el [ centerX ] <| text "Generate Project Name"
        , el [ alignRight ] <| link [] { url = "https://github.com/coreyhaines/generate-project-name", label = text "github" }
        ]


menuView : Model -> Element Message
menuView _ =
    column
        [ height fill
        , Border.color (rgb 0 0 0)
        , Border.width 1
        , padding 20
        , spacing 10
        ]
        [ text "Things We Can Do"
        , buttonView UserClickedGenerateNameButton "Generate"
        ]


buttonView : Message -> String -> Element Message
buttonView onPress label =
    Input.button
        [ padding 20
        , Border.width 2
        , Border.rounded 16
        , Border.color <| rgb255 0x50 0x50 0x50
        , Border.shadow { offset = ( 4, 4 ), size = 3, blur = 10, color = rgb255 0xD0 0xD0 0xD0 }
        , Background.color <| rgb255 114 159 207
        , Font.color <| rgb255 0xFF 0xFF 0xFF
        , mouseOver
            [ Background.color <| rgb255 0xFF 0xFF 0xFF, Font.color <| rgb255 0 0 0 ]
        , focused
            [ Border.shadow { offset = ( 4, 4 ), size = 3, blur = 10, color = rgb255 114 159 207 } ]
        , centerX
        ]
        { onPress = Just onPress
        , label = text label
        }



-- MESSAGE


type Message
    = UserClickedGenerateNameButton
    | NameGenerated String



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        UserClickedGenerateNameButton ->
            ( { model
                | generatedName = Nothing
              }
            , GeneratesProjectNames.randomName NameGenerated
            )

        NameGenerated name ->
            ( { model
                | generatedName = Just name
              }
            , Cmd.none
            )



-- MAIN


main : Program {} Model Message
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
