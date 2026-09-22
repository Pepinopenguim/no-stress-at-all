using Serendip

# ===========================================================
# ================= SLAB DEFINITION =========================
# ===========================================================


# >> Beam proportions
ℓ = 2500.0e-3    # x direction
b = 2500.0e-3    # y direction
h = 180.0e-3     # z direction


# >> Define slab
geo = GeoModel(size=1)

slab = add_box(geo, [0.0, 0.0, 0.0], ℓ, b, h; tag="bulk")

# Define a single line near surface

# add top_reinforcement

function create_grid(geo::GeoModel, tag::String, C::Vector{Float64}, n::Int, d::Float64)
    cx, cy, cz = C

    p0 = add_point(geo, [cx, cy, h - cz])
    p1x = add_point(geo, [ℓ - cx, cy    , h - cz])
    p1y = add_point(geo, [cx    , b - cy, h - cz])

    top_edge_x = add_line(geo, p0, p1x)
    top_path_x = add_path(geo, [top_edge_x]; tag=tag)
    top_array_x = add_array(geo, top_path_x; ny=16, dy=155.0e-3)

    top_edge_y = add_line(geo, p0, p1y)
    top_path_y = add_path(geo, [top_edge_y]; tag=tag)
    top_array_y = add_array(geo, top_path_y; nx=16, dx=155.0e-3)
end

create_grid(geo, "topReinforcement", [87.5e-3, 87.5e-3, h - 25e-3], 16, 155.0e-3)
create_grid(geo, "botReinforcement", [87.5e-3, 87.5e-3, 25e-3], 16, 155.0e-3)

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
# NOTE - signal of ℓ_u inverts its orientation
create_ubars(geo, "uBar", [87.5e-3, 87.5e-3, 25e-3], 250.0e-3, x, 16, 155.0e-3)
create_ubars(geo, "uBar", [ℓ - 87.5e-3, 87.5e-3, 25e-3], -250.0e-3, x, 16, 155.0e-3)
create_ubars(geo, "uBar", [87.5e-3, 87.5e-3, 25e-3], 250.0e-3, y, 16, 155.0e-3)
create_ubars(geo, "uBar", [87.5e-3, b - 87.5e-3, 25e-3], -250.0e-3, y, 16, 155.0e-3)

# >> define column
ℓ_col = 300.0e-3             # x
b_col = 300.0e-3             # y
# respectively, lower bound, upper bound, slab height
h_col = (low_col_h = 600.0e-3) + (upp_col_h = 800.0e-3) + h # z

col_origin = [(ℓ - ℓ_col) / 2, (b - b_col) / 2, -low_col_h]

column = add_box(geo, col_origin, ℓ_col, b_col, h_col; tag="bulk")

# define column bars
c = 30e-3 # spacing from the edge. TODO - review
col_bar_spacing = [(ℓ_col - 2c)/2, (b_col - 2c)/2]

col_bar_coords_xy = [
    col_origin[1] + c                       col_origin[2] + c;                             #bottom left
    col_origin[1] + c +  col_bar_spacing[1] col_origin[2] + c;                             #bottom mid
    col_origin[1] + c + 2col_bar_spacing[1] col_origin[2] + c;                             #bottom right

    col_origin[1] + c                       col_origin[2] + c + col_bar_spacing[2];        #mid left
    col_origin[1] + c + 2col_bar_spacing[1] col_origin[2] + c + col_bar_spacing[2];        #mid right

    col_origin[1] + c                       col_origin[2] + c + 2col_bar_spacing[2];       #top left
    col_origin[1] + c +  col_bar_spacing[1] col_origin[2] + c + 2col_bar_spacing[2];       #top mid
    col_origin[1] + c + 2col_bar_spacing[1] col_origin[2] + c + 2col_bar_spacing[2];       #top right
]

for (x, y) in eachrow(col_bar_coords_xy)
    p0 = add_point(geo, [x, y, -low_col_h])
    p1 = add_point(geo, [x, y, +upp_col_h])
    bar = add_line(geo, p0, p1)
    path = add_path(geo, [bar], tag="columnReinforcement")
end

# column stirrups

col_stirrup_xy = [
    col_origin[1] + c                       col_origin[2] + c;                             #bottom left
    col_origin[1] + c + 2col_bar_spacing[1] col_origin[2] + c;                             #bottom right
    col_origin[1] + c + 2col_bar_spacing[1] col_origin[2] + c + 2col_bar_spacing[2];       #top right
    col_origin[1] + c                       col_origin[2] + c + 2col_bar_spacing[2];       #top left
    col_origin[1] + c                       col_origin[2] + c;                             #bottom left
]

col_stirrup_points = [
    add_point(geo, [x, y, -low_col_h + c])
    for (x, y) in eachrow(col_stirrup_xy)
]

col_stirrup_lines = [
    add_line(geo, p0, p1)
    for (p0, p1) in zip(
        col_stirrup_points[1:end-1],
        col_stirrup_points[2:end],
    )
]

col_stirrup_path = add_path(
    geo,
    col_stirrup_lines;
    tag = "columnStirrup",
)

col_stirrup_array = add_array(geo, col_stirrup_path; nz=18, dz=80.0e-3)

# fuse volumes
bulk = fuse(geo, slab, column, tag="bulk")

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

# >> Materials

# TODO - REVIEW VALUES, BORROWED FROM OTHER CODE

# >> Concreto

Ec    = 45e6 # 45 GPa do artigo
nu    = 0.2
fc    = -97e3 # 97 MPa do artigo
ft    = 4e3 # !adotado
alpha = 1.2 + 0.1*√(-fc/ft)
GF    = 0.166 # 166 N/m
wc    = GF/(0.1947*ft)
zeta  = 10

# Aço cabo protendido 

Ep   = 200e6  # 200 GPa nos artigos
fyp  = 1674e3 # artigo hussien
fp   = 1000e3 # tensão de protensão
ϕp   = 0.012  # diâmetro aço protendido
Ap   = pi*ϕp^2/4
pp   = ϕp*pi  # perímetro da barra
kp   = 1e0    # Valor baixo artificial
kn   = 1e9
ktip = 1e8    # 100 GN/m artigo

# Aço passivo

Ea  = 200e6 # 200 GPa do artigo
fya = 470e3 # 470 MPa do artigo
ϕa  = 0.010 # Diâmetro 1 barra
Aa  = pi*ϕa^2/4 # Área de uma barra de espessura ϕa (m²)
pa  = ϕa*pi  # perímetro da barra

# Contato aço-Concreto

tmax10  = 2.5*√abs(fc/1e3)*1e3
tmax10  = tmax10/2
tres10  = 0.4*tmax10
speak10 = 0.07*ϕa # 0.7mm no artigo
speak10 = 1e-3

# >> Mappers

mapper = RegionMapper()

add_mapping(mapper, "bulk", MechSolid, LinearElastic, E=Ec, nu=nu)
add_mapping(mapper, "topReinforcement")
add_mapping(mapper, "botReinforcement")
add_mapping(mapper, "uBar")
add_mapping(mapper, "columnReinforcement", MechBar, VonMises, E=Ea)
add_mapping(mapper, "columnStirrup")