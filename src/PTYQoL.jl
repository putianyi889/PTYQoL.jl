module PTYQoL

include("Utils.jl")

import Base: //
//(x, y) = x / y

import Base: eps, ceil, floor, precision
eps(::Type{Complex{T}}) where T = eps(T)
precision(::Type{Complex{T}}) where T = precision(T)
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
import Base: AbstractRange, AbstractArray
AbstractRange{T}(r::AbstractRange) where T<:Real = T(first(r)):T(step(r)):T(last(r))
AbstractArray{T,1}(r::AbstractRange) where T<:Real = AbstractRange{T}(r)
AbstractArray{T}(r::AbstractRange) where T<:Real = AbstractRange{T}(r)
AbstractRange{T}(r::AbstractUnitRange) where {T<:Integer} = AbstractUnitRange{T}(r)

import Base: Fix2, Fix1, isone, ^, ∘, inv
# problematic in terms of type consistency, but these are not supported by Base at all.
for Fun in (Fix1, Fix2)
    @eval begin
        ∘(f::$Fun{typeof(+)}, g::$Fun{typeof(+)}) = $Fun(+, f.x+g.x)
        ∘(f::$Fun{typeof(*)}, g::$Fun{typeof(*)}) = $Fun(*, f.x*g.x)
        ^(f::$Fun{typeof(+)}, p) = $Fun(+, f.x*p)
        ^(f::$Fun{typeof(*)}, p) = $Fun(*, f.x^p)
        isone(f::$Fun{typeof(+)}) = iszero(f.x)
        isone(f::$Fun{typeof(*)}) = isone(f.x)
    end
end
∘(f::Fix2{typeof(^)}, g::Fix2{typeof(^)}) = Fix2(^, g.x*f.x)
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

end
