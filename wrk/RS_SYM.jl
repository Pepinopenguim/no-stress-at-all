using Serendip
using LinearAlgebra: sind, cosd, tand

rel_path = "./"
proj_folder = "RS_SYM/"

const m = 1
const mm = 1m * 1e-3
const cm = 1m * 1e-2

const N = 1e-3
const kN = 1N*1e3

const s = 1

const Pa = 1e-3
const kPa = 1Pa * 1e3
const MPa = 1Pa * 1e6
const GPa = 1Pa * 1e9

const approx = .999

# Slab
ℓ = 2500.0mm
b = 2500.0mm
h = 180.0mm

msh_size = 20cm

geo = GeoModel(size=msh_size)

slab = add_box(geo, [0.0, 0.0, 0.0], ℓ/2, b/2, h; tag="bulk")

# Column
ℓ_col = 300.0mm
b_col = 300.0mm
low_col_h = 600.0mm
upp_col_h = 800.0mm
h_col = low_col_h + upp_col_h + h

column = add_box(geo, [0, 0, -low_col_h], ℓ_col/2, b_col/2, h_col; tag="bulk")

bulk = fuse(geo, slab, column, tag="bulk")

# Load plates
load_radius = 1124mm
load_θs = [20, 70]

plate_dim = [10cm, 10cm, 2cm]
plates, plate_coords = Any[], Any[]
for θ in load_θs
    load_center = [0, 0]
    plate_coord = load_center .+ load_radius .* [cosd(θ), sind(θ)]

    corner = plate_coord .- plate_dim[1:2] ./ 2
    plate = add_box(geo, [corner..., h], plate_dim...; tag="loadPlate")
    push!(plates, plate)

    add_point(geo, [plate_coord..., 2cm+h], embedded=true)
    push!(plate_coords, plate_coord)
end

fragment(geo, bulk, plates)

# Reinforcement grids (top and bottom)
C = [20mm, 20mm, 20mm]
n_grid = 16
cx, cy, cz = C
sx = (ℓ/2 - cx) / (n_grid/2 - 1/2)
sy = (b/2 - cy) / (n_grid/2 - 1/2)

for (tag, int_tag, z) in [("topReinforcement", "barInt16", h - 25mm),
                           ("botReinforcement", "barInt10", 25mm)]
    p0x = add_point(geo, [sx/2, 0, z])
    p1x = add_point(geo, [sx/2, b/2, z])
    edgex = add_line(geo, p0x, p1x)
    pathx = add_path(geo, [edgex]; tag=tag, interface_tag=int_tag)
    add_array(geo, pathx; nx=div(n_grid, 2), dx=155mm)

    p0y = add_point(geo, [0, sy/2, z])
    p1y = add_point(geo, [ℓ/2, sy/2, z])
    edgey = add_line(geo, p0y, p1y)
    pathy = add_path(geo, [edgey]; tag=tag, interface_tag=int_tag)
    add_array(geo, pathy; ny=div(n_grid, 2), dy=155mm)
end

# U bars - x direction
ℓ_u = 250mm
offset = 16mm
n = 16

nx, ny = 1, div(n, 2)
sx_u = 0.0
sy_u = (b/2 - cy) / (n/2 - 1/2)

points_u = [
    add_point(geo, [ℓ/2 - cx - ℓ_u, sy_u/2 + offset, h - cz]),
    add_point(geo, [ℓ/2 - cx, sy_u/2 + offset, h - cz]),
    add_point(geo, [ℓ/2 - cx, sy_u/2 + offset, cz]),
    add_point(geo, [ℓ/2 - cx - ℓ_u, sy_u/2 + offset, cz]),
]
edges_u = [add_line(geo, points_u[i], points_u[i+1]) for i in 1:3]
path_u = add_path(geo, edges_u; tag="uBar", interface_tag="barInt16")
add_array(geo, path_u; nx=nx, ny=ny, dx=sx_u, dy=sy_u)

# U bars - y direction
nx, ny = div(n, 2), 1
sx_u = (ℓ/2 - cx) / (n/2 - 1/2)
sy_u = 0.0

points_u = [
    add_point(geo, [sx_u/2 + offset, b/2 - cy - ℓ_u, h - cz]),
    add_point(geo, [sx_u/2 + offset, b/2 - cy, h - cz]),
    add_point(geo, [sx_u/2 + offset, b/2 - cy, cz]),
    add_point(geo, [sx_u/2 + offset, b/2 - cy - ℓ_u, cz]),
]
edges_u = [add_line(geo, points_u[i], points_u[i+1]) for i in 1:3]
path_u = add_path(geo, edges_u; tag="uBar", interface_tag="barInt16")
add_array(geo, path_u; nx=nx, ny=ny, dx=sx_u, dy=sy_u)

# LVDT points
logger_X = [
     275  0
     475  0
     725  0
    1170  0
    0     275
    0     475
    0     725
    0     1170
] * mm

logger_points = []
for (i, (xv, yv)) in enumerate(eachrow(logger_X))
    p = add_point(geo, [xv, yv, h*approx]; embedded=true, tag="logger$i")
    push!(logger_points, p)
end

# Column bars
for (x, y, tag, int_tag) in [
    (ℓ_col / 2 - 20mm, b_col / 2 - 20mm, "ColReinforcement", "barInt16"),
    (ℓ_col / 2 - 20mm,                0, "halfColRfcmnt", "halfBarInt16"),
    (               0, b_col / 2 - 20mm, "halfColRfcmnt", "halfBarInt16"),
]
    p_low = add_point(geo, [x, y, -low_col_h])
    p_high = add_point(geo, [x, y, upp_col_h])
    bar_line = add_line(geo, p_low, p_high)
    bar_path = add_path(geo, [bar_line], tag=tag, interface_tag=int_tag)
end

# Column stirrups
points = [
    add_point(geo, [ℓ_col / 2 - 20mm, 0, -low_col_h]),
    add_point(geo, [ℓ_col / 2 - 20mm, b_col / 2 - 20mm, -low_col_h]),
    add_point(geo, [0, b_col / 2 - 20mm, -low_col_h]),
]
edges = [
    add_line(geo, points[1], points[2]),
    add_line(geo, points[2], points[3]),
]
path = add_path(geo, edges; tag="ColReinforcement", interface_tag="barInt16")
add_array(geo, path; nz=18, dz=80mm)

# Mesh
set_refinement(geo, [0, 0, h/2], ℓ/2, b/2, 2h, msh_size/3, msh_size, transition=0.8, roundness=0.8)

mesh = Mesh(geo)

save(mesh, "$rel_path/$proj_folder/mesh.vtu")

add_cohesive_elements(mesh, "bulk"; tag="cohesive")

