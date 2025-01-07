abstract type AbstractSpatialUniqueIndex{M,I} <: AbstractUniqueIndex end
struct SpatialIndex{M,I} <: AbstractSpatialUniqueIndex{M,I}
    M::M  # module
    I::I  # index
end

SpatialIndex(M::Module) = SpatialIndex(Val(M))
SpatialIndex(::Val{M}) where M = SpatialIndex{Val{M}}

function AcceleratedArrays.accelerate(a::AbstractArray, ::Type{<:AbstractSpatialUniqueIndex{M}}) where {M}
    return AcceleratedArray(a, SpatialIndex{M}(a))
end

function AcceleratedArrays.accelerate(a::AbstractArray, M::Module)
    return accelerate(a, SpatialIndex(M))
end

_value(::Type{Val{X}}) where X = X

Base.show(io::IO, ::MIME"text/plain", R::SpatialIndex{M}) where M = print(io, "SpatialIndex using ", _value(M), " backend with ", GeoInterface.extent(R))
Base.show(io::IO, ::SpatialIndex{M}) where M = print(io, "SpatialIndex using ", _value(M))
Base.summary(io::IO, R::SpatialIndex) = show(io::IO, R)

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
