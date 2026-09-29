using Serendip

# Dados Viga

b  = 0.16    # espessura
x1 = 0.2     # comprimento até apoio 1
x2 = 4.2     # comprimento até apoio 2
x3 = 1.2     # comprimento aplicação 1a carga
x4 = 1.2 + 2 # comprimento aplicação 2a carga
l  = 4.4     # comprimento total direção x
h  = 0.34    # altura viga direção y

# Geometria

geo = GeoModel()

p1 = add_point(geo, [0, 0, 0])
p2 = add_point(geo, [x1, 0, 0])
p3 = add_point(geo, [l/2, 0, 0])
p4 = add_point(geo, [x2, 0, 0])
p5 = add_point(geo, [l, 0, 0])
p6 = add_point(geo, [l, h, 0])
p7 = add_point(geo, [x4, h, 0])
p8 = add_point(geo, [x3, h, 0])
p9 = add_point(geo, [0, h, 0])

poly = add_polygon(geo, [p1, p2, p3, p4, p5, p6, p7, p8, p9])

# sz = 0.025 #tamanho malha
sz = 0.07 #tamanho malha
set_size(geo, sz) #tamanho malha

# Armadura Passiva

q1 = add_point(geo, [0.025, 0.040, 0])
q2 = add_point(geo, [(l - 0.025), 0.040, 0])
l_arm = add_line(geo, q1, q2)
path_arm = add_path(geo, [l_arm], tag="barras", interface_tag="cont-barras")
add_array(geo, path_arm, ny=2, dy=0.26)

# Estribos

est1 = add_point(geo, [0.100, 0.030, 0])
est2 = add_point(geo, [0.100, 0.310, 0])
l_est1 = add_line(geo, est1, est2)
path_estr1 = add_path(geo, [l_est1], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr1, nx = 11, dx = 0.10)

est3 = add_point(geo, [1.200, 0.030, 0])
est4 = add_point(geo, [1.200, 0.310, 0])
l_est2 = add_line(geo, est3, est4)
path_estr2 = add_path(geo, [l_est2], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr2, nx = 10, dx = 0.20)

est5 = add_point(geo, [3.200, 0.030, 0])
est6 = add_point(geo, [3.200, 0.310, 0])
l_est3 = add_line(geo, est5,  est6)
path_estr3 = add_path(geo, [l_est3], tag="estribos", interface_tag="cont-barras")
add_array(geo, path_estr3, nx = 12, dx = 0.10)

# Armadura Ativa

P1 = add_point(geo, [0.000, 0.170, 0])
P2 = add_point(geo, [0.318, 0.170, 0])
Q1 = add_point(geo, [0.600, 0.170, 0])
Q2 = add_point(geo, [0.900, 0.042, 0])
P3 = add_point(geo, [1.405, 0.042, 0])
P4 = add_point(geo, [2.995, 0.042, 0])
Q3 = add_point(geo, [3.500, 0.042, 0])
Q4 = add_point(geo, [3.800, 0.170, 0])
P5 = add_point(geo, [4.082, 0.170, 0])
P6 = add_point(geo, [4.400, 0.170, 0])

l1 = add_line(geo, P1, P2)
l2 = add_bezier(geo, [P2, Q1, Q2, P3])
l3 = add_line(geo, P3, P4)
l4 = add_bezier(geo, [P4, Q3, Q4, P5])
l5 = add_line(geo, P5, P6)

add_path(geo, [l1, l2, l3, l4, l5], tag="cabo", interface_tag="cont-cabo", tips=:both, tip_tag="tips")

# Refinamento

set_refinement(geo, [l/2, 0, 0], 0.45*l, h, b, 0.5*sz, sz, transition=0.3, roundness=0.1)

# Malha

mesh = Mesh(geo)

select(mesh, :element, :solid, tag="solidos")
add_cohesive_elements(mesh, (x>=0.15*l, x<0.85*l), tag="coesivos")

save(mesh, "malha_hussien2D.vtu")

# Concreto

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


sres10  = 0.4*ϕa*(0.5) # 0.4mm no artigo
ks10    = 10*tmax10/speak10

# Materiais
mapper = RegionMapper()

