module PTYQoLArrayLayoutsExt

# https://github.com/JuliaLinearAlgebra/ArrayLayouts.jl/pull/184
import ArrayLayouts: rowsupport, colsupport

rowsupport(A, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A, i::CartesianIndex{2}) = colsupport(A, last(i))

end