module PTYQoLContinuumArraysExt

import Base: union, Fix2, isempty
import ContinuumArrays: AbstractInterval, BroadcastQuasiVector, Interval, Inclusion, endpoints, isleftclosed, isrightclosed

function union(x::BroadcastQuasiVector{T, <:Fix2{typeof(^), <:Number}, <:Tuple{Inclusion{T, <:AbstractInterval}}}) where T
    p = x.f.x
    I = first(x.args).domain
    a, b = endpoints(I)
    if isempty(I) || b ≤ 0
        Inclusion(Interval{:open, :open}(zero(T), zero(T)))
    elseif iszero(p)
        Inclusion(Interval{:closed, :closed}(one(T), one(T)))
    else
        R = ifelse(isrightclosed(I), :closed, :open)
        if a ≥ 0
            L = ifelse(isleftclosed(I), :closed, :open)
        else
            L = :closed
            a = zero(T)
        end
        if p < 0
            Inclusion(Interval{R, L}(b^p, a^p))
        else
            Inclusion(Interval{L, R}(a^p, b^p))
        end
    end            
end

isempty(a::Inclusion) = isempty(a.domain)

# ambiguities
import ContinuumArrays: LinearSpline, HeavisideSpline
import Base: _sum

_sum(::HeavisideSpline, ::Colon) = error("not implemented")
_sum(::LinearSpline, ::Colon) = error("not implemented")

end