#add_mapping(mapper, "solidos", MechSolid, UCP, E=Ec, nu=nu, alpha=0.666, beta=1.15, fc=fc, epsc=-0.00217, eta=2.2, ft=ft, GF = GF)
add_mapping(mapper, "solidos", MechSolid, LinearElastic, E=Ec, nu=nu)
#add_mapping(mapper, "coesivos", MechCohesive, MohrCoulombCohesive, E=Ec, nu=0.3, ft=ft, GF=GF, mu=0.3, ft_law=:hordijk, zeta = 0.5)
add_mapping(mapper, "coesivos", MechCohesive, PowerYieldCohesive, 
    E=Ec, nu=nu, fc=fc, ft=ft, zeta=zeta, wc=wc, alpha=alpha, gamma=0.01, 
    theta=1.5, psi=1.5
)
# add_mapping(mapper, "coesivos", MechCohesive, AsinhYieldCohesive, 
#     E=Ec, nu=nu, fc=fc, ft=ft, zeta=zeta, wc=wc, alpha=0.6, gamma=0.01, 
#     theta=1.5, psi=1.5
# )

add_mapping(mapper, "barras", MechBar, VonMises, E=Ea, A=2*Aa, fy=fya, H=0.001*Ea) 
add_mapping(mapper, "estribos", MechBar, VonMises, E=Ea, A=2*Aa, fy=fya, H=0.001*Ea) 
add_mapping(mapper, "cont-barras", MechBondSlip, CebBondSlip, taumax=tmax10, taures=tres10, s1=speak10, s2=speak10*1.1, s3=sres10, alpha=0.4, p=2*pa, ks=ks10, kn=kn)
add_mapping(mapper, "cabo", MechBar, VonMises, E=Ep, A=Ap, fy=fyp, H=0.001*Ep, state=(σ=fp,))
add_mapping(mapper, "cont-cabo", MechBondSlip, LinearBondSlip, ks=kp, kn=kn, p=pp)
add_mapping(mapper, "tips", MechBondTip, LinearTip, k=ktip, fixed=true)

model = FEModel(mesh, mapper, stress_state=:plane_stress, thickness=b) 

# Análise

select(select(model, :element, "barras"), :ip, tag="barras-ips")
select(select(model, :element, "cabo"), :ip, tag="cabo-ips")
select(select(model, :element, "coesivos"), :ip, tag="coesivos-ips")
select(select(model, :element, "cont-barras"), :ip, tag="cont-barras-ips")

ana = MechAnalysis(model, outdir="B9-2D")

# loggers
add_logger(ana, :nodalreduce, (x==x3, y==h), "carga1.table")
add_logger(ana, :nodalreduce, (x==x4, y==h), "carga2.table")
add_logger(ana, :node, (x==l/2, y==0), "flecha-base.table")

# monitors
add_monitor(ana, :ipgroup, "barras-ips", :(σx´, σx´>$fya), "barras-ips.table")
add_monitor(ana, :ipgroup, "cabo-ips", :(σx´, σx´>$fyp), "cabo-ips.table")
add_monitor(ana, :ipgroup, "coesivos-ips", :(up, up>0), "coesivos-ips.table")
add_monitor(ana, :ipgroup, "cont-barras-ips", :(s, s>$speak10), "cont-barras.table")

# Estágio 01: Protensão

stage = add_stage(ana, nouts=2)

add_bc(stage, :node, (x==x1, y==0), ux=0, uy=0)
add_bc(stage, :node, (x==x2, y==0), uy=0)

run(ana, autoinc=true, tol=2.0, quiet=false)
reset_displacements(model)

# Estágio 02: Aplicação de carregamento externo

stage = add_stage(ana, nouts=50)

uy = -0.05 # Definir deslocamento Aplicado em cada ponto
add_bc(stage, :node, (x==x1, y==0), ux=0, uy=0)
add_bc(stage, :node, (x==x2, y==0), uy=0)
add_bc(stage, :node, (x==x3, y==h), uy=uy)
add_bc(stage, :node, (x==x4, y==h), uy=uy)

run(ana, autoinc=true, maxits=3, tol=5.0, rspan=0.03, quiet=false)
save(model, "modelo_hussien2D.vtu")
