module PTYQoLBlockArraysExt

import BlockArrays: findblockindex, BlockIndex
import Base.IteratorsMD: flatten

function findblockindex(A::AbstractArray{T,N}, I::Tuple{Vararg{Integer,N}}) where {T,N}
    blockinds = findblockindex.(axes(A), I)
    BlockIndex(flatten(map(x->x.I, blockinds)), flatten(map(x->x.α, blockinds)))
end

# ambiguities
import BlockArrays: BlockArray, to_axes, colsupport, rowsupport, PseudoBlockArray, _pseudo_reshape
import Base: OneTo, similar, reshape

@inline similar(::BlockArray, ::Type{T}, axes::Tuple{Union{Integer, OneTo}, Vararg{Union{Integer, OneTo}}}) where T = BlockArray{T}(undef, map(to_axes,axes))
@inline similar(::BlockArray, ::Type{T}, axes::Tuple{Integer, Vararg{Integer}}) where T = BlockArray{T}(undef, map(to_axes,axes))

rowsupport(A::PseudoBlockArray, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A::PseudoBlockArray, i::CartesianIndex{2}) = colsupport(A, last(i))

reshape(block_array::PseudoBlockArray, axes::Tuple{}) = _pseudo_reshape(block_array, axes)
reshape(block_array::BlockArray, dims::Tuple{Vararg{Int}}) = reshape(PseudoBlockArray(block_array), dims)
reshape(block_array::BlockArray, dims::Tuple{}) = reshape(PseudoBlockArray(block_array), dims)

end # module