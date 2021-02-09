module Pages.Weather exposing (Model, Msg, Params, page)

import Api
import Api.Weather.Listing exposing (Listing)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { listings : Api.Data (List Listing)
    }


init : Url Params -> ( Model, Cmd Msg )
init url =
    ( Model Api.Loading
    , Api.Weather.Listing.badung
        { onResponse = GotHotListings
        }
    )



-- UPDATE


type Msg
    = GotHotListings (Api.Data (List Listing))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotHotListings data ->
            ( { model | listings = data }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Posts"
    , body =
        [ div [ class "page" ]
            [ viewListings model.listings
            ]
        ]
    }


viewListings : Api.Data (List Listing) -> Html msg
viewListings data =
    case data of
        Api.NotAsked ->
            text "Not asked"

        Api.Loading ->
            text "Loading..."

        Api.Failure _ ->
            text "Something went wrong..."

        Api.Success listings ->
            div [ class "listings" ]
                (List.map viewListing listings)


viewListing : Listing -> Html msg
viewListing listing =
    div [ class "listing" ]
        [ a [ class "title", href "#" ]
            [ text ("Main Weather: " ++ listing.main) ]
        , p [ class "author" ]
            [ text ("Weather Now: " ++ listing.description) ]
        , p [ class "author" ]
            [ text ("Weather Now: " ++ listing.name) ]
        ]
