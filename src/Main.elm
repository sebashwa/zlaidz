module Main exposing (..)

import Array
import Browser
import Data exposing (Language(..), slides)
import DomainTypes exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, disabled)
import Html.Styled.Events exposing (onClick)
import Styling exposing (..)
import SyntaxHighlight



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view >> toUnstyled }



-- MODEL


type alias Model =
    { slides : Slides
    , positions : Positions
    }


init : Model
init =
    { slides = slides En
    , positions = Positions 0 0
    }



-- UPDATE


type Msg
    = Forwards
    | Backwards
    | GotoSlide Int


itemsAt : Int -> Slides -> Items
itemsAt position slides =
    case Array.fromList slides |> Array.get position of
        Just slide ->
            slide.items

        Nothing ->
            []


forwardsPositions : Positions -> Slides -> Positions
forwardsPositions positions slides =
    let
        currentSlideItems =
            slides |> itemsAt positions.slide
    in
    if positions.item < List.length currentSlideItems - 1 then
        Positions positions.slide (positions.item + 1)

    else if positions.slide < List.length slides - 1 then
        Positions (positions.slide + 1) 0

    else
        positions


backwardsPostions : Positions -> Slides -> Positions
backwardsPostions positions slides =
    if positions.item > 0 then
        Positions positions.slide (positions.item - 1)

    else if positions.slide > 0 then
        let
            previousSlideItems =
                slides |> itemsAt (positions.slide - 1)
        in
        Positions (positions.slide - 1) (List.length previousSlideItems - 1)

    else
        positions


update : Msg -> Model -> Model
update msg model =
    case msg of
        Forwards ->
            { model | positions = forwardsPositions model.positions model.slides }

        Backwards ->
            { model | positions = backwardsPostions model.positions model.slides }

        GotoSlide position ->
            let
                maxSlidePosition =
                    List.length model.slides - 1
            in
            { model | positions = { item = 0, slide = clamp 0 maxSlidePosition position } }



-- VIEW


syntaxHighlight : String -> List (Html Msg)
syntaxHighlight string =
    [ SyntaxHighlight.useTheme SyntaxHighlight.monokai |> fromUnstyled
    , SyntaxHighlight.elm string
        |> Result.map (SyntaxHighlight.toBlockHtml (Just 1) >> fromUnstyled)
        |> Result.withDefault (pre [] [ code [] [ text string ] ])
    ]


viewItem : Bool -> Item -> Html Msg
viewItem isActive item =
    case item of
        Paragraph string ->
            p [ css [ itemCss isActive, paragraphCss ] ] [ text string ]

        CodeBlock string ->
            div [ css [ itemCss isActive ] ] (syntaxHighlight string)


viewItems : Positions -> Int -> Items -> List (Html Msg)
viewItems positions index items =
    if positions.slide == index then
        (items |> List.take (positions.item + 1) |> List.map (viewItem True))
            ++ (items |> List.drop (positions.item + 1) |> List.map (viewItem False))

    else if index == (positions.slide - 1) then
        items |> List.map (viewItem False)

    else
        []


viewSlide : Positions -> Int -> Slide -> Html Msg
viewSlide positions index slide =
    let
        onlyTitle =
            List.length slide.items == 0
    in
    section [ css [ slideCss onlyTitle index positions.slide ] ]
        [ h1 [ css [ titleCss ] ] [ text slide.title ]
        , div [ css [ itemsCss ] ] (viewItems positions index slide.items)
        ]


viewSlides : Model -> List (Html Msg)
viewSlides model =
    List.indexedMap (viewSlide model.positions) model.slides


viewNavBubble : Int -> Int -> Html Msg
viewNavBubble slidePosition index =
    let
        isActive =
            slidePosition == index
    in
    div [ css [ navBubbleContainerCss ], onClick (GotoSlide index) ]
        [ div [ css [ navBubbleCss isActive ] ] [] ]


viewNavBubbles : Slides -> Int -> List (Html Msg)
viewNavBubbles slides slidePosition =
    List.map (viewNavBubble slidePosition) (List.range 0 (List.length slides - 1))


viewNavBar : Slides -> Int -> Html Msg
viewNavBar slides slidePosition =
    div [ css [ navbarCss slidePosition ] ]
        [ div [ css [ navItemsCss ] ]
            [ button [ css [ buttonCss ], disabled (slidePosition == 0), onClick Backwards ] [ text "◀" ]
            , div [ css [ navBubblesCss ] ] (viewNavBubbles slides slidePosition)
            , button [ css [ buttonCss ], onClick Forwards ] [ text "▶" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ css [ mainCss ] ]
        [ div [] (viewSlides model)
        , viewNavBar model.slides model.positions.slide
        ]
