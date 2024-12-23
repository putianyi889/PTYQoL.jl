module PTYQoL

include("Utils.jl")

import Base: //
//(x, y) = x / y
# https://github.com/JuliaLang/julia/issues/52870
//(A::AbstractMatrix{<:Integer}, B::AbstractMatrix{<:Integer}) = (A // one(eltype(A))) / (B // one(eltype(B)))

import Base: eps, ceil, floor, precision
eps(::Type{Complex{T}}) where {T} = eps(T)
eps(::Complex{T}) where {T} = eps(Complex{T})
precision(::Type{Complex{T}}) where {T} = precision(T)
precision(::Complex{T}) where {T} = precision(Complex{T})
ceil(z::Complex; args...) = ceil(real(z), args...) + ceil(imag(z), args...)im
floor(z::Complex; args...) = floor(real(z), args...) + floor(imag(z), args...)im

import Base: front, tail
front(A::AbstractVector) = A[1:end-1]
tail(A::AbstractVector) = A[2:end]

# https://github.com/JuliaLang/julia/issues/35033
import Base: startswith, endswith
startswith(a, b) = startswith(string(a), string(b))
endswith(a, b) = endswith(string(a), string(b))

# https://github.com/JuliaLang/julia/pull/48894
import Base: AbstractRange, AbstractArray, OrdinalRange
AbstractRange{T}(r::AbstractRange) where {T} = range(T(first(r)), T(last(r)), length(r))
AbstractRange{T}(r::OrdinalRange) where {T<:Integer} = OrdinalRange{T}(r) # float should fall back to StepRangeLen
AbstractRange{T}(r::OrdinalRange) where {T<:Rational} = OrdinalRange{T}(r)
AbstractRange{T}(r::StepRangeLen) where {T} = StepRangeLen{T}(r)
AbstractRange{T}(r::LinRange) where {T} = LinRange{T}(r)
AbstractArray{T,1}(r::AbstractRange) where {T} = AbstractRange{T}(r)
AbstractArray{T}(r::AbstractRange) where {T} = AbstractRange{T}(r)
OrdinalRange{T}(r::OrdinalRange{R,S}) where {T,R,S} = OrdinalRange{T,promote_type(T, S)}(r) # type of step matters
OrdinalRange{T}(r::AbstractUnitRange) where {T} = AbstractUnitRange{T}(r) # not in this case

import Base: Fix2, Fix1, isone, ^, ∘, inv
# problematic in terms of type consistency, but these are not supported by Base at all.
for Fun in (Fix1, Fix2)
    @eval begin
        ∘(f::$Fun{typeof(+)}, g::$Fun{typeof(+)}) = $Fun(+, f.x + g.x)
        ∘(f::$Fun{typeof(*)}, g::$Fun{typeof(*)}) = $Fun(*, f.x * g.x)
        ^(f::$Fun{typeof(+)}, p) = $Fun(+, f.x * p)
        ^(f::$Fun{typeof(*)}, p) = $Fun(*, f.x^p)
        isone(f::$Fun{typeof(+)}) = iszero(f.x)
        isone(f::$Fun{typeof(*)}) = isone(f.x)
    end
end
∘(f::Fix2{typeof(^)}, g::Fix2{typeof(^)}) = Fix2(^, g.x * f.x)
∘(::typeof(abs), ::typeof(abs)) = abs
∘(::typeof(identity), f::Function) = f
∘(f::Function, ::typeof(identity)) = f
∘(::typeof(identity), ::typeof(identity)) = identity
inv(::typeof(identity)) = identity
for (op, invop) in ((exp, ln), (exp10, log10), (exp2, log2))
    @eval begin
        inv(::typeof($op)) = $invop
        inv(::typeof($invop)) = $op
        ∘(::typeof($op), ::typeof($invop)) = identity
        ∘(::typeof($invop), ::typeof($op)) = identity
    end
end
inv(f::ComposedFunction) = inv(f.inner) ∘ inv(f.outer)

import Base: ==
==(f::Function, ::typeof(identity)) = isone(f)
==(::typeof(identity), f::Function) = isone(f)
==(::typeof(identity), ::typeof(identity)) = true # ambiguity

import Base: getproperty, Fix2
getproperty(x) = Fix2(getproperty, x)

# https://github.com/JuliaLang/julia/pull/52312
import Base: first, last, lastindex, front, tail, getindex
first(A::CartesianIndex) = first(Tuple(A))
last(A::CartesianIndex) = last(Tuple(A))
lastindex(A::CartesianIndex) = lastindex(Tuple(A))
front(A::CartesianIndex) = CartesianIndex(front(Tuple(A)))
tail(A::CartesianIndex) = CartesianIndex(tail(Tuple(A)))
getindex(A::CartesianIndex, i) = CartesianIndex(Tuple(A)[i])

import Base: copy
copy(t::Tuple) = t

