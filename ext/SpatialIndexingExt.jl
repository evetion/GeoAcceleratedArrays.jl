module SpatialIndexingExt


using GeoAcceleratedArrays
import SpatialIndexing
using Extents
using GeoInterface

function SpatialIndex{Val{SpatialIndexing}}(A::AbstractVector)
    rtree = SpatialIndexing.RTree{Float64,2}(Int, String, leaf_capacity=20, branch_capacity=20)
    for I in eachindex(A)
        box = GeoInterface.extent(A[I])
        rect = _convert(SpatialIndexing.Rect, box)
        SpatialIndexing.insert!(rtree, rect, I, string(I))
    end
    return SpatialIndex(Val(SpatialIndexing), rtree)
end

function Base.isvalid(R::SpatialIndex{Val{SpatialIndexing}})
    return SpatialIndexing.check(R.I)
end

function GeoInterface.extent(::PolygonTrait, R::SpatialIndex{Val{SpatialIndexing}})
    rect = SpatialIndexing.mbr(R.I)
    return _convert(Extent, rect)
end

function Base.findall(pred::Base.Fix2{typeof(in),Extent{K,V}}, SI::SpatialIndex{Val{SpatialIndexing}}) where {K,V}
    map(SpatialIndexing.id, SpatialIndexing.intersects_with(SI.I, _convert(SpatialIndexing.Rect, pred.x)))
end

function _convert(::Type{Extent}, rect::SpatialIndexing.Rect)
    Extent(X=(rect.low[1], rect.high[1]), Y=(rect.low[2], rect.high[2]))
end
function _convert(::Type{SpatialIndexing.Rect}, extent::Extent)
    SpatialIndexing.Rect((extent.X[1], extent.Y[1]), (extent.X[2], extent.Y[2]))
end

end
