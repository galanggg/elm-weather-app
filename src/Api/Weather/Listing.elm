module Api.Weather.Listing exposing (Listing, badung)

import Api
import Http
import Json.Decode exposing (Decoder, field, list, map3, string)


type alias Listing =
    { main : String
    , description : String
    , name : String
    }


decoder : Decoder Listing
decoder =
    map3 Listing
        (field
            "weather"
            (field "main" string)
        )
        (field
            "weather"
            (field "description" string)
        )
        (field "name" string)



-- (Json.field "name" Json.string)


badung : { onResponse : Api.Data (List Listing) -> msg } -> Cmd msg
badung =
    listings "badung"


listings : String -> { onResponse : Api.Data (List Listing) -> msg } -> Cmd msg
listings endpoint options =
    Http.get
        { url = "http://api.openweathermap.org/data/2.5/weather?q=" ++ endpoint ++ "&appid=6bad1ff8c1506b923695e8993dbc9858"
        , expect =
            Api.expectJson options.onResponse (list decoder)
        }
