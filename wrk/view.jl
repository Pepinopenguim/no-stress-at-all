# visualizer for mesh 
using Serendip
include("mesh.jl")

plot = DomainPlot(
    # size=(8.5cm, 5cm),
    # font="Times New Roman",
    # font_size=8.0,
    # title="",
    # axes=:none,
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