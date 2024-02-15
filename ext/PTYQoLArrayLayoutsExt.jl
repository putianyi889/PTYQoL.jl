module PTYQoLArrayLayoutsExt

# https://github.com/JuliaLinearAlgebra/ArrayLayouts.jl/pull/184
import ArrayLayouts: rowsupport, colsupport
import Base: Slice

rowsupport(A, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A, i::CartesianIndex{2}) = colsupport(A, last(i))
rowsupport(A::SubArray{<:Any,N,<:Any,<:Tuple{Slice,AbstractVector}}, i::CartesianIndex{2}) where N = rowsupport(A, first(i))
colsupport(A::SubArray{<:Any,N,<:Any,<:Tuple{Slice,AbstractVector}}, i::CartesianIndex{2}) where N = colsupport(A, last(i))

end