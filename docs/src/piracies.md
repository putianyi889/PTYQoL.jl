## Type piracies

### Extended support on `Complex`
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