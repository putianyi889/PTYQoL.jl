using PTYQoL
using Test

@testset "Pull Requests" begin
    @testset "https://github.com/JuliaLang/julia/issues/35033" begin
        @test startswith(AbstractArray, "Abstract")
        @test endswith(AbstractArray, Array)
    end

    @testset "https://github.com/JuliaLang/julia/pull/48894" begin
        # StepRangeLen is converted to StepRangeLen
        @test 0.0:5.0 isa StepRangeLen # just in case
        @test convert(AbstractRange{Int}, 0.0:5.0) === convert(AbstractVector{Int}, 0.0:5.0) === convert(AbstractArray{Int}, 0.0:5.0) === StepRangeLen(0, 1, 6)
        @test convert(AbstractRange{Float16}, 0.0:5.0) === convert(AbstractVector{Float16}, 0.0:5.0) === convert(AbstractArray{Float16}, 0.0:5.0) === Float16(0.0):Float16(5.0)

        # Try to preserve type when possible
        @test AbstractArray{Int8}(Base.oneto(5)) === Base.oneto(Int8(5)) # OneTo
        @test AbstractArray{Int32}(0:5) === Int32(0):Int32(5) # UnitRange
        @test AbstractArray{Int128}(0:2:5) === Int128(0):Int128(2):4 # StepRange
        @test AbstractArray{Float64}(LinRange(1, 5, 5)) === LinRange(1.0, 5.0, 5) # LinRange
        @test AbstractArray{Float64}(Base.oneto(5)) === AbstractArray{Float64}(1:5) === AbstractArray{Float64}(1:1:5) === 1.0:1.0:5.0 # fallback

        # Edge cases where floating point can be glitchy. Credit: @mcabbott
        @test convert(AbstractArray{Float64}, 0 * (1:10)) === range(0.0, 0.0, 10)
        @test length(convert(AbstractArray{Float16}, range(1 / 43^2, 1, 43))) == 43
    end

    @testset "https://github.com/JuliaLang/julia/pull/52312" begin
        using Base: front, tail
        ind = CartesianIndex(1, 2, 3)
        @test first(ind) == 1
        @test last(ind) == ind[end] == 3
        @test front(ind) == ind[1:end-1] == CartesianIndex(1, 2)
        @test tail(ind) == ind[2:end] == CartesianIndex(2, 3)
    end

    @testset "https://github.com/JuliaLang/julia/issues/52870" begin
        using LinearAlgebra
        A = rand(1:9, 3, 3)
        B = rand(1:9, 3, 3)
        while det(B) == 0
            B = rand(1:9, 3, 3)
        end
        C = A // B
        @test C * B == A
    end
end

@testset "Misc" begin
    @testset "//" begin
        @test 1 // 2 isa Rational
        @test 1.0 // 2.0 == 1 // 2
    end

    @testset "dotu" begin
        using LinearAlgebra
        u = rand(10)
        v = rand(10)
        @test LinearAlgebra.BLAS.dotu(u, v) == LinearAlgebra.BLAS.dotu(u, 1, v, 1) == LinearAlgebra.BLAS.dotu(10, u, 1, v, 1) ≈ u ⋅ v

        u = rand(ComplexF64, 10)
        v = rand(ComplexF64, 10)
        @test endswith(string(which(LinearAlgebra.BLAS.dotu, map(typeof, (10, u, 1, v, 1))).file), "blas.jl")
        @test LinearAlgebra.BLAS.dotu(u, v) == LinearAlgebra.BLAS.dotu(u, 1, v, 1) == LinearAlgebra.BLAS.dotu(10, u, 1, v, 1)
    end

    @testset "Complex interface" begin
        @test eps(ComplexF64) == eps(Float64)
        @test precision(ComplexF64) == precision(Float64)
        @test ceil(0.5 + 0.5im) == 1 + 1im == floor(1.5 + 1.5im)
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
        @test Fix2(+, 3)^5 == Fix2(+, 15)
        @test Fix2(*, 4)^3 == Fix2(*, 64)
        @test Fix2(^, 2) ∘ Fix2(^, 3) == Fix2(^, 6)

        @test (sin + 1)(1) ≈ 1 + sin(1)
        @test (2sin * cos)(1) ≈ sin(2)
    end

    @testset "Tuple copy" begin
        @test copy((1, 2)) ≡ (1, 2)
    end

    @testset "searchsorted" begin
        v = cumsum(rand(10) .+ 1)
        t = Tuple(v)
        @test searchsorted(v, 0.5) == searchsorted(t, 0.5)
        @test searchsortedfirst(v, 0.5) == searchsortedfirst(t, 0.5)
        @test searchsortedlast(v, 0.5) == searchsortedlast(t, 0.5)
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
    @testset "fracpochhammer" begin
        @test fracpochhammer(1, 2, 3) ≡ 0.25
        @test fracpochhammer(1, 2, 0.5, 1, 3) ≡ 0.125
    end
end

