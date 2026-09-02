using Serendip

#❱❱❱ Node definitions

B = 2 * 6.1 + 6
H = 2 * (2.697 + 1.912 + 1.89)

columns = [
    0.0      0.0                 #1
    B        0.0                 #2
    0.0      H                   #3
    B        H                   #4
    6.1      0.0                 #5
    B-6.1    0.0                 #6
    6.1      H                   #7
    B-6.1    H                   #8
    6.1      3.25                #9
    B-6.1    3.25                #10
    6.1      H-3.25              #11
    B-6.1    H-3.25              #12
    0.0      H/2                 #13
    B        H/2                 #14
]

column_order = [1,5,9,10,6,2,14,4,8,12,11,7,3,13,1]
column_conn = []
for i in 1:(length(column_order)-1)
        push!(column_conn, [column_order[i], column_order[i+1]])
end
levels = [0;2.850;5.6;8.45;11.3]

#❱❱❱ Build Pórtico
N = size(columns, 1)

# Build 3D Coordinates (X, Y, Z)
# Horizontally concatenates the X,Y matrix with a Z column, then vertically stacks all floors
coord = vcat([hcat(columns, fill(z, N)) for z in levels]...)

# Build Connections
conn = Vector{Vector{Int}}()

# Vertical columns: Connect node i at level L to node i at level L+1
append!(conn, [
    [i + (L-1)*N, i + L*N]
        for L in 1:(length(levels)-1)
    for i in 1:N
])

# Horizontal beams
append!(conn, [
    [c[1] + (L-1)*N, c[2] + (L-1)*N]
        for L in 2:length(levels)
    for c in column_conn
])


mesh = Mesh(coord, conn, tag="bars")

plot = DomainPlot()
add_plot(plot, mesh)
save(plot, "test.pdf")


#❱❱❱ FEM analysis

# Bar definitions (Units: meters and kN)
b = 0.3        # 300 mm width
h = 0.4        # 400 mm height
gamma = 78.5   # Specific weight of steel (kN/m^3)

# Model definitions (Structural Steel in kN-m system)
E = 200e6      # Young's Modulus (200,000,000 kN/m^2 = 200 GPa)
nu = 0.3       # Poisson's ratio (unitless)
fy = 250e3     # Yield strength (250,000 kN/m^2 = 250 MPa)
H = 0.0        # Hardening modulus (0.0 for perfectly plastic)

# Material mapping
mapper = RegionMapper()
add_mapping(mapper, "bars", MechBeam, VonMises; b=b, h=h, gamma=gamma, E=E, nu=nu, fy=fy, H=H)

# FE model
model = FEModel(mesh, mapper)
ana = MechAnalysis(model, outkey="elastic-3d")

stage = add_stage(ana)

# Fix all 6 degrees of freedom at the ground nodes
add_bc(stage, :node, z==0, ux=0, uy=0, uz=0)

# Applying a distributed vertical downward load (e.g., -20 kN/m) on all elevated beams
add_bc(stage, :edge, z>0, qz=-20.0)

run(ana, autoinc=true)

# ❱❱❱ Post-processing
outname = "portico-3d"

plot_kwargs = (
    field = "ux",
    colormap = :coolwarm,
    label = "`u_x` [mm]",
    field_mult=1e3,
    warp = 10,
    node_labels = true,
    stage = stage
)

plot = DomainPlot(azimuth = 15);
add_plot(plot, model;
    plot_kwargs...
)
save(plot, "$outname.pdf")


video = VideoBuilder(freeze_scale=false, bounds_factor=1.05)

for az in 0:2:360
    frame = DomainPlot(azimuth = az);
    add_plot(frame, model; plot_kwargs...)
    add_frame(video, frame)
end
print("\e[K")

save(video, "$outname.mp4")
