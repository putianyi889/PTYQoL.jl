module PTYQoLInfiniteArraysExt

import InfiniteArrays: InfStepRange, AbstractInfUnitRange, Zeros, ∞, diag, Diagonal
#import LinearAlgebra: diag, Diagonal

infdiag(a, k) = iszero(k) ? copy(a.diag) : Zeros{eltype(a)}(∞)

for TYP in (InfStepRange, AbstractInfUnitRange)
    @eval begin
        diag(a::Diagonal{T, <:$TYP}, k::Integer=0) where T = infdiag(a, k)
    end
end

end