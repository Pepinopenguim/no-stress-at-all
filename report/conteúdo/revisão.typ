// #import "/utils/todo.typ": TODO
#import "helpers.typ": todo
= Revisão bibliográfica

== Referencial Teórico

=== O Método dos Elementos Finitos (MEF)

#todo["Após realizar algumas simulações, revisar este texto para descrever partes do processo de elementos finitos que causaram problema / são interessantes."]


O Método dos elementos finitos é um método de solução numérica para problemas de valor de contorno usado amplamente e históricamente na engenharia civil. Baseia-se na discretização de domínios complexos em elementos discretos, uma aproximação que será bem sucedida em função da qualidade da malha (a união dos elementos em nós, linhas, faces e volumes) e modelos constitutivos (que representam as qualidades físicas do material) adotados. 

Para um problema estático, têm-se a forma forte como:

$
  cases(bold(nabla dot sigma + b = 0) in Omega , bold(u = u_D) in Gamma_D, bold(sigma dot n = t)in Gamma_N "")
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

Para o problema de punção em lajes lisas. a não-linearidade ocorre principalmente em função do material, pela ocorrência de fraturas, escoamento do aço, coesão (e deslizamento) entre armadura e o concreto, dentre outros fatores. Nesses casos, a equação de equilíbrio deve ser reescrita em função do resíduo entre as forças internas e externas do sistema:

$ 
  bold(R)(bold(u)) = bold(f)_"ext" - bold(f)_"int" (bold(u)) = 0
$

As forças internas dependem do estado atual do material, e por isso o sistema não pode ser resolvido diretamente. A solução é obtida de forma incremental e iterativa, pelo método de Newton-Raphson: aplica-se a carga em pequenos passos e, em cada passo, corrige-se a solução até que o resíduo seja suficientemente pequeno. Essa correção ocorre pela alteração da rigidez interna do material, ditada pelo modelo constitutivo apropriado.

Em problemas com amolecimento acentuado, no caso da punção, a matriz tangente pode se tornar indefinida e o método pode falhar. Nesses casos, técnicas de continuação (como arc-length e métodos de passo automático) e esquemas de integração implícita, como os adotados em @Durand_2019 e @Durand_2021_3D, são necessários para acompanhar o caminho de equilíbrio após o pico de carga.

=== Elementos Coesivos e a Mecânica da Fratura

A modelagem de elementos frágeis possui duas principais vertentes, a de fratura distribuida, onde a influência da fratura é espalhada ao longo do elemento finito (p. ex. Modelos de Dano) e fratura discreta, onde fratura, ou seu potencial, é representada por elemento de interface próprio. 

Os elementos coesivos se inserem no contexto de abordagens discretas da ruptura. Eles fornecem a lei constitutiva local que governa a perda de rigidez na fissura, alimentando o resíduo e a matriz tangente global a cada iteração. O elemento é iniciado com espessura nula, sendo sujeito às variações nas tensões do problema. Quando as condições do modelo constitutivo forem atingidas, haverá o início da ruptura na interface entre os elementos. 

Essa dependência do modelo constitutivo faz parte da natureza dos elementos coesivos, e sua formulação deve ser eficiente e suficientemente representativa do material frágil sendo analisado. 



=== Modelos Constitutivos

==== O modelo 2D de Durand & Silva

O texto de @Durand_2019 apresenta um modelo bidimensional para elementos de interface modelados de acordo com a função de escoamento de Mohr-Coulomb. Além disso, os autores utilizam modelos de fratura não-lineares para representar o amolecimento (_softening_) da fratura ao longo de sua separação. 

O modelo adota uma superfície de escoamento baseada no critério de Mohr-Coulomb com aderência, conforme proposto por @Lens_2009 A função de escoamento $f$ é definida no espaço de tensões normal ($sigma_n$) e cisalhante $tau$ como:

$
   f(sigma, sigma_max) = abs(tau) + (sigma_n - sigma_max) tan(phi) = 0 
$ <esc_f>

#figure(
  image("../figuras/lens_modelo_const.png", width: 80%),
  caption: [Função de escoamento (sólida) e potencial plástico (tracejada) de acordo com @Lens_2009 #todo[revisar necessidade de mudar imagem]]
)

A função de potencial plástico ($g$), utilizada para determinar a direção do fluxo do material durante deformações plásticas, é definina por

$
   g(sigma, sigma_max) = cases(tau^2 - tau_max^2 = 0 " para " sigma_n <= 0, sigma_n^2 tan^2(phi) + tau^2 - tau_max^2 = 0 " para " sigma_n > 0) 
$

// Hordijk

Para representar o amolecimento da fratura, isto é, a translação da @esc_f para a esquerda, ao longo do eixo $sigma_n$, em relação à abertura da fissura $u_p$, os autores analisaram duas curvas apresentadas por @Hordijk1992:

#figure(
  image("../figuras/amolecimento_hordjark.png", width: 80%),
  caption: [Curva de amolecimento de Hordijk #todo[revisar necessidade de mudar imagem]]
)

#figure(
  image("../figuras/amolecimento_modelo.png"),
  caption: [Função de Escoamento (a) $u_p = 0$, (b) $u_c > u_p > 0$, (c) $u_p = u_c$ #todo[revisar necessidade de mudar imagem]]
)

//  $ D_(e p)$

A matriz constitutiva elastoplástica $D_"ep"$ relaciona o incremento de tensão com o incremento de deslocamento relativo. Sua derivação parte da decomposição aditiva dos deslocamentos e da condição de consistência. A matriz final é expressa como: 

$ D_(e p) = D_e - (D_e r v^T D_e) / (v^T D_e r - y m norm(r)) $

Onde $D_e$ é a matriz constitutiva elástica do elemento, $v = (partial f) / (partial sigma)$ e $y = (partial f) / (partial sigma_max)$ são derivadas da função de escoamento em função das tensões, $r = (partial g) / (partial sigma)$ é o fluxo plástico e $m = (partial sigma_max) / (partial u_p)$ é a derivada da tensão máxima em relação à abertura do elemento.

// atualização de tensões e integração implícita
Na análise não-linear de elementos finitos, e especialmente para um modelo matematicamente sensível como os elementos coesivos, a atualização de tensões é parte fundamental do processo iterativo. No modelo de @Durand_2019, essa atualização dependerá do deslocamento relativo $Delta bold(w)$ de tal modo que, dado o valor da tensão na iteração atual $bold(sigma)^n$, a tensão de teste $bold(sigma)^(t r)$ será 

$
  bold(sigma)^(t r) = bold(sigma)^n + bold(D)_e Delta bold(w)
$

A tensão de teste apenas será válida se a condição de escoamento não for atingida, ou seja, se $f(bold(sigma)^(t r), sigma^n_"max") <= 0$. Se for o caso, $bold(sigma)^(t r) = bold(sigma)^(n + 1)$. Caso contrário ($f(bold(sigma)^(t r), sigma^n_"max") > 0$), o incremento será elastoplástico e haverá fissuração, alterando o valor de $sigma_"max"^(n + 1)$.

#figure(
  image("../figuras/atualiz_tensoes.png", width: 100%),
  caption: [Atualização de tensões #todo[revisar necessidade de mudar imagem]]
)


==== Interface barra-sólido
[O problema da aderência aço-concreto, modelo de bond-slip, tip bearing]

==== O modelo 3D de Durand & Silva
[O salto para o estado triaxial, o potencial 3D, as técnicas numéricas (Runge-Kutta e passo automático)]

== Estado da Arte

=== Cenário atual da modelagem numérica de punção

=== Simulação de punção via CDPM: O modelo de Palhares et al. (2022)
