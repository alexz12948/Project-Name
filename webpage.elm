import Browser
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Decoder, map4, at, string, int, bool)
import Dict



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



-- MODEL


type Model
  = Failure
  | Loading
  | Success String

type alias Bike =
  { number : Int
  , last_user : String
  , checkout_time : Int
  , needs_maintenance : Bool
  }


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getBikeData)



-- UPDATE


type Msg
  = GotData (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotData result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Shrek is God" ]
    , viewData model
    ]


viewData : Model -> Html Msg
viewData model =
  case model of
    Failure ->
      div []
        [ text "I could not load a bike for some reason. "
        ]

    Loading ->
      text "Loading..."

    Success url ->
      text "a bike"


-- HTTP


getBikeData : Cmd Msg
getBikeData =
  Http.get
    { url = "http://127.0.0.1:5000/"
    , expect = Http.expectJson GotData dataDecoder
    }


dataDecoder : Decoder String
dataDecoder =
  at ["id"] string

decodeBike : Decoder Bike
decodeBike =
  map4 Bike
    (at ["number"] int)
    (at ["last_user"] string)
    (at ["checkout_time"] int)
    (at ["needs_maintenance"] bool)




subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none