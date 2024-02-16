module PTYQoLQuasiArraysExt

import Base: union, Fix2, Fix1, broadcasted, literal_pow
import QuasiArrays: BroadcastQuasiVector, LazyQuasiArrayStyle, AbstractQuasiVector, AbstractQuasiFill

broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), x::AbstractQuasiVector, b::Number) = Fix2(^, b).(x)
broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), x::AbstractQuasiFill{T,1}, b::Number) where T = Fix2(^, b).(x)
broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), a::Number, x::AbstractQuasiVector) = Fix1(^, a).(x)
broadcasted(::LazyQuasiArrayStyle{1}, ::typeof(^), a::Number, x::AbstractQuasiFill{T,1}) where T = Fix1(^, a).(x)
broadcasted(::typeof(literal_pow), ::typeof(^), x::AbstractQuasiVector, ::Val{b}) where b = Fix2(^, b).(x)

# ambiguities
import QuasiArrays: AbstractQuasiArray, AbstractQuasiMatrix, rowsupport, colsupport, MulQuasiArray
import QuasiArrays.QuasiIteratorsMD: QuasiCartesianIndex
import Base: convert, to_indices, _to_subscript_indices, __to_subscript_indices

convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T<:VecElement} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Missing} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Nothing} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Union{Missing, Nothing}} = convert(T, index[1])

@inline to_indices(A::AbstractQuasiArray, I::Tuple{}) = to_indices(A, axes(A), I)

_to_subscript_indices(A::AbstractQuasiMatrix, J::Tuple, Jrem::Tuple) = J
_to_subscript_indices(A::AbstractQuasiMatrix, J::Tuple, Jrem::Tuple{}) = __to_subscript_indices(A, axes(A), J, Jrem)

rowsupport(B::MulQuasiArray, i::CartesianIndex{2}) = rowsupport(B, first(i))
colsupport(B::MulQuasiArray, i::CartesianIndex{2}) = colsupport(B, last(i))

end