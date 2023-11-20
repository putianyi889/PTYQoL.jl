module PTYQoLCircularArraysExt

import CircularArrays: CircularArray
"""
    CircularMatrix{T,A} <: AbstractVector{T}
    
Two-dimensional array backed by an `AbstractArray{T, 2}` of type `A` with fixed size and circular indexing.
Alias for [`CircularArray{T,2,A}`](@ref).
"""
const CircularMatrix{T} = CircularArray{T, 2}

end
