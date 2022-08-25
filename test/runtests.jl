using GeoAcceleratedArrays
using LibGEOS
using Extents
using GeoInterface
using Test

@testset "GeoAcceleratedArrays.jl" begin
    p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
    p2 = readgeom("POLYGON((0 0,-1 0,-1 -1,0 0))")
    p3 = readgeom("MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
    ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),
    (30 20, 20 15, 20 25, 30 20)))")

    acc_polys = accelerate([p1, p2, p3], RTreeIndex)

    @test GeoInterface.extent(acc_polys) isa Extent

    @test isvalid(acc_polys.index)

    # GeoInterface.testgeometry(RTreeIndex)
    @test occursin("RTreeIndex with Extent{(:X, :Y)", summary(acc_polys))

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
