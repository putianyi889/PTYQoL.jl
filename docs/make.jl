using Documenter
using PTYQoL

makedocs(
    sitename = "PTYQoL",
    format = Documenter.HTML(),
    doctest = false,
    modules = [PTYQoL]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/putianyi889/PTYQoL.jl.git"
)
