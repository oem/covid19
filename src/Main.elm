module Main exposing (main)

import Browser
import Html exposing (Html, a, button, div, h1, h2, h3, p, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, maybe, string)
import Json.Decode.Pipeline exposing (required)



-- MAIN


initialModel : Model
initialModel =
    { status = Loading
    , dataset = { new = [], total = [], deaths = [], hospitalizations = [], intensivecare = [] }
    }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Status
    = Loading
    | Errored
    | Loaded



-- MODEL


type alias Model =
    { status : Status
    , dataset : Dataset
    }


type alias Dataset =
    { new : List Int
    , total : List Int
    , deaths : List (Maybe Int)
    , hospitalizations : List (Maybe Int)
    , intensivecare : List (Maybe Int)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , fetchInfected
    )



-- UPDATE


type Msg
    = GotData (Result Http.Error Dataset)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotData result ->
            case result of
                Ok data ->
                    ( { model | status = Loaded, dataset = data }, Cmd.none )

                Err _ ->
                    ( { model | status = Errored }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container p-4 md:p-6 mx-auto max-w-6xl" ]
        [ h1 [ class "text-3xl font-black tracking-tight pb-4 pt-14" ] [ text "COVID-19 in Hamburg" ]
        , div [] <|
            case model.status of
                Loaded ->
                    [ viewInfected model
                    , viewHospitalizations model
                    , viewDeaths model.dataset.deaths
                    , viewSources
                    ]

                Loading ->
                    [ text "Loading data..." ]

                Errored ->
                    viewErrored
        ]


type Cell
    = Today (Maybe Int)
    | SevenDays Int
    | Hospitalizations (Maybe Int)
    | Intensivecare (Maybe Int)


severityClass : Cell -> String
severityClass cell =
    let
        normalized =
            case cell of
                Today Nothing ->
                    0

                Today (Just value) ->
                    toFloat value / 180

                SevenDays value ->
                    toFloat value / 950

                Intensivecare Nothing ->
                    0

                Intensivecare (Just value) ->
                    toFloat value / 80

                Hospitalizations Nothing ->
                    0

                Hospitalizations (Just value) ->
                    toFloat value / 650

        severity =
            if normalized > 1 then
                "bg-gradient-to-b from-red-600 to-red-500"

            else if normalized > 0.9 then
                "bg-red-500"

            else if normalized > 0.5 then
                "bg-red-400"

            else if normalized > 0.2 then
                "bg-purple-500"

            else
                "bg-gray-300"
    in
    severity


viewErrored : List (Html Msg)
viewErrored =
    [ p [] [ text "Sorry, I was unable to load the data." ]
    , p [] [ text "It is likely a connectivity issue, but there might also be a chance that the data is currently not available." ]
    , p []
        [ text "If you would like to check for yourself, I am trying to fetch the data from "
        , a [ class "font-bold", href dataUrl ] [ text "github.com/oem/Hamburg.jl" ]
        , text "."
        ]
    ]


viewInfected : Model -> Html Msg
viewInfected model =
    let
        allInfected : String
        allInfected =
            case model.dataset.total of
                newest :: older ->
                    String.fromInt newest

                [] ->
                    ""

        lastSeven : Int
        lastSeven =
            List.sum <| List.take 7 model.dataset.new
    in
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 pb-1" ] [ text "New Infections" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-3 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewToday <| List.head model.dataset.new
            , viewWeek lastSeven
            , viewAll allInfected
            ]
        , p [ class "text-xs pt-1 pb-1" ]
            [ text "* The goverment will consider restrictive policies after this threshold." ]
        ]


viewToday : Maybe Int -> Html Msg
viewToday newCases =
    let
        latest : Int
        latest =
            case newCases of
                Just value ->
                    value

                Nothing ->
                    0

        severity : String
        severity =
            severityClass (Today newCases)
    in
    div []
        [ viewColumnHeadline "today"
        , div [ class (severity ++ " text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40") ]
            [ text (String.fromInt latest) ]
        ]


