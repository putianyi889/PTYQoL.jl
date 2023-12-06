import Base: front
export seealso, fields, @struct_all, @struct_copy, @struct_map

docref(s) = "[`$(string(s))`](@ref)"

langenum(s) = s
langenum(s, t) = s * " and " * t
langenum(s, t...) = s * ", " *langenum(t...)
"""
    seealso(s...)

Produce the "See also" parts of docstrings.

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
    @struct_all(TYP, op)
    @struct_all(TYP, ops...)

Define the binary operator of the type `TYP` by applying the operator to each field and return true only when all the results are true. $(seealso("@struct_copy", "@struct_map"))

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

julia> x==y, isequal(x,y), isapprox(x,y)
(false, false)

julia> isapprox(x,y)
ERROR: MethodError: no method matching isapprox(::Foo, ::Foo)

julia> @struct_all Foo Base.:(==) Base.isequal Base.isapprox

julia> x==y, isequal(x,y), isapprox(x,y)
(true, true, true)
```
"""
macro struct_all(TYP, op)
    esc(quote
        function $op(A::T1, B::T2) where {T1<:$TYP, T2<:$TYP}
            for p in fields($TYP)
                if !$op(getfield(A, p), getfield(B, p))
                    return false
                end
            end
            return true
        end
    end)
end

macro struct_all(TYP, ops...)
    esc(quote
        @struct_all($TYP, $(Base.first(ops)))
        @struct_all($TYP, $(Base.tail(ops)...))
    end)
end

macro struct_any(TYP, op)
    esc(quote
        function $op(A::T1, B::T2) where {T1<:$TYP, T2<:$TYP}
            for p in fields($TYP)
                if $op(getfield(A, p), getfield(B, p))
                    return true
                end
            end
            return false
        end
    end)
end

"""
    @struct_copy(TYP)

Generate `Base.copy` for copying structs of type `TYP`. $(seealso("@struct_equal", "@struct_map"))

# Example
```jldoctest
julia> struct Foo
       a
       b
       end

julia> x = Foo(1,1)
Foo(1, 1)

julia> y = copy(x)
ERROR: MethodError: no method matching copy(::Foo)

julia> @struct_copy Foo;

julia> y = copy(x)
Foo(1, 1)
```
"""
macro struct_copy(TYP)
    quote
        function Base.copy(A::$(esc(TYP)))
            typeof(A)((Base.copy(getfield(A, p)) for p in fields($(esc(TYP))))...)
        end
    end
end

"""
    @struct_map(TYP, op)
    @struct_map(TYP, ops...)

Define the function(s) of the type `TYP` by applying the function(s) to each field and generate a new `TYP` with the values. The generated function(s) are somehow faster than the naive implementation. $(seealso("@struct_equal", "@struct_copy"))

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
    quote
        function $(esc(op))(A::$(esc(TYP))...)
            $(esc(TYP))(($(esc(op))(getfield.(A, p)...) for p in fields($(esc(TYP))))...)
        end
    end
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