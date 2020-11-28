module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, text)
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
    div [ class "container p-10" ]
        [ h1 [ class "text-xl font-black" ] [ text "Counter" ]
        , button
            [ onClick Increment
            , class "py-2 px-4 bg-green-500 text-white rounded-lg"
            ]
            [ text "+1" ]
        , div [ class "py-10 px-4 bg-blue-500 text-white rounded-lg inline-block" ] [ text <| String.fromInt model.count ]
        , button
            [ onClick Decrement
            , class "py-2 px-4 bg-red-400 text-white rounded-lg"
            ]
            [ text "-1" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
