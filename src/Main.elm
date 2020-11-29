module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, h2, h3, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { new : List Int
    , total : List Int
    }


type Msg
    = Increment
    | Decrement



-- INIT


initialModel : Model
initialModel =
    { new = [ 104, 300, 252, 360, 363, 392, 237, 172, 433, 362, 659, 246 ]
    , total = [ 24710, 24606, 24306, 24054, 23694 ]
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model

        Decrement ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    let
        allInfected : String
        allInfected =
            case model.total of
                latest :: older ->
                    String.fromInt latest

                [] ->
                    ""
    in
    div [ class "container p-2 md:p-4 mx-auto max-w-6xl" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4 pt-14" ] [ text "Covid19 in Hamburg" ]
        , h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-red-500 pb-1" ] [ text "New Infections" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-3 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewToday 356
            , viewWeek 1156
            , viewAll allInfected
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


viewAll : String -> Html Msg
viewAll allInfected =
    div []
        [ h3 [ class "tracking-widest" ] [ text "total" ]
        , div [ class "bg-gray-300 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40" ]
            [ text allInfected ]
        ]
