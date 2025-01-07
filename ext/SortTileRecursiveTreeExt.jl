module SortTileRecursiveTreeExt


using GeoAcceleratedArrays
using SortTileRecursiveTree
using Extents
using GeoInterface

function SpatialIndex{Val{SortTileRecursiveTree}}(A::AbstractVector)
    tree = STRtree(A)
    return SpatialIndex(Val(SortTileRecursiveTree), tree)
end

function Base.isvalid(R::SpatialIndex{Val{SortTileRecursiveTree}})
    return true
end

function GeoInterface.extent(::PolygonTrait, R::SpatialIndex{Val{SortTileRecursiveTree}})
    if R.I.rootnode isa SortTileRecursiveTree.STRNode
        return R.I.rootnode.extent
    elseif R.I.rootnode isa SortTileRecursiveTree.STRLeafNode
        return foldl(Extents.union, R.I.rootnode.extents)
    end
end

function Base.findall(pred::Base.Fix2{typeof(in),Extent{K,V}}, SI::SpatialIndex{Val{SortTileRecursiveTree}}) where {K,V}
    query_result = query(SI.I, pred.x)
end


end
