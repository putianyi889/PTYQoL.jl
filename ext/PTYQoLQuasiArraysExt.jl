module PTYQoLQuasiArraysExt

import Base: union, Fix2, Fix1, broadcasted, literal_pow
import QuasiArrays: BroadcastQuasiVector, LazyQuasiArrayStyle, AbstractQuasiVector

broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), x::AbstractQuasiVector, b::Number) = Fix2(^, b).(x)
broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), a::Number, x::AbstractQuasiVector) = Fix1(^, a).(x)
broadcasted(::typeof(literal_pow), ::typeof(^), x::AbstractQuasiVector, ::Val{b}) where b = Fix2(^, b).(x)

end