module Hw.Core where

data Vector3 = Vector3 {
    x :: Float,
    y :: Float,
    z :: Float
    } deriving (Show, Eq)

zeroVector3 = Vector3 0.0 0.0 0.0

add :: Vector3 -> Vector3 -> Vector3
add v1 v2 = 
    Vector3
        (x v1 + x v2) (y v1 + y v2) (z v1 + z v2)

scalarProduct :: Vector3 -> Float -> Vector3
scalarProduct v s = Vector3 (x v * s) (y v * s) (z v * s)

dotProduct :: Vector3 -> Vector3 -> Float
dotProduct v1 v2 = 
    (x v1 * x v2) + (y v1 * y v2) + (z v1 * z v2)

crossProduct :: Vector3 -> Vector3 -> Vector3
crossProduct v1 v2 = 
    Vector3
        (y v1 * z v2 - y v2 * z v1)
        (x v2 * z v1 - x v1 * z v2)
        (x v1 * y v2 - x v2 * y v1)

length :: Vector3 -> Float
length v =
    sqrt (x v ^ 2) + (y v ^ 2) + (z v ^ 2)

isParallel :: Vector3 -> Vector3 -> Bool
isParallel v1 v2 = crossProduct v1 v2 == zeroVector3

angle :: Vector3 -> Vector3 -> Float
angle v1 v2 = 
    acos 
        (dotProduct v1 v2 / (Hw.Core.length v1 * Hw.Core.length v2))

normalize :: Vector3 -> Vector3
normalize v | v == zeroVector3  = Vector3 0.0 0.0 0.0
            | otherwise         = scalarProduct v (1 / Hw.Core.length v)
