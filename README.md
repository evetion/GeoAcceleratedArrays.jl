
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/dev)
[![Codecov](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl)

# GeoAcceleratedArrays
Accelerate Arrays using Spatial Indexes.

Combines [AcceleratedArrays](https://github.com/andyferris/AcceleratedArrays.jl) with [LibSpatialIndex](https://github.com/JuliaGeo/LibSpatialIndex.jl).
Takes inspiration from the Python [rtree](https://github.com/Toblerity/rtree) package.


## Install
```julia
] add GeoAcceleratedArrays
```

## Example
```julia
using GeoAcceleratedArrays
using LibGEOS  # or any other GeoInterface compatible geometries

p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
p2 = readgeom("POLYGON((0 0,-1 0,-1 -1,0 0))")

acc_polys = accelerate([p1, p2], RTreeIndex)
2-element Vector{Polygon} + RTreeIndex with Extents.Extent{(:X, :Y), Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}}((X = (-1.0, 1.0), Y = (-1.0, 1.0))):
 Polygon(Ptr{Nothing} @0x00006000030d2d00)
 Polygon(Ptr{Nothing} @0x00006000030d23a0)

aoi = Extents.Extent(X=(0.5, 1), Y=(0.5, 1))
Extent(X = (0.5, 1.0), Y = (0.5, 1.0))

indices = findall(in(aoi), acc_polys)
1-element Vector{Int64}:
 1
```
