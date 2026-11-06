using Serendip

# 1. Geometria da Viga-Parede (Unidade em metros)
geo = GeoModel(size=0.03) 

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

l1 = add_point(geo, [0.5, 0.78, 0]) 
l2  = add_point(geo, [0.5,0.78, 0.14])

l3 = add_point(geo, [0.07, 0, 0]) #apoio_1
l4 = add_point(geo, [0.07, 0, 0.14]) #apoio_1

l5 = add_point(geo, [0.93, 0, 0]) #apoio_2
l6 = add_point(geo, [0.93, 0, 0.14]) #apoio_2

# 1.3 Superfície da viga-parede
s1 = add_polygon(geo, [pl10, p2, p3, p4, p5, pl5, p7, p8])
s2 = add_polygon(geo, [h1, h2, h3, h4]) #furo
s3 = add_polygon(geo, [p1, pl1, pl2, pl10]) #Apoios 1
s4 = add_polygon(geo, [pl4, p6, pl5, pl3]) #Apoios 2
# Cria um disco no plano XZ, apoiado no topo da viga (Y=0.74)
s5 = add_disk(geo, [0.5, 0.74, 0.07], [0, 1, 0], 0.07)
Viga = cut(geo, s1, s2) 

# 1.4 Extrusão da viga-parede
viga_vol = extrude(geo, Viga, [0, 0, 0.14])
apoio_1 = extrude(geo, s3, [0, 0, 0.14])
apoio_2 = extrude(geo, s4, [0, 0, 0.14])
aplicacao_carga = extrude(geo, s5, [0, 0.04, 0])
l = add_line(geo, l1, l2)
l_apoio_1 = add_line(geo, l3, l4)
l_apoio_2 = add_line(geo, l5, l6)

placas = [apoio_1, l, l_apoio_1, l_apoio_2, apoio_2, aplicacao_carga]


#1.5 Aramadura da viga-parede

# Coordenadas da armadura N1
a1 = add_point(geo, [0.025, 0.165, 0.025])
a2 = add_point(geo, [0.685, 0.165, 0.025])
l1 = add_line(geo, a1, a2) 
N1 = add_path(geo, [l1], tag="bar_N1", interface_tag="bar_N1-interface") 
add_array(geo, N1, nz=3, dz=0.045)

# Coordenadas da armadura N2
b1 = add_point(geo, [0.025, 0.160, 0.025])
b2 = add_point(geo, [0.025, 0.065, 0.025])
b3 = add_point(geo, [0.175, 0.065, 0.025])
b4 = add_point(geo, [0.175, 0.225, 0.025])
l4 = add_line(geo, b1, b2)
l5 = add_line(geo, b2, b3)
l6 = add_line(geo, b3, b4)
N2 = add_path(geo, [l4, l5, l6], tag="bar_N2", interface_tag="bar_N2-interface")
add_array(geo, N2, nz=3, dz=0.045)

# Coordenadas da armadura N3
c1 = add_point(geo, [0.525, 0.225, 0.025])
c2 = add_point(geo, [0.525, 0.065, 0.025])
c3 = add_point(geo, [0.975, 0.065, 0.025])
c4 = add_point(geo, [0.975, 0.160, 0.025])
l7 = add_line(geo, c1, c2)
l8 = add_line(geo, c2, c3)
l9 = add_line(geo, c3, c4)
N3 = add_path(geo, [l7, l8, l9], tag="bar_N3", interface_tag="bar_N3-interface")
add_array(geo, N3, nz=3, dz=0.045)


#1.6 Reforço da viga parede NSM 

r1 = add_point(geo, [0.001, 0.165,0.001])
r2 = add_point(geo, [0.998, 0.165,0.001])
rl10 = add_line(geo, r1, r2)
R1 = add_path(geo, [rl10], tag="Lamina_1", interface_tag="Lam1_int")
add_array(geo, R1, nz=2, dz=0.138)

r5 = add_point(geo, [0.4926, 0.4130, 0.001])
r6 = add_point(geo, [0.821, 0.740, 0.001])
rl4 = add_line(geo, r5, r6)
R2 = add_path(geo, [rl4], tag="Lamina_2", interface_tag="Lam2_int")
add_array(geo, R2, nz=2, dz=0.138)

r7 = add_point(geo, [0.6337, 0.2714,0.001])
r8   = add_point(geo, [1.000, 0.6376,0.001])
rl5 = add_line(geo, r7, r8)
R3 = add_path(geo, [rl5], tag="Lamina_3", interface_tag="Lam3_int")
add_array(geo, R3, nz=2, dz=0.138)

r9 = add_point(geo, [0.7707, 0.2077, 0.001]) 
r10 = add_point(geo, [1.0000, 0.4370, 0.001])
rl6 = add_line(geo, r9, r10)
R4 = add_path(geo, [rl6], tag="Lamina_4", interface_tag="Lam4_int")
add_array(geo, R4, nz=2, dz=0.138)

