using Serendip

# ===========================================================
# ================= SLAB DEFINITION =========================
# ===========================================================
# >> Reinforcement
struct Reinforcement
    n::Int
    ϕ::Float64
    Δ::Float64  # center-to-center spacing
end


# >> U-bar
struct UBar
    n::Int
    ϕ::Float64
    Δ::Float64  # center-to-center spacing
    x::Float64
    z::Float64
end


# Defines offset for given reinforcement
reinforcement_offset(rein::Reinforcement, l) =
    (l - (rein.n - 1) * rein.Δ) / 2


# >> Top reinforcement
# 16 ϕ 16.0 @ 155
top_reinforcement = Reinforcement(
    16,
    16.0,
    155.0,
)


# >> Bottom reinforcement
# 16 ϕ 10.0 @ 155
bot_reinforcement = Reinforcement(
    16,
    10.0,
    155.0,
)


# >> U-bar at edges
# 130 (z) x 250 (x or y)
# (2x) ϕ 16.0 @ 155
u_bar = UBar(
    2,
    16.0,
    155.0,
    250.0,
    130.0,
)


# >> Beam proportions
ℓ = 2500.0    # x direction
b = 2500.0    # y direction
h = 180.0     # z direction

# Removed the *1e3 conversion factor
z_offset = (h - u_bar.z) / 2

# ===========================================================
# ================= COLUMN DEFINITION =======================
# ===========================================================

column_reinforcement = Reinforcement(8, 16.0, 0.0)

column_shear_armor = Reinforcement(18, 10.0, 80.0)

# ===========================================================
# ================= GEOMODEL ================================
# ===========================================================

# >> Define box 
# NOTE - Assuming symmetry. 
geo = GeoModel(size=1)

box = add_box(geo, [0.0, 0.0, 0.0], ℓ, b, h; tag="bulk")

# Define first bar of top reinforcement
offset_top = reinforcement_offset(top_reinforcement, ℓ)

p0_top = add_point(geo, [offset_top, offset_top, z_offset + u_bar.z])
px_top = add_point(geo, [ℓ - offset_top, offset_top, z_offset + u_bar.z])
py_top = add_point(geo, [offset_top, ℓ - offset_top, z_offset + u_bar.z])

barx_top = add_line(geo, p0_top, px_top, "top-bar")
bary_top = add_line(geo, p0_top, py_top, "top-bar")
add_array()

# add top_reinforcement