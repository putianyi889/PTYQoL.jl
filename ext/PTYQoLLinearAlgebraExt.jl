module PTYQoLLinearAlgebraExt

import LinearAlgebra.BLAS: dotu
dotu(x, y) = mapreduce(*, +, x, y)
dotu(x, incx, y, incy) = dotu(view(x, firstindex(x):incx:lastindex(x)), view(y, firstindex(y):incy:lastindex(y)))
dotu(n, x, incx, y, incy) = dotu(view(x, range(start=1, step=incx, length=n)), view(y, range(start=1, step=incy, length=n)))

end