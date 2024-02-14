module PTYQoLInfinitiesExt

import Base: +, -, *, div, cld, mod, ==, <, isless, ≤, fld
import Base.Checked: checked_sub, checked_mul
import Infinities: InfiniteCardinal, ∞, Infinity, ComplexInfinity, RealInfinity, NotANumber, ℵ₀

+(::InfiniteCardinal, x::Rational) = ∞ + x
+(x::Rational, ::InfiniteCardinal) = x + ∞
+(::InfiniteCardinal, x::Complex{Bool}) = ∞ + x
+(::InfiniteCardinal, x::Complex) = ∞ + x

-(x::InfiniteCardinal, y::InfiniteCardinal) = x > y ? x : -∞
-(x::Infinity, y::ComplexInfinity) = x + (-y)
-(::InfiniteCardinal, x::Complex{Bool}) = ∞ - x
-(x::Complex, ::InfiniteCardinal) = x - ∞

*(x::InfiniteCardinal, y::InfiniteCardinal) = max(x,y)
*(x::InfiniteCardinal, y::Complex) = y*x
*(x::RealInfinity, y::Complex{Bool}) = ComplexInfinity(x)*y
*(a::Complex{Bool}, y::Infinity) = a*ComplexInfinity(y)
*(a::Complex{Bool},y::RealInfinity) = a*ComplexInfinity(y)
*(a::Rational, ::InfiniteCardinal) = a * ∞
*(a::InfiniteCardinal, b::Rational) = b*a

div(x::InfiniteCardinal, ::Rational) = x

cld(x::Rational, ::InfiniteCardinal) = signbit(x) ? zero(x) : one(x)
cld(x::InfiniteCardinal, ::Rational) = x

fld(x::InfiniteCardinal, ::Rational) = x

mod(::RealInfinity, ::InfiniteCardinal) = NotANumber()

==(x::Complex, y::RealInfinity) = y==x
==(x::AbstractIrrational, y::RealInfinity) = y==x
==(x::RealInfinity, y::AbstractIrrational) = isinf(y) && signbit(y) == signbit(x)
==(::InfiniteCardinal, y::AbstractIrrational) = ∞ == y
==(y::AbstractIrrational, x::Infinity) = x == y
==(x::AbstractIrrational, ::InfiniteCardinal) = x == ∞
==(y::Complex, x::Infinity) = x == y

<(::InfiniteCardinal, ::Rational) = false
<(x::Rational, ::InfiniteCardinal{0}) = x < ∞

≤(::InfiniteCardinal{0}, x::Rational) = ∞ ≤ x

isless(::InfiniteCardinal, ::InfiniteCardinal{0}) = false
isless(x::RealInfinity, y::ComplexInfinity{Bool}) = signbit(x) && y ≠ -∞

checked_sub(::InfiniteCardinal{0}, ::InfiniteCardinal{0}) = NotANumber()

checked_mul(::InfiniteCardinal{0}, ::InfiniteCardinal{0}) = ℵ₀

end # module