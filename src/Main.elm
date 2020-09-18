module Main exposing (main)

{- Generate Project Names
   Tasks Remaining
   [x] Set up Layout
       [ ] View to show name
       [x] Button to generate

   [ ] Import adjective list
   [ ] Import noun list
   [ ] Get random seed
   [ ] Generate simple 2-piece name
   [ ] Generate multiple-word name
   [ ] Generate alliterative name
-}

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input



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
                    ]
                ]
        ]
    }


titleView : Element Message
titleView =
    row
        [ width fill
        , padding 20
        , Border.color (rgb 0 0 0)
        , Border.width 1
        ]
        [ el [ centerX ] <| text "Generate Project Name"
        , el [ alignRight ] <| link [] { url = "https://github.com/coreyhaines/", label = text "github" }
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
        , buttonView GenerateName "Generate"
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
    = GenerateName



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )



-- MAIN


main : Program {} Model Message
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
