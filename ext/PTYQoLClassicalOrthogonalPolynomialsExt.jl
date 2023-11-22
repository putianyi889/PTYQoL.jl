module PTYQoLClassicalOrthogonalPolynomialsExt

import ClassicalOrthogonalPolynomials: AbstractJacobi, Jacobi, Chebyshev, Legendre, Ultraspherical

AbstractJacobi{T}(a::Jacobi) where T = Jacobi{T}(a)
AbstractJacobi{T}(a::Chebyshev{kind}) where T where kind = Chebyshev{kind,T}(a)
AbstractJacobi{T}(a::Legendre) where T = Legendre{T}(a)
AbstractJacobi{T}(a::Ultraspherical) where T = Ultraspherical{T}(a)

Jacobi{T}(a::Jacobi) where T = Jacobi(T(a.a), T(a.b))

end