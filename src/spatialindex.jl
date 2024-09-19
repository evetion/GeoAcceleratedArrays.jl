abstract type AbstractSpatialUniqueIndex{M,I} <: AbstractUniqueIndex end
struct SpatialIndex{M,I} <: AbstractSpatialUniqueIndex{M,I}
    M::M  # module
    I::I  # index
end

function AcceleratedArrays.accelerate(a::AbstractArray, ::Type{<:AbstractSpatialUniqueIndex{M}}) where {M}
    return AcceleratedArray(a, SpatialIndex{M}(a))
end

Base.summary(R::SpatialIndex) = "SpatialIndex using $(R.M) backend with $(GeoInterface.extent(R))"

GeoInterface.isgeometry(::Type{<:AcceleratedArray{T,N,A,<:AbstractSpatialUniqueIndex}} where {T,N,A}) = true
GeoInterface.isgeometry(::Type{<:SpatialIndex}) = true
GeoInterface.geomtrait(::AcceleratedArray{T,N,A,<:AbstractSpatialUniqueIndex}) where {T,N,A} = GeoInterface.PolygonTrait()
GeoInterface.geomtrait(::AbstractSpatialUniqueIndex) = GeoInterface.PolygonTrait()


function GeoInterface.extent(t::GeoInterface.PolygonTrait, AA::AcceleratedArray{T,N,A,<:AbstractSpatialUniqueIndex}) where {T,N,A}
    GeoInterface.extent(t, AA.index)
end

function Base.findfirst(pred::Base.Fix2{typeof(in),<:Extent}, AA::AcceleratedArray{T,N,A,<:AbstractSpatialUniqueIndex}) where {T,N,A}
    i = findall(pred, AA)
    isempty(i) ? nothing : first(i)
end

function Base.findall(pred::Base.Fix2{typeof(in),<:Extent}, AA::AcceleratedArray{T,N,A,<:AbstractSpatialUniqueIndex}) where {T,N,A}
    Base.findall(pred, AA.index)
end
