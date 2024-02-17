import Base: front
export seealso, fields, @struct_all, @struct_any, @struct_copy, @struct_map

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

Define the operator of the type `TYP` by applying the operator to each field and return true only when all the results are true. $(seealso("@struct_any", "@struct_copy", "@struct_map"))

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

julia> x==y, isequal(x,y)
(false, false)

julia> isapprox(x,y)
ERROR: MethodError: no method matching isapprox(::Foo, ::Foo)

julia> isfinite(x)
ERROR: MethodError: no method matching isfinite(::Foo)

julia> @struct_all Foo Base.:(==) Base.isequal Base.isapprox Base.isfinite

julia> x==y, isequal(x,y), isapprox(x,y), isfinite(x)
(true, true, true, true)
```
"""
macro struct_all(TYP, op)
    quote
        function $(esc(op))(A::$(esc(TYP))...)
            Base.all($(esc(op))(getfield.(A, p)...) for p in fields($(esc(TYP))))
        end
    end
end

macro struct_all(TYP, ops...)
    esc(quote
        @struct_all($TYP, $(Base.first(ops)))
        @struct_all($TYP, $(Base.tail(ops)...))
    end)
end

"""
    @struct_any(TYP, op)
    @struct_any(TYP, ops...)

Define the binary operator of the type `TYP` by applying the operator to each field and return true when any of the results is true. $(seealso("@struct_all", "@struct_copy", "@struct_map"))

# Example
```jldoctest
julia> struct Foo
       a
       b
       end

julia> x = Foo(Inf, NaN)
Foo(Inf, NaN)

julia> isinf(x)
ERROR: MethodError: no method matching isinf(::Foo)

julia> isnan(x)
ERROR: MethodError: no method matching isnan(::Foo)

julia> @struct_any Foo Base.isinf Base.isnan

julia> isinf(x), isnan(x)
(true, true)
```
"""
macro struct_any(TYP, op)
    quote
        function $(esc(op))(A::$(esc(TYP))...)
            Base.any($(esc(op))(getfield.(A, p)...) for p in fields($(esc(TYP))))
        end
    end
end

macro struct_any(TYP, ops...)
    esc(quote
        @struct_any($TYP, $(Base.first(ops)))
        @struct_any($TYP, $(Base.tail(ops)...))
    end)
end

"""
    @struct_copy(TYP)

Generate `Base.copy` for copying structs of type `TYP`. $(seealso("@struct_all", "@struct_any", "@struct_map"))

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

Define the function(s) of the type `TYP` by applying the function(s) to each field and generate a new `TYP` with the values. The generated function(s) are somehow faster than the naive implementation. $(seealso("@struct_all", "@struct_any", "@struct_copy"))

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

import Base: Fix1, show, string
export ln
"""
    const ln = Fix1(log,ℯ)

Natural logarithm.
"""
const ln = Fix1(log,ℯ)
show(io::IO, ::MIME"text/plain", ::typeof(ln)) = print(io,"ln (alias function for $(Fix1){typeof(log), Irrational{:ℯ}})")
string(::typeof(ln)) = "ln"

export precision_convert
precision_convert(::Type{BigFloat}, x, precision) = BigFloat(x, precision = precision)
precision_convert(T, x, precision) = convert(T, x)

export isalias
"""
    isalias(type)

Check if a type is alias.

# Examples
```jldoctest
julia> isalias(Vector)
true

