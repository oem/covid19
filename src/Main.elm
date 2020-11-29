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
    div [ class "container p-2 md:p-4 mx-auto max-w-6xl" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4 pt-14" ] [ text "Covid19 in Hamburg" ]
        , h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-red-500 pb-1" ] [ text "New Infections" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-3 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewToday 356
            , viewWeek 1156
            , viewAll 112872
            ]
        ]


viewToday : Int -> Html Msg
viewToday newCases =
    div []
        [ h3 [ class "tracking-widest" ] [ text "Today" ]
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
            [ text <| String.fromInt newCases ]
        ]


viewWeek : Int -> Html Msg
viewWeek newCases =
    div []
        [ h3 [ class "tracking-widest" ] [ text "seven days" ]
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40" ]
            [ span [ class "flex items-center" ]
                [ text <| String.fromInt newCases ]
            , span [ class "pl-3 font-thin flex items-center" ]
                [ text "/ 950" ]
            ]
        ]


viewAll : Int -> Html Msg
viewAll newCases =
    div []
        [ h3 [ class "tracking-widest" ] [ text "total" ]
        , div [ class "bg-gray-300 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40" ]
            [ text <| String.fromInt newCases ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
