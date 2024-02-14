module PTYQoLDomainSetsExt

# ambiguities
import DomainSets: AnyDomain, setdiffdomain, domain, AffineMap, isaffine, matrix, vector, isequaldomain
import Base: setdiff, ==

setdiff(d1::AbstractSet, d2::AnyDomain) = setdiffdomain(d1, domain(d2))

==(d1::AnyDomain, d2::WeakRef) = isequaldomain(domain(d1), d2)

convert(::Type{AffineMap}, m::AffineMap) = (@assert isaffine(m); AffineMap(matrix(m), vector(m)))

end # module