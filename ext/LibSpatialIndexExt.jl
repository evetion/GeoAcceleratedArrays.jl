module LibSpatialIndexExt

using GeoAcceleratedArrays
using LibSpatialIndex
using Extents
using GeoInterface

function SpatialIndex{Val{LibSpatialIndex}}(A::AbstractVector)
    rtree = LibSpatialIndex.RTree(2)
    min = zeros(2)
    max = zeros(2)
    for I in eachindex(A)
        box = GeoInterface.extent(A[I])
        LibSpatialIndex.insert!(rtree, I, box)
    end
    return SpatialIndex(Val(LibSpatialIndex), rtree)
end

function Base.isvalid(R::SpatialIndex{Val{LibSpatialIndex}})
    Bool(LibSpatialIndex.C.Index_IsValid(R.I.index))
end

function GeoInterface.extent(::PolygonTrait, R::SpatialIndex{Val{LibSpatialIndex}})
    pmins, pmaxs = _getbounds(R)
    return Extent(X=(pmins[1], pmaxs[1]), Y=(pmins[2], pmaxs[2]))
end

function _getbounds(R::SpatialIndex{Val{LibSpatialIndex},I}) where {I}
    pmins = Ref{Ptr{Float64}}(C_NULL)
    pmaxs = Ref{Ptr{Float64}}(C_NULL)
    ndims = Ref{UInt32}()
    result = LibSpatialIndex.C.Index_GetBounds(R.I.index, pmins, pmaxs, ndims)
    LibSpatialIndex._checkresult(result, "Couldn't determine bounds of RTree")
    pmins = unsafe_wrap(Array, pmins[], ndims[], own=true)
    pmaxs = unsafe_wrap(Array, pmaxs[], ndims[], own=true)
    (pmins, pmaxs)
end


function Base.findall(pred::Base.Fix2{typeof(in),Extent{K,V}}, SI::SpatialIndex{Val{LibSpatialIndex}}) where {K,V}
    LibSpatialIndex.intersects(SI.I, pred.x)
end

end  # module
