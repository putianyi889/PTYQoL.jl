module PTYQoLAlgebraicNumbersExt

import AlgebraicNumbers: sin_alg, cos_alg, AlgebraicNumber
import Base: sinpi, cospi, tanpi, sincospi, sind, cosd, sincosd, promote_rule, float

export tan_alg, sincos_alg

tan_alg(x) = sin_alg(x) // cos_alg(x)
sincos_alg(x) = (sin_alg(x), cos_alg(x))

for (fd, fpi, falg) in ((:sind, :sinpi, :sin_alg), (:cosd, :cospi, :cos_alg), (:tand, :tanpi, :tan_alg), (:sincosd, :sincospi, :sincos_alg))
    @eval begin
        $fpi(x::Rational) = $falg(x)
        $fpi(x::AlgebraicNumber) = $falg(x)
        $fd(x::Integer) = $falg(x//180)
        $fd(x::Rational) = $falg(x//180)
    end
end

promote_rule(::Type{<:AlgebraicNumber}, ::Type{T}) where T <: AbstractFloat = T
float(x::AlgebraicNumber) = x.apprx
(::Type{T})(x::AlgebraicNumber) where T<:Number = T(x.apprx)
AlgebraicNumber(x::AlgebraicNumber) = x

end # module