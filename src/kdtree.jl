struct KDTreeIndex{I<:DataFreeTree} <: AbstractUniqueIndex
    I::I
end

function KDTreeIndex(A::AbstractArray)
    dftree = DataFreeTree(KDTree, A)
    return KDTreeIndex(dftree)
end

Base.summary(::KDTreeIndex) = "KDTreeIndex"

"""Answer using outer bbox of the index."""
function Base.in(x, a::AcceleratedArray{<:Any,<:Any,<:Any,<:KDTreeIndex})
    tree = injectdata(a.index.I, a.parent)  # yields a KDTree
    in(x, tree.hyper_rec)
end

"""Inside Hyperectangle check."""
function Base.in(coordinate::Vector{T}, bbox::HyperRectangle{T}) where {T}
    length(coordinate) <= length(bbox.mins) || error("Coordinate has more dimensions than the bounding box.")
    for (i, ax) in enumerate(coordinate)
        bbox.mins[i] <= ax <= bbox.maxes[i] || return false
    end
    true
end


function Base.findfirst(pred::Base.Fix2{typeof(in),HyperSphere{N,T}}, points::AcceleratedArray{<:Any,<:Any,<:Any,<:KDTreeIndex}) where {N} where {T}
    findall(pred, points)[1]  # this will error on empty sets
end

function Base.findall(pred::Base.Fix2{typeof(in),HyperSphere{N,T}}, points::AcceleratedArray{<:Any,<:Any,<:Any,<:KDTreeIndex}) where {N} where {T}
    tree = injectdata(points.index.I, points.parent)  # yields a KDTree
    hypersphere = pred.x
    inrange(tree, hypersphere.center, hypersphere.r, false)
end

function HyperSphere(coords::Vector{T}, radius::T) where {T<:AbstractFloat}
    HyperSphere(SVector{length(coords)}(coords), radius)
end
