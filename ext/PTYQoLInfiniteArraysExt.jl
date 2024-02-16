module PTYQoLInfiniteArraysExt

# ambiguities
import InfiniteArrays: RealInfinity, PosInfinity, ℵ₀, InfiniteCardinal
import Base: Colon, getindex, OverflowSafe, (:), getindex, OneTo

(:)(start::RealInfinity, step::AbstractFloat, stop::RealInfinity) = (:)(promote(start, step)..., stop)
(:)(::PosInfinity, ::AbstractFloat, ::PosInfinity) = throw(ArgumentError("Cannot create range starting at infinity"))
(:)(::PosInfinity, ::PosInfinity, ::PosInfinity) = throw(ArgumentError("Cannot create range starting at infinity"))

function getindex(x::UnitRange{<:OverflowSafe}, y::InfiniteCardinal{0})
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end
function getindex(x::UnitRange, y::InfiniteCardinal{0})
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end
function getindex(x::OneTo, y::InfiniteCardinal{0})
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end

end # module