// #import "/utils/todo.typ": TODO
#import "helpers.typ": todo
= Revisão bibliográfica

== Referencial Teórico

=== O Método dos Elementos Finitos (MEF)

#todo["Após realizar algumas simulações, revisar este texto para descrever partes do processo de elementos finitos que causaram problema / são interessantes."]


O Método dos elementos finitos é um método de solução numérica para problemas de valor de contorno usado amplamente e históricamente na engenharia civil. Baseia-se na discretização de domínios complexos em elementos discretos, uma aproximação que será bem sucedida em função da qualidade da malha (a união dos elementos em nós, linhas, faces e volumes) e modelos constitutivos (que representam as qualidades físicas do material) adotados. 

Para um problema estático, têm-se a forma forte como:

$
  cases(bold(nabla dot sigma + b = 0) "dentro de" Omega , bold(u = u_D)" em" Gamma_D, bold(sigma dot n = t)" em" Gamma_N "")
$

A forma forte do problema de equilíbrio estrutural é composta pela equação diferencial de equilíbrio no domínio $Omega$ e pelas condições de contorno essenciais e naturais, prescritas nas parcelas $Gamma_D$ e $Gamma_N$, respectivamente. A equação diferencial estabelece o equilíbrio local do corpo, enquanto as condições de contorno definem os deslocamentos prescritos e as trações aplicadas em suas respectivas regiões de contorno. 

Por meio da forma forte do problema, deriva-se, a forma fraca do problema, equação governante do MEF:

$
  integral_Omega bold(B)^T bold(D) bold(B) d Omega dot bold(U) = 
  integral_(Gamma_N) bold(N)^T bold(t) d Gamma_N + 
  integral_(Omega) bold(N)^T bold(b) d Gamma_Omega 
$
Ou simplesmente:
$
  bold(K) dot bold(U) = bold(F)_N + bold(F)_Omega = bold(F)
$

A forma fraca define a relação entre a matriz de rigidez global ($bold(K)$), os deslocamentos aplicados e decorrentes ($bold(U)$) com as forças existentes no problema ($bold(F)$). Em problemas elásticos, essa equação é válida e objetiva de se obter, em pequenos deslocamentos, mas torna-se inadequada para problemas não-lineares, como o concreto em ruptura.



=== Elementos Coesivos e a Mecânica da Fratura

O método dos Elementos Finitos é uma das principais ferramentas numéricas utilizadas para a solução de problemas mecânicos. Baseia-se na discretização de linhas, superfícies e volumes em elementos  

=== Modelos Constitutivos

==== O modelo 2D de Durand & Silva (2019)
[Superfície de Mohr-Coulomb, Hordijk, regra de fluxo, $ D_(e p)$]

==== Interface barra-sólido (Durand et al., 2021a)
[O problema da aderência aço-concreto, modelo de bond-slip, tip bearing]

==== O modelo 3D de Durand & Silva (2021b)
[O salto para o estado triaxial, o potencial 3D, as técnicas numéricas (Runge-Kutta e passo automático)]

== Estado da Arte

=== Cenário atual da modelagem numérica de punção

=== Simulação de punção via CDPM: O modelo de Palhares et al. (2022)