import Base: Fix1, Fix2, +, -, *, /, //, show, Splat
(t::NTuple{N,Function})(x...) where {N} = tuple((f(x...) for f in t)...)
for op in (:+, :*, :-, :/, ://)
    @eval begin
        $op() = nothing # ambiguity
        $op(f::Function...) = ∘(splat($op), f)
        $op(f::Function, c::Number) = Fix2($op, c) ∘ f
        $op(c::Number, f::Function) = Fix1($op, c) ∘ f
        show(io::IO, f::ComposedFunction{<:Fix1{typeof($op)}}) = print(io, '(', f.outer.x, $op, f.inner, ')')
        show(io::IO, f::ComposedFunction{<:Fix2{typeof($op)}}) = print(io, '(', f.inner, $op, f.outer.x, ')')
        show(io::IO, f::ComposedFunction{Splat{typeof($op)},<:Tuple{Function,Function}}) = print(io, '(', f.inner[1], $op, f.inner[2], ')')
    end
end
show(io::IO, f::ComposedFunction{<:Fix1}) = print(io, f.outer.f, '(', f.outer.x, ',', f.inner, ')')
show(io::IO, f::ComposedFunction{<:Fix2}) = print(io, f.outer.f, '(', f.inner, ',', f.outer.x, ')')

# Against Julia Base
# import Base: sinpi, cospi, tanpi, sincospi
# sinpi(x::Integer) = zero(x)
# cospi(x::Integer) = ifelse(isodd(x), -one(x), one(x))
# tanpi(x::Integer) = zero(x)

# https://github.com/JuliaLang/julia/pull/53360
import Base: mapreduce
mapreduce(f, op) = f()

# https://github.com/JuliaLang/julia/pull/51475
import Base: zero, TwicePrecision
function zero(r::StepRangeLen{T,R,S}) where {T,R,S}
    StepRangeLen{T}(zero(r.ref), zero(r.step), length(r), r.offset)
end
zero(r::LinRange) = LinRange{eltype(r)}(zero(first(r)), zero(last(r)), length(r))
zero(r::Union{UnitRange, StepRange}) = zero(StepRangeLen(r))
zero(r::TwicePrecision) = zero(typeof(r))

import Base: searchsorted, searchsortedfirst, searchsortedlast, Ordering, Forward, ord, keytype, midpoint, lt

function searchsortedfirst(v, x, lo::T, hi::T, o::Ordering)::keytype(v) where {T<:Integer}
    hi = hi + T(1)
    len = hi - lo
    @inbounds while len != 0
        half_len = len >>> 0x01
        m = lo + half_len
        if lt(o, v[m], x)
            lo = m + 1
            len -= half_len + 1
        else
            hi = m
            len = half_len
        end
    end
    return lo
end

function searchsortedlast(v, x, lo::T, hi::T, o::Ordering)::keytype(v) where {T<:Integer}
    u = T(1)
    lo = lo - u
    hi = hi + u
    @inbounds while lo < hi - u
        m = midpoint(lo, hi)
        if lt(o, x, v[m])
            hi = m
        else
            lo = m
        end
    end
    return lo
end

function searchsorted(v, x, ilo::T, ihi::T, o::Ordering)::UnitRange{keytype(v)} where {T<:Integer}
    u = T(1)
    lo = ilo - u
    hi = ihi + u
    @inbounds while lo < hi - u
        m = midpoint(lo, hi)
        if lt(o, v[m], x)
            lo = m
        elseif lt(o, x, v[m])
            hi = m
        else
            a = searchsortedfirst(v, x, max(lo, ilo), m, o)
            b = searchsortedlast(v, x, m, min(hi, ihi), o)
            return a:b
        end
    end
    return (lo+1):(hi-1)
end

for s in [:searchsortedfirst, :searchsortedlast, :searchsorted]
    @eval begin
        $s(v, x, o::Ordering) = $s(v, x, firstindex(v), lastindex(v), o)
        $s(v, x;
            lt=isless, by=identity, rev::Union{Bool,Nothing}=nothing, order::Ordering=Forward) =
            $s(v, x, ord(lt, by, rev, order))
    end
end

# https://github.com/JuliaLang/julia/pull/56433
import Base: (:), +, -, TwicePrecision, zero, IEEEFloat
# zero(::TwicePrecision{T}) where {T} = TwicePrecision(zero(T)) # overwrites https://github.com/JuliaLang/julia/pull/51475
TwicePrecision(x::AbstractIrrational) = TwicePrecision{Float64}(x)
for op in (:+, :-)
    for (prec, twiceprec) in ((Float16, Float32), (Float32, Float64))
        @eval $op(a::AbstractIrrational, b::$prec) = $prec($op($twiceprec(a), b))
        @eval $op(a::$prec, b::AbstractIrrational) = $prec($op(a, $twiceprec(b)))
    end
    @eval function $op(a::AbstractIrrational, b::T) where {T<:AbstractFloat}
        o = precision(BigFloat)
        setprecision(BigFloat, 2 * precision(b) + 1)
        ret = $op(BigFloat(a), b)
        setprecision(BigFloat, o)
        T(ret)
    end
    @eval function $op(a::T, b::AbstractIrrational) where {T<:AbstractFloat}
        o = precision(BigFloat)
        setprecision(BigFloat, 2 * precision(a) + 1)
        ret = $op(a, BigFloat(b))
        setprecision(BigFloat, o)
        T(ret)
    end
end
steprangelen_irrational(::Type{T}, ref::T, step::AbstractIrrational, len::Integer, offset::Integer) where {T<:IEEEFloat} = StepRangeLen{T}(Float64(ref), Float64(step), len, offset)
steprangelen_irrational(::Type{Float64}, ref::T, step::AbstractIrrational, len::Integer, offset::Integer) where {T<:IEEEFloat} = StepRangeLen{T}(TwicePrecision(ref), TwicePrecision(step), len, offset)
function (:)(a::T, b::AbstractIrrational, c::T) where {T<:Real}
    elT = promote_type(T, typeof(b))
    elT(a):b:elT(c)
end
function (:)(start::T, step::AbstractIrrational, stop::T) where {T<:AbstractFloat}
    lf = (stop - start) / step
    if lf < 0
        len = 0
    elseif lf == 0
        len = 1
    else
        len = round(Int, lf) + 1
        stop′ = start + (len - 1) * step
        # if we've overshot the end, subtract one:
        len -= (start < stop < stop′) + (start > stop > stop′)
    end
    steprangelen_irrational(T, start, step, len, 1)
end

end # module
