module Main exposing (Model, Msg(..), init, main, subscriptions, update, view, viewLink)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- CONSTS


assetPrefix =
    "/littlemakings/assets/"



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


type alias Page =
    { title : String
    , url : String
    , view : Model -> List (Html Msg)
    }


pages : List Page
pages =
    [ { title = "Home", url = "/main", view = viewHome }
    , { title = "Bows", url = "/bows", view = viewBows }
    , { title = "Canvas", url = "/canvas", view = viewCanvas }
    , { title = "Signs", url = "/signs", view = viewSigns }
    ]


view : Model -> Browser.Document Msg
view model =
    { title = "littlemakings"
    , body =
        let
            viewPage =
                pages
                    |> List.filter (\page -> page.url == model.url.path)
                    |> List.head
                    |> Maybe.map .view
                    |> Maybe.withDefault viewHome
        in
        viewPage model
    }


viewHome : Model -> List (Html Msg)
viewHome model =
    [ viewHeader model
    , viewFullLogoBanner
    , viewBanner (assetPrefix ++ "bow.webp") "Bows" "/bows"
    , viewBanner (assetPrefix ++ "canvas.webp") "Canvas" "/canvas"
    , viewBanner (assetPrefix ++ "sign.webp") "Signs" "/signs"
    ]


viewBows : Model -> List (Html Msg)
viewBows model =
    [ viewHeader model
    , viewGallery
        [ assetPrefix ++ "bow1.webp"
        , assetPrefix ++ "bow2.webp"
        , assetPrefix ++ "bow3.webp"
        , assetPrefix ++ "bow4.webp"
        , assetPrefix ++ "bow6.webp"
        , assetPrefix ++ "bow7.webp"
        , assetPrefix ++ "bow8.webp"
        , assetPrefix ++ "bow9.webp"
        , assetPrefix ++ "bow10.webp"
        , assetPrefix ++ "bow11.webp"
        , assetPrefix ++ "bow12.webp"
        , assetPrefix ++ "bow13.webp"
        , assetPrefix ++ "bow14.webp"
        ]
    ]


viewCanvas : Model -> List (Html Msg)
viewCanvas model =
    [ viewHeader model
    , viewGallery
        [ assetPrefix ++ "canvas1.webp"
        , assetPrefix ++ "canvas2.webp"
        , assetPrefix ++ "canvas3.webp"
        , assetPrefix ++ "canvas4.webp"
        , assetPrefix ++ "canvas5.webp"
        ]
    ]


viewSigns : Model -> List (Html Msg)
viewSigns model =
    [ viewHeader model
    , viewGallery
        [ assetPrefix ++ "sign1.webp"
        , assetPrefix ++ "sign2.webp"
        , assetPrefix ++ "sign3.webp"
        , assetPrefix ++ "sign4.webp"
        ]
    ]


viewGallery : List String -> Html Msg
viewGallery urls =
    div []
        (urls
            |> List.map (\url -> img [ src url, style "height" "300px", style "width" "300px" ] [])
        )


viewHeader : Model -> Html Msg
viewHeader model =
    div
        [ style "background-color" "rgb(227, 179, 202)"
        , style "height" "1in"
        , style "display" "flex"
        , style "align-items" "center"
        , style "padding" "0 30px"
        ]
        [ viewLogo
        , headerIcon model (assetPrefix ++ "bow.svg") "/bows"
        , headerIcon model (assetPrefix ++ "canvas.svg") "/canvas"
        , headerIcon model (assetPrefix ++ "sign.svg") "/signs"
        ]


viewLogo =
    a
        [ style "padding-right" "30px"
        , style "cursor" "pointer"
        , href "/home"
        , style "text-decoration" "none"
        , style "color" "black"
        , style "font" "normal normal normal 1.4em cookie,cursive"
        ]
        [ text "littlemakings" ]


headerIcon model url link =
    a
        [ style "text-decoration" "none"
        , style "color" "black"
        , style "cursor" "pointer"
        , href link
        , style "border-bottom"
            (if onPage model link then
                "1px solid #555"

             else
                "0"
            )
        , style "border-radius" "1px"
        ]
        [ img
            [ src url
            , style "height" "40px"
            , style "width" "40px"
            , style "padding" "0px 20px"
            ]
            []
        ]


onPage model link =
    model.url.path == link


viewFullLogoBanner =
    -- , viewBanner "/assets/car.mp4" "" ""
    div
        [ style "width" "100vw"
        , style "height" "60vh"
        , style "opacity" "0.6"
        , style "overflow" "hidden"
        , style "position" "relative"
        ]
        [ video
            [ autoplay True
            , attribute "muted" "true"

            -- , attribute "loop" "true"
            , id "car"
            , style "height" "100%"
            , style "position" "absolute"

            -- , style "top" "-100px"
            ]
            [ source [ src (assetPrefix ++ "car.mp4") ] [] ]
        , div
            [ style "position" "absolute"
            , style "top" "50%"
            , style "left" "50%"
            , style "background-color" "rgba(0,0,0,0.4)"
            , style "height" "100%"
            , style "width" "100%"
            , style "font" "6rem cookie, cursive"
            , style "color" "rgb(227, 179, 202)"
            , style "transform" "translate(-50%, -50%)"
            , style "display" "flex"
            , style "align-items" "center"
            , style "justify-content" "center"
            ]
            [ span [] [ text "littlemakings" ] ]
        ]


viewBanner url title pageUrl =
    a
        [ style "background" ("linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5))," ++ "url('" ++ url ++ "')")
        , style "width" "100vw"
        , style "height" "100vh"
        , style "background-position" "center"
        , style "background-repeat" "no-repeat"
        , style "background-size" "cover"
        , style "text-align" "center"
        , style "cursor" "pointer"
        , style "display" "block"
        , style "opacity" "0.6"
        , href pageUrl
        ]
        [ h2
            [ style "color" "white"
            , style "font-size" "15rem"
            , style "position" "absolute"
            , style "width" "100%"
            , style "text-align" "center"
            ]
            [ text title ]
        ]


viewProfile : Model -> List (Html Msg)
viewProfile model =
    [ h1 [] [ text "Profile" ]
    ]


viewLink : Page -> Html msg
viewLink page =
    li [] [ a [ href page.url ] [ text page.title ] ]
