module Styling exposing (..)

import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)


theme =
    { palette =
        { primary = rgb 249 38 114
        , white = rgb 255 255 255
        , black = rgb 0 0 0
        , bg = rgb 35 36 31
        , font = rgb 230 230 230
        }
    }


titleCss : Style
titleCss =
    Css.batch
        [ letterSpacing (em 0.2)
        , textShadow3 (px 2) (px 2) theme.palette.primary
        ]


paragraphCss : Style
paragraphCss =
    Css.batch
        [ marginBottom (rem 1)
        , marginTop (rem 1)
        , whiteSpace preWrap
        ]


buttonCss : Style
buttonCss =
    Css.batch
        [ border3 (px 1) solid theme.palette.white
        , borderRadius (rem 0.2)
        , backgroundColor transparent
        , fontSize (rem 1.1)
        , width (rem 2)
        , cursor pointer
        , color theme.palette.white
        , hover [ boxShadow3 (px 1) (px 2) theme.palette.white ]
        , transition [ Css.Transitions.boxShadow3 200 0 easeInOut ]
        ]


navbarCss : Int -> Style
navbarCss slidePosition =
    let
        ( initialOpacityValue, initialTranslateYValue ) =
            if slidePosition == 0 then
                ( 1, 0 )

            else
                ( 0, 50 )
    in
    Css.batch
        [ position fixed
        , bottom (px 0)
        , width (pct 100)
        , height (px 80)
        , displayFlex
        , opacity (num initialOpacityValue)
        , justifyContent center
        , transform (translateY (pct initialTranslateYValue))
        , transition
            [ Css.Transitions.transform3 100 0 easeInOut
            , Css.Transitions.opacity3 100 0 easeInOut
            ]
        , hover
            [ opacity (num 1)
            , transform (translateY (pct 0))
            ]
        ]


navItemsCss : Style
navItemsCss =
    Css.batch
        [ minWidth (pct 20)
        , maxWidth (pct 80)
        , displayFlex
        , justifyContent spaceBetween
        , backgroundColor (rgba theme.palette.bg.red theme.palette.bg.green theme.palette.bg.blue 0.9)
        , alignItems center
        ]


navBubblesCss : Style
navBubblesCss =
    Css.batch
        [ displayFlex
        , height (pct 100)
        , alignItems center
        , paddingLeft (em 1)
        , paddingRight (em 1)
        ]


mainCss : Style
mainCss =
    Css.batch
        [ backgroundColor theme.palette.bg
        , fontFamilies
            [ "-apple-system"
            , "BlinkMacSystemFont"
            , "Segoe UI"
            , "Roboto"
            , "Helvetica"
            , "Arial"
            , "sans-serif"
            , "Apple Color Emoji"
            , "Segoe UI Emoji"
            , "Segoe UI Symbol"
            ]
        , color theme.palette.font
        , width (vw 100)
        , height (vh 100)
        , fontSize (em 2)
        ]


navBubbleContainerCss : Style
navBubbleContainerCss =
    Css.batch
        [ displayFlex
        , height (rem 0.5)
        , paddingLeft (rem 0.2)
        , cursor pointer
        , paddingRight (rem 0.2)
        , transition [ Css.Transitions.height3 200 0 easeInOut ]
        , hover [ height (rem 1) ]
        ]


navBubbleCss : Bool -> Style
navBubbleCss isActive =
    let
        bgColor =
            if isActive then
                backgroundColor theme.palette.primary

            else
                backgroundColor transparent
    in
    Css.batch
        [ width (rem 0.6)
        , height (rem 0.6)
        , border3 (px 1) solid theme.palette.white
        , bgColor
        , borderRadius (rem 0.6)
        ]


slideCss : Bool -> Int -> Int -> Style
slideCss onlyTitle slideIndex currentPosition =
    let
        translateXValue =
            (slideIndex - currentPosition) * 100 |> toFloat

        justifyContentValue =
            if onlyTitle then
                center

            else
                flexStart
    in
    Css.batch
        [ position fixed
        , displayFlex
        , flexDirection column
        , alignItems center
        , justifyContent justifyContentValue
        , top (px 0)
        , left (px 0)
        , width (vw 100)
        , height (vh 100)
        , transform (translateX (pct translateXValue))
        , transition [ Css.Transitions.transform3 200 0 easeInOut ]
        ]


itemsCss : Style
itemsCss =
    Css.batch
        [ maxWidth maxContent
        , displayFlex
        , flexDirection column
        ]


itemCss : Bool -> Style
itemCss isActive =
    let
        ( opacityValue, translateYValue ) =
            if isActive then
                ( 1, 0 )

            else
                ( 0, 10 )
    in
    Css.batch
        [ opacity (num opacityValue)
        , transform (translateY (pct translateYValue))
        , transition
            [ Css.Transitions.transform3 100 0 easeInOut
            , Css.Transitions.opacity3 100 0 easeInOut
            ]
        ]
