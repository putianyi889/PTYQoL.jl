module PTYQoLCircularArraysExt

import CircularArrays: CircularArray
"""
    CircularMatrix{T,A} <: AbstractVector{T}
    
Two-dimensional array backed by an `AbstractArray{T, 2}` of type `A` with fixed size and circular indexing.
Alias for [`CircularArray{T,2,A}`](@ref).
"""
const CircularMatrix{T} = CircularArray{T, 2}

# ambiguities
import Base: similar
import CircularArrays: CircularArray, _similar

# https://github.com/Vexatos/CircularArrays.jl/pull/31
@inline similar(arr::CircularArray, ::Type{T}, dims::Tuple{Integer, Vararg{Integer}}) where T = _similar(arr, T, dims)

end
