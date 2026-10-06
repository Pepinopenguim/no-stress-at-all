#=
Now the objective is to make it non-linear

Objectives:
    - Correctly define geometry, materials (mapping), forces, etc.
    - review if loading is fine
    - create analysis and plots accordingly
    - Define the materials correctly
=#

using Serendip
using LinearAlgebra: sind, cosd

# units of measure
const mm = 1e-3
const cm = 1e-2

const N = 1

const MPa = 1e6
const GPa = 1e9

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
# TODO - REVIEW ANGLE
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

# unite plates with volume
fragment(geo, bulk, plates)

# ===========================================================
# ----------------- IRON BARS DEFINTION ---------------------
# ===========================================================


# This function creates a grid of bars for the current problem
function create_grid(geo::GeoModel, tag::String, interface_tag::String, C::Vector{Float64}, n::Int64, d::Float64)
    cx, cy, cz = C

    p0 = add_point(geo, [cx, cy, h - cz])
    p1x = add_point(geo, [ℓ - cx, cy    , h - cz])
    p1y = add_point(geo, [cx    , b - cy, h - cz])

    top_edge_x = add_line(geo, p0, p1x)
    top_path_x = add_path(geo, [top_edge_x]; tag=tag, interface_tag=interface_tag)
    add_array(geo, top_path_x; ny=n, dy=d)

    top_edge_y = add_line(geo, p0, p1y)
    top_path_y = add_path(geo, [top_edge_y]; tag=tag, interface_tag=interface_tag)
    add_array(geo, top_path_y; nx=n, dx=d)


end

create_grid(geo, "topReinforcement", "barInt", [87.5mm, 87.5mm, h - 25mm], 16, 155.0mm)
create_grid(geo, "botReinforcement", "barInt", [87.5mm, 87.5mm, 25mm], 16, 155.0mm)

# ===========================================================
# ----------------- U BARS DEFINTION ------------------------
# ===========================================================

function create_ubars(geo::GeoModel, tag::String, interface_tag::String, C::Vector{Float64}, ℓ_u::Float64, direction::String, n::Int, d::Float64)
    cx, cy, cz = C

    (∇x, ∇y, nx, ny, dx, dy) = direction == "x" ? (ℓ_u, 0, 1, n, 0.0, d) : (0, ℓ_u, n, 1, d, 0.0)
    
    points_u = [
        add_point(geo, [cx + ∇x, cy + ∇y, h - cz])
        add_point(geo, [cx     , cy     , h - cz])
        add_point(geo, [cx     , cy     ,     cz])
        add_point(geo, [cx + ∇x, cy + ∇y,     cz])
    ]

    edges_u = [add_line(geo,points_u[i],points_u[i+1]) for i in 1:3]
    path_u = add_path(geo, edges_u; tag=tag, interface_tag=interface_tag)
    add_array(geo, path_u; nx=nx, ny=ny, dx=dx, dy=dy)
end

# NOTE - signal of ℓ_u inverts its orientation
create_ubars(geo, "uBar", "barInt", [87.5mm, 87.5mm, 25mm], 250.0mm, "x", 16, 155.0mm)
create_ubars(geo, "uBar", "barInt", [ℓ - 87.5mm, 87.5mm, 25mm], -250.0mm, "x", 16, 155.0mm)
create_ubars(geo, "uBar", "barInt", [87.5mm, 87.5mm, 25mm], 250.0mm, "y", 16, 155.0mm)
create_ubars(geo, "uBar", "barInt", [87.5mm, b - 87.5mm, 25mm], -250.0mm, "y", 16, 155.0mm)

# ===========================================================
# ----------------- MESH, COHESIVE AND VIDEO DEF. -----------
# ===========================================================

# define mesh
mesh = Mesh(geo)

# >> Cohesive elements creation
add_cohesive_elements(mesh, (z >=0, z <= h); tag="cohesive")

