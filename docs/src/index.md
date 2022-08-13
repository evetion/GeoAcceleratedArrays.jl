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
julia> using GeoAcceleratedArrays
julia> using LibGEOS  # or any other GeoInterface compatible geometries

julia> p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
julia> p2 = readgeom("POLYGON((0 0,-1 0,-1 -1,0 0))")

julia> acc_polys = accelerate([p1, p2], RTreeIndex)
2-element Vector{Polygon} + RTreeIndex with Extent{(:X, :Y), Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}}((X = (5.21501908402615e-310, 5.21501908411073e-310), Y = (0.0, 0.0))):

julia> aoi = Extents.Extent(X=(0.5, 1), Y=(0.5, 1))
Extent(X = (0.5, 1.0), Y = (0.5, 1.0))

julia> indices = findall(in(aoi), acc_polys)
1-element Vector{Int64}:
 1
```

```@index
```

```@autodocs
Modules = [GeoAcceleratedArrays]
```
