module GeoAcceleratedArrays

# using NearestNeighbors: DataFreeTree, KDTree, injectdata, inrange, HyperSphere, HyperRectangle
import GeoInterface
using Extents
import LibSpatialIndex
using AcceleratedArrays: accelerate, AbstractUniqueIndex, AcceleratedArray

include("rtree.jl")

export RTreeIndex
export accelerate

end # module
