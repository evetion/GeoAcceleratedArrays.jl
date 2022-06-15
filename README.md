
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/dev)
[![Codecov](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl)

# GeoAcceleratedArrays
Accelerate Arrays using Spatial Indexes.

Combines [AcceleratedArrays](https://github.com/andyferris/AcceleratedArrays.jl) with [NearestNeighbors](https://github.com/KristofferC/NearestNeighbors.jl/).

*this is a work in progress*

## Install
```julia
] add GeoAcceleratedArrays
```

## Example
```julia
using GeoAcceleratedArrays

# Accelerate 1000 points
points = rand(3, 1000)
acc_points = accelerate(points, KDTreeIndex)

center = [0.5, 0.5, 0.5]
radius = 0.1
sphere = HyperSphere(center, radius)

indices = findall(in(sphere), acc_points)
points_in_sphere = @view acc_points[:, indices]
```
