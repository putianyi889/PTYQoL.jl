module PTYQoLBandedMatricesExt

import BandedMatrices: inbands_getindex, inbands_setindex!, AbstractBandedMatrix, bandwidths, MemoryLayout, BandedLayout, BandedMatrix
import Base: getindex, setindex!, @propagate_inbounds, convert

# too tedious to test

MemoryLayout(::Type{<:AbstractBandedMatrix}) = BandedLayout()

@propagate_inbounds function getindex(A::AbstractBandedMatrix, j::Integer, k::Integer)
    @boundscheck checkbounds(A, j, k)
    l, u = bandwidths(A)
    if -l ≤ k-j ≤ u
        inbands_getindex(A, j, k)
    else
        zero(eltype(A))
    end
end

@propagate_inbounds function setindex!(A::AbstractBandedMatrix, v, j::Integer, k::Integer)
    @boundscheck checkbounds(A, j, k)
    l, u = bandwidths(A)
    if -l ≤ k-j ≤ u
        inbands_setindex!(A, v, j, k)
    elseif iszero(v)
        zero(eltype(A))
    else
        error("out of band.")
    end
end

end