using Serendip

# Dados Viga

b  = 0.16    # base viga direção x
y1 = 0.2     # comprimento até apoio 1
y2 = 4.2     # comprimento até apoio 2
y3 = 1.2     # comprimento aplicação 1a carga
y4 = 1.2 + 2 # comprimento aplicação 2a carga
l  = 4.4     # comprimento total direção y
h  = 0.34    # altura viga direção z

# Geometria

geo = GeoModel()
box = add_box(geo, [0,0,0], b, l, h)

#Fragmento para aplicação de deslocamento imposto 1a carga

p_fragm1 = add_point(geo, [0, y3, h])
p_fragm2 = add_point(geo, [b, y3, h])
l_fragm  = add_line(geo, p_fragm1, p_fragm2)
fragment(geo, l_fragm, box)

#Fragmento para aplicação de deslocamento imposto 2a carga

p_fragm3 = add_point(geo, [0, y4, h])
p_fragm4 = add_point(geo, [b, y4, h])
l_fragm2= add_line(geo, p_fragm3, p_fragm4)
fragment(geo, l_fragm2, box)

#Fragmento inserção dos apoios

p_fragm5 = add_point(geo, [0, y1, 0])
p_fragm6 = add_point(geo, [b, y1, 0])
l_fragm3 = add_line(geo, p_fragm5, p_fragm6)
fragment(geo, l_fragm3, box)

p_fragm7 = add_point(geo, [0, y2, 0])
p_fragm8 = add_point(geo, [b, y2, 0])
l_fragm4 = add_line(geo, p_fragm7, p_fragm8)
fragment(geo, l_fragm4, box)

add_point(geo, [b/2, l/2, 0], embedded=true, tag="meio") #Ponto monitoramento deslocamentoxforça

sz = 0.1 #tamanho malha
set_size(geo, sz) #tamanho malha

# Armadura Passiva

p_arm1 = add_point(geo, [0.025, 0.025, 0.04])
p_arm2 = add_point(geo, [0.025, l - 0.025, 0.04])
l_arm = add_line(geo, p_arm1, p_arm2)
path_arm = add_path(geo, [l_arm], tag="barras", interface_tag="cont-barras")
add_array(geo, path_arm, nx=2, dx = (b - 0.025*2), nz=2, dz = (h - 0.04*2))

# Estribos

p_estr1 = add_point(geo, [0.03, 0.1, 0.03])
p_estr2 = add_point(geo, [b-0.03, 0.1, 0.03])
p_estr3 = add_point(geo, [b-0.03, 0.1, h-0.03])
p_estr4 = add_point(geo, [0.03, 0.1, h-0.03])

l_estr1 = add_line(geo, p_estr1, p_estr2)
l_estr2 = add_line(geo, p_estr2, p_estr3)
l_estr3 = add_line(geo, p_estr3, p_estr4)
l_estr4 = add_line(geo, p_estr4, p_estr1)

path_estr1 = add_path(geo, [l_estr1, l_estr2, l_estr3, l_estr4], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr1, ny = 11, dy = 0.10)

p_estr5 = add_point(geo, [0.03, 1.2, 0.03])
p_estr6 = add_point(geo, [b-0.03, 1.2, 0.03])
p_estr7 = add_point(geo, [b-0.03, 1.2, h-0.03])
p_estr8 = add_point(geo, [0.03, 1.2, h-0.03])

l_estr5 = add_line(geo, p_estr5, p_estr6)
l_estr6 = add_line(geo, p_estr6, p_estr7)
l_estr7 = add_line(geo, p_estr7, p_estr8)
l_estr8 = add_line(geo, p_estr8, p_estr5)

path_estr2 = add_path(geo, [l_estr5, l_estr6, l_estr7, l_estr8], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr2, ny = 10, dy = 0.2)

p_estr9  = add_point(geo, [0.03, 3.2, 0.03])
p_estr10 = add_point(geo, [b-0.03, 3.2, 0.03])
p_estr11 = add_point(geo, [b-0.03, 3.2, h-0.03])
p_estr12 = add_point(geo, [0.03, 3.2, h-0.03])

l_estr9  = add_line(geo, p_estr9,  p_estr10)
l_estr10 = add_line(geo, p_estr10, p_estr11)
l_estr11 = add_line(geo, p_estr11, p_estr12)
l_estr12 = add_line(geo, p_estr12, p_estr9)

path_estr3 = add_path(geo, [l_estr9, l_estr10, l_estr11, l_estr12], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr3, ny = 12, dy = 0.10)

# Armadura Ativa

