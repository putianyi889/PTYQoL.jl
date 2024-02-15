module PTYQoLBlockBandedMatricesExt

# ambiguities
import Base: DimOrInd, to_shape
import BlockBandedMatrices: BandedBlockBandedMatrix

similar(a::BandedBlockBandedMatrix, ::Type{T}, dims::DimOrInd...) where {T}  = similar(a, T, to_shape(dims))

end # module