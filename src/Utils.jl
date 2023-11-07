import Base: front
export seealso
"""
    seealso(s...)

Produce the "See also" parts of docstrings. $(seealso(docref, langenum))

```jldoctest
julia> seealso(sin)
"See also [`sin`](@ref)."

julia> seealso(sin, cos)
"See also [`sin`](@ref) and [`cos`](@ref)."

julia> seealso(sin, cos, tan)
"See also [`sin`](@ref), [`cos`](@ref) and [`tan`](@ref)."
```
"""
seealso(s...) = "See also " * langenum(map(docref, s)...) * "."

docref(s) = "[`$(string(s))`](@ref)"

langenum(s) = s
langenum(s, t) = s * " and " * t
langenum(s, t...) = s * ", " *langenum(t...)