P1 = add_point(geo, [b/2, 0.000, 0.170])
P2 = add_point(geo, [b/2, 0.318, 0.170])
Q1 = add_point(geo, [b/2, 0.600, 0.170])
Q2 = add_point(geo, [b/2, 0.900, 0.042])
P3 = add_point(geo, [b/2, 1.405, 0.042])
P4 = add_point(geo, [b/2, 2.995, 0.042])
Q3 = add_point(geo, [b/2, 3.500, 0.042])
Q4 = add_point(geo, [b/2, 3.800, 0.170])
P5 = add_point(geo, [b/2, 4.082, 0.170])
P6 = add_point(geo, [b/2, 4.400, 0.170])

l1 = add_line(geo, P1, P2)
l2 = add_bezier(geo, [P2, Q1, Q2, P3])
l3 = add_line(geo, P3, P4)
l4 = add_bezier(geo, [P4, Q3, Q4, P5])
l5 = add_line(geo, P5, P6)

add_path(geo, [l1, l2, l3, l4, l5], tag="cabo", interface_tag="cont-cabo", tips=:both, tip_tag="tips")

# Refinamento

# set_refinement(geo, [b/2, l/2, 0], b, 0.3*l, 2*h, 0.06, 0.15, gradient=0.20)
set_refinement(geo, [b/2, l/2, 0], b, 0.35*l, 1.5*h, 0.5*sz, sz, transition=0.5, roundness=0.1)

# Malha

mesh = Mesh(geo)

select(mesh, :element, :solid, tag="solidos")
# add_cohesive_elements(mesh, (y>=0.15*l, y<0.85*l), tag="coesivos")
add_cohesive_elements(mesh, (y>=0.15*l, y<0.85*l), tag="coesivos")

save(mesh, "malha_hussien.vtu")

# Concreto

Ec    = 45e6 # 45 GPa do artigo
nu    = 0.2
fc    = -97e3 # 97 MPa do artigo
ft    = 4e3
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
tres10  = 0.4*tmax10
speak10 = 0.07*ϕa # 0.7mm no artigo
sres10  = 0.4*ϕa*(0.5) # 0.4mm no artigo
ks10    = 10*tmax10/speak10

# Materiais
mapper = RegionMapper()

add_mapping(mapper, "solidos", MechBulk, LinearElastic, E=Ec, nu=nu)
#add_mapping(mapper, "coesivos", MechCohesive, MohrCoulombCohesive, E=Ec, nu=0.3, ft=ft, GF=GF, mu=0.3, zeta=10)
add_mapping(mapper, "coesivos", MechCohesive, PowerYieldCohesive, 
    E=Ec, nu=nu, fc=fc, ft=ft, zeta=zeta, wc=wc, alpha=alpha, gamma=0.01, 
    theta=1.5, psi=1.5
)
add_mapping(mapper, "barras", MechBar, VonMises, E=Ea, A=Aa, fy=fya, H=0.001*Ea) 
add_mapping(mapper, "estribos", MechBar, VonMises, E=Ea, A=Aa, fy=fya, H=0.001*Ea) 
add_mapping(mapper, "cont-barras", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=speak10, s2=speak10*1.1, s3=sres10, alpha=0.4, p=pa, ks=ks10, kn=kn)
add_mapping(mapper, "cabo", MechBar, VonMises, E=Ep, A=Ap, fy=fyp, H=0.001*Ep, state=(σ=fp,))
add_mapping(mapper, "cont-cabo", MechBondSlip, LinearBondSlip, ks=kp, kn=kn, p=pp)
add_mapping(mapper, "tips", MechBondTip, LinearTip, k=ktip, fixed=true)

model = FEModel(mesh, mapper) 

# Análise

ana = MechAnalysis(model, outdir="B9-3D")
add_logger(ana, :nodalreduce, (y==y3, z==h), "carga1.table")
add_logger(ana, :nodalreduce, (y==y4, z==h), "carga2.table")
add_logger(ana, :node, (y==l/2, z==0), "flecha-base.table")

# Estágio 01: Protensão

stage = add_stage(ana, nouts=2)

add_bc(stage, :node, (y==y1, z==0), ux=0, uy=0, uz=0)
add_bc(stage, :node, (y==y2, z==0), ux=0, uz=0)

run(ana, autoinc=true, tol=2.0, quiet=false)
reset_displacements(model)

# Estágio 02: Aplicação de carregamento externo

stage = add_stage(ana, nouts=50)

uz = -0.05 # Definir deslocamento Aplicado em cada ponto
add_bc(stage, :node, (y==y1, z==0), ux=0, uy=0, uz=0)
add_bc(stage, :node, (y==y2, z==0), ux=0, uz=0)
add_bc(stage, :edge, (y==y3, z==h), uz=uz)
add_bc(stage, :edge, (y==y4, z==h), uz=uz)

run(ana, autoinc=true, tol=5.0, rspan=0.03, quiet=false)
save(model, "modelo_hussien.vtu")
