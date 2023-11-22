import Base: front
export seealso, fields, @struct_equal, @struct_map

docref(s) = "[`$(string(s))`](@ref)"

langenum(s) = s
langenum(s, t) = s * " and " * t
langenum(s, t...) = s * ", " *langenum(t...)
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

"""
    @generated fields(::Type{T}) where T = fieldnames(T)

The same as `fieldnames`, but is `@generated` so is fast.
"""
@generated fields(::Type{T}) where T = fieldnames(T)

"""
    @struct_equal(TYP)

Generate `Base.==` for comparing structs of type `TYP`.

# Example
```jldoctest
julia> struct Foo
       a
       b
       end

julia> x = Foo(1,1)
Foo(1, 1)

julia> y = Foo(1.0,1.0)
Foo(1.0, 1.0)

julia> x==y
false

julia> @struct_equal Foo;

julia> x==y
true
```
"""
macro struct_equal(TYP)
    esc(quote
        import Base: ==
        function ==(A::T1, B::T2) where {T1<:$TYP, T2<:$TYP}
            for p in fields($TYP)
                if getfield(A, p) != getfield(B, p)
                    return false
                end
            end
            return true
        end
    end)
end

"""
    @struct_map(TYP, op)
    @struct_map(TYP, ops...)

Define the function(s) of the type `TYP` by applying the function(s) to each field and generate a new `TYP` with the values. The generated function(s) are somehow faster than the naive implementation.

# Example
```jldoctest
julia> struct Foo
       a
       b
       end

julia> x = Foo(1,1)
Foo(1, 1)

julia> @struct_map(Foo, Base.exp, Base.sin, Base.:+)

julia> exp(x), sin(x), x+x
(Foo(2.718281828459045, 2.718281828459045), Foo(0.8414709848078965, 0.8414709848078965), Foo(2, 2))
```
"""
macro struct_map(TYP, op)
    esc(quote
        function $op(A::$TYP...)
            $TYP(($op(getfield.(A, p)...) for p in fields($TYP))...)
        end
    end)
end

macro struct_map(TYP, ops...)
    esc(quote
        @struct_map($TYP, $(Base.first(ops)))
        @struct_map($TYP, $(Base.tail(ops)...))
    end)
end

export ln
"""
    ln(x) = log(x)

The same as `log` but only accepts one argument.
"""
ln(x::Number) = log(x)

export precision_convert
precision_convert(::Type{BigFloat}, x, precision) = BigFloat(x, precision = precision)
precision_convert(T, x, precision) = convert(T, x)