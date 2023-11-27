module PTYQoLArrayLayoutsExt

import ArrayLayouts: rowsupport, colsupport

rowsupport(A, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A, i::CartesianIndex{2}) = colsupport(A, last(i))

end