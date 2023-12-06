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
(t::NTuple{N, Function})(x...) where N = tuple((f(x...) for f in t)...)
for op in (:+, :*, :-, :/, ://)
    @eval begin
        $op() = nothing # ambiguity
        $op(f::Function...) = ∘(splat($op), f)
        $op(f::Function, c::Number) = Fix2($op, c) ∘ f
        $op(c::Number, f::Function) = Fix1($op, c) ∘ f
        show(io::IO, f::ComposedFunction{<:Fix1{typeof($op)}}) = print(io, '(', f.outer.x, $op, f.inner, ')')
        show(io::IO, f::ComposedFunction{<:Fix2{typeof($op)}}) = print(io, '(', f.inner, $op, f.outer.x, ')')
        show(io::IO, f::ComposedFunction{Splat{typeof($op)}, <:Tuple{Function, Function}}) = print(io, '(', f.inner[1], $op, f.inner[2], ')')
    end
end
show(io::IO, f::ComposedFunction{<:Fix1}) = print(io, f.outer.f, '(', f.outer.x, ',', f.inner, ')')
show(io::IO, f::ComposedFunction{<:Fix2}) = print(io, f.outer.f, '(', f.inner, ',', f.outer.x, ')')

end
