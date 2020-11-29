module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h1, h2, h3, p, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)



-- MODEL


type alias Model =
    { new : List Int
    , total : List Int
    , deaths : List (Maybe Int)
    , hopsitalizations : List (Maybe Int)
    , intensivecare : List (Maybe Int)
    }



-- MAIN


initialModel : Model
initialModel =
    { new = [ 104, 300, 252, 360, 363, 392, 237, 172, 433, 362, 659, 246 ]
    , total = [ 24710, 24606, 24306, 24054, 23694 ]
    , deaths = [ Just 281, Just 281, Just 281, Just 281 ]
    , hopsitalizations = [ Just 312, Just 312, Just 309, Just 314, Just 312 ]
    , intensivecare = [ Just 79, Just 79, Just 79, Just 79, Just 88 ]
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }



-- UPDATE


type Msg
    = DataLoaded


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container p-2 md:p-4 mx-auto max-w-6xl" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4 pt-14" ] [ text "COVID-19 in Hamburg" ]
        , viewInfected model
        , viewHospitalizations model
        , viewDeaths model
        , viewSources
        ]


viewInfected : Model -> Html Msg
viewInfected model =
    let
        allInfected : String
        allInfected =
            case model.total of
                latest :: older ->
                    String.fromInt latest

                [] ->
                    ""

        lastSeven : Int
        lastSeven =
            List.sum <| List.take 7 model.new
    in
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-red-500 pb-1" ] [ text "New Infections" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-3 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewToday <| List.head model.new
            , viewWeek lastSeven
            , viewAll allInfected
            ]
        , p [ class "text-xs pt-1 pb-1" ]
            [ text "* The goverment will need to enact policies like lockdowns after this threshold." ]
        ]


viewToday : Maybe Int -> Html Msg
viewToday newCases =
    let
        latest =
            case newCases of
                Just value ->
                    String.fromInt value

                Nothing ->
                    ""
    in
    div []
        [ viewColumnHeadline "today"
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
            [ text latest ]
        ]


viewWeek : Int -> Html Msg
viewWeek lastSeven =
    div []
        [ viewColumnHeadline "seven days"
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40" ]
            [ span [ class "flex items-center" ] [ text <| String.fromInt lastSeven ]
            , span [ class "pl-3 font-thin flex items-center" ] [ text "/ 950*" ]
            ]
        ]


viewAll : String -> Html Msg
viewAll allInfected =
    div []
        [ viewColumnHeadline "total"
        , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40" ] [ text allInfected ]
        ]


viewColumnHeadline : String -> Html Msg
viewColumnHeadline headline =
    h3 [ class "tracking-widest" ] [ text headline ]


viewHospitalizations : Model -> Html Msg
viewHospitalizations model =
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-indigo-500 pb-1" ] [ text "Hospitalizations" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-2 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewIntensivecare 12
            , viewTotalHospitalizations 34
            ]
        ]


viewTotalHospitalizations : Int -> Html Msg
viewTotalHospitalizations total =
    div []
        [ viewColumnHeadline "total"
        , div [ class "bg-purple-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
            [ text "34" ]
        ]


viewIntensivecare : Int -> Html Msg
viewIntensivecare total =
    div []
        [ viewColumnHeadline "intensivecare"
        , div [ class "bg-pink-400 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
            [ text "34" ]
        ]


viewDeaths : Model -> Html Msg
viewDeaths model =
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-gray-500 pb-1" ] [ text "Deaths" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-1 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ div []
                [ viewColumnHeadline "total"
                , div [ class "bg-gray-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
                    [ text "34" ]
                ]
            ]
        ]


viewSources : Html Msg
viewSources =
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 text-black pb-1" ] [ text "Sources" ]
        , p []
            [ text "The source of the data for this dashboard is "
            , a [ class "font-extrabold", href "https://github.com/oem/Hamburg.jl" ] [ text "github.com/oem/Hamburg.jl" ]
            , text ", which in turn gathers the data from the RKI and Hamburg.de. See the github page for more detailed information on the data sources."
            ]
        ]
