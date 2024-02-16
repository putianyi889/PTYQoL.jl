module PTYQoLDomainSetsExt

# ambiguities
import DomainSets: AnyDomain, setdiffdomain, domain, AffineMap, isaffine, matrix, vector, isequaldomain, uniondomain
import Base: setdiff, ==, convert, union

setdiff(d1::AbstractSet, d2::AnyDomain) = setdiffdomain(d1, domain(d2))

union(d1::BitSet, d2::AnyDomain, domains...) = uniondomain(d1, domain(d2), domains...)

==(d1::AnyDomain, d2::WeakRef) = isequaldomain(domain(d1), d2)
==(::AnyDomain, ::Missing) = missing
==(::Missing, ::AnyDomain) = missing

convert(::Type{AffineMap}, m::AffineMap) = m
convert(::Type{AffineMap{T}}, m::AffineMap{T}) where T = m

end # module