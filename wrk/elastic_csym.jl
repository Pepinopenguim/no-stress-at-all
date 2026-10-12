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
geo = GeoModel(size=.05)

slab = add_box(geo, [0.0, 0.0, 0.0], ℓ/2, b/2, h; tag="bulk")


# >> define column
ℓ_col = 300.0mm             # x
b_col = 300.0mm             # y
# respectively, lower bound, upper bound, slab height
h_col = (low_col_h = 600.0mm) + (upp_col_h = 800.0mm) + h # z

# reference point for the column
column = add_box(geo, [0,0,-low_col_h], ℓ_col/2, b_col/2, h_col; tag="bulk")

# fuse volumes
bulk = fuse(geo, slab, column, tag="bulk")

# ===========================================================
# ----------------- LOAD PLATE DEFINITION -------------------
# ===========================================================
load_radius = 1124mm
load_θs = [20, 70] # Angle reviewed with pixel measure

# define dimensions of square plate
# assuming 10x10cm
plate_dim = [10cm, 10cm, 2cm] # TODO - REVIEW SIZE
plates = Any[]
for θ in load_θs
    load_center = [0, 0]
    plate_coord = load_center .+ load_radius .* [cosd(θ), sind(θ)]

    corner = plate_coord .- plate_dim[1:2] ./ 2
    plate  = add_box(geo, [corner..., h], plate_dim...; tag="loadPlate")
    push!(plates, plate)
end

# unite plates with volume
fragment(geo, bulk, plates)

# ===========================================================
# ----------------- IRON BARS DEFINTION ---------------------
# ===========================================================

"""
# This function creates a grid of bars for the current problem

In this function

    - n is the TOTAL number of bars, not the number of bars at symmetry
        NOTE: It is assumed that N is even ALWAYS.
    - C is a vector that represents the 'cobriment' at all directions, xyz...
    - z is the height were the bars will be placed
"""
function create_grid(geo::GeoModel, box_dim::AbstractVector{<:Real}, tag::String, interface_tag::String, n::Int, z::Real, C::AbstractVector{<:Real})
    cx, cy, cz = C
    ℓ, b, h = box_dim

    if %(n, 2) != 0
        throw(error("n must be even! Please rewrite this function so it doesnt suck, if n is pair."))
    end


    sx = (ℓ / 2 - cx) / (n / 2 -  1/2)
    sy = (b / 2 - cy) / (n / 2 -  1/2)


    # ------------------------ At the x direction
    p0x = add_point(geo, [sx/2,   0, z])
    p1x = add_point(geo, [sx/2, b/2, z])
    edgex = add_line(geo, p0x, p1x)
    pathx = add_path(geo, [edgex]; tag=tag, interface_tag=interface_tag)
    add_array(geo, pathx; nx=div(n, 2), dx=sx)

    # ------------------------ At the y direction
    p0y = add_point(geo, [0, sy/2, z])
    p1y = add_point(geo, [ℓ/2, sy/2, z])
    edgey = add_line(geo, p0y, p1y)
    pathy = add_path(geo, [edgey]; tag=tag, interface_tag=interface_tag)
    add_array(geo, pathy; ny=div(n, 2), dy=sy)

end

C = [20mm, 20mm, 25mm]


create_grid(geo, [ℓ, b, h], "topReinforcement", "barInt", 16, h - 25mm, C)
create_grid(geo, [ℓ, b, h], "botReinforcement", "barInt", 16,     25mm, C)

# ===========================================================
# ----------------- U BARS DEFINTION ------------------------
# ===========================================================
"""
NOTES:
    - 'direction' refers to the dimensions ubar is parallel to
    - n is the TOTAL number of bars, not the number of bars at symmetry
        NOTE: It is assumed that N is even ALWAYS.
"""
function create_ubars(geo::GeoModel, box_dim::AbstractVector{<:Real}, tag::String, interface_tag::String, C::Vector{Float64}, ℓ_u::Real, offset::Real, direction::String, n::Int)
    cx, cy, cz = C
    ℓ, b, h = box_dim

    if direction == "x"
        nx, ny = 1, div(n,2)
        sx = 0.0
        sy = (b/2 - cy) / (n / 2 - 1/2)

        points_u = [
            add_point(geo, [ℓ/2 - cx - ℓ_u, sy/2 + offset, h - cz]),
            add_point(geo, [ℓ/2 - cx      , sy/2 + offset, h - cz]),
            add_point(geo, [ℓ/2 - cx      , sy/2 + offset,     cz]),
            add_point(geo, [ℓ/2 - cx - ℓ_u, sy/2 + offset,     cz]),
        ]
    elseif direction == "y"
        nx, ny = div(n,2), 1
        sx = (ℓ/2 - cx) / (n / 2 - 1/2)
        sy = 0.0

        points_u = [
            add_point(geo, [sx/2 + offset, b/2 - cy - ℓ_u, h - cz]),
            add_point(geo, [sx/2 + offset, b/2 - cy      , h - cz]),
            add_point(geo, [sx/2 + offset, b/2 - cy      ,     cz]),
            add_point(geo, [sx/2 + offset, b/2 - cy - ℓ_u,     cz]),
        ]
    else
        throw(error("Direction must be 'x' or 'y'"))
    end

    edges_u = [add_line(geo,points_u[i],points_u[i+1]) for i in 1:3]
    path_u = add_path(geo, edges_u; tag=tag, interface_tag=interface_tag)
    println("nx=$ny, ny=$nx")
    add_array(geo, path_u; nx=nx, ny=ny, dx=sx, dy=sy)
end

create_ubars(geo, [ℓ, b, h], "uBar", "barInt", C, 250mm, 16mm, "x", 16)
create_ubars(geo, [ℓ, b, h], "uBar", "barInt", C, 250mm, 16mm, "y", 16)


# ===========================================================
# ----------------- MESH, COHESIVE AND VIDEO DEF. -----------
# ===========================================================

# define mesh
mesh = Mesh(geo)

# >> Cohesive elements creation
add_cohesive_elements(mesh, (z >=0, z <= h); tag="cohesive")

# view mesh
video = VideoBuilder(bounds_factor=1.05)
for az in 0:20:180
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
add_mapping(mapper, "loadPlate"      , MechSolid, LinearElastic, E=900GPa)
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
# U = UR = 0
add_bc(stage, :face, (z == upp_col_h + h); ux=0, uy=0, uz=0)
add_bc(stage, :face, (z == -low_col_h); ux=0, uy=0, uz=0)

# Uy = URx = URz = 0
add_bc(stage, :face, (x == 0); uy = 0)

# Ux = URy = URz = 0
add_bc(stage, :face, (y == 0); ux = 0)

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