julia> isalias(Array)
false
```
"""
@generated isalias(::Type{T}) where T = string(T) != string(Base.typename(T).name)

export fracpochhammer
"""
    fracpochhammer(a, b, n)

Calculate the fraction of two Pochhammer symbols ``\\frac{(a)_n}{(b)_n}`` by multiplying the fractions. This approach reduces the risk of overflow/underflow when ``n`` is large.

# Examples
```jldoctest
julia> fracpochhammer(1, 2, 3) # (1 * 2 * 3) / (2 * 3 * 4)
0.25
```

    fracpochhammer(a, b, stepa, stepb, n)

Similar to `fracpochhammer(a, b, n)`, except that the steps of the Pochhammer symbols are not necessarily ``1``.

# Examples
```jldoctest
julia> fracpochhammer(1, 2, 0.5, 1, 3) # (1 * 1.5 * 2) / (2 * 3 * 4)
0.125
```
"""
fracpochhammer(a,b,n) = prod(x/y for (x,y) in zip(range(a,length=n),range(b,length=n)))
fracpochhammer(a,b,stepa,stepb,n) = prod(x/y for (x,y) in zip(range(a,step=stepa,length=n),range(b,step=stepb,length=n)))

const TupleN{T,N} = Tuple{Vararg{T,N}}
const Tuple1N{T,N} = Tuple{T, Vararg{T,N}}
const Tuple2N{T,N} = Tuple{T, T, Vararg{T,N}}

export @Vararg1
"""
    @Vararg1

Use before a function definition to let `x::T...` means at least one (instead of zero by Julia default) of type `T`. This can be used to avoid ambiguity as all `Vararg{T}` overlap at zero argument.

# Example
```jldoctest
julia> mysum1(x::Int...) = sum(x) # sum up integers
mysum1 (generic function with 1 method)

julia> mysum1() # works for 0 argument
0

julia> mysum1(x::Float64...) = sum(x) # sum up floats
mysum1 (generic function with 2 methods)

julia> mysum1()
ERROR: MethodError: mysum1() is ambiguous.

julia> @Vararg1 mysum2(x::Int...) = sum(x)
mysum2 (generic function with 1 method)

julia> @Vararg1 mysum2(x::Float64...) = sum(x)
mysum2 (generic function with 2 methods)

julia> mysum2()
ERROR: MethodError: no method matching mysum2()
```
"""
macro Vararg1(expr)
    if expr.head in (Symbol(:(=)), Symbol(:function))
        lhs = expr.args[1]
        vname = Symbol[]
        newlhs = copy(lhs)

        # peel off where statements
        lhsbody = lhs
        newlhsbody = newlhs
        while lhsbody.head == Symbol(:where) 
            lhsbody = lhsbody.args[1]
            newlhsbody = newlhsbody.args[1]
        end

        # manipulate the argument list
        if lhsbody.head == Symbol(:call)
            fname = lhsbody.args[1]
            newlhsbody.args = Any[fname] # reconstruct the argument list
            for arg in lhsbody.args[2:end]
                if arg.head == Symbol(:(...)) # expand (x::T...) to (x_first::T, x_tail:T...)
                    push!(vname, arg.args[1].args[1])
                    push!(newlhsbody.args, Vararg_expand(arg.args[1])...)
                else # keep (x::T) statements
                    push!(newlhsbody.args, arg)
                end
            end
        else
            throw(ArgumentError("Unrecognised left side"))
        end

        # manipulate the function body
        rhs = expr.args[2]
        newrhs = rhs
        if rhs.head == Symbol(:block)
            # add assignments like (x = (x_first, x_tail...)) before the first line
            for vn in vname
                pushfirst!(newrhs.args, Vararg_assign(vn))
            end
        else
            throw(ArgumentError("Unrecognised right side"))
        end
        esc(Expr(expr.head, newlhs, newrhs))
    else
        throw(ArgumentError("Unrecognised function definition"))
    end
end
macro Vararg1(expr...)
    Vararg1(Meta.@dump(expr...))
end

function Vararg_expand(expr)
    if expr.head == Symbol(:(::)) # expr = :(x::T)
        vname = expr.args[1] # x
        type = expr.args[2] # T
        firstexpr = Expr(:(::), _first(vname), type) # :(x_first::T)
        tailexpr = Expr(:(...), Expr(:(::), _tail(vname), type)) # :(x_tail::T...)
        firstexpr, tailexpr
    else
        throw(ArgumentError("Unrecognised expression $(expr)"))
    end
end
_first(vname) = Symbol("$(vname)_first")
_tail(vname) = Symbol("$(vname)_tail")

Vararg_assign(vname) = :($vname = ($(_first(vname)), $(_tail(vname))...)) # x = (x_first, x_tail...)