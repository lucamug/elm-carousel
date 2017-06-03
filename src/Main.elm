port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Json.Encode exposing (Value)


port urlChange : String -> Cmd msg


type alias Model =
    { history : List Navigation.Location
    }


type Msg
    = UrlChange Navigation.Location


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [] }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , (urlChange location.hash)
            )


view : Model -> Html Msg
view model =
    let
        currenthash =
            currentHash (List.head model.history)
    in
        div [ style [ ( "background-color", "#444" ) ] ]
            [ div
                [ style
                    [ ( "position", "fixed" )
                    , ( "background-color", "#444" )
                    , ( "color", "white" )
                    , ( "opacity", "0.5" )
                    , ( "top", "0" )
                    ]
                ]
                [ div
                    []
                    [ ul []
                        (List.map viewLink
                            [ "top"
                            , "carousel"
                            , "post"
                            , "comment"
                            ]
                        )
                    ]
                ]
            , if currenthash == "#carousel" then
                div []
                    [ h1 [] [ text "Carousel" ]
                    , div [ class "carousel" ]
                        [ div [ class "carousel-cell" ]
                            []
                        , div [ class "carousel-cell" ]
                            []
                        , div [ class "carousel-cell" ]
                            []
                        , div [ class "carousel-cell" ]
                            []
                        , div [ class "carousel-cell" ]
                            []
                        ]
                    ]
              else if currenthash == "#top" then
                h1 [] [ text "Top" ]
              else if currenthash == "#post" then
                h1 [] [ text "Post" ]
              else if currenthash == "#comment" then
                h1 [] [ text "Comment" ]
              else
                div [] []
            ]


currentHash : Maybe Navigation.Location -> String
currentHash currentPage =
    case currentPage of
        Just location ->
            location.hash

        Nothing ->
            ""


viewLink : String -> Html msg
viewLink name =
    li
        [ style
            [ ( "display", "inline-block" )
            , ( "padding", "0 10px" )
            ]
        ]
        [ a
            [ href ("#" ++ name)
            , style [ ( "color", "inherit" ) ]
            ]
            [ text name ]
        ]


viewLocation : Navigation.Location -> Html msg
viewLocation location =
    li [] [ text (location.pathname ++ location.hash) ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
