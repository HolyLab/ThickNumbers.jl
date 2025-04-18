using ThickNumbers
using Documenter

DocMeta.setdocmeta!(ThickNumbers, :DocTestSetup, :(using ThickNumbers); recursive=true)

makedocs(;
    modules=[ThickNumbers],
    authors="Tim Holy <tim.holy@gmail.com> and contributors",
    repo="https://github.com/HolyLab/ThickNumbers.jl/blob/{commit}{path}#{line}",
    sitename="ThickNumbers.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://HolyLab.github.io/ThickNumbers.jl",
        repolink="https://github.com/HolyLab/ThickNumbers.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "developers.md",
        "required.md",
        "optional.md",
        "user_api.md",
    ],
)

deploydocs(;
    repo="github.com/HolyLab/ThickNumbers.jl",
    devbranch="main",
    push_preview=false,      # see also the corresponding flag in .github/workflows/CleanPreview.yml
)
