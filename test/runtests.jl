using PTYQoL
using Test

@testset "Pull Requests" begin
    @testset "https://github.com/JuliaLang/julia/issues/35033" begin
        @test startswith(AbstractArray, "Abstract")
        @test endswith(AbstractArray, Array)
    end
    
    @testset "https://github.com/JuliaLang/julia/pull/48894" begin
        @test AbstractRange{Float64}(1:10) ≡ AbstractVector{Float64}(1:10) ≡ AbstractArray{Float64}(1:10) ≡ 1.0:10
    end
    
    @testset "https://github.com/JuliaLang/julia/pull/52312" begin
        using Base: front, tail
        ind = CartesianIndex(1,2,3)
        @test first(ind) == 1
        @test last(ind) == ind[end] == 3
        @test front(ind) == ind[1:end-1] == CartesianIndex(1,2)
        @test tail(ind) == ind[2:end] == CartesianIndex(2,3)
    end
end

@testset "Misc" begin
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

    @testset "Complex interface" begin
        @test eps(ComplexF64) == eps(Float64)
        @test precision(ComplexF64) == precision(Float64)
        @test ceil(0.5+0.5im) == 1+1im == floor(1.5+1.5im)
    end

    @testset "front tail" begin
        using Base: front, tail
        @test front(1:10) == 1:9 == tail(0:9)
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

        @test (sin+1)(1) ≈ 1+sin(1)
        @test (2sin*cos)(1) ≈ sin(2)
    end

    @testset "Tuple copy" begin
        @test copy((1,2)) ≡ (1,2)
    end
end

@testset "Utils" begin
    @testset "ln" begin
        @test ln(1) == 0 # just for coverage
    end
    @testset "precision_convert" begin
        setprecision(256)
        x = precision_convert(BigFloat, BigFloat(1), 128)
        @test precision(x) == 128
    end
end

@testset "Extensions" begin
    @testset "IntervalSets" begin
        using DomainSets
        @test union(ChebyshevInterval()) ≡ ChebyshevInterval()
    end
    @testset "QuasiArrays" begin
        using ContinuumArrays
        @test union(Inclusion(0..1).^2) == Inclusion(0..1) == union(Inclusion(-1..1).^1.0) == union(Inclusion(1..Inf).^(-0.5))
        @test isempty(union(Inclusion(-1..0).^1.5))
        @test union(Inclusion(0..1).^0) == Inclusion(1..1)
    end
    @testset "ClassicalOrthogonalPolynomials" begin
        using ClassicalOrthogonalPolynomials
        using ClassicalOrthogonalPolynomials: AbstractJacobi
        @test AbstractJacobi{Float32}(Jacobi(1,1)) isa Jacobi{Float32}
        @test AbstractJacobi{Float16}(ChebyshevU()) isa ChebyshevU{Float16}
        @test AbstractJacobi{BigFloat}(Legendre()) isa Legendre{BigFloat}
        @test AbstractJacobi{Float32}(Ultraspherical(2)) isa Ultraspherical{Float32}
    end
    @testset "ArrayLayouts" begin
        using ArrayLayouts
        A = rand(3,5)
        ind = CartesianIndex(2,3)
        @test rowsupport(A, ind) == rowsupport(A,2)
        @test colsupport(A, ind) == colsupport(A,3)
    end
    @testset "AlgebraicNumbers" begin
        using AlgebraicNumbers
        @test sincospi(1//3) == sincos_alg(1//3) == sincosd(60)
        @test tanpi(AlgebraicNumber(1)) == AlgebraicNumber(0)
    end
end

using Documenter
DocMeta.setdocmeta!(PTYQoL, :DocTestSetup, :(using PTYQoL); recursive=true)
@testset "Docs" begin
	doctest(PTYQoL)
end

using Aqua
@testset "Project quality" begin
    Aqua.test_all(PTYQoL, ambiguities=true, piracies=false, deps_compat=false)
end