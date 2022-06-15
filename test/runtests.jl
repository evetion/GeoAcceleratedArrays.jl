using GeoAcceleratedArrays
using Test

@testset "GeoAcceleratedArrays.jl" begin
    # Accelerate 1000 points
    points = rand(1, 1000)
    acc_points = accelerate(points, KDTreeIndex)

    center = [0.0]
    radius = 0.1
    sphere = HyperSphere(center, radius)

    indices = findall(in(sphere), acc_points)
    in_sphere = acc_points[:, indices]
    @test all(in_sphere .<= radius)
end
