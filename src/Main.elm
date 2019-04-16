module Main exposing (Flags, Model, Msg, init, main, subscriptions, update, view)

import Browser
import Html.Styled exposing (div)
-- import Html.Styled.Attributes exposing (..)
import Random
import Visualization exposing (visualization)

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


type alias Model = ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( ()
    , Cmd.none
    )



-- Update


type alias Msg = ()


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Browser.Document Msg
view _ =
    { title = "Elm Svg Test"
    , body =
        [ Html.Styled.toUnstyled
            (div [] [ visualization ])
        ]
    }
