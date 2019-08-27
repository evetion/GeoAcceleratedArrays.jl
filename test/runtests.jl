using GeoAcceleratedArrays
using AcceleratedArrays
using Test

@testset "GeoAcceleratedArrays.jl" begin
    # Write your own tests here.
    aa = accelerate(rand(3, 1000), KDTreeIndex)
end
