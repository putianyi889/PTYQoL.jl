using Documenter
using PTYQoL

makedocs(
    sitename = "PTYQoL",
    format = Documenter.HTML(),
    modules = [PTYQoL]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
