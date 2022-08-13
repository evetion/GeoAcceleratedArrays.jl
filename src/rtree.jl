struct RTreeIndex{I} <: AbstractUniqueIndex
    I::I
end

function RTreeIndex(A::AbstractVector)
    rtree = LibSpatialIndex.RTree(2)
    min = zeros(2)
    max = zeros(2)
    for I in eachindex(A)
        box = GeoInterface.extent(A[I])
        min[1] = box.X[1]
        min[2] = box.Y[1]
        max[1] = box.X[2]
        max[2] = box.Y[2]
        LibSpatialIndex.insert!(rtree, I, min, max)
    end
    return RTreeIndex(rtree)
end

Base.summary(R::RTreeIndex) = "RTreeIndex with $(GeoInterface.extent(R))"

function GeoInterface.extent(R::RTreeIndex)
    pmins = zeros(2)
    pmaxs = zeros(2)
    ndims = Ref{UInt32}()
    result = LibSpatialIndex.C.Index_GetBounds(R.I.index, pointer_from_objref(pmins), pointer_from_objref(pmaxs), ndims)
    LibSpatialIndex._checkresult(result, "Couldn't determine bounds of RTree")
    return Extent(X=(pmins[1], pmaxs[1]), Y=(pmins[2], pmaxs[2]))
end

function Base.isvalid(R::RTreeIndex)
    Bool(LibSpatialIndex.C.Index_IsValid(R.I.index))
end

function Base.findfirst(pred::Base.Fix2{typeof(in),Extent{K,V}}, AA::AcceleratedArray{<:Any,<:Any,<:Any,<:RTreeIndex}) where {N,K,V,T}
    first(findall(pred, AA))  # this will error on empty sets
end

function Base.findall(pred::Base.Fix2{typeof(in),Extent{K,V}}, AA::AcceleratedArray{<:Any,<:Any,<:Any,<:RTreeIndex}) where {N,K,V,T}
    LibSpatialIndex.intersects(AA.index.I, Float64[pred.x.X[1], pred.x.Y[1]], Float64[pred.x.X[2], pred.x.Y[2]])
end
