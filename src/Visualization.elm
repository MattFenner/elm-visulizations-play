module Visualization exposing (visualization)

import Svg.Styled exposing (..)
import Svg.Styled.Attributes exposing (..)

-- TODO: generate boxes procedurally
allBoxes : List Box
allBoxes = 
    let
        xs = (List.range -5 5)
        ys = (List.range -5 5)
    in
        makeCombinations xs ys (\x y -> makeBox x y)

makeCombinations : List Int -> List Int -> (Int -> Int -> thing) -> List thing
makeCombinations xs ys f =
    List.concatMap (\x -> List.map (\y -> (f x y)) ys) xs

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
    {
        gridX = gX,
        gridY = gY
    }

-- draw box at grid location
-- TODO: add Z dimension
boxToSvg : Box -> Svg.Styled.Svg msg
boxToSvg box =
    let
        xLoc = (((cos (degrees 30)) + boxGap) * toFloat box.gridX) - (((cos (degrees 30)) + boxGap) * toFloat box.gridY)
        yLoc = (((sin (degrees 30)) + boxGap) * toFloat box.gridX) + (((sin (degrees 30)) + boxGap) * toFloat box.gridY)
        -- TODO: handle y
    in
        g
            [ transform ("translate(" ++ (String.fromFloat xLoc) ++ "," ++ (String.fromFloat yLoc) ++ ")")
            ]
            [ boxLeft
            , boxRight
            , boxTop
            ]

boxesToSvg : List Box -> List (Svg.Styled.Svg msg)
boxesToSvg boxes = 
    List.map boxToSvg boxes

sortBoxesByZOrder : List Box -> List Box
sortBoxesByZOrder boxes =
    List.sortBy (\b -> b.gridX + b.gridY) boxes

-- box parts

boxGap = 0.1

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
