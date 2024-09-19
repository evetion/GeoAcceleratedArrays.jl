module GeoAcceleratedArrays

# using NearestNeighbors: DataFreeTree, KDTree, injectdata, inrange, HyperSphere, HyperRectangle
import GeoInterface
using Extents
using AcceleratedArrays: AbstractUniqueIndex, AcceleratedArray, accelerate, AcceleratedArrays

include("spatialindex.jl")

export SpatialIndex
export accelerate

end # module
