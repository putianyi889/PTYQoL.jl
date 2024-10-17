module PTYQoLInfiniteArraysExt

# ambiguities
import InfiniteArrays: RealInfinity, PosInfinity, ℵ₀, InfiniteCardinal
import Base: Colon, getindex, OverflowSafe, (:), getindex, OneTo, unitrange_last, _sub2ind_recurse

(:)(start::RealInfinity, step::AbstractFloat, stop::RealInfinity) = (:)(promote(start, step)..., stop)
(:)(::PosInfinity, ::AbstractFloat, ::PosInfinity) = throw(ArgumentError("Cannot create range starting at infinity"))
(:)(::PosInfinity, ::PosInfinity, ::PosInfinity) = throw(ArgumentError("Cannot create range starting at infinity"))

function getindex(x::UnitRange{<:OverflowSafe}, y::InfiniteCardinal{0})
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end
function getindex(x::UnitRange{T}, y::InfiniteCardinal{0}) where T
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end
function getindex(x::OneTo{T}, y::InfiniteCardinal{0}) where T
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end

unitrange_last(::Integer, ::InfiniteCardinal{0}) = ∞

function _sub2ind_recurse(::Tuple{}, L::InfiniteCardinal{0}, ind, i::Integer, I::Vararg{Integer})
    @inline
    _sub2ind_recurse((), L, ind+(i-1)*L, I...)
end

end # module