# Type piracies

These features are not available in raw Julia, so introducing them should not break anything, except potential ambiguities against other packages.

## `//` falls back to `/` for general arguments
```jldoctest
julia> 1.0 // 2.0
0.5
```

## `Complex` supports `eps`, `precision`, `ceil` and `floor`
```jldoctest
julia> eps(1.0+im)
2.220446049250313e-16

julia> precision(1.0+im)
53

julia> ceil(0.5+0.5im)
1.0 + 1.0im

julia> floor(0.5+0.5im)
0.0 + 0.0im
```

## `AbstractVector` supports `Base.front` and `Base.tail`
```jldoctest
julia> Base.front([1,2,3])
2-element Vector{Int64}:
 1
 2

julia> Base.tail(1:10)
2:10
```

## Function compositions of `Fix`
```jldoctest
julia> Base.Fix1(+, 1) ∘ Base.Fix1(+, 2) === Base.Fix1(+, 3)
true

julia> Base.Fix2(*, 2) ∘ Base.Fix2(*, 3) === Base.Fix2(*, 6)
true

julia> Base.Fix1(+, 2)^3 === Base.Fix1(+, 6)
true

julia> exp2 ∘ log2 === identity
true
```

!!! note
    This feature is not numerically consistent. For example, `log2(exp2(x)) == x` is not always true.

## Others
- Tuple copying
- In raw Julia, `searchsorted`, `searchsortedfirst` and `searchsortedlast` only support `AbstractVector` when the starting index and the ending index are specified. The support is now extended to anything that supports `getindex`.
- `summary` now supports several inputs like `print`. The outputs are separated by commas.
