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
import Base.IteratorsMD: split
import Base: convert, to_indices, _to_subscript_indices, __to_subscript_indices, @_inline_meta, to_index

convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T<:VecElement} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Missing} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Nothing} = convert(T, index[1])
convert(::Type{T}, index::QuasiCartesianIndex{1}) where {T>:Union{Missing, Nothing}} = convert(T, index[1])
convert(::Type{Ref{T}}, x::QuasiCartesianIndex{1}) where {T} = RefValue{T}(x)::RefValue{T}

@inline to_indices(A::AbstractQuasiArray, I::Tuple{}) = to_indices(A, axes(A), I)

# this change happens at https://github.com/JuliaLang/julia/pull/45869
@static if VERSION <= v"1.10.1"
    to_indices(A::AbstractQuasiArray, ::Tuple{}, I::Union{Tuple{BitArray{N}}, Tuple{Array{Bool, N}}}) where N = (@_inline_meta; (to_index(A, I[1]), to_indices(A, (), tail(I))...))
else
    to_indices(A::AbstractQuasiArray, ::Tuple{}, I::Tuple{AbstractArray{Bool, N}, Vararg}) where N = (@_inline_meta; (to_index(A, I[1]), to_indices(A, (), tail(I))...))
end

_to_subscript_indices(A::AbstractQuasiMatrix, J::Tuple, Jrem::Tuple) = J
_to_subscript_indices(A::AbstractQuasiMatrix, J::Tuple, Jrem::Tuple{}) = __to_subscript_indices(A, axes(A), J, Jrem)
function _to_subscript_indices(A::AbstractQuasiArray{T,N}, I::Tuple, J::Tuple) where {T,N}
    @_inline_meta
    J, Jrem = split((I,J), Val(N))
    _to_subscript_indices(A, J, Jrem)
end
_to_subscript_indices(::AbstractQuasiArray{T,0}, ::Tuple, ::Tuple{}) where T = ()
_to_subscript_indices(::AbstractQuasiArray{T,0}, ::Tuple, ::Tuple) where T = ()

rowsupport(B::MulQuasiArray, i::CartesianIndex{2}) = rowsupport(B, first(i))
colsupport(B::MulQuasiArray, i::CartesianIndex{2}) = colsupport(B, last(i))

end