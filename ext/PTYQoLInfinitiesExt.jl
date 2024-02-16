module PTYQoLInfinitiesExt

import Base: +, -, *, div, cld, mod, ==, <, isless, ≤, fld, TwicePrecision, AbstractChar
import Base.Checked: checked_sub, checked_mul
import Infinities: InfiniteCardinal, ∞, Infinity, ComplexInfinity, RealInfinity, NotANumber, ℵ₀

RealInfinity(x::Complex) = RealInfinity(Bool(x))
RealInfinity(x::TwicePrecision) = RealInfinity(Bool(x))
ComplexInfinity(x::Complex) = ComplexInfinity(Real(x))
ComplexInfinity{T}(x::AbstractChar) where T<:Real = ComplexInfinity(Real(x))

+(::InfiniteCardinal, x::Rational) = ∞ + x
+(x::Rational, ::InfiniteCardinal) = x + ∞
+(x::Complex, ::InfiniteCardinal) = x + ∞
+(x::Complex{Bool}, ::InfiniteCardinal) = x + ∞
+(::InfiniteCardinal, x::Complex{Bool}) = ∞ + x
+(::InfiniteCardinal, x::Complex) = ∞ + x

-(x::InfiniteCardinal, y::InfiniteCardinal) = x > y ? x : -∞
-(x::Infinity, y::ComplexInfinity) = x + (-y)
-(::InfiniteCardinal, x::Complex{Bool}) = ∞ - x
-(::InfiniteCardinal, x::Complex) = ∞ - x
-(::InfiniteCardinal, x::Rational) = ∞ - x
-(x::Complex, ::InfiniteCardinal) = x - ∞
-(x::Complex{Bool}, ::InfiniteCardinal) = x - ∞
-(x::Rational, ::InfiniteCardinal) = x - ∞
-(::Complex{Bool}, y::RealInfinity) = -y
-(::Complex, y::RealInfinity) = -y

*(x::InfiniteCardinal, y::InfiniteCardinal) = max(x,y)
*(x::InfiniteCardinal, y::Complex) = y*x
*(x::InfiniteCardinal, y::Complex{Bool}) = y*x
*(x::RealInfinity, y::Complex{Bool}) = ComplexInfinity(x)*y
*(a::Complex{Bool}, y::Infinity) = a*ComplexInfinity(y)
*(a::Complex{Bool},y::RealInfinity) = a*ComplexInfinity(y)
*(a::Rational, ::InfiniteCardinal) = a * ∞
*(a::Complex{Bool}, b::InfiniteCardinal) = a * ∞
*(a::Complex, b::InfiniteCardinal) = a * ∞
*(a::InfiniteCardinal, b::Rational) = b*a

div(x::InfiniteCardinal, ::Rational) = x
div(x::Rational, ::InfiniteCardinal) = zero(x)

cld(x::Rational, ::InfiniteCardinal) = signbit(x) ? zero(x) : one(x)
cld(x::InfiniteCardinal, ::Rational) = x

fld(x::InfiniteCardinal, ::Rational) = x
fld(x::Rational, ::InfiniteCardinal) = signbit(x) ? -one(x) : zero(x)

mod(::RealInfinity, ::InfiniteCardinal) = NotANumber()
mod(::InfiniteCardinal, ::Rational) = NotANumber()
function mod(x::Rational, ::InfiniteCardinal)
    x ≥ 0 || throw(ArgumentError("mod(x,∞) is unbounded for x < 0"))
    x
end

==(x::Complex, y::RealInfinity) = y==x
==(x::AbstractIrrational, y::RealInfinity) = y==x
==(x::RealInfinity, y::AbstractIrrational) = isinf(y) && signbit(y) == signbit(x)
==(x::RealInfinity, y::Complex) = isinf(y) && signbit(y) == signbit(x)
==(::InfiniteCardinal, y::AbstractIrrational) = ∞ == y
==(y::AbstractIrrational, x::Infinity) = x == y
==(x::AbstractIrrational, ::InfiniteCardinal) = x == ∞
==(x::Rational, ::InfiniteCardinal) = x == ∞
==(y::Complex, x::Infinity) = x == y
==(x::Infinity, y::Complex) = isinf(y) && angle(y) == angle(x)

<(::InfiniteCardinal, ::Rational) = false
<(x::Rational, ::InfiniteCardinal) = true
<(x::Rational, ::InfiniteCardinal{0}) = x < ∞

≤(::InfiniteCardinal{0}, x::Rational) = ∞ ≤ x
≤(::InfiniteCardinal, x::Rational) = false
≤(x::Rational, ::InfiniteCardinal) = true

isless(::InfiniteCardinal, ::InfiniteCardinal{0}) = false
isless(x::RealInfinity, y::ComplexInfinity{Bool}) = signbit(x) && y ≠ -∞

checked_sub(::InfiniteCardinal{0}, ::InfiniteCardinal{0}) = NotANumber()

checked_mul(::InfiniteCardinal{0}, ::InfiniteCardinal{0}) = ℵ₀

end # module