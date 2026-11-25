# visualizer for mesh 
using Serendip
include("mesh.jl")

plot = DomainPlot(
    azimuth=-60
)

add_plot(
    plot, mesh, "bulk";
    view_mode=:surface,
    face_color=Color(128, 128, 128)
)

add_plot(
    plot, mesh, "loadPlate";
    view_mode=:surface,
    face_color=Color(158, 158, 158)
)

save(plot, "view.pdf")

bars = DomainPlot(
    azimuth=-60
)

add_plot(bars, mesh, "bulk";
    view_mode=:outline,
    line_elem_color=Color(50,50,50)
)

for (rule, color) in Dict(
    "topReinforcement" => Color(230, 126, 0),    # Orange
    "botReinforcement" => Color(180, 30, 45),    # Dark red
    "uBar" => Color(0, 115, 75),                 # Dark green
    "ColReinforcement" => Color(0, 90, 170),     # Blue
    "halfColRfcmnt" => Color(0, 90, 170),        # Blue
)

    add_plot(
        bars, mesh, rule;
        view_mode=:wireframe,
        line_elem_color=color,
    )
end

save(bars, "report/figuras/bars.pdf")

looper = Dict(
    "M100R3.pdf" => generate_mesh(10cm, 1/3),
    "M100R5.pdf" => generate_mesh(10cm, 1/5),
    "M100R7.pdf" => generate_mesh(10cm, 1/7),
    "M200R3.pdf" => generate_mesh(20cm, 1/3),
    "M200R5.pdf" => generate_mesh(20cm, 1/5),
    "M200R7.pdf" => generate_mesh(20cm, 1/7),
)

for (fname, msh) in looper

    meshplot = DomainPlot(azimuth=-60)

    println("| $fname | $(length(msh.nodes)) |")

    add_plot(
        meshplot, msh, "bulk";
        view_mode=:wireframe
    )

    save(meshplot, fname)
end