module PTYQoL

import Base: //
//(x, y) = x / y

import Base: eps, ceil, floor
eps(::Type{Complex{T}}) where T = eps(T)
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

import Base: Fix2, Fix1, isone, ^, ∘
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

import Base: ==
==(f::Function, ::typeof(identity)) = isone(f)
==(::typeof(identity), f::Function) = isone(f)

include("Utils.jl")

end