#1.7 Reforço da viga parede EBR
ebr_face_tag = "EBR-face"

g1 = add_point(geo, [0, 0.140, 0])
g2 = add_point(geo, [1, 0.140, 0])
g3 = add_point(geo, [1, 0.190, 0])
g4 = add_point(geo, [0, 0.190, 0])
g5 = add_point(geo, [0, 0.140, 0.140])
g6 = add_point(geo, [1, 0.140, 0.140])
g7 = add_point(geo, [1, 0.190, 0.140])
g8 = add_point(geo, [0, 0.190, 0.140])

ebr_1_front = add_polygon(geo, [g1, g2, g3, g4], tag=ebr_face_tag)
ebr_1_back  = add_polygon(geo, [g5, g6, g7, g8], tag=ebr_face_tag)
ebr_1_left  = add_polygon(geo, [g1, g4, g8, g5], tag=ebr_face_tag)
ebr_1_right = add_polygon(geo, [g2, g3, g7, g6], tag=ebr_face_tag)

g9 = add_point(geo, [0.7856, 0.7400, 0])
g10 = add_point(geo,[0.8565, 0.7400, 0])
g11 = add_point(geo,[0.4748, 0.3600, 0])
g12 = add_point(geo,[0.4395, 0.3953, 0])
ebr_5 = add_polygon(geo, [g9, g10, g11, g12], tag=ebr_face_tag)

g21 = add_point(geo, [0.7856, 0.7400, 0.14])
g22 = add_point(geo,[0.8565, 0.7400, 0.14])
g23 = add_point(geo,[0.4748, 0.3600, 0.14])
g24 = add_point(geo,[0.4395, 0.3953, 0.14])
ebr_8 = add_polygon(geo, [g21, g22, g23, g24], tag=ebr_face_tag)
ebr_58 = add_polygon(geo, [g9, g10, g22, g21], tag=ebr_face_tag)

g13 = add_point(geo, [1, 0.6730, 0])
g14 = add_point(geo, [1, 0.6023, 0])
g15 = add_point(geo, [0.6155, 0.2176,0])
g16 = add_point(geo, [0.5802, 0.2529, 0])
ebr_6 = add_polygon(geo, [g13, g14, g15, g16], tag=ebr_face_tag)

g25 = add_point(geo, [1, 0.6730, 0.14])
g26 = add_point(geo, [1, 0.6023, 0.14])
g27 = add_point(geo, [0.6155, 0.2176, 0.14])
g28 = add_point(geo, [0.5802, 0.2529, 0.14])
ebr_9 = add_polygon(geo, [g25, g26, g27, g28], tag=ebr_face_tag)
ebr_69 = add_polygon(geo, [g13, g14, g26, g25], tag=ebr_face_tag)

g17 = add_point(geo,[1, 0.4724,0])
g18 = add_point(geo,[1, 0.4016,0])
g19 = add_point(geo, [0.7884, 0.1900, 0])
g20 = add_point(geo, [0.7530, 0.2254, 0])
ebr_7 = add_polygon(geo, [g17, g18, g19, g20], tag=ebr_face_tag)

g29 = add_point(geo,[1, 0.4724,0.14])
g30 = add_point(geo,[1, 0.4016,0.14])
g31 = add_point(geo, [0.7884, 0.1900, 0.14])
g32 = add_point(geo, [0.7530, 0.2254, 0.14])
ebr_10 = add_polygon(geo, [g29, g30, g31, g32], tag=ebr_face_tag)
ebr_710 = add_polygon(geo, [g17, g18, g30, g29], tag=ebr_face_tag)

ebr_surfaces = [
    ebr_1_front, ebr_1_back, ebr_1_left, ebr_1_right,
    ebr_5, ebr_8, ebr_58,
    ebr_6, ebr_9, ebr_69,
    ebr_7, ebr_10, ebr_710,
]
fragment(geo, viga_vol, [placas; ebr_surfaces])

# 2. Geração da malha
mesh = Mesh(geo)

# 3. Classificação dos elementos e inserção das interfaces
select(mesh, :element, :bulk, tag="concreto")
select(mesh, :element, :bulk, y<=0.040, tag="steel_plates_inf")
select(mesh, :element, :bulk, x<=0.650, y>=0.740, tag="steel_plates_sup")

add_cohesive_elements(mesh, "concreto", tag="cohesive")

ebr_faces = select(mesh, :face, ebr_face_tag)
isempty(ebr_faces) && error("No boundary faces were tagged as $ebr_face_tag")
add_boundary_shell_elements(
    mesh,
    ebr_face_tag,
    tag="EBR_1",
    contact_tag="inter_EBR",
)

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
Eb = 200e6
Ec = 200e6
fy_aco = 556e3       # Tensão de escoamento do aço (kN/m²)
fy1_aco = 649e3
fy2_aco = 592e3
ϕa  = 0.010 # Diâmetro 1 barra
ϕb  = 0.0063
ϕc  = 0.008
Aa  = pi*ϕa^2/4 # Área de uma barra de espessura ϕa (m²)
Ab  = pi*ϕb^2/4
Ac  = pi*ϕc^2/4
pa  = ϕa*pi  # perímetro da barra
pb = ϕb*pi
pc = ϕc*pi
Ha = 0

