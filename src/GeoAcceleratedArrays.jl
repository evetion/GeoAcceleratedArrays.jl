module GeoAcceleratedArrays

using NearestNeighbors: DataFreeTree, KDTree, injectdata, inrange, HyperSphere, HyperRectangle
using AcceleratedArrays: accelerate, AbstractUniqueIndex, AcceleratedArray
using StaticArrays: SVector

include("kdtree.jl")

export KDTreeIndex
export HyperSphere, HyperRectangle
export accelerate

end # module
