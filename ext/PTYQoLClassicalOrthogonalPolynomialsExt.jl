module PTYQoLClassicalOrthogonalPolynomialsExt

import ClassicalOrthogonalPolynomials: AbstractJacobi, Jacobi, Chebyshev, Legendre, Ultraspherical

AbstractJacobi{T}(a::Jacobi) where T = Jacobi{T}(a)
AbstractJacobi{T}(::Chebyshev{kind}) where T where kind = Chebyshev{kind,T}()
AbstractJacobi{T}(::Legendre) where T = Legendre{T}()
AbstractJacobi{T}(a::Ultraspherical) where T = Ultraspherical{T}(a)

Jacobi{T}(a::Jacobi) where T = Jacobi(T(a.a), T(a.b))

# ambiguities
import Base: _sum, array_summary, dims2string
import ClassicalOrthogonalPolynomials: Weighted, ChebyshevU, PiecewiseInterlace, BlockBroadcastArray, rowsupport, colsupport, LanczosConversion, Legendre, LanczosJacobiBand, Clenshaw, SymTridiagonal
_sum(::Weighted{T,<:ChebyshevU}, ::Colon) where T = @assert Colon()==1
_sum(::Weighted{T,<:Chebyshev}, ::Colon) where T = @assert Colon()==1
_sum(::Legendre, ::Colon) = @assert Colon()==1
_sum(::AbstractJacobi, ::Colon) = @assert Colon()==1
_sum(P::PiecewiseInterlace, ::Colon) = BlockBroadcastArray(hcat, unitblocks.(_sum.(P.args, Colon()))...)

rowsupport(A::LanczosConversion, i::CartesianIndex{2}) = rowsupport(A, first(i))
colsupport(A::LanczosConversion, i::CartesianIndex{2}) = colsupport(A, last(i))

array_summary(io::IO, ::LanczosJacobiBand{T}, inds::Tuple{}) where T = print(io, dims2string(length.(inds)), " LanczosJacobiBand{$T}")
array_summary(io::IO, C::Clenshaw{T}, inds::Tuple{}) where T = print(io, dims2string(length.(inds)), " Clenshaw{$T} with $(length(C.c)) degree polynomial")
array_summary(io::IO, ::SymTridiagonal{T,<:LanczosJacobiBand}, inds::Tuple{}) where T = print(io, dims2string(length.(inds)), " SymTridiagonal{$T} Jacobi operator from Lanczos")
Base.array_summary(io::IO, ::LanczosConversion{T}, inds::Tuple{}) where T = print(io, dims2string(length.(inds)), " LanczosConversion{$T}")

end