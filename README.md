
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://evetion.github.io/GeoAcceleratedArrays.jl/dev)
[![Codecov](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/GeoAcceleratedArrays.jl)

# GeoAcceleratedArrays
Accelerate Arrays using Spatial Indexes.

Combines [AcceleratedArrays](https://github.com/andyferris/AcceleratedArrays.jl) with either [LibSpatialIndex](https://github.com/JuliaGeo/LibSpatialIndex.jl), [SpatialIndexing](https://github.com/alyst/SpatialIndexing.jl) or [SortTileRecursiveTree](https://github.com/maxfreu/SortTileRecursiveTree.jl), speeding up area of interest queries, without having to do exact intersections on all geometries.
Takes inspiration from the Python [rtree](https://github.com/Toblerity/rtree) package.

*Note that as the acceleration works by using the extents of geometries, the filtered list of geometries is not guaranteed to intersect, we only guarantee that all intersecting geometries are present.*

## Install
```julia
] add GeoAcceleratedArrays
```

## Usage
Apply a spatial index on a Vector with geometries using `accelerate`, after which one can quickly find the intersecting extents for a given area of interest by `findall` with the `in` predicate.

```julia
using GeoAcceleratedArrays
using LibSpatialIndex
AA = accelerate(A, LibSpatialIndex)
indices = findall(in(area_of_interest), AA)
```

## Example
```julia
using GeoAcceleratedArrays
using LibGEOS  # or any other GeoInterface compatible geometries

p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))");
p2 = readgeom("POLYGON((0 0,-1 0,-1 -1,0 0))");
p3 = readgeom("MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
(30 20, 20 15, 20 25, 30 20)))");
A = [p1, p2, p3];

using LibSpatialIndex # (or SortTileRecursiveTree or SpatialIndexing)
acc_polys = accelerate(A, LibSpatialIndex)
3-element Vector{LibGEOS.AbstractGeometry} + SpatialIndex using Val{LibSpatialIndex}() backend with Extent{(:X, :Y), Tuple{Tuple{Float64, Float64}, Tuple{Float64, Float64}}}((X = (-1.0, 45.0), Y = (-1.0, 45.0))):
 POLYGON ((0 0, 1 0, 1 1, 0 0))
 POLYGON ((0 0, -1 0, -1 -1, 0 0))
 MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))

aoi = Extents.Extent(X=(0.5, 1), Y=(0.5, 1));

indices = findall(in(aoi), acc_polys)
1-element Vector{Int64}:
 1
```
