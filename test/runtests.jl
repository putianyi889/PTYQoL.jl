using PTYQoL
using Test, Documenter

@testset "//" begin
    @test 1 // 2 isa Rational
    @test 1.0 // 2.0 == 1 // 2
end

@testset "dotu" begin
    using LinearAlgebra
    u = rand(10); v = rand(10)
    @test LinearAlgebra.BLAS.dotu(u, v) == LinearAlgebra.BLAS.dotu(u, 1, v, 1) == LinearAlgebra.BLAS.dotu(10, u, 1, v, 1) ≈ u ⋅ v

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

@testset "https://github.com/JuliaLang/julia/issues/35033" begin
    @test startswith(AbstractArray, "Abstract")
    @test endswith(AbstractArray, Array)
end

@testset "https://github.com/JuliaLang/julia/pull/48894" begin
    @test AbstractRange{Float64}(1:10) ≡ AbstractVector{Float64}(1:10) ≡ AbstractArray{Float64}(1:10) ≡ 1.0:10
end

@testset "Function interface" begin
    using Base: Fix2
    @test identity ∘ identity ≡ identity ≡ exp10 ∘ inv(exp10) ≡ log2 ∘ inv(log2) ≡ inv(identity)
    @test identity ∘ exp ≡ exp ≡ exp ∘ identity
    @test abs ∘ abs ≡ abs
    @test inv(exp10 ∘ exp2) ≡ log2 ∘ log10
    @test Fix2(+, 0) == identity == Fix2(*, 1)

    @test Fix2(+, 1) ∘ Fix2(+, 2) == Fix2(+, 3)
    @test Fix2(*, 2) ∘ Fix2(*, 3) == Fix2(*, 6)
    @test Fix2(+, 3) ^ 5 == Fix2(+, 15)
    @test Fix2(*, 4) ^ 3 == Fix2(*, 64)
    @test Fix2(^, 2) ∘ Fix2(^, 3) == Fix2(^, 6)
end

@testset "ln" begin
    @test ln(1) == 0 # just for coverage
end

@testset "Extensions" begin
    @testset "IntervalSets" begin
        using DomainSets
        @test union(ChebyshevInterval()) ≡ ChebyshevInterval()
    end
    @testset "QuasiArrays" begin
        using ContinuumArrays
        @test union((Inclusion(0..1)).^2) == Inclusion(0..1)
    end
end

DocMeta.setdocmeta!(PTYQoL, :DocTestSetup, :(using PTYQoL); recursive=true)
@testset "Docs" begin
	doctest(PTYQoL)
end