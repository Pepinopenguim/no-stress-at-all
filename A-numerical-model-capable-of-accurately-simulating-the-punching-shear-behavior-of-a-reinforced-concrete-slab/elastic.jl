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
geo = GeoModel(size=.1)

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
plate_coords = []

# define dimensions of square plate
# assuming 5x5cm
plate_dim = [5cm, 5cm, 2cm]

# simple function to define a plate of iron.
for θ in load_θs
    # define center of load circle
    load_center = [ℓ/2, b/2]

    plate_coord = load_center + load_radius * [cosd(θ), sind(θ)] 

    push!(plate_coords, plate_coord)

    # NOTE: from corner of box, not center
    plate_corner = plate_coord - plate_dim[1:2]/2

    plate = add_box(geo, [plate_coord..., h], plate_dim...; tag="steelPlate")
end

# ===========================================================
# ----------------- MESH AND VIDEO DEF. ---------------------
# ===========================================================

# define mesh
mesh = Mesh(geo)

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
save(video, "view.mp4")



# ===========================================================
# ----------------- MATERIALS -------------------------------
# ===========================================================

# >> Concrete
Ec    = 21.551MPa
nu    = 0.2

# >> Steel
Es    = 200GPa

# >> Mappers

mapper = RegionMapper()

add_mapping(mapper, "bulk", MechSolid, LinearElastic, E=Ec, nu=nu)
add_mapping(mapper, "steelPlate", MechSolid, LinearElastic, E=Es)

# ===========================================================
# ----------------- FEModel ---------------------------------
# ===========================================================

model = FEModel(mesh, mapper; g=9.81)
ana = MechAnalysis(model; outkey="elastic_1", outdir="elastic")

stage = add_stage(ana, nincs=10, nouts=50)

# ===========================================================
# ----------------- BOUNDARY CONDITIONS ---------------------
# ===========================================================


add_bc(stage, :node, x==0, ux=0, uy=0, uz=0)
add_bc(stage, :node, x==ℓ, ux=0, uy=0, uz=0)
add_bc(stage, :node, y==0, ux=0, uy=0, uz=0)
add_bc(stage, :node, y==b, ux=0, uy=0, uz=0)

for (xp, yp) in plate_coords
    add_bc(stage, :node, (x==xp, y==yp, z==h); uz=-1)
end


# >> Load definitions 
run(ana)

plot_kwargs = (
    field      = "σxx",
    colormap   = :spectral,
    diverging  = true,
    line_color = :gray,
    line_width = 0.1,
    colorbar   = :bottom,
    label      = "`sigma_(x x)` [MPa]",
    view_mode   = :wireframe
)

plot = DomainPlot(
    azimuth = -80,
)
add_plot(plot, model;
    plot_kwargs...
)
save(plot, "elastic//elastic.pdf")


video = VideoBuilder(bounds_factor=1.05)
for az in 0:10:180
    frame = DomainPlot(azimuth=az)
    add_plot(
        frame, model;
        plot_kwargs...
    )
    add_frame(video, frame)
end
save(video, "elastic//elastic.mp4")

