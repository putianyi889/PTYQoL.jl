module PTYQoLClassicalOrthogonalPolynomialsExt

import ClassicalOrthogonalPolynomials: AbstractJacobi, Jacobi, Chebyshev, Legendre, Ultraspherical

AbstractJacobi{T}(a::Jacobi) where T = Jacobi{T}(a)
AbstractJacobi{T}(::Chebyshev{kind}) where T where kind = Chebyshev{kind,T}()
AbstractJacobi{T}(::Legendre) where T = Legendre{T}()
AbstractJacobi{T}(a::Ultraspherical) where T = Ultraspherical{T}(a)

Jacobi{T}(a::Jacobi) where T = Jacobi(T(a.a), T(a.b))

# ambiguities
import Base: _sum
import ClassicalOrthogonalPolynomials: Weighted, ChebyshevU, PiecewiseInterlace, BlockBroadcastArray
_sum(::Weighted{T,<:ChebyshevU}, ::Colon) where T = @assert Colon()==1
_sum(::Weighted{T,<:Chebyshev}, ::Colon) where T = @assert Colon()==1
_sum(P::PiecewiseInterlace, ::Colon) = BlockBroadcastArray(hcat, unitblocks.(_sum.(P.args, Colon()))...)

end