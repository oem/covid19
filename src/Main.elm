module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, h3, span, text)
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
    div [ class "container p-10 mx-auto dark:text-white" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4" ] [ text "Covid19 in Hamburg" ]
        , h2 [ class "text-3xl font-extrabold tracking-tight sm:text-4x1 text-red-500 pb-1" ] [ text "New Infections" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-3 gap-4 uppercase text-2xl md:text-xl" ]
            [ viewInfected "today"
            , viewInfected "last seven days"
            , viewInfected "since outbreak"
            ]
        ]


viewInfected : String -> Html Msg
viewInfected headline =
    div []
        [ h3 [] [ text headline ]
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16" ] [ text "+356" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
