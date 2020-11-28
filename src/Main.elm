module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


view : Model -> Html Msg
view model =
    div [ class "container p-10 dark:text-white" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4" ] [ text "Covid19 in Hamburg" ]
        , h2 [ class "text-3x1 font-extrabold tracking-tight sm:text-4x1 text-indigo-600" ] [ text "New Infections" ]
        , h2 [ class "text-3x1 text-gray-600 font-light tracking-tight sm:text-4x1" ] [ text "Today" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
