using GeoAcceleratedArrays
using LibGEOS
using Extents
using GeoInterface
using Test
import LibSpatialIndex
import SortTileRecursiveTree
import SpatialIndexing

@testset "GeoAcceleratedArrays.jl" begin
    p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
    p2 = readgeom("POLYGON((0 0,-1 0,-1 -1,0 0))")
    p3 = readgeom("MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
    ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
    (30 20, 20 15, 20 25, 30 20)))")

    for library in (LibSpatialIndex, SortTileRecursiveTree, SpatialIndexing)
        @testset "$library" begin
            acc_polys = accelerate([p1, p2, p3], library)
            @test acc_polys isa GeoAcceleratedArrays.AcceleratedArray{T,N,A,<:GeoAcceleratedArrays.AbstractSpatialUniqueIndex} where {T,N,A}

            @test isgeometry(acc_polys)
            @test isgeometry(acc_polys.index)

            @test geomtrait(acc_polys) == GeoInterface.PolygonTrait()
            @test geomtrait(acc_polys.index) == GeoInterface.PolygonTrait()

            @test GeoInterface.extent(acc_polys) == Extent(X=(-1.0, 45.0), Y=(-1.0, 45.0))
            @test GeoInterface.extent(acc_polys.index) == Extent(X=(-1.0, 45.0), Y=(-1.0, 45.0))

            @test isvalid(acc_polys.index)

            # GeoInterface.testgeometry(RTreeIndex)
            @test occursin("SpatialIndex using $library", summary(acc_polys))

            aoi = Extents.Extent(X=(0.5, 1), Y=(0.5, 1))

            indices = findall(in(aoi), acc_polys)
            @test indices == [1]
            indice = findfirst(in(aoi), acc_polys)
            @test indice == 1
            in_aoi = @view acc_polys[indices]

            aoi = Extents.Extent(X=(1.5, 1), Y=(1.5, 1))
            indice = findfirst(in(aoi), acc_polys)
            @test isnothing(indice)
        end
    end
end
