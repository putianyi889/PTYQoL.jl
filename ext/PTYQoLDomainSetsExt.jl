module PTYQoLDomainSetsExt

# ambiguities
import DomainSets: AnyDomain, setdiffdomain, domain, AffineMap, isaffine, matrix, vector, isequaldomain, uniondomain, DomainStyle
import Base: setdiff, ==, convert, union, intersect, @deprecate

setdiff(d1::AbstractSet, d2::AnyDomain) = setdiffdomain(d1, domain(d2))

union(d1::BitSet, d2::AnyDomain, domains...) = uniondomain(d1, domain(d2), domains...)
@deprecate intersect(d1::AbstractSet, d2::AnyDomain) intersect(DomainRef(d1), d2)

==(d1::AnyDomain, d2::WeakRef) = isequaldomain(domain(d1), d2)
==(::AnyDomain, ::Missing) = missing
==(::Missing, ::AnyDomain) = missing

end # module