using PTYQoL
using Test

@testset "//" begin
    @test 1 // 2 isa Rational
    @test 1.0 // 2.0 == 1 // 2
end

@testset "dotu" begin
    using LinearAlgebra
    u = rand(10); v = rand(10)
    @test LinearAlgebra.BLAS.dotu(u, v) == LinearAlgebra.BLAS.dotu(u, 1, v, 1) == LinearAlgebra.BLAS.dotu(10, u, 1, v, 1) == u ⋅ v

    u = rand(ComplexF64, 10); v = rand(ComplexF64, 10)
    @test endswith(string(which(LinearAlgebra.BLAS.dotu, map(typeof,(10,u,1,v,1))).file), "blas.jl")
    @test LinearAlgebra.BLAS.dotu(u, v) == LinearAlgebra.BLAS.dotu(u, 1, v, 1) == LinearAlgebra.BLAS.dotu(10, u, 1, v, 1)
end

@testset "eps ceil floor" begin
    @test eps(ComplexF64) == eps(Float64)
    @test ceil(0.5+0.5im) == 1+1im == floor(1.5+1.5im)
end

@testset "front tail" begin
    using Base: front, tail
    @test front(1:10) == 1:9 == tail(0:9)
end

@testset "startswith endswith" begin
    @test startswith(AbstractArray, "Abstract")
    @test endswith(AbstractArray, Array)
end