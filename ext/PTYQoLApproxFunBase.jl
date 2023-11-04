# https://github.com/JuliaApproximation/ApproxFunBase.jl/pull/613
import ApproxFunBase: ldiffbc, rdiffbc, ldirichlet, rdirichlet, lneumann, rneumann, ivp, bvp, periodic

"""
    ldiffbc(d::Domain, k)

The boundary condition of the `k`-th order derivative on the left endpoint of `d`. See also [`rdiffbc`](@ref), [`ldirichlet`](@ref) and [`lneumann`](@ref).
"""
ldiffbc

"""
    rdiffbc(d::Domain, k)

The boundary condition of the `k`-th order derivative on the right endpoint of `d`. See also [`ldiffbc`](@ref), [`rdirichlet`](@ref) and [`rneumann`](@ref).
"""
rdiffbc

"""
    ldirichlet(d::Domain) = ldiffbc(d, 0)

The dirichlet boundary condition on the left endpoint of `d`. See also [`rdirichlet`](@ref) and [`ldiffbc`](@ref).
"""
ldirichlet

"""
    rdirichlet(d::Domain) = rdiffbc(d, 0)

The dirichlet boundary condition on the right endpoint of `d`. See also [`ldirichlet`](@ref) and [`rdiffbc`](@ref).
"""
rdirichlet

"""
    lneumann(d::Domain) = ldiffbc(d, 1)

The neumann boundary condition on the left endpoint of `d`. See also [`rneumann`](@ref) and [`ldiffbc`](@ref).  
"""
lneumann

"""
    rneumann(d::Domain) = rdiffbc(d, 1)

The neumann boundary condition on the right endpoint of `d`. See also [`lneumann`](@ref) and [`rdiffbc`](@ref).  
"""
rneumann

"""
    ivp(d::Domain, k) = [ldiffbc(d,i) for i=0:k-1]
    ivp(d) = ivp(d,2)

The conditions for the `k`-th order initial value problem. See also [`ldiffbc`](@ref), [`bvp`](@ref) and [`periodic`](@ref).
"""
ivp

"""
    bvp(d::Domain, k) = vcat([ldiffbc(d,i) for i=0:div(k,2)-1],
                        [rdiffbc(d,i) for i=0:div(k,2)-1])
    bvp(d) = bvp(d,2)

The conditions for the `k`-th order boundary value problem. See also [`ldiffbc`](@ref), [`rdiffbc`](@ref), [`ivp`](@ref) and [`periodic`](@ref).
"""
bvp

"""
    periodic(d::Domain,k) = [ldiffbc(d,i) - rdiffbc(d,i) for i=0:k]

The conditions for the `k`-th order periodic problem. See also [`ldiffbc`](@ref), [`rdiffbc`](@ref), [`ivp`](@ref) and [`bvp`](@ref)
"""
periodic