using Documenter, GeoAcceleratedArrays

makedocs(;
    modules=[GeoAcceleratedArrays],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/evetion/GeoAcceleratedArrays.jl/blob/{commit}{path}#L{line}",
    sitename="GeoAcceleratedArrays.jl",
    authors="Maarten Pronk, Deltares",
    assets=String[],
)

deploydocs(;
    repo="github.com/evetion/GeoAcceleratedArrays.jl",
)
