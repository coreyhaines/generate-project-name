module Main exposing (main)

{- Generate Project Names
   Tasks Remaining
   [x] Set up Layout
       [x] View to show name
       [x] Button to generate

   [x] Import adjective list
   [x] Import noun list
   [x] Generate simple 2-piece name
   [x] Generate multiple-word name
   [ ] Generate alliterative name

   [ ] Choose style
       [ ] PascalCase
       [ ] Text delimiter (default -)
       [ ] camelCase
   [ ] Generate with different style
       [ ] PascalCase
       [ ] Text delimiter (default -)
       [ ] camelCase
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
    { nameLength : Int
    , desiredCasingType : GeneratesProjectNames.CasingType
    , generatedNameData : Maybe GeneratesProjectNames.GeneratedName
    }



-- INIT


defaultWordLength : Int
defaultWordLength =
    2


init : {} -> ( Model, Cmd Message )
init _ =
    ( { nameLength = defaultWordLength
      , desiredCasingType = GeneratesProjectNames.defaultCasingType
      , generatedNameData = Nothing
      }
    , GeneratesProjectNames.randomNameData defaultWordLength NameDataGenerated
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
    let
        name =
            model.generatedNameData
                |> Maybe.map (GeneratesProjectNames.applyCasing model.desiredCasingType)
                |> Maybe.withDefault "Not Generated Yet"
    in
    el [ centerX, centerY, Font.size 48 ] (text name)


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
menuView model =
    let
        parseWordLengthInput newLength =
            if String.length newLength == 0 then
                UserChangedLength 0

            else
                newLength
                    |> String.toInt
                    |> Maybe.withDefault model.nameLength
                    |> UserChangedLength

        displayWordLengthInput nameLength =
            if nameLength == 0 then
                ""

            else
                String.fromInt nameLength

        generateNameButton =
            if model.nameLength > 0 then
                buttonView UserClickedGenerateNameButton "Generate"

            else
                Element.none
    in
    column
        [ height fill
        , Border.color (rgb 0 0 0)
        , Border.width 1
        , padding 20
        , spacing 10
        ]
        [ Input.text []
            { onChange = parseWordLengthInput
            , text = displayWordLengthInput model.nameLength
            , placeholder = Nothing
            , label = Input.labelAbove [] (text "Word Length")
            }
        , delimiterChoiceView model
        , generateNameButton
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


delimiterChoiceView : Model -> Element Message
delimiterChoiceView model =
    Input.radio
        [ padding 5, spacing 10 ]
        { onChange = CasingTypeChosen
        , selected = Just model.desiredCasingType
        , label = Input.labelAbove [] (text "Casing Type")
        , options =
            [ Input.option GeneratesProjectNames.KebabCase (text "kebab-case")
            , Input.option GeneratesProjectNames.SnakeCase (text "snake_case")
            , Input.option GeneratesProjectNames.CamelCase (text "camelCase")
            , Input.option GeneratesProjectNames.PascalCase (text "PascalCase")
            ]
        }



-- MESSAGE


type Message
    = UserClickedGenerateNameButton
    | NameDataGenerated GeneratesProjectNames.GeneratedName
    | UserChangedLength Int
    | CasingTypeChosen GeneratesProjectNames.CasingType



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        UserClickedGenerateNameButton ->
            ( { model
                | generatedNameData = Nothing
              }
            , GeneratesProjectNames.randomNameData model.nameLength NameDataGenerated
            )

        NameDataGenerated nameData ->
            ( { model
                | generatedNameData = Just nameData
              }
            , Cmd.none
            )

        UserChangedLength newLength ->
            ( { model
                | nameLength = newLength
              }
            , Cmd.none
            )

        CasingTypeChosen newCasingType ->
            ( { model
                | desiredCasingType = newCasingType
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