@testset "Extensions" begin
    @testset "BlockArrays" begin
        using BlockArrays
        @test findblockindex(mortar(reshape([randn(2, 2), randn(1, 2), randn(2, 3), randn(1, 3)], 2, 2)), (2, 3)) == BlockIndex((1, 2), (2, 1))
    end
    @testset "IntervalSets" begin
        using DomainSets
        @test union(ChebyshevInterval()) ≡ ChebyshevInterval()
    end
    @testset "QuasiArrays" begin
        using ContinuumArrays
        @test union(Inclusion(0 .. 1) .^ 2) == Inclusion(0 .. 1) == union(Inclusion(-1 .. 1) .^ 1.0) == union(Inclusion(1 .. Inf) .^ (-0.5))
        @test isempty(union(Inclusion(-1 .. 0) .^ 1.5))
        @test union(Inclusion(0 .. 1) .^ 0) == Inclusion(1 .. 1)
    end
    @testset "ClassicalOrthogonalPolynomials" begin
        using ClassicalOrthogonalPolynomials
        using ClassicalOrthogonalPolynomials: AbstractJacobi
        @test AbstractJacobi{Float32}(Jacobi(1, 1)) isa Jacobi{Float32}
        @test AbstractJacobi{Float16}(ChebyshevU()) isa ChebyshevU{Float16}
        @test AbstractJacobi{BigFloat}(Legendre()) isa Legendre{BigFloat}
        @test AbstractJacobi{Float32}(Ultraspherical(2)) isa Ultraspherical{Float32}
    end
    @testset "ArrayLayouts" begin
        using ArrayLayouts
        A = rand(3, 5)
        ind = CartesianIndex(2, 3)
        @test rowsupport(A, ind) == rowsupport(A, 2)
        @test colsupport(A, ind) == colsupport(A, 3)
    end
    @testset "AlgebraicNumbers" begin
        using AlgebraicNumbers
    end
    @testset "IrrationalConstants" begin
        using IrrationalConstants
        @testset "half" begin
            for (x, halfx) in ((halfπ, quartπ), (π, halfπ), (twoπ, π), (fourπ, twoπ), (inv2π, inv4π), (invπ, inv2π), (twoinvπ, invπ), (fourinvπ, twoinvπ), (sqrt2, invsqrt2), (sqrt2π, sqrthalfπ), (sqrt4π, sqrtπ))
                @test halfx + halfx === x
                @test x - halfx === halfx
                @test halfx / x === 0.5
                @test x / halfx === 2
            end
        end
        @testset "inv" begin
            for (x, invx) in ((quartπ, fourinvπ), (halfπ, twoinvπ), (π, invπ), (twoπ, inv2π), (fourπ, inv4π), (sqrt2, invsqrt2), (sqrtπ, invsqrtπ), (sqrt2π, invsqrt2π))
                @test inv(x) === invx
                @test inv(invx) === x
                @test x * invx === 1
                @test invx * x === 1
            end
        end
        @testset "sqrt" begin
            for (x, sqrtx) in ((π, sqrtπ), (twoπ, sqrt2π), (fourπ, sqrt4π), (halfπ, sqrthalfπ), (invπ, invsqrtπ), (inv2π, invsqrt2π))
                @test sqrt(x) === sqrtx
                @test sqrtx * sqrtx === x
                @test x / sqrtx === sqrtx
                @test sqrtx / x === inv(sqrtx)
            end
        end
    end
end

using Documenter
DocMeta.setdocmeta!(PTYQoL, :DocTestSetup, :(using PTYQoL); recursive=true)
@testset "Docs" begin
    doctest(PTYQoL)
end

using Aqua
@testset "Project quality" begin
    using PTYQoL, AlgebraicNumbers, ArrayLayouts, BandedMatrices, BlockBandedMatrices, CircularArrays, ClassicalOrthogonalPolynomials, ContinuumArrays, DomainSets, InfiniteArrays, Infinities, IntervalSets, LinearAlgebra, QuasiArrays, BlockArrays
    Aqua.test_all(PTYQoL, ambiguities=false, piracies=false, deps_compat=false)

    ambi = detect_ambiguities(Base, PTYQoL, AlgebraicNumbers, ArrayLayouts, BandedMatrices, BlockBandedMatrices, CircularArrays, ClassicalOrthogonalPolynomials, ContinuumArrays, DomainSets, InfiniteArrays, Infinities, IntervalSets, LinearAlgebra, QuasiArrays, BlockArrays)
    internal = similar(ambi, 0)
    extension = similar(ambi, 0)
    external = similar(ambi, 0)
    while !isempty(ambi)
        inst = pop!(ambi)
        if (startswith(inst[1].module, PTYQoL) && inst[2].module == Base) || (startswith(inst[2].module, PTYQoL) && inst[1].module == Base) || string(inst[1].module) == string(PTYQoL, inst[2].module, "Ext") || string(inst[2].module) == string(PTYQoL, inst[1].module, "Ext")
            push!(internal, inst)
        elseif inst[1].module == Base || inst[2].module == Base
            push!(extension, inst)
        else
            push!(external, inst)
        end
    end
    if !isempty(internal)
        for m in internal
            display(m[1])
            display(m[2])
            Aqua.ambiguity_hint(m...)
            print("\n\n\n")
        end
        @test length(internal) == 0
    elseif !isempty(extension)
        for m in extension
            display(m[1])
            display(m[2])
            Aqua.ambiguity_hint(stdout, m...)
            print("\n\n\n")
        end
        println("There are $(length(extension)) ambiguities that can be solved by extension.")
        @test_skip length(extension) == 0
    end
end

using BeepBeep
if Sys.iswindows()
    if relpath(@__FILE__, "/") != "a\\PTYQoL.jl\\PTYQoL.jl\\test\\runtests.jl" # the CI runner
        beep(2)
    end
end