viewWeek : Int -> Html Msg
viewWeek lastSeven =
    let
        severity : String
        severity =
            severityClass (SevenDays lastSeven)
    in
    div []
        [ viewColumnHeadline "seven days"
        , div [ class (severity ++ " text-center text-4xl text-white flex items-center justify-center font-black rounded-lg h-40") ]
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
    h3 [ class "tracking-tight" ] [ text headline ]


getLatestMaybe : List (Maybe Int) -> Maybe Int
getLatestMaybe list =
    case List.head list of
        Just head ->
            head

        Nothing ->
            Nothing


viewHospitalizations : Model -> Html Msg
viewHospitalizations model =
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 pb-1" ] [ text "Hospitalizations" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-2 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ viewIntensivecare (getLatestMaybe model.dataset.intensivecare)
            , viewTotalHospitalizations (getLatestMaybe model.dataset.hospitalizations)
            ]
        ]


viewTotalHospitalizations : Maybe Int -> Html Msg
viewTotalHospitalizations total =
    let
        amount : String
        amount =
            case total of
                Nothing ->
                    ""

                Just value ->
                    String.fromInt value

        severity : String
        severity =
            severityClass (Hospitalizations total)
    in
    div []
        [ viewColumnHeadline "total"
        , div [ class (severity ++ " text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40") ]
            [ text amount ]
        ]


viewIntensivecare : Maybe Int -> Html Msg
viewIntensivecare total =
    let
        amount : String
        amount =
            case total of
                Nothing ->
                    ""

                Just value ->
                    String.fromInt value

        severity : String
        severity =
            severityClass (Intensivecare total)
    in
    div []
        [ viewColumnHeadline "intensivecare"
        , div [ class (severity ++ " text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40") ]
            [ text amount ]
        ]


viewDeaths : List (Maybe Int) -> Html Msg
viewDeaths deaths =
    let
        total : Int
        total =
            case getLatestMaybe deaths of
                Just value ->
                    value

                Nothing ->
                    0
    in
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 pb-1" ] [ text "Deaths" ]
        , div
            [ class "grid grid-cols-1 md:grid-cols-1 gap-4 place-content-center font-bold uppercase text-3xl md:text-2xl" ]
            [ div []
                [ viewColumnHeadline "total"
                , div [ class "bg-red-500 text-center text-4xl text-white flex items-center justify-center font-black rounded-lg p-16 h-40" ]
                    [ text (String.fromInt total) ]
                ]
            ]
        ]


viewSources : Html Msg
viewSources =
    div [ class "pb-8" ]
        [ h2 [ class "text-2xl font-extrabold tracking-tight sm:text-4x1 pb-1" ] [ text "Sources" ]
        , p []
            [ text "The source of the data for this dashboard is "
            , a [ class "font-extrabold", href "https://github.com/oem/Hamburg.jl" ] [ text "github.com/oem/Hamburg.jl" ]
            , text ", which in turn gathers its data from the "
            , a [ class "font-extrabold", href "https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/Gesamt.html" ] [ text "Robert Koch Institut" ]
            , text " and "
            , a [ class "font-extrabold", href "https://www.hamburg.de/corona-zahlen" ] [ text "hamburg.de" ]
            , text "."
            ]
        ]



-- HTTP


dataUrl : String
dataUrl =
    "https://raw.githubusercontent.com/oem/Hamburg.jl/main/src/covid-19/infected.json"


fetchInfected : Cmd Msg
fetchInfected =
    Http.get
        { url = dataUrl
        , expect = Http.expectJson GotData datasetDecoder
        }


datasetDecoder : Decoder Dataset
datasetDecoder =
    Decode.succeed Dataset
        |> required "new" (list int)
        |> required "total" (list int)
        |> required "deaths" (list (maybe int))
        |> required "hospitalizations" (list (maybe int))
        |> required "intensivecare" (list (maybe int))
