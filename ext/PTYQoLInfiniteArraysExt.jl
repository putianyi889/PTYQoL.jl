module PTYQoLInfiniteArraysExt

# ambiguities
import InfiniteArrays: RealInfinity, PosInfinity, ℵ₀
import Base: Colon, getindex, OverflowSafe

(:)(start::RealInfinity, step::AbstractFloat, stop::RealInfinity) = (:)(promote(start, step)..., stop)

function getindex(x::UnitRange{OverflowSafe}, y::PosInfinity)
    isinf(length(x)) || throw(BoundsError(x,y))
    ℵ₀
end

end # module