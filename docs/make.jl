using Documenter, GeoAcceleratedArrays

makedocs(;
    modules=[GeoAcceleratedArrays],
    format=Documenter.HTML(repolink="https://github.com/evetion/GeoAcceleratedArrays.jl"),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/evetion/GeoAcceleratedArrays.jl/blob/{commit}{path}#L{line}",
    sitename="GeoAcceleratedArrays.jl",
    authors="Maarten Pronk, Deltares",
)

deploydocs(;
    repo="github.com/evetion/GeoAcceleratedArrays.jl"
)
