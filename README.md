
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/dev)
[![Build Status](https://travis-ci.com/evetion/GeoAcceleratedArrays.jl.svg?branch=master)](https://travis-ci.com/evetion/GeoAcceleratedArrays.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/evetion/GeoAcceleratedArrays.jl?svg=true)](https://ci.appveyor.com/project/evetion/GeoAcceleratedArrays-jl)
[![Codecov](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl)

# GeoAcceleratedArrays
Accelerate Arrays using Spatial Indexes.

Combines [AcceleratedArrays](https://github.com/andyferris/AcceleratedArrays.jl) with [NearestNeighbors](https://github.com/KristofferC/NearestNeighbors.jl/).

*this is a work in progress*

## Install
```julia
] add https://github.com/evetion/GeoAcceleratedArrays.jl
```

## Example
```julia
using AcceleratedArrays
using GeoAcceleratedArrays
using NearestNeighbors

# Accelerate 1000 points
points = rand(3, 1000)
acc_points = accelerate(points, KDTreeIndex)

center = [0.5, 0.5, 0.5]
radius = 0.1
sphere = NearestNeighbors.HyperSphere(center, radius)

indices = findall(in(sphere), acc_points)
points_in_sphere = acc_points[:, indices]
```
