#❱❱❱ Simple beam example ❰❰❰#

using Serendip

# ❱❱❱ Mesh generation

# geometric aspects of slab
l = 6.0   # x direction
b = 5.0   # y direction
h = 0.6   # z direction

geo  = GeoModel(size=0.2)
base = add_rectangle(geo, [0,0,0], l, b)
volume = extrude(geo, base, [0,0,h])

# Add a set of bars to work as reinforcement
# Defined in the x direction
c = 0.03 # cover
num_lines = 8 # number of bars to fix across y
lines = []

for cur_y in range(c, b - c, num_lines)
    startpoint = add_point(geo, [c, cur_y, c])
    endpoint = add_point(geo, [l - c, cur_y, c])
    push!(lines, add_line(geo, startpoint, endpoint))
end

for line in lines
    add_path(geo, [line], mode=:interface,  tag="reinforcement", interface_tag="contact")
end

mesh = Mesh(geo)

save(mesh, "simple-beam-mesh.vtu")

plot = DomainPlot()
add_plot(plot, mesh; view_mode= :wireframe)
save(plot, "simple-beam-mesh.pdf")

# ❱❱❱ Finite element analysis

mapper = RegionMapper()
add_mapping(mapper, :solid, MechSolid, LinearElastic, E=22.0e6, nu=0.25)
add_mapping(mapper, "reinforcement", MechBar, LinearElastic, A=0.001, E=200e6, nu=0.2)
add_mapping(mapper, "contact", MechBondSlip, LinearBondSlip, p=2*sqrt(.001/π), ks=1e8, kn=1e10)

model = FEModel(mesh, mapper)

ana   = MechAnalysis(model, outkey="simple-slab")
stage = add_stage(ana, nincs=10, nouts=5)

add_bc(stage, :face, (x==0), ux=0, uy=0, uz=0) # fixed support
add_bc(stage, :face, (x==l), ux=0, uy=0, uz=0) # fixed support
add_bc(stage, :face, (y==0), ux=0, uy=0, uz=0) # fixed support
add_bc(stage, :face, (z==h), tz=-1000) # surface load

run(ana)

# save(model, "beam.vtu")

# ❱❱❱ Post-processing


plot = DomainPlot(azimuth=-30)
add_plot(plot, model;
    warp=50,
    field="σxx",
    field_mult=1e3,
    label="`u_z` [mm]",
    colormap=:spectral,
    view_mode=:surface,
)
save(plot, "simple-beam.pdf")