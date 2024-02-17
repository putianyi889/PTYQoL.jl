module PTYQoLBlockArraysExt

# ambiguities
import BlockArrays: BlockArray, to_axes, colsupport, rowsupport, PseudoBlockArray, _pseudo_reshape
import Base: OneTo, similar, reshape

@inline similar(::BlockArray, ::Type{T}, axes::Tuple{Union{Integer, OneTo}, Vararg{Union{Integer, OneTo}}}) where T = BlockArray{T}(undef, map(to_axes,axes))
@inline similar(::BlockArray, ::Type{T}, axes::Tuple{Integer, Vararg{Integer}}) where T = BlockArray{T}(undef, map(to_axes,axes))

rowsupport(A::PseudoBlockArray, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A::PseudoBlockArray, i::CartesianIndex{2}) = colsupport(A, last(i))

reshape(block_array::PseudoBlockArray, axes::Tuple{}) where N = _pseudo_reshape(block_array, axes)

end # module