# view mesh
video = VideoBuilder(bounds_factor=1.05)
for az in 0:10:180
    frame = DomainPlot(azimuth=az)
    add_plot(frame, mesh, "bulk";view_mode=:outline, line_color=:gray)
    add_plot(frame, mesh, "topReinforcement";view_mode=:wireframe, line_elem_color=:blue)
    add_plot(frame, mesh, "botReinforcement";view_mode=:wireframe, line_elem_color=darken(Color(:green), .6))
    add_plot(frame, mesh, "uBar";view_mode=:wireframe, line_color=:red)
    add_frame(video, frame)
end
save(video, "elastic_c//view_c.mp4")



# ===========================================================
# ----------------- MATERIALS -------------------------------
# ===========================================================

# >> Concrete
Ec    = 29.9MPa
nu    = 0.2
ft    = 1.8MPa # Tensile strength, obtained from TABLE 4
GF    = .134N/mm # Fracture Energy, same table. TODO - Review!!!

# >> Steel ϕ16.0
Es1   = 196.9GPa
fy1   = 549.0MPa 

# >> Steel ϕ10.0
Es2   = 126.6GPa
fy2   = 515.0MPa 

# >> Mappers

mapper = RegionMapper()

add_mapping(mapper, "bulk"            , MechSolid, LinearElastic, E=Ec, nu=nu) 
add_mapping(mapper, "cohesive"        , MechCohesive, LinearCohesive, E=Ec, nu=nu) 
add_mapping(mapper, "steelPlate"      , MechSolid, LinearElastic, E=900GPa)
add_mapping(mapper, "topReinforcement", MechBar, VonMises, d=16mm, E=Es1, fy=fy1) 
add_mapping(mapper, "botReinforcement", MechBar, VonMises, d=10mm, E=Es2, fy=fy2)
add_mapping(mapper, "uBar"            , MechBar, VonMises, d=16mm, E=Es1, fy=fy1)
add_mapping(mapper, "barInt"          , MechBondSlip, LinearBondSlip, ks=1e10, kn=1e9, p=0.01) # TODO - Review values

# ===========================================================
# ----------------- FEModel ---------------------------------
# ===========================================================

model = FEModel(mesh, mapper; g=9.81)
ana = MechAnalysis(model; outkey="elastic_c", outdir="elastic_c")

stage = add_stage(ana, nincs=50, nouts=5)

# ===========================================================
# ----------------- BOUNDARY CONDITIONS ---------------------
# ===========================================================


# Slab perimeter fully restrained (the only support of the system)
add_bc(stage, :face, (z == upp_col_h + h); ux=0, uy=0, uz=0)
add_bc(stage, :face, (z == -low_col_h); ux=0, uy=0, uz=0)


loading = select(model, :face, z==h + plate_dim[3]; tag="loading")

# logger
add_logger(ana, :nodalreduce, (x==0, y==0, z==h), "test.table")


z_top = h + plate_dim[3]


add_bc(
        stage,
        :face,
        "loading";  
        uz = -3cm
    )

# >> Load definitions 
run(ana)

# plot_kwargs = (
#     field      = "uz",
#     colormap   = :spectral,
#     diverging  = true,
#     field_mult = 1e3,
#     line_width = 0.1,
#     colorbar   = :bottom,
#     warp = 10,
#     label      = "`u_(z)` [mm]",
#     view_mode   = :surface
# )
plot_kwargs = (
    field      = "σzz",
    field_mult = 1e-6,
    warp       = 10,
    colormap   = :spectral,
    diverging  = true,
    line_color = :gray,
    colorbar   = :bottom,
    label      = "`σ_(z z)` [MPa]",
)

plot = DomainPlot(
    azimuth = -80,
)

add_plot(plot, model;
    plot_kwargs...
)
save(plot, "elastic_c//elastic.pdf")


video = VideoBuilder(bounds_factor=1.05)
for az in 0:20:180
    frame = DomainPlot(
        azimuth=az,
        # up=:y
    )
    add_plot(
        frame, model;
        plot_kwargs...
    )
    add_frame(video, frame)
end
save(video, "elastic_c//elastic.mp4")