# Contato aço-Concreto
tmax10     =  10.77e3                 #2.5*sqrt(abs(fc/1e3))*1e3 
tres10     =  0.8e3                    #0.4*tmax10
s1_10      = 0.55e-3             #0.07*ϕa # 0.7mm no artigo #s2 = speak10*1.1
s2_10      = s1_10*1.1               #0.4*ϕa*(0.5) # 0.4mm no artigo 
s3_10      = 12e-3   
ks10       = 1*tmax10/s1_10
kn_10      = 150*ks10
alpha_aco = 0.58

# Lâmina de PRFC (NSM)
b1_lam = 2.4e-3
b2_lam = 10e-3
A_lam = b1_lam*b2_lam
p_lam = 2*b2_lam+b1_lam
E_lam = 164e6
nu_lam = 0.3

# Manta de PRFC (EBR)
E_man  = 238e6
nu_man = 0.3
fy_man = 4312e3
e_man  = 0.166e-3

#Interface NSM-Concreto 
ks_lam = 5e9
kn_lam = 10*ks_lam

#Interface EBR-Concreto
ks_man = 3e4  
kn_man = 100*ks_man
ft_man = 0.7*4.15e3  
GF_man = 0.05         
mu_man = 1.2 


mapper = RegionMapper()
# Mapeamento do Concreto
add_mapping(mapper, "concreto", MechBulk, LinearElastic, E=E, nu=0.2)
add_mapping(mapper, "cohesive", MechCohesive, MohrCoulombCohesive, E=E, nu=nu, ft=ft, GF=GF, mu=mu)

# Mapeamento das Placas de Aço 
add_mapping(mapper, "steel_plates_inf", MechBulk, LinearElastic, E=200e6, nu=0.3)
add_mapping(mapper, "steel_plates_sup", MechBulk, LinearElastic, E=200e6, nu=0.3)

# Mapeamento das barras de aço
add_mapping(mapper, "bar_N1", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha) 
add_mapping(mapper, "bar_N2", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha) 
add_mapping(mapper, "bar_N3", MechBar, VonMises, E=Ea, A=Aa, fy=fy_aco, H=Ha)
add_mapping(mapper, "bar_N1-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10) #s1 3 s2 valores conforme CEB para boas condições de aderência
add_mapping(mapper, "bar_N2-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10)
add_mapping(mapper, "bar_N3-interface", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=s1_10, s2= s2_10, s3=s3_10, alpha=alpha_aco, p=pa, ks=ks10, kn=kn_10)

# Mapeamento das lâminas de PRFC
add_mapping(mapper, "Lamina_1", MechBar, LinearElastic, E=E_lam, A=A_lam, nu=nu_lam)
add_mapping(mapper, "Lamina_2", MechBar, LinearElastic, E=E_lam, A=A_lam, nu=nu_lam)
add_mapping(mapper, "Lamina_3", MechBar, LinearElastic, E=E_lam, A=A_lam, nu=nu_lam)
add_mapping(mapper, "Lamina_4", MechBar, LinearElastic, E=E_lam, A=A_lam, nu=nu_lam)
add_mapping(mapper, "Lam1_int", MechBondSlip,  LinearBondSlip, ks=ks_lam, kn=kn_lam, p=p_lam)
add_mapping(mapper, "Lam2_int", MechBondSlip,  LinearBondSlip, ks=ks_lam, kn=kn_lam, p=p_lam)
add_mapping(mapper, "Lam3_int", MechBondSlip,  LinearBondSlip, ks=ks_lam, kn=kn_lam, p=p_lam)
add_mapping(mapper, "Lam4_int", MechBondSlip,  LinearBondSlip, ks=ks_lam, kn=kn_lam, p=p_lam)

# Manta de PRFC e interface EBR--concreto. Sem GF, TensionFieldSoftening adota
# plasticidade perfeita após fy, evitando assumir uma energia de ruptura não medida.
add_mapping(mapper, "EBR_1", MechMembrane, TensionFieldSoftening,
    E=E_man, nu=nu_man, fy=fy_man, thickness=e_man)
add_mapping(mapper, "inter_EBR", MechContact, MohrCoulombContact, ft=ft_man, GF=GF_man, mu=mu_man, kn=kn_man, ks=ks_man, ft_law=:bilinear)

model = FEModel(mesh, mapper)
ana   = MechAnalysis(model, outkey="Vigaparede_DB3_H1_S_FS_M", outdir="Viga_DB3_H1_S_FS_M")

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
log_EF1 = add_logger(ana, :ip, ("N1_ips", [0.5, 0.17, 0.07]),  "EF1_aco.dat")

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
