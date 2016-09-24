module DeepSky exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Http.Decorators as HttpDecorators

main = 
  App.program
    { init = init "WAITING"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { forecast : String
  }

init : String -> (Model, Cmd Msg)
init forecast =
  (Model forecast, Cmd.none)

type Msg
  = Pull
  | FetchSucceed Http.Response
  | FetchFail Http.RawError

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Pull ->
      (model, getForecast "location")

    FetchSucceed newUrl ->
      (Model model.forecast, Cmd.none)

    FetchFail _ ->
      (Model "", Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model = 
  div []
  [ h1 [] [ text "HI PAUL HOW ARE YOU DOING" ]
  , button [ onClick Pull ] [ text "Pull Forecast" ]
  , div [] [ text model.forecast ]
  ]

getForecast : String -> Cmd Msg
getForecast location =
  let
    url = 
     "http://kyletcreasey.me/example.json"
  in
    Http.fromJson (Json) Task.Task FetchFail decodeForecast (getURL "http://kyletcreasey.me/" url))

getURL : String -> String -> Task.Task Http.RawError Http.Response
getURL origin url =
  Http.send Http.defaultSettings 
    { verb = "GET"
    , headers = [("Access-Control-Allow-Origin", origin)
                ]
    , url = url
    , body = Http.empty
    }

corsPost : Http.Request
corsPost =
    { verb = "POST"
    , headers =
        [ ("Origin", "http://lightningjim.duckdns.org")
        , ("Access-Control-Request-Method", "POST")
        , ("Access-Control-Request-Headers", "X-Custom-Header")
        ]
    , url = "http://kyletcreasey.me/example.json"
    , body = Http.empty
    }

--decodeForecast : Http.Request -> Cmd Msg
--decodeForecast = 
-- http
