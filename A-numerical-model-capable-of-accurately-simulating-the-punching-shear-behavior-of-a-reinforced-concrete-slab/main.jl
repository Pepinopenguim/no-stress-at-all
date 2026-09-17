using Serendip

# ===========================================================
# ================= SLAB DEFINITION =========================
# ===========================================================


# >> Beam proportions
ℓ = 2500.0    # x direction
b = 2500.0    # y direction
h = 180.0     # z direction


# >> Define box 
geo = GeoModel(size=1000)

box = add_box(geo, [0.0, 0.0, 0.0], ℓ, b, h; tag="bulk")

# Define a single line near surface

# add top_reinforcement

function create_grid(geo::GeoModel, tag::String, C::Vector{Float64}, n::Int, d::Float64)
    cx, cy, cz = C

    p0 = add_point(geo, [cx, cy, h - cz])
    p1x = add_point(geo, [ℓ - cx, cy    , h - cz])
    p1y = add_point(geo, [cx    , b - cy, h - cz])

    top_edge_x = add_line(geo, p0, p1x)
    top_path_x = add_path(geo, [top_edge_x]; tag=tag)
    top_array_x = add_array(geo, top_path_x; ny=16, dy=155.0)

    top_edge_y = add_line(geo, p0, p1y)
    top_path_y = add_path(geo, [top_edge_y]; tag=tag)
    top_array_y = add_array(geo, top_path_y; nx=16, dx=155.0)
end

create_grid(geo, "topReinforcement", [87.5, 87.5, h - 25], 16, 155.0)
create_grid(geo, "botReinforcement", [87.5, 87.5, 25], 16, 155.0)

# define U reinforcements
# _ux -> parallel to x
@enum Direction x y
function create_ubars(geo::GeoModel, tag::String, C::Vector{Float64}, ℓ_u::Float64, direction::Direction, n::Int, d::Float64)
    cx, cy, cz = C

    (∇x, ∇y, nx, ny, dx, dy) = direction == x ? (ℓ_u, 0, 1, n, 0.0, d) : (0, ℓ_u, n, 1, d, 0.0)

    points_u = [
        add_point(geo, [cx + ∇x, cy + ∇y, h - cz])
        add_point(geo, [cx, cy, h - cz])
        add_point(geo, [cx, cy, cz])
        add_point(geo, [cx + ∇x, cy + ∇y, cz])
    ]

    edges_u = [add_line(geo,points_u[i],points_u[i+1]) for i in 1:3]
    path_u = add_path(geo, edges_u; tag=tag)
    add_array(geo, path_u; nx=nx, ny=ny, dx=dx, dy=dy)
end

create_ubars(geo, "uBar", [87.5, 87.5, 25], 250.0, x, 16, 155.0)
create_ubars(geo, "uBar", [ℓ - 87.5, 87.5, 25], -250.0, x, 16, 155.0)
create_ubars(geo, "uBar", [87.5, 87.5, 25], 250.0, y, 16, 155.0)
create_ubars(geo, "uBar", [87.5, b - 87.5, 25], -250.0, y, 16, 155.0)

# define mesh

mesh = Mesh(geo)

# view mesh

video = VideoBuilder(bounds_factor=1.05)

for az in 0:10:360
    frame = DomainPlot(azimuth=az)
    add_plot(frame, mesh, view_mode=:wireframe)
    add_frame(video, frame)
end

save(video, "test.mp4")
