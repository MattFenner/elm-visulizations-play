module Main exposing (Flags, Model, Msg, init, main, subscriptions, update, view)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Visualization exposing (..)

type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { content : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { content = "hello world"
      }
    , Cmd.none
    )



-- Update


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Svg Test"
    , body =
        [ Html.Styled.toUnstyled
            (div [] [ visualization ])
        ]
    }
