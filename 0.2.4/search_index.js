var documenterSearchIndex = {"docs":
[{"location":"#PTYQoL.jl","page":"PTYQoL.jl","title":"PTYQoL.jl","text":"","category":"section"},{"location":"","page":"PTYQoL.jl","title":"PTYQoL.jl","text":"Documentation for PTYQoL.jl","category":"page"},{"location":"","page":"PTYQoL.jl","title":"PTYQoL.jl","text":"Modules = [PTYQoL]","category":"page"},{"location":"#PTYQoL.fields-Union{Tuple{Type{T}}, Tuple{T}} where T","page":"PTYQoL.jl","title":"PTYQoL.fields","text":"@generated fields(::Type{T}) where T = fieldnames(T)\n\nThe same as fieldnames, but is @generated so is fast.\n\n\n\n\n\n","category":"method"},{"location":"#PTYQoL.fracpochhammer-Tuple{Any, Any, Any}","page":"PTYQoL.jl","title":"PTYQoL.fracpochhammer","text":"fracpochhammer(a, b, n)\n\nCalculate the fraction of two Pochhammer symbols frac(a)_n(b)_n by multiplying the fractions. This approach reduces the risk of overflow/underflow when n is large.\n\nExamples\n\njulia> fracpochhammer(1, 2, 3) # (1 * 2 * 3) / (2 * 3 * 4)\n0.25\n\nfracpochhammer(a, b, stepa, stepb, n)\n\nSimilar to fracpochhammer(a, b, n), except that the steps of the Pochhammer symbols are not necessarily 1.\n\nExamples\n\njulia> fracpochhammer(1, 2, 0.5, 1, 3) # (1 * 1.5 * 2) / (2 * 3 * 4)\n0.125\n\n\n\n\n\n","category":"method"},{"location":"#PTYQoL.isalias-Union{Tuple{Type{T}}, Tuple{T}} where T","page":"PTYQoL.jl","title":"PTYQoL.isalias","text":"isalias(type)\n\nCheck if a type is alias.\n\nExamples\n\njulia> isalias(Vector)\ntrue\n\njulia> isalias(Array)\nfalse\n\n\n\n\n\n","category":"method"},{"location":"#PTYQoL.ln","page":"PTYQoL.jl","title":"PTYQoL.ln","text":"const ln = Fix1(log,ℯ)\n\nNatural logarithm.\n\n\n\n\n\n","category":"function"},{"location":"#PTYQoL.seealso-Tuple","page":"PTYQoL.jl","title":"PTYQoL.seealso","text":"seealso(s...)\n\nProduce the \"See also\" parts of docstrings.\n\njulia> seealso(sin)\n\"See also [`sin`](@ref).\"\n\njulia> seealso(sin, cos)\n\"See also [`sin`](@ref) and [`cos`](@ref).\"\n\njulia> seealso(sin, cos, tan)\n\"See also [`sin`](@ref), [`cos`](@ref) and [`tan`](@ref).\"\n\n\n\n\n\n","category":"method"},{"location":"#PTYQoL.@struct_all-Tuple{Any, Any}","page":"PTYQoL.jl","title":"PTYQoL.@struct_all","text":"@struct_all(TYP, op)\n@struct_all(TYP, ops...)\n\nDefine the operator of the type TYP by applying the operator to each field and return true only when all the results are true. See also @struct_any, @struct_copy and @struct_map.\n\nExample\n\njulia> struct Foo\n       a\n       b\n       end\n\njulia> x = Foo(1,1)\nFoo(1, 1)\n\njulia> y = Foo(1.0,1.0)\nFoo(1.0, 1.0)\n\njulia> x==y, isequal(x,y)\n(false, false)\n\njulia> isapprox(x,y)\nERROR: MethodError: no method matching isapprox(::Foo, ::Foo)\n\njulia> isfinite(x)\nERROR: MethodError: no method matching isfinite(::Foo)\n\njulia> @struct_all Foo Base.:(==) Base.isequal Base.isapprox Base.isfinite\n\njulia> x==y, isequal(x,y), isapprox(x,y), isfinite(x)\n(true, true, true, true)\n\n\n\n\n\n","category":"macro"},{"location":"#PTYQoL.@struct_any-Tuple{Any, Any}","page":"PTYQoL.jl","title":"PTYQoL.@struct_any","text":"@struct_any(TYP, op)\n@struct_any(TYP, ops...)\n\nDefine the binary operator of the type TYP by applying the operator to each field and return true when any of the results is true. See also @struct_all, @struct_copy and @struct_map.\n\nExample\n\njulia> struct Foo\n       a\n       b\n       end\n\njulia> x = Foo(Inf, NaN)\nFoo(Inf, NaN)\n\njulia> isinf(x)\nERROR: MethodError: no method matching isinf(::Foo)\n\njulia> isnan(x)\nERROR: MethodError: no method matching isnan(::Foo)\n\njulia> @struct_any Foo Base.isinf Base.isnan\n\njulia> isinf(x), isnan(x)\n(true, true)\n\n\n\n\n\n","category":"macro"},{"location":"#PTYQoL.@struct_copy-Tuple{Any}","page":"PTYQoL.jl","title":"PTYQoL.@struct_copy","text":"@struct_copy(TYP)\n\nGenerate Base.copy for copying structs of type TYP. See also @struct_all, @struct_any and @struct_map.\n\nExample\n\njulia> struct Foo\n       a\n       b\n       end\n\njulia> x = Foo(1,1)\nFoo(1, 1)\n\njulia> y = copy(x)\nERROR: MethodError: no method matching copy(::Foo)\n\njulia> @struct_copy Foo;\n\njulia> y = copy(x)\nFoo(1, 1)\n\n\n\n\n\n","category":"macro"},{"location":"#PTYQoL.@struct_map-Tuple{Any, Any}","page":"PTYQoL.jl","title":"PTYQoL.@struct_map","text":"@struct_map(TYP, op)\n@struct_map(TYP, ops...)\n\nDefine the function(s) of the type TYP by applying the function(s) to each field and generate a new TYP with the values. The generated function(s) are somehow faster than the naive implementation. See also @struct_all, @struct_any and @struct_copy.\n\nExample\n\njulia> struct Foo\n       a\n       b\n       end\n\njulia> x = Foo(1,1)\nFoo(1, 1)\n\njulia> @struct_map(Foo, Base.exp, Base.sin, Base.:+)\n\njulia> exp(x), sin(x), x+x\n(Foo(2.718281828459045, 2.718281828459045), Foo(0.8414709848078965, 0.8414709848078965), Foo(2, 2))\n\n\n\n\n\n","category":"macro"}]
}
