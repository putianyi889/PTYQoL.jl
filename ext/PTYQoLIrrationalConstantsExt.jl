module PTYQoLIrrationalConstantsExt

using IrrationalConstants
import Base: +, -, *, /, inv, sqrt, exp, log

# x+x=2x, 2x-x=x, x/2x=1/2, 2x/x=2
for (x, halfx) in ((halfπ,quartπ), (π,halfπ), (twoπ,π), (fourπ,twoπ), (inv2π,inv4π), (invπ,inv2π), (twoinvπ,invπ), (fourinvπ,twoinvπ), (sqrt2,invsqrt2), (sqrt2π,sqrthalfπ), (sqrt4π,sqrtπ))
    @eval +(::$(typeof(halfx)), ::$(typeof(halfx))) = $x
    @eval -(::$(typeof(x)), ::$(typeof(halfx))) = $halfx
    @eval /(::$(typeof(halfx)), ::$(typeof(x))) = 1/2
    @eval /(::$(typeof(x)), ::$(typeof(halfx))) = 2
end

# x*inv(x)=1
for (x,invx) in ((quartπ,fourinvπ), (halfπ,twoinvπ), (π,invπ), (twoπ,inv2π), (fourπ,inv4π), (sqrt2,invsqrt2), (sqrtπ,invsqrtπ), (sqrt2π,invsqrt2π))
    @eval inv(::$(typeof(x))) = $invx
    @eval inv(::$(typeof(invx))) = $x
    @eval *(::$(typeof(x)), ::$(typeof(invx))) = 1
    @eval *(::$(typeof(invx)), ::$(typeof(x))) = 1
end

# sqrt(x)*sqrt(x)=x, x/sqrt(x)=sqrt(x)
for (x,sqrtx) in ((π,sqrtπ), (twoπ,sqrt2π), (fourπ,sqrt4π), (halfπ,sqrthalfπ), (invπ,invsqrtπ), (inv2π,invsqrt2π))
    @eval sqrt(::$(typeof(x))) = $sqrtx
    @eval *(::$(typeof(sqrtx)), ::$(typeof(sqrtx))) = $x
    @eval /(::$(typeof(x)), ::$(typeof(sqrtx))) = $sqrtx
    @eval /(::$(typeof(sqrtx)), ::$(typeof(x))) = inv($sqrtx)
end

# exp(log(x))=x
for (x,logx) in ((π,logπ), (twoπ,log2π), (fourπ,log4π))
    @eval log(::$(typeof(x))) = $logx
    @eval exp(::$(typeof(logx))) = $x
end

end # module