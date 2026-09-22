using Serendip

# 1. Geometria da Viga-Parede (Unidade em metros)
geo = GeoModel(size=1)

# 1.1 Coordenadas da viga-parede
p1  = add_point(geo, [0, 0, 0])
pl1 = add_point(geo, [0.14, 0, 0])
pl2 = add_point(geo, [0.14, 0.04, 0])
p2  = add_point(geo, [0.2, 0.04, 0])
p3  = add_point(geo, [0.2, 0.14, 0])
p4  = add_point(geo, [0.5, 0.14, 0])
p5  = add_point(geo, [0.5, 0.04, 0])
pl3 = add_point(geo, [0.86, 0.04, 0])
pl4 = add_point(geo, [0.86, 0, 0])
p6  = add_point(geo, [1, 0, 0])
pl5 = add_point(geo, [1, 0.04, 0])
p7  = add_point(geo, [1, 0.74, 0])
p8  = add_point(geo, [0, 0.74, 0])
pl10 = add_point(geo, [0, 0.04, 0])
h1  = add_point(geo, [0.732, 0.405, 0]) #furo
h2  = add_point(geo, [0.838, 0.511, 0]) #furo
h3  = add_point(geo, [0.732, 0.617, 0]) #furo
h4  = add_point(geo, [0.626, 0.511, 0]) #furo

h5  = add_point(geo, [0.275, 0.234, 0]) #furo*
h6  = add_point(geo, [0.381, 0.340, 0]) #furo*
h7  = add_point(geo, [0.275, 0.446, 0]) #furo*
h8  = add_point(geo, [0.169, 0.340, 0]) #furo*
l1 = add_point(geo, [0.5, 0.78, 0])
l2  = add_point(geo, [0.5,0.78, 0.14])

l3 = add_point(geo, [0.07, 0, 0]) #apoio_1
l4 = add_point(geo, [0.07, 0, 0.14]) #apoio_1

l5 = add_point(geo, [0.93, 0, 0]) #apoio_2
l6 = add_point(geo, [0.93, 0, 0.14]) #apoio_2

# 1.3 Superfície da viga-parede
# s1 = add_polygon(geo, [pl10, p2, p3, p4, p5, pl5, p7, p8])
# s2 = add_polygon(geo, [h1, h2, h3, h4])
# s3 = add_polygon(geo, [p1, pl1, pl2, pl10]) #Apoios 1
# s4 = add_polygon(geo, [pl4, p6, pl5, pl3]) #Apoios 2
# s5 = add_disk(geo, [0.5, 0.74, 0.07], [0, 1, 0], 0.07) #aplicação de carga
# s6 = add_polygon(geo, [h5, h6, h7, h8]) #furo2
# Viga_f1 = cut(geo, s1, s2)
# Viga = cut(geo, Viga_f1, s6)

# 1.4 Extrusão da viga-parede
viga_vol = extrude(geo, Viga, [0, 0, 0.14])
apoio_1 = extrude(geo, s3, [0, 0, 0.14])
apoio_2 = extrude(geo, s4, [0, 0, 0.14])
aplicacao_carga = extrude(geo, s5, [0, 0.04, 0])
l = add_line(geo, l1, l2)
l_apoio_1 = add_line(geo, l3, l4)
l_apoio_2 = add_line(geo, l5, l6)

placas = [apoio_1, l, l_apoio_1, l_apoio_2, apoio_2, aplicacao_carga]
fragment(geo, viga_vol, placas)
#1.5 Armadura da viga-parede

# Coordenadas da armadura N1
a1 = add_point(geo, [0.025, 0.165, 0.025])
a2 = add_point(geo, [0.685, 0.165, 0.025])
al1 = add_line(geo, a1, a2)
N1 = add_path(geo, [al1], tag="bar_N1", interface_tag="bar_N1-interface")
add_array(geo, N1, nz=3, dz=0.045)

# Coordenadas da armadura N2
b1 = add_point(geo, [0.025, 0.160, 0.025])
b2 = add_point(geo, [0.025, 0.065, 0.025])
b3 = add_point(geo, [0.175, 0.065, 0.025])
b4 = add_point(geo, [0.175, 0.225, 0.025])
al2 = add_line(geo, b1, b2)
al3 = add_line(geo, b2, b3)
al4 = add_line(geo, b3, b4)
N2 = add_path(geo, [al2, al3, al4], tag="bar_N2", interface_tag="bar_N2-interface")
add_array(geo, N2, nz=3, dz=0.045)

