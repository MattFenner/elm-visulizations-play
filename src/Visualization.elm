module Visualization exposing (visualization)

import Css exposing (Style, animationName, animationDuration, sec, transform, translate2, num, px, property)
import Css.Animations as Anim exposing (transform, keyframes)
import Html.Styled exposing (Html)
import Svg.Styled exposing (Svg, g, polygon, svg)
import Svg.Styled.Attributes exposing (fill, height, points, viewBox, width, css, transform)


-- TODO: generate boxes procedurally


allBoxes : List Box
allBoxes =
    let
        xs =
            List.range -5 5

        ys =
            List.range -5 5
    in
    makeCombinations xs ys (\x y -> makeBox x y)


makeCombinations : List Int -> List Int -> (Int -> Int -> thing) -> List thing
makeCombinations xs ys f =
    List.concatMap (\x -> List.map (\y -> f x y) ys) xs


visualization : Html msg
visualization =
    svg
        [ width "100%"
        , height "800"
        , viewBox "-10 -10 20 20"
        ]
        (boxesToSvg (sortBoxesByZOrder allBoxes))


type alias Box =
    { gridX : Int
    , gridY : Int
    }


makeBox : Int -> Int -> Box
makeBox gX gY =
    { gridX = gX
    , gridY = gY
    }



-- draw box at grid location
-- TODO: add Z dimension


boxToSvg : Box -> Svg.Styled.Svg msg
boxToSvg box =
    g
        [ animatePosition box
        ]
        [ boxLeft
        , boxRight
        , boxTop
        ]

animatePosition : Box -> Svg.Styled.Attribute msg
animatePosition box = 
    let
        xLoc =
            ((cos (degrees 30) + boxGap) * toFloat box.gridX) - ((cos (degrees 30) + boxGap) * toFloat box.gridY)

        yLoc =
            ((sin (degrees 30) + boxGap) * toFloat box.gridX) + ((sin (degrees 30) + boxGap) * toFloat box.gridY)
        
        animation =
            keyframes 
                [ (0, [ Anim.property "transform" ("translate(" ++ String.fromFloat xLoc ++ "px, -50px)") ] )
                , (50, [ Anim.property "transform" ("translate(" ++ String.fromFloat xLoc ++ "px, " ++ String.fromFloat yLoc ++ "px)") ] )
                , (100, [ Anim.property "transform" ("translate(" ++ String.fromFloat xLoc ++ "px, 50px)") ] )
                ]
    in
        css 
            [ animationName animation 
            , property "animation-duration" "30s"
            , property "animation-iteration-count" "infinite"
            -- , property "animation-timing-function" "ease-in-out"
            ]

boxesToSvg : List Box -> List (Svg.Styled.Svg msg)
boxesToSvg boxes =
    List.map boxToSvg boxes


sortBoxesByZOrder : List Box -> List Box
sortBoxesByZOrder boxes =
    List.sortBy (\b -> b.gridX + b.gridY) boxes



-- box parts


boxGap : Float
boxGap =
    0.1


boxTop : Svg msg
boxTop =
    polygon
        [ fill "#619554"
        , polygonPoints
            [ topFront
            , topRight
            , topBack
            , topLeft
            ]
        ]
        []


boxLeft : Svg msg
boxLeft =
    polygon
        [ fill "#725239"
        , polygonPoints
            [ topFront
            , topLeft
            , bottomLeft
            , bottomFront
            ]
        ]
        []


boxRight : Svg msg
boxRight =
    polygon
        [ fill "#3D2C1F"
        , polygonPoints
            [ topFront
            , topRight
            , bottomRight
            , bottomFront
            ]
        ]
        []



-- Polygon helpers


polygonPoints : List Point -> Svg.Styled.Attribute msg
polygonPoints pts =
    points (pts |> List.map ptToStr |> String.join ", ")


type alias Point =
    ( Float, Float )


ptToStr : Point -> String
ptToStr pt =
    let
        ( x, y ) =
            pt
    in
    String.fromFloat x ++ " " ++ String.fromFloat y


topFront : Point
topFront =
    ( 0, 0 )


topRight : Point
topRight =
    ( cos (degrees 30), -(sin (degrees 30)) )


topLeft : Point
topLeft =
    ( -(cos (degrees 30)), -(sin (degrees 30)) )


topBack : Point
topBack =
    ( 0, -(sin (degrees 30)) * 2 )


bottomFront : Point
bottomFront =
    ( 0, 1 )


bottomLeft : Point
bottomLeft =
    ( -(cos (degrees 30)), 1 - sin (degrees 30) )


bottomRight : Point
bottomRight =
    ( cos (degrees 30), 1 - sin (degrees 30) )
