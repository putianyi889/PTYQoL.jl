module PTYQoLAlgebraicNumbersExt

import AlgebraicNumbers: sin_alg, cos_alg, AlgebraicNumber
import Base: promote_rule, float

# https://github.com/anj1/AlgebraicNumbers.jl/pull/35
promote_rule(::Type{<:AlgebraicNumber}, ::Type{T}) where T <: AbstractFloat = T
float(x::AlgebraicNumber) = x.apprx
(::Type{T})(x::AlgebraicNumber) where T<:AbstractFloat = T(x.apprx)

AlgebraicNumber(x::AlgebraicNumber) = x

end # module