# Coordenadas da armadura N3
c1 = add_point(geo, [0.525, 0.225, 0.025])
c2 = add_point(geo, [0.525, 0.065, 0.025])
c3 = add_point(geo, [0.975, 0.065, 0.025])
c4 = add_point(geo, [0.975, 0.160, 0.025])
al5 = add_line(geo, c1, c2)
al6 = add_line(geo, c2, c3)
al7 = add_line(geo, c3, c4)
N3 = add_path(geo, [al5, al6, al7], tag="bar_N3", interface_tag="bar_N3-interface")
add_array(geo, N3, nz=3, dz=0.045)

#Coordenadas da armadura N4
d1 = add_point(geo, [0.045, 0.065, 0.025])
d2 = add_point(geo, [0.045, 0.715, 0.025])
d3 = add_point(geo, [0.045, 0.715, 0.115])
d4 = add_point(geo, [0.045, 0.065, 0.115])
al8 = add_line(geo, d1, d2)
al9 = add_line(geo, d2, d3)
al10 = add_line(geo, d3, d4)
al11 = add_line(geo, d4, d1)
N4 = add_path(geo, [al8, al9, al10, al11], tag="bar_N4", interface_tag="bar_N4-interface")

d1f = add_point(geo, [0.582, 0.065, 0.025])
d2f = add_point(geo, [0.582, 0.715, 0.025])
d3f = add_point(geo, [0.582, 0.715, 0.115])
d4f = add_point(geo, [0.582, 0.065, 0.115])
l10f = add_line(geo, d1f, d2f)
l11f = add_line(geo, d2f, d3f)
l12f = add_line(geo, d3f, d4f)
l13f = add_line(geo, d4f, d1f)
N4f = add_path(geo, [l10f, l11f, l12f, l13f], tag="bar_N4f", interface_tag="bar_N4f-interfac")
add_array(geo, N4f, nx=2, dx=0.330)

#Coordenadas da armadura N5
e1 = add_point(geo, [0.025, 0.655, 0.025])
e2 = add_point(geo, [0.975, 0.655, 0.025])
e3 = add_point(geo, [0.975, 0.655, 0.115])
e4 = add_point(geo, [0.025, 0.655, 0.115])
al12 = add_line(geo, e1, e2)
al13 = add_line(geo, e2, e3)
al14 = add_line(geo, e3, e4)
al15 = add_line(geo, e4, e1)
N5 = add_path(geo, [al12, al13, al14, al15], tag="bar_N5", interface_tag="bar_N5-interface")

#Coordenadas da armadura N6
f1 = add_point(geo, [0.547, 0.355, 0.025])
f2 = add_point(geo, [0.947, 0.355, 0.025])
al16 = add_line(geo, f1, f2)
N6 = add_path(geo, [al16], tag="bar_N6", interface_tag="bar_N6-interface")
add_array(geo, N6, nz=2, dz=0.5*0.14)

#1.6 Reforço da viga parede NSM

r1 = add_point(geo, [0.001, 0.165,0.001])
r2 = add_point(geo, [0.999, 0.165,0.001])
r3 = add_point(geo, [0.999, 0.165,0.138])
r4 = add_point(geo, [0.001, 0.165,0.138])
rl10 = add_line(geo, r1, r2)
rl11 = add_line(geo, r2, r3)
rl12 = add_line(geo, r3, r4)
rl13 = add_line(geo, r4, r1)
R1 = add_path(geo, [rl10, rl11, rl12, rl13], tag="Lamina_1", interface_tag="Lam1_int")


# 2. Geração da malha
mesh = Mesh(geo)


# view mesh

video = VideoBuilder(freeze_scale=false, bounds_factor=1.05)

for az in 0:20:360
    frame = DomainPlot(azimuth=az)
    add_plot(
        frame,
        mesh,
        view_mode=:wireframe
    )
    add_frame(video, frame)
end

save(video, "test.mp4")


# 3. Classificação dos elementos
select(mesh, :element, :bulk, tag="concreto")
select(mesh, :element, :bulk, y<=0.040, tag="steel_plates_inf")
select(mesh, :element, :bulk, y>=0.740, tag="steel_plates_sup")
add_cohesive_elements(mesh, "concreto", tag="cohesive")


# 4. Análise de elementos finitos

#concreto
E  = 40.76e6      # Módulo de Elasticidade (kN/m²)
ft = 0.9*4.15e3       # Resistência à tração 0.9*4.15e3 (kN/m²)
fc = -51.94e3     # Resistência à compressão = 51,94 (kN/m²)
GF = 0.05        # kN/m
nu = 0.2
mu = 1.4

#Aço
Ea = 200e6       # Módulo de Elasticidade do aço (kN/m²)
fy_aco  = 556e3       # Tensão de escoamento do aço 10 mm(kN/m²)
fy1_aco = 649e3        # 6.3 mm
fy2_aco = 592e3        # 8 mm
Ha  = 0
ϕa  = 0.010 # Diâmetro 1 barra
ϕb  = 0.0063
ϕc  = 0.008
Aa  = pi*ϕa^2/4 # Área de uma barra de espessura ϕa (m²)
Ab  = pi*ϕb^2/4
Ac  = pi*ϕc^2/4
pa  = ϕa*pi  # perímetro da barra
pb  = ϕb*pi
pc  = ϕc*pi

# Contato aço-Concreto
tmax10  =  10.77e3
tmax63  =  10e3
tmax8   =  10.33e3
tres10  =  0.8e3
tres63  =  0.9e3
tres8   =  0.9e3
s1_10      = 0.55e-3
s1_63   = 0.30e-3
s1_8    = 0.42e-3
s2_10      = s1_10*1.1
s2_63   = s1_63*1.1
s2_8    = s1_8*1.1
s3_10      = 12e-3
s3_63   = 12e-3
s3_8    = 12e-3
ks10    = 1*tmax10/s1_10
ks_63   = 1*tmax63/s1_63
ks_8    = 1*tmax8/s1_8
kn_10   = 150*ks10
kn_63   = 150*ks_63
kn_8    = 150*ks_8
alpha_aco = 0.58

# Lâmina de PRFC (NSM)
b1_lam = 2.4e-3
b2_lam = 10e-3
A_lam  = b1_lam*b2_lam
p_lam  = 2*b2_lam+b1_lam
E_lam  = 164e6
nu_lam = 0.3

#Manta de PRFC (EBR)
E_man  = 238e6
e_man  = 0.166e-3
l_man  = 50e-3
A_man  = e_man*l_man
nu_man = 0.3

ks_ref = 1e9
kn_ref = 100*ks_ref

#Parâmetros equivalentes
E_equ = (E_lam*A_lam + E_man*A_man)/(A_lam+A_man)
A_equ = A_lam + A_man

mapper = RegionMapper()
# Mapeamento do Concreto
add_mapping(mapper, "concreto", MechBulk, LinearElastic, E=E, nu=nu)
add_mapping(mapper, "cohesive", MechCohesive, MohrCoulombCohesive, E=E, nu=nu, ft=ft, GF=GF, mu=mu)

# Mapeamento das Placas de Aço
add_mapping(mapper, "steel_plates_inf", MechBulk, LinearElastic, E=200e6, nu=0.3)
add_mapping(mapper, "steel_plates_sup", MechBulk, LinearElastic, E=200e6, nu=0.3)

# Mapeamento das barras de aço
add_mapping(mapper, "bar_N1", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha)
add_mapping(mapper, "bar_N2", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha)
add_mapping(mapper, "bar_N3", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha)
add_mapping(mapper, "bar_N4", MechBar, VonMises, E=Ea, A=Ab, fy=fy1_aco, H=Ha)
add_mapping(mapper, "bar_N4f", MechBar, VonMises, E=Ea, A=Ab, fy=fy1_aco, H=Ha)
add_mapping(mapper, "bar_N5", MechBar, VonMises, E=Ea, A=Ab, fy=fy1_aco, H=Ha)
add_mapping(mapper, "bar_N6", MechBar, VonMises, E=Ea, A=Ac, fy=fy2_aco, H=Ha)
add_mapping(mapper, "bar_N1-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10)
add_mapping(mapper, "bar_N2-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10)
add_mapping(mapper, "bar_N3-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10)

add_mapping(mapper, "bar_N4-interface", MechBondSlip, CebBondSlip, taumax=tmax63, taures=tres63, s1=s1_63, s2= s2_63, s3=s3_63, alpha=alpha_aco, p=pb, ks=ks_63, kn=kn_63)
add_mapping(mapper, "bar_N4f-interfac", MechBondSlip, CebBondSlip, taumax=tmax63, taures=tres63, s1=s1_63, s2= s2_63, s3=s3_63, alpha=alpha_aco, p=pb, ks=ks_63, kn=kn_63)
add_mapping(mapper, "bar_N5-interface", MechBondSlip, CebBondSlip, taumax=tmax63, taures=tres63, s1=s1_63, s2= s2_63, s3=s3_63, alpha=alpha_aco, p=pb, ks=ks_63, kn=kn_63)

add_mapping(mapper, "bar_N6-interface", MechBondSlip, CebBondSlip, taumax=tmax8, taures=tres8, s1=s1_8, s2= s2_8, s3=s3_8, alpha=alpha_aco, p=pc, ks=ks_8, kn=kn_8)

# Mapeamento das lâminas de PRFC
add_mapping(mapper, "Lamina_1", MechBar, LinearElastic, E=E_equ, A=A_equ, nu=nu_lam)
add_mapping(mapper, "Lam1_int", MechBondSlip,  LinearBondSlip, ks=ks_ref, kn=kn_ref, p=p_lam)

model = FEModel(mesh, mapper)

ana   = MechAnalysis(model, outkey="Vigaparede_DB3_W_H2_S_F", outdir="Viga_DB3_W_H2_S_F")

log1 = add_logger(ana, :nodalreduce, (y == 0.78), "forca.dat")
log2 = add_logger(ana, :node, (x==0.5, y==0.04, z==0), "LVDT1.dat")
log3 = add_logger(ana, :node, (x==0.732, y==0.405, z==0), "LVDT3_1.dat")
log4 = add_logger(ana, :node, (x==0.838, y==0.511, z==0), "LVDT3_2.dat")
log5 = add_logger(ana, :node, (x==0.275, y==0.234, z==0), "LVDT4_1.dat")
log6 = add_logger(ana, :node, (x==0.381, y==0.340, z==0), "LVDT4_2.dat")

log7 = add_logger(ana, :node, (x==0.5, y==0.04, z==0), "flecha.dat")
add_monitor(ana, :node, (x==0.5, y==0.04, z==0), :uy)

log_ip = add_logger(ana, :ip, (x >= 0.49, x <= 0.51, y <= 0.05), "tensao_deformacao.dat")

# Monitorar deformações no Aço e no Concreto

select(model, :element, "concreto", :ip, tag="concreto_ips")
log_roseta = add_logger(ana, :ip, ("concreto_ips", [0.45, 0.61, 0]), "roseta_EC1_2_3.dat")
log_EC4 = add_logger(ana, :ip, ("concreto_ips", [0.888, 0.511, 0]), "EC4.dat")
log_EC5 = add_logger(ana, :ip, ("concreto_ips", [0.732, 0.455, 0]), "EC5.dat")
log_EC6 = add_logger(ana, :ip, ("concreto_ips", [0.119, 0.340, 0]), "EC6.dat")
select(model, :element, "bar_N1", :ip, tag="N1_ips")
log_EF1 = add_logger(ana, :ip, ("N1_ips", [0.5, 0.165, 0.07]),  "EF1_aco.dat")

stage = add_stage(ana, nincs=1000, nouts=50)

# 5. CONDIÇÕES DE CONTORNO

# Apoio Esquerdo (na base da placa esquerda, y=0.0)
add_bc(stage, :node, (x == 0.07, y == 0.0), ux=0, uy=0, uz=0)
# Apoio Direito (na base da placa direita, y=0.0)
add_bc(stage, :node, (x == 0.93, y == 0.0), uy=0)

# Deslocamento imposto no TOPO da placa superior
add_bc(stage, :node, (x == 0.5, y == 0.78), uy=-0.002)

# 6. Execução da análise
run(ana, autoinc=true, maxits=80, tol=1.0, rspan=0.03, quiet=false)
