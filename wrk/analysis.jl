include("mesh.jl")

# Materials
Ec = 21.551GPa
nu = 0.2
ft = 1.8MPa
GF = .134kN/m
μ = tand(55)

Es1 = 196.9GPa
fy1 = 549.0MPa

Es2 = 126.6GPa
fy2 = 515.0MPa

tmax10 = 13.7MPa
tres10 = 5.5MPa
s1_10 = 1mm
s2_10 = 1.1mm
s3_10 = 16mm
alpha_aco = 0.58

# case_name, bond_factor, steel_factor
cases = [
    ("original",   1.0, 1.0),
    ("weak_bond",  0.5, 1.0),
    ("weak_steel", 1.0, 0.8),
]

for (case_name, bond_factor, steel_factor) in cases

    tmax_c = tmax10 * bond_factor
    tres_c = tres10 * bond_factor

    ks_c = 2*tmax_c/s1_10
    kn_c = 150*ks_c

    fy1_c = fy1 * steel_factor
    fy2_c = fy2 * steel_factor

    mapper = RegionMapper()

    add_mapping(mapper, "bulk", MechSolid, LinearElastic, E=Ec, nu=nu)
    add_mapping(mapper, "cohesive", MechCohesive, MohrCoulombCohesive, E=Ec, nu=nu, ft=ft, GF=GF, mu=μ)
    add_mapping(mapper, "loadPlate", MechSolid, LinearElastic, E=900GPa)

    add_mapping(mapper, "topReinforcement", MechBeam, VonMises, d=16mm, E=Es1, fy=fy1_c)
    add_mapping(mapper, "botReinforcement", MechBeam, VonMises, d=10mm, E=Es2, fy=fy2_c)

    add_mapping(mapper, "ColReinforcement", MechBar, VonMises, d=16mm, E=Es1, fy=fy1_c)
    add_mapping(mapper, "halfColRfcmnt", MechBar, VonMises, A=(π*(8mm)^2)/2, E=Es1, fy=fy1_c)
    add_mapping(mapper, "uBar", MechBeam, VonMises, d=16mm, E=Es1, fy=fy1_c)

    add_mapping(mapper, "barInt16", MechBondSlip, CebBondSlip,
        taumax=tmax_c, taures=tres_c, s1=s1_10, s2=s2_10, s3=s3_10,
        alpha=alpha_aco, p=π*16mm, ks=ks_c, kn=kn_c)

    add_mapping(mapper, "barInt10", MechBondSlip, CebBondSlip,
        taumax=tmax_c, taures=tres_c, s1=s1_10, s2=s2_10, s3=s3_10,
        alpha=alpha_aco, p=π*10mm, ks=ks_c, kn=kn_c)

    add_mapping(mapper, "halfBarInt16", MechBondSlip, CebBondSlip,
        taumax=tmax_c, taures=tres_c, s1=s1_10, s2=s2_10, s3=s3_10,
        alpha=alpha_aco, p=π/2*16mm, ks=ks_c, kn=kn_c)

    model = FEModel(mesh, mapper; g=9.81m/s^2)

    ana = MechAnalysis(
        model;
        outkey="RS_SYM_$(case_name)",
        outdir="$rel_path//RS_SYM_$(case_name)"
    )

    stage = add_stage(ana, nincs=100, nouts=50)

    # Boundary conditions
    add_bc(stage, :face, (z == upp_col_h + h); ux=0, uy=0)
    add_bc(stage, :face, (z == -low_col_h); ux=0, uy=0, uz=0)

    add_bc(stage, :node, (x == 0); ux = 0)
    add_bc(stage, :node, (y == 0); uy = 0)

    z_top = h + plate_dim[3]

    for (θ, plate_coord) in zip(load_θs, plate_coords)
        add_bc(
            stage,
            :node,
            (x==plate_coord[1], y==plate_coord[2], z==z_top);
            uz = -25mm
        )

        add_logger(
            ana,
            :nodalreduce,
            (x==plate_coord[1], y==plate_coord[2], z==z_top),
            "logger_load_$(case_name)_$θ.dat"
        )
    end

    for i in 1:length(logger_points)
        add_logger(
            ana,
            :nodalreduce,
            "logger$i",
            "logger_$(case_name)_$i.dat"
        )

        add_monitor(ana, :node, "logger$i", :uz)
    end

    run(ana, tol=1kN, autoinc=true)
end