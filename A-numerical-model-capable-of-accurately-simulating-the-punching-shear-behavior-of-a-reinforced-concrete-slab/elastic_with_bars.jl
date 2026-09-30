#=
This code represents a simple simulation of the structure assuming 
no steel bars and elastic qualities of the beam.

For the sake of simplifing the solution, displacement applied will be unitary

Objectives:
    - Correctly define geometry, materials (mapping), forces, etc.
    - review if loading is fine
    - create analysis and plots accordingly
=#

using Serendip
using LinearAlgebra

# units of measure
mm = 1e-3
cm = 1e-2

MPa = 1e6
GPa = 1e9

# ===========================================================
# ----------------- SLAB DEFINITION -------------------------
# ===========================================================

# >> Beam proportions
ℓ = 2500.0mm    # x direction
b = 2500.0mm    # y direction
h = 180.0mm     # z direction


# >> Define slab
geo = GeoModel(size=1)

slab = add_box(geo, [0.0, 0.0, 0.0], ℓ, b, h; tag="bulk")


# >> define column
ℓ_col = 300.0mm             # x
b_col = 300.0mm             # y
# respectively, lower bound, upper bound, slab height
h_col = (low_col_h = 600.0mm) + (upp_col_h = 800.0mm) + h # z

# reference point for the column
col_origin = [(ℓ - ℓ_col) / 2, (b - b_col) / 2, -low_col_h]

column = add_box(geo, col_origin, ℓ_col, b_col, h_col; tag="bulk")

# fuse volumes
bulk = fuse(geo, slab, column, tag="bulk")

# ===========================================================
# ----------------- LOAD PLATE DEFINITION -------------------
# ===========================================================

load_radius = 1124mm
load_θs = [30 * n for n in 1:12 if n ∉ (3:3:12)]

# define dimensions of square plate
# assuming 5x5cm
plate_dim = [5cm, 5cm, 2cm]
plates = Any[]
plate_coords = Any[]
for θ in load_θs
    load_center = [ℓ/2, b/2]
    plate_coord = load_center .+ load_radius .* [cosd(θ), sind(θ)]
    push!(plate_coords, (plate_coord[1], plate_coord[2]))

    corner = plate_coord .- plate_dim[1:2] ./ 2
    plate  = add_box(geo, [corner..., h], plate_dim...; tag="steelPlate")
    push!(plates, plate)
end

fragment(geo, bulk, plates)

# ===========================================================
# ----------------- IRON BARS DEFINTION ---------------------
# ===========================================================


# This function creates a grid of bars for the current problem
function create_grid(geo::GeoModel, tag::String, C::Vector{Float64}, n::Int, d::Float64)
    cx, cy, cz = C

    p0 = add_point(geo, [cx, cy, h - cz])
    p1x = add_point(geo, [ℓ - cx, cy    , h - cz])
    p1y = add_point(geo, [cx    , b - cy, h - cz])

    top_edge_x = add_line(geo, p0, p1x)
    top_path_x = add_path(geo, [top_edge_x]; tag=tag)
    add_array(geo, top_path_x; ny=16, dy=155.0mm)

    top_edge_y = add_line(geo, p0, p1y)
    top_path_y = add_path(geo, [top_edge_y]; tag=tag)
    add_array(geo, top_path_y; nx=16, dx=155.0mm)


end

create_grid(geo, "topReinforcement", [87.5mm, 87.5mm, h - 25mm], 16, 155.0mm)
create_grid(geo, "botReinforcement", [87.5mm, 87.5mm, 25mm], 16, 155.0mm)


# ===========================================================
# ----------------- MESH AND VIDEO DEF. ---------------------
# ===========================================================

# define mesh
mesh = Mesh(geo)

# delete placeholder elements
mesh = remove_elements(mesh, "")

# view mesh
video = VideoBuilder(bounds_factor=1.05)
for az in 0:10:360
    frame = DomainPlot(azimuth=az)
    add_plot(
        frame,
        mesh;
        #view_mode=:outline
        view_mode=:wireframe
    )
    add_frame(video, frame)
end
save(video, "elastic_b//view.mp4")



# ===========================================================
# ----------------- MATERIALS -------------------------------
# ===========================================================

# >> Concrete
Ec    = 29.9MPa
nu    = 0.2

# >> Steel
Es    = 200GPa

# >> Mappers

mapper = RegionMapper()

add_mapping(mapper, "bulk", MechSolid, LinearElastic, E=Ec, nu=nu)
add_mapping(mapper, "steelPlate", MechSolid, LinearElastic, E=Es)
add_mapping(mapper, "topReinforcement", MechBar, LinearElastic, d=16mm, E=Es)
add_mapping(mapper, "botReinforcement", MechBar, LinearElastic, d=10mm, E=Es)

# ===========================================================
# ----------------- FEModel ---------------------------------
# ===========================================================

model = FEModel(mesh, mapper; g=9.81)
ana = MechAnalysis(model; outkey="elastic_b", outdir="elastic_b")

stage = add_stage(ana, nincs=1, nouts=1)

# ===========================================================
# ----------------- BOUNDARY CONDITIONS ---------------------
# ===========================================================


# Slab perimeter fully restrained (the only support of the system)
add_bc(stage, :face, (x == 0.0), ux=0, uy=0, uz=0)
add_bc(stage, :face, (x == ℓ),   ux=0, uy=0, uz=0)
add_bc(stage, :face, (y == 0.0), ux=0, uy=0, uz=0)
add_bc(stage, :face, (y == b),   ux=0, uy=0, uz=0)

# logger
add_logger(ana, :nodalreduce, (x==0, y==0, z==h), "test.table")


z_top = h + plate_dim[3]
for (xp, yp) in plate_coords
    x_lo = xp - plate_dim[1]/2
    x_hi = xp + plate_dim[1]/2
    y_lo = yp - plate_dim[2]/2
    y_hi = yp + plate_dim[2]/2
    add_bc(stage, :face,
           (x >= x_lo, x <= x_hi, y >= y_lo, y <= y_hi, z == z_top);
           uz = -1mm)
end

# >> Load definitions 
run(ana)

plot_kwargs = (
    field      = "uz",
    colormap   = :spectral,
    diverging  = true,
    field_mult = 1e3,
    line_width = 0.1,
    colorbar   = :bottom,
    warp = 100,
    label      = "`u_(z)` [mm]",
    view_mode   = :wireframe
)

plot = DomainPlot(
    azimuth = -80,
)
add_plot(plot, model;
    plot_kwargs...
)
save(plot, "elastic_b_//elastic.pdf")


video = VideoBuilder(bounds_factor=1.05)
for az in 0:20:180
    frame = DomainPlot(
        azimuth=az,
    )
    add_plot(
        frame, model;
        plot_kwargs...
    )
    add_frame(video, frame)
end
save(video, "elastic_b_//elastic.mp4")

