// #import "/utils/todo.typ": TODO
#import "helpers.typ": todo
= Revisão bibliográfica

== Referencial Teórico

O presente capítulo apresenta uma revisão atualizada do contexto atual da engenharia estrutural no que se refere à punção de lajes lisas. Depois, será apresentada uma introdução básica ao método dos elementos finitos, focada em aspectos interessantes para o caso simulado. Por fim, serão observados os modelos matemáticos utilizados na simulação.

=== Punção em Lajes Lisas

As lajes lisas são sistemas estruturais laminares apoiados exclusivamente por pilares. O acúmulo de esforços e tensões, especialmente em torno da conexão laje-pila, causa uma região de grande potencial de ruptura. De acordo com @melges1995, o acúmulo de tensões nessa região pode ser extremo a ponto da ruptura ocorrer antes do escoamento do aço, caracterizando uma ruptura frágil. 

Apesar disso, a conveniência na sua execução justifica seu uso, especialmente em função da: supressão de vigas, que simplifica a execução em obra do concreto armado, obtendo-se uma execução mais ágil do projeto, redução de formas, além da economia de materiais e mão de obra; redução do pé-direito, fator que aumenta o número de pavimentos a serem executados para uma mesma altura; Simplificação do projeto de ventilação, iluminação e resistência à incêndios, por diminuição dos obstáculos e assim, concentração de calor @palhares2018.

A ruptura por punção é um evento potencialmente catastrófico, por ocorrer de forma frágil, sem aviso prévio, pode desencadear o colapso progressivo da estrutura, uma vez que a redistribuição de esforços resultante é direcionada a regiões que não foram dimensionadas para absorvê-la. Casos históricos incluem o colapso parcial do edifício Pipers Row Multi-Storey Car Park (Reino Unido, 1997) e do Skyline Plaza (EUA, 1973), ambos associados a falhas em ligações laje-pilar @palhares2018.

#figure(
  grid(
    columns: 2,
    column-gutter: 1cm,
    image("../figuras/skyline.png", height: 20%),
    image("../figuras/wolverhampton.jpg", height: 20%),
  ),
  caption: [
    Acidentes históricos de ruptura por punção em lajes lisas.
    (a) Colapso parcial do Pipers Row Multi-Storey Car Park,
    Wolverhampton, Reino Unido, 1997.
    (b) Colapso do Skyline Plaza, Virgínia, EUA, 1973.
  ]
)


Sob carregamento crescente, a região da ligação laje-pilar desenvolve um estado triaxial de tensões no qual a componente cisalhante predomina. Quando a resistência à tração diagonal do concreto é atingida, inicia-se a formação de uma fissura inclinada que, propagando-se da face tracionada em direção à face comprimida, delimita um sólido aproximadamente cônico ao redor do pilar — o chamado tronco de cone de punção @melges1995.

A superfície de ruptura inclina-se tipicamente entre $25 degree$ e $30 degree$ em relação ao plano da laje, conforme observado experimentalmente por @regan1981 e confirmado por @palhares2018. A extensão horizontal dessa superfície é da ordem de $2 d$ a $3 d$, onde $d$ é a altura útil da laje.

#figure(
  image("../figuras/tronco_puncao.png", width: 70%),
  caption: [Formação do tronco de cone de punção ao redor do pilar. @palhares2018 #todo[substituir por figura própria se necessário]]
) <fig_tronco_cone>

Do ponto de vista mecânico, a resistência à punção mobiliza diferentes mecanismos: a contribuição do concreto íntegro na zona comprimida, o engrenamento dos agregados nas fissuras inclinadas, o efeito de pino das barras de flexão e, quando presente, a contribuição da armadura de cisalhamento @Sacramento_2012. A falha ocorre quando a soma dessas parcelas é superada pela demanda cisalhante atuante na seção crítica.

// #figure(
//   image("../figuras/mecanismos_resistencia.png", width: 70%),
//   caption: [Mecanismos de resistência à punção: concreto íntegro, engrenamento de agregados, efeito de pino e armadura de cisalhamento. #todo[substituir por figura própria ou adaptada de @palhares2018]]
// ) <fig_mecanismos>

=== Modos de ruptura e fissuração

A fissuração de lajes lisas submetidas à punção segue uma sequência característica. As primeiras fissuras a surgir são as radiais, que partem do contorno do pilar em direção às bordas da laje; elas marcam o fim da fase elástica do comportamento e o início da não linearidade global @melges1995. Com o aumento do carregamento, o padrão radial se intensifica. Apenas nos estágios finais, imediatamente antes da ruptura, surgem as fissuras tangenciais, que delimitam o contorno do cone de punção @regan1981.

// #figure(
//   image("../figuras/fissuracao_radial_tangencial.png", width: 70%),
//   caption: [Padrão de fissuração: fissuras radiais (fase inicial) e tangenciais (imediatamente antes da ruptura). #todo[substituir por figura própria ou adaptada de @melges1995]]
// ) <fig_fissuracao>

A depender da taxa de armadura de flexão e das condições de contorno, três modos de ruptura podem ser identificados:

- Punção pura, ruptura frágil, sem escoamento da armadura de flexão, com formação clara do tronco de cone;
- Flexo-punção, ruptura mista, em que parte da armadura de flexão escoa antes do colapso, conferindo alguma ductilidade;
- Flexão pura, ruptura dúctil, com ampla fissuração, típica de lajes com baixa taxa de armadura de flexão.

Para o caso de lajes lisas usuais, a punção pura é o modo predominante e o mais crítico, por ocorrer subitamente @Sacramento_2012.


==== Parâmetros que influenciam na resistência à punção

Diversos parâmetros governam a resistência à punção de lajes lisas, atuando de forma acoplada.

A resistência à compressão do concreto $f_c$ é o primeiro deles: a capacidade resistente cresce com $f_c$, mas a relação não é linear — formulações normativas adotam proporcionalidade com $f_c^(1\/3)$ (EN 1992-1-1:2023 e ABNT NBR 6118:2026) ou com $sqrt(f_c)$ (ACI 318-25). @melges1995 relata que a relação não linear já havia sido observada por Graf na década de 1930, sendo que a adoção da raiz quadrada tende a superestimar a influência em concretos de alta resistência. 

A taxa de armadura de flexão $rho$ controla a abertura das fissuras de flexão: quanto maior $rho$, menor a abertura, o que melhora o engrenamento dos agregados e o efeito de pino, elevando a capacidade resistente @regan1981. 

A geometria e dimensão do pilar determinam a distribuição de tensões na ligação: pilares circulares apresentam resistência cerca de $15 percent$ superior à de pilares quadrados de área equivalente, em razão da concentração de tensões nos cantos dos pilares retangulares @regan1981, e pilares alongados (relação entre lados maior que $2$) produzem ruptura mais abrupta, com cone de punção menor e menor resistência @melges1995.

  O efeito de escala (_size effect_) é outro fator central: a resistência nominal ao cisalhamento diminui com o aumento da altura útil, uma vez que lajes mais espessas apresentam maior heterogeneidade do concreto e menor eficiência da armadura de flexão no controle da abertura de fissuras ao longo de toda a seção fissurada @melges1995. Esse efeito é incorporado nas formulações normativas por coeficientes que majoram a resistência para lajes de menor altura útil @cen_en1992_2023, @abnt_nbr6118_2026. 

Por fim, a armadura de cisalhamento é a forma mais eficiente de elevar a resistência à punção, uma vez que as demais alternativas — aumento da seção do pilar, da espessura da laje, da taxa de armadura de flexão ou da resistência do concreto — são, em geral, economicamente desfavoráveis ou arquitetonicamente indesejáveis @palhares2018. Diferentes tipos já foram investigados (estribos fechados, estribos abertos, estribos inclinados, barras dobradas e conectores tipo pino), sendo os estribos fechados e os _studs_ os mais utilizados na prática; a eficiência da armadura depende diretamente das condições de ancoragem na armadura de flexão @palhares2018, @Lima2021.

==== Dimensionamento normativo

O dimensionamento à punção é tratado de forma distinta pelas três principais normas de projeto de estruturas de concreto: a ABNT NBR 6118:2023, o Eurocode 2 (EN 1992-1-1:2023) e o ACI 318-25. Embora compartilhem o conceito de superfície de controle, um perímetro crítico ao redor do pilar onde a tensão cisalhante atuante é comparada a uma resistência, as normas diferem na localização desse perímetro, nas expressões de resistência e no tratamento da armadura de cisalhamento. Esta seção apresenta os critérios de cada norma, com destaque para as revisões recentes.

A ABNT NBR 6118:2023 trata o dimensionamento à punção na _Seção 19.5_. O modelo verifica a tensão cisalhante em até três contornos críticos, definidos no entorno da força concentrada:

- Contorno C: o próprio perímetro do pilar. Verifica-se, de forma indireta, a compressão diagonal do concreto, por meio da tensão cisalhante atuante $tau_(S d)$ comparada à resistência $tau_(R d 2)$:

$
tau_(S d) <= tau_(R d 2) = 0.27 alpha_v f_(c d)
$

Para $alpha_v = 1 - f_(c k)\/250$, onde $f_(c k)$ é a resistência característica do concreto.

- Contorno C': afastado $2d$ da face do pilar. Verifica-se a tração diagonal, associada à resistência do concreto à punção. A resistência é dada por:

$
tau_(R d 1) = 0.13 (1 + sqrt(20\/d)) (100 rho f_(c k))^(1\/3)
$

onde $rho$ é a taxa geométrica de armadura de flexão aderente.

- Contorno C'': afastado $2d$ da última camada de armadura de cisalhamento. Verifica-se apenas quando há armadura transversal, para garantir que a ruína não ocorra fora da região armada. Nota-se que em casos onde a estabilidade global da estrutura depende da resistência da laje à punção, a armadura será obrigatória.

#figure(
  image("../figuras/perimetros_c_abnt.png", width: 80%),
  caption: [Contornos críticos C e C' segundo a ABNT NBR 6118:2023. #todo[Retirar marca d'água / ver necessidade de adicionar C'']]
) <fig_nbr_contornos>

Quando a resistência no contorno C' é insuficiente, a norma permite o uso de armadura de cisalhamento. Nesse caso, a resistência é acrescida da parcela contribuída pela armadura, e a tensão resistente $tau_(R d 3)$ passa a incluir um termo proporcional a $(A_(s w) f_(y w d)) / (u_1 d)$, onde $A_(s w)$ é a área da armadura por camada, $f_(y w d)$ é a resistência de cálculo da armadura (limitada a 300 MPa para conectores e 250 MPa para estribos) e $u_1$ é o perímetro crítico.

O Eurocode 2:2023 introduziu uma revisão profunda no dimensionamento à punção, substituindo as formulações empíricas da versão de 2004 por um modelo mecânico baseado na _Critical Shear Crack Theory_ (CSCT). A principal mudança geométrica é a redefinição do perímetro de controle básico: enquanto a versão de 2004 adotava $2d$ a partir da face do pilar, a versão de 2023 adota $0.5d_v$ (onde $d_v$ é a altura útil efetiva).

A verificação é organizada na Seção 8.4 do código. De modo similar à norma brasileira, a resistência ao puncionamento deve ser verificada na face do pilar (perímetro $u_0$) e no perímetro de controle $u_1$ (a $0.5d_v$), e, caso haja armadura de cisalhamento, em um perímetro adicional $u_"out"$ onde a armadura já não é necessária.

A resistência do concreto sem armadura, $τ_"Rd,c"$, é expressa por:

$ τ_"Rd,c" = 0.6 / γ_V k_(p b) (100 ρ_l f_(c k) d_(d g) / d_v)^(1/3) <= 0.5/γ_V sqrt(f_"ck") $

onde $k_"pb"$ é o coeficiente de aprimoramento do gradiente de punção ($1 <= k_"pb" <= 2.5$), $d_(d g)$ é o parâmetro que descreve a rugosidade da fissura, $rho_l$ é a taxa geométrica de armadura longitudinal de flexão, e $gamma_V$ é o coeficiente parcial de segurança para a resistência ao cisalhamento.

#figure(
  image("../figuras/perimetros_c_eurocode.png", width: 80%),
  caption: [Exemplos de Perímetro de controle básico segundo o Eurocode 2:2023 ($0.5d_v$). #todo[melhorar imagem, tirar '2']]
) <fig_ec2_perimetro>


Em relação ao ACI 318-25, a seção crítica é definida a $d\/2$ da face do pilar ou da área carregada. A tensão cisalhante atuante $v_u$ é calculada como a força concentrada dividida por $b_0 d$, e comparada à resistência $phi v_n$, onde $phi$ é o fator de redução de resistência. Para lajes sem armadura de cisalhamento, $v_n = v_c$, se não, $v_n = v_c + v_s$.

A resistência do concreto é definida pela expressão:

$
v_c = min cases(
  4 lambda lambda_s sqrt(f_c'),
  (2 + 4/β) lambda lambda_s sqrt(f_c'),
  (2 + (α_s d) / b_0) lambda lambda_s sqrt(f_c'),
)
$

onde $β$ é a razão entre as dimensões do pilar, $λ$ é o fator de concreto leve, $λ_s$ é o fator de efeito de escala (_size effect_) e $α_s$ depende da posição do pilar.

//#figure(
//  image("../figuras/aci_perimetro.png", width: 70%),
//  caption: [Perímetro crítico $b_0$ a $d\/2$ da face do pilar segundo o ACI 318-25. #todo[substituir por figura própria]]
//) <fig_aci_perimetro>

Observa-se que a ABNT NBR 6118 e o Eurocode 2 compartilham a filosofia de múltiplos contornos críticos, enquanto o ACI 318 adota um contorno único a $d\/2$. A revisão de 2023 do Eurocode 2 aproxima o perímetro de controle da face do pilar, tornando a verificação mais rigorosa na região de altas tensões cisalhantes, e substitui as expressões empíricas por um modelo mecânico.

=== O Método dos Elementos Finitos (MEF)

#todo[Após realizar algumas simulações, revisar este texto para descrever partes do processo de elementos finitos que causaram problema / são interessantes.]


O Método dos elementos finitos é um método de solução numérica para problemas de valor de contorno usado amplamente e históricamente na engenharia civil. A discretização converte a análise geométrica em uma análise de um conjunto finito de elementos, conectados por nós, que substituem o domínio contínio com um modelo discreto adequado para análise numérica. A qualidade dessa aproximação depende diretamente da malha adotada (a união dos elementos em nós, linhas, faces e volumes) e dos modelos constitutivos (que representam as propriedades físicas do material). 

#figure(
  image("../figuras/discretization.png", width: 80%),
  caption: [Discretização de um modelo geométrico CAD em uma malha de elementos finitos. Fonte: Durand (2025), Notas de aula.]
)

A base do método está no relacionamento desses elementos, e como as forças neles impostas definem a rigidez global da estrutura. Para a simulação de rupturas, observada na presente pesquisa, a interface desses elementos será a base da propagação de fraturas, e definirão o formato das mesmas ao longo da simulação1.

Para um problema estático, o equilíbrio pode ser descrito como um _boundary value problem_ (problema de valor de contorno) na sua forma forte:

$
  cases(bold(nabla dot sigma + b = 0) in Omega , bold(u = u_D) in Gamma_D, bold(sigma dot n = t)in Gamma_N "")
$

A forma forte é composta pela equação diferencial de equilíbrio no domínio $Omega$ e pelas condições de contorno essenciais e naturais, prescritas nas parcelas $Gamma_D$ e $Gamma_N$, respectivamente. Nessa formulação, $sigma$ representa o tensor de tensões, $b$ são as forças de volume, $u_D$ são os deslocamentos prescritos, $t$ são as trações aplicadas e $n$ é o vetor normal unitário à superfície de contorno. A equação diferencial estabelece o equilíbrio local do corpo, enquanto as condições de contorno definem os deslocamentos e as trações em suas respectivas regiões.


Por meio da forma forte, deriva-se a forma fraca, que resulta na equação governante do MEF:

$
  integral_Omega bold(B)^T bold(D) bold(B) dif Omega_" " bold(U) = 
  integral_(Gamma_N) bold(N)^T bold(t) dif Gamma_N + 
  integral_(Omega) bold(N)^T bold(b) dif Gamma_Omega 
$

Ou, de forma compacta:

$
  bold(K) bold(U) = bold(F)_N + bold(F)_Omega = bold(F)
$

A forma fraca define a relação entre a matriz de rigidez global ($bold(K)$), os deslocamentos aplicados e decorrentes ($bold(U)$) com as forças existentes no problema ($bold(F)$). Em problemas elásticos, essa equação é válida e objetiva de se obter, em pequenos deslocamentos, mas torna-se inadequada para problemas não-lineares, como o concreto em ruptura.

Para o problema de punção em lajes lisas. a não-linearidade ocorre principalmente em função do material, pela ocorrência de fraturas, escoamento do aço, coesão (e deslizamento) entre armadura e o concreto, dentre outros fatores. Nesses casos, a equação de equilíbrio deve ser reescrita em função do resíduo ($bold(R)(bold(u))$) entre as forças internas ($bold(f)_"int"$)e externas ($bold(f)_"ext"$) do sistema:

$ 
  bold(R)(bold(u)) = bold(f)_"ext" - bold(f)_"int" (bold(u)) = 0
$

As forças internas dependem do estado atual do material, e por isso o sistema não pode ser resolvido diretamente. A solução é obtida de forma incremental e iterativa, pelo método de Newton-Raphson: aplica-se a carga em pequenos passos e, em cada passo, corrige-se a solução até que o resíduo seja suficientemente pequeno. Essa correção ocorre pela alteração da rigidez interna do material, ditada pelo modelo constitutivo apropriado.

Em problemas com amolecimento acentuado, no caso da punção, a matriz tangente pode se tornar indefinida e o método pode falhar. Nesses casos, técnicas de continuação (como _arc-length_ e métodos de passo automático) e esquemas de integração implícita, como os adotados em @Durand_2019 e @Durand_2021_3D, são necessários para acompanhar o caminho de equilíbrio após o pico de carga.

=== Elementos Coesivos

A modelagem de elementos quase-frágeis possui duas principais vertentes, a de fratura distribuida, onde a influência da fratura é espalhada ao longo do elemento finito (p. ex. Modelos de Dano) e fratura discreta, onde fratura, ou seu potencial, é representada por elemento de interface próprio. 

Os elementos coesivos se inserem no contexto de abordagens discretas da ruptura. Eles fornecem a lei constitutiva local que governa a perda de rigidez na fissura, alimentando o resíduo e a matriz tangente global a cada iteração. O elemento é iniciado com espessura nula, sendo sujeito às variações nas tensões do problema. Quando as condições do modelo constitutivo forem atingidas, haverá o início da ruptura na interface entre os elementos. 

#figure(
  image("../figuras/interface_element.png", width: 90%),
  caption: [Elemento de interface de 8 nós (a) Em coordenadas globais (b) em coordenadas locais]
)

Essa dependência do modelo constitutivo faz parte da natureza dos elementos coesivos, e sua formulação deve ser eficiente e suficientemente representativa do material frágil sendo analisado. 



=== Modelos Constitutivos

==== O modelo bidimensional

O texto de @Durand_2019 apresenta um modelo bidimensional para elementos de interface modelados de acordo com a função de escoamento de Mohr-Coulomb. Além disso, os autores utilizam modelos de fratura não-lineares para representar o amolecimento (_softening_) da fratura ao longo de sua separação.

O modelo adota uma superfície de escoamento baseada no critério de Mohr-Coulomb com aderência, conforme proposto por @Lens_2009 A função de escoamento $f$ é definida no espaço de tensões normal ($sigma_n$) e cisalhante $tau$ como:

$
   f(sigma, sigma_max) = abs(tau) + (sigma_n - sigma_max) tan(phi) = 0 
$ <esc_f>

#figure(
  image("../figuras/lens_modelo_const.png", width: 65%),
  caption: [Função de escoamento (sólida) e potencial plástico (tracejada) de acordo com @Lens_2009]
)

A função de potencial plástico ($g$), utilizada para determinar a direção do fluxo do material durante deformações plásticas, é definina por

$
   g(sigma, sigma_max) = cases(tau^2 - tau_max^2 = 0 " para " sigma_n <= 0, sigma_n^2 tan^2(phi) + tau^2 - tau_max^2 = 0 " para " sigma_n > 0) 
$

// Hordijk

Para representar o amolecimento da fratura, isto é, a translação da @esc_f para a esquerda, ao longo do eixo $sigma_n$, em relação à abertura da fissura $u_p$, os autores utilizaram a seguinte curva, definida @Hordijk1992. que relaciona a abertura de tração com a tensão máxima do modelo:

#figure(
  image("../figuras/amolecimento_hordjark.png", width: 60%),
  caption: [Curva de amolecimento de Hordijk] 
) <hordijk>

#figure(
  image("../figuras/amolecimento_modelo.png"),
  caption: [Função de Escoamento (a) $u_p = 0$, (b) $u_c > u_p > 0$, (c) $u_p = u_c$ #todo[ajustar zoom / manter fontes consistentes]]
)

//  $ D_(e p)$

A matriz constitutiva elastoplástica $D_"ep"$ relaciona o incremento de tensão com o incremento de deslocamento relativo. Sua derivação parte da decomposição aditiva dos deslocamentos e da condição de consistência. A matriz final é expressa como: 

$ bold(D)_(e p) = bold(D)_e - (bold(D)_e bold(r) bold(v)^T bold(D)_e) / (bold(v)^T bold(D)_e bold(r) - bold(y) bold(m) norm(bold(r))) $ <eq_Dep>

Onde $bold(D)_e$ é a matriz constitutiva elástica do elemento, $bold(v) = (partial f) / (partial sigma)$ e $bold(y) = (partial f) / (partial sigma_max)$ são derivadas da função de escoamento em função das tensões, $bold(r) = (partial g) / (partial sigma)$ é o fluxo plástico e $bold(m) = (partial sigma_max) / (partial u_p)$ é a derivada da tensão máxima em relação à abertura do elemento.

// atualização de tensões e integração implícita
Na análise não-linear de elementos finitos, e especialmente para um modelo matematicamente sensível como os elementos coesivos, a atualização de tensões é parte fundamental do processo iterativo. No modelo de @Durand_2019, essa atualização dependerá do deslocamento relativo $Delta bold(w)$ de tal modo que, dado o valor da tensão na iteração atual $bold(sigma)^n$, a tensão de teste $bold(sigma)^(t r)$ será 

$
  bold(sigma)^(t r) = bold(sigma)^n + bold(D)_e Delta bold(w)
$

A tensão de teste apenas será válida se a condição de escoamento não for atingida, ou seja, se $f(bold(sigma)^(t r), sigma^n_"max") <= 0$. Neste caso o material ainda trabalhará como elástico, logo $bold(sigma)^(t r) = bold(sigma)^(n + 1)$. Caso contrário ($f(bold(sigma)^(t r), sigma^n_"max") > 0$), o incremento será elastoplástico e haverá fissuração, alterando o valor de $sigma_"max"^(n + 1)$. A @tens_update representa a atualização de tensões quando o material trabalha no regime elastoplástico. 

#figure(
  image("../figuras/atualiz_tensoes.png", width: 100%),
  caption: [Atualização de tensões #todo[revisar necessidade de mudar imagem]]
) <tens_update>

==== Modelo tridimensional <sec_cohesive_3d>

Seguindo a aplicação e análise feita nos modelos coesivos em @Durand_2019, que apresentou uma abordagem bidimensional do modelo, que se mostra uma limitação natural do modelo. Assim, para superar essa limitação, @Durand_2021_3D apresenta uma extensão tridimensioal do modelo constitutivo, que é a base utilizada nesse trabalho para analisar a punção em lajes lisas.

// extensão para o estado triaxial de tensões

A extensão para o modelo tridimensioal parte da substituição do elemento de interface de quatro nós (2D) por um elemento quadrilateral de oito nós com espessura nula. onsequentemente, o estado de tensões no ponto de integração deixa de ser representado por duas componentes ($sigma_n$ e $tau$) e passa a incluir duas componentes cisalhantes ortogonais no plano da fissura ($tau_s$ e $tau_t$). O vetor de tensões locais passa a ser:

$
  bold(sigma) = chevron.l sigma_n, tau_s, tau_t chevron.r
$

Esse fator também afetará a função de escoamento, que sofrerá influência do esforço cisalhante resultante:

$
  f(bold(sigma), sigma_max) = sqrt(tau_s^2 + tau_t^2) + (sigma_n - sigma_max) tan(phi) = 0
$

Assim como no modelo anterior, a variável $sigma_max$ representa a resistência à tração atual do material e é responsável por simular a perda de resistência por fissuração. O deslocamento plástico relativo efetivo, que governa a evolução de $sigma_max$, também é generalizado para o estado triaxial:

$
  u_p = integral_0^t
  norm(dot(bold(w))_p) d t
  = integral_0^t
  sqrt(dot(w)_(n p)^2
  +
  dot(w)_(s p)^2 + dot(w)_(t p)^2) d t
$

Onde $dot(bold(w)_p)$ é o vetor que contém a taxa de deslocamento plástico relativo em coordenadas locais $chevron.l n, s, t chevron.r$. A curva de amolecimento utilizada é a mesma da @hordijk.

// formulação potencial plástico 3D

Para formulação da matriz constitutiva no fluxo plástico, adota-se uma regra não associada, similar ao modelo 2D. Na compressão, o fluxo plástico depende puramente dos esforços cisalhantes, e na tração, considera-se a influência da tensão e do ângulo de atrito. A função de potencial plástico $g$ assume a forma:

$
  g(bold(sigma), sigma_max) = cases(
    tau_s^2 + tau_t^2 - tau_max^2 = 0 & "para " sigma_n <= 0,
    sigma_n^2 tan^2(phi) + tau_s^2 + tau_t^2 - tau_max^2 = 0 & "para " sigma_n > 0
  )
$

As derivadas necessárias para o cálculo da matriz elastoplástica $bold(D)_(e p)$ são generalizadas para o vetor tridimensional. O vetor normal à superfície de escoamento $bold(v)$ e o vetor de fluxo plástico $bold(r)$ passam a ter três componentes:

$
  bold(v) = ((partial f)/(partial sigma_n), (partial f)/(partial tau_s), (partial f)/(partial tau_t)) = (tan(phi), tau_s / sqrt(tau_s^2 + tau_t^2), tau_t / sqrt(tau_s^2 + tau_t^2))
$

$
  bold(r) = ((partial g)/(partial sigma_n), (partial g)/(partial tau_s), (partial g)/(partial tau_t)) = (2 sigma_n tan^2(phi), 2 tau_s, 2 tau_t) quad "para " sigma_n > 0
$

A matriz constitutiva elastoplástica $bold(D)_(e p)$ mantém a mesma estrutura da @eq_Dep (do modelo 2D), porém agora operando com vetores de três componentes. 


// técnicas de solução numérica
//    -> runge kutta
//    -> passo automático

Problemas altamente não-lineares podem apresentar, próximos da carga máxima, variações bruscas na rigidez, o que levará a erros na solução de elementos finitos se um procedimento padrão de Newton-Raphson for aplicado. Para lidar com essa complexidade, @Durand_2021_3D incorporam duas técnicas avançadas de solução numérica.

- Runge-Kutta (Método de Ralston): Em vez de avaliar a matriz de rigidez global $bold(K)$ apenas no início de cada incremento, o método de Ralston faz duas avaliações: uma no início ($bold(K)_1 = bold(K)(bold(U)^n)$) e outra em um ponto intermediário do incremento ($bold(K)_2 = bold(K)(bold(U)^n + 2/3 Delta bold(U))$). A matriz de rigidez final é uma média ponderada:

$
  tilde(bold(K)) = 1/4 bold(K)_1 + 3/4 bold(K)_2
$

Essa aproximação melhora significativamente a acurácia da solução e reduz o número de iterações necessárias para a convergência.

- Passo Automático (Automatic Stepping): O tamanho do incremento de carga $Delta T$ é ajustado dinamicamente com base no erro de truncamento $e r r = norm(Delta bold(F)_"ext" - Delta bold(F)_"int")$. Se o incremento converge com sucesso, o passo é aumentado; se falha, é reduzido. O fator de escala $q$ é definido como:

$
  q = (1 + tanh(log_10 (t o l) / (e r r)))
$

O novo passo é calculado como $Delta T^(n+1) = q Delta T^n$, com limites para evitar passos muito pequenos ($0.2$) ou muito grandes ($0.9$). Essa técnica permite que a análise avance de forma eficiente nas regiões estáveis e desacelere automaticamente próximo ao pico de carga e no ramo de amolecimento.


// aplicação

O modelo 3D foi validado por @Durand_2021_3D por meio de ensaios de tração e cisalhamento puros (patch tests) e, posteriormente, aplicado à simulação de experimentos clássicos da literatura, como vigas entalhadas submetidas à torção e placas com duplo entalhe em modo misto. Os resultados demonstraram boa concordância com as curvas experimentais de carga-CMOD, incluindo o ramo de amolecimento, e padrões de fissuração compatíveis com os observados experimentalmente.

É importante destacar que o modelo 3D apresenta uma limitação em relação ao tipo de elemento de volume utilizado: @Durand_2021_3D observaram que elementos hexaédricos interferem no desenvolvimento das fissuras, tendendo a aumentar a carga de pico ou gerar múltiplas fissuras em regiões onde se esperava apenas uma. Por outro lado, elementos tetraédricos e piramidais proporcionaram padrões de fissuração mais realistas. Essa observação é particularmente relevante para o presente trabalho, pois a escolha do tipo de elemento de volume na malha da laje influenciará diretamente a qualidade dos resultados da simulação de punção.

==== Modelagem da Fissuração do Concreto
// problema de compatibilidade malha entre aço e concreto
Segundo @Durand_2021, a modelagem de armaduras em meios sólidos por elementos finitos apresenta duas problemáticas clássicas: A primeira, em relação à dificuldade de representar o elemento numericamente, isto é, sua relação geométrica com a discretização do problema, e a segunda, referente à definição de um modelo de interface adequado para modelar a ligação entre aço e concreto, incluindo o escorregamento. 

Atualmente existem três abordagens para a abordar a geometria e influência das barras no concreto armado: 

- Distribuida, que assume uma rigidez equivalente para o elemento de volume, com a contribuição da barra, porém necessita da hipótese aderência perfeita, além de dificultar a recuperação de tensões específicas ao aço; 
- Embutida, onde a barra é um elemento próprio, interior ao elemento de volume, ao custo do maior esforço computacional, e maior complexidade na aplicação de condições de contorno.
- Discreta, que depende implicitamente da malha, por representar seus elementos ao longo de contatos de elementos, o que afeta diretamente a distribuição dos nós ao longo do volume, e impactaria diretamente no comportamento de fissuração do concreto;

#figure(
  caption: [Representação dos modelos (a) distribuídos, (b) embutido e (c) discretos @hipolito2016aplicacao],
  image("../figuras/modelos_barras.png")
) <fig:modelos_barras>


Para superar essas limitações, especialmente em simulações tridimensionais, o modelo apresentado por @Durand_2021 utiliza um elemento semi-embutido de interface contínuo barra-sólido (_rod-solid interface element_) que dispensa a compatibilidade de malha e permite a aplicação direta de condições de contorno nos nós da barra. Diferentemente do modelo embutido apresentado na @fig:modelos_barras (b), o elemento é formulado a partir de pontos de controle virtuais interiores ao elemento de volume, localizados, inicialmente, nas mesmas coordenadas espaciais dos nós da barra. 

#figure(
  caption: [Modelo semi-embutido],
  image("../figuras/modelos_barras_semi-embutido.png", width: 55%)
)

A partir desses pontos, calcula-se o deslocamento relativo entre barra e sólido por interpolação das funções de forma do elemento de volume, obtendo-se o vetor de deslocamentos relativos $tilde(bold(w))$ em coordenadas locais alinhadas com a barra. Para simulações tridimensionais, será adodotado o elemento expresso pela @fig:interface_tetra.

#import "helpers.typ": rebar

#figure(
  rebar,
  caption: [Elemento de interface de barra de 3 nós, embutido em um elemento tetrahétrico de 4 nós.]
) <fig:interface_tetra>

A matriz $tilde(bold(B))$ relaciona os deslocamentos nodais do sólido e da barra aos deslocamentos relativos no ponto de integração, e a matriz de rigidez do elemento é obtida por integração numérica ao longo do comprimento da barra. Diferentemente de elementos de mola pontuais, as forças de contato são distribuídas continuamente ao longo do comprimento, o que permite recuperar a distribuição de tensões de aderência nos pontos de integração de forma análoga a elementos finitos convencionais.

Para o comportamento constitutivo da interface, @Durand_2021 adota um modelo que combina o envelope monotônico do _fib Model Code_ @fib2020modelcode com o modelo cíclico de @Murcia_Delso_2013.

O envelope monotônico é definido por uma curva em quatro trechos: ascendente, patamar, descendente e residual, que podem ser observados na @fib_bond_slip.

#figure(
  image("../figuras/fib_bond_slip_monotonic.png", width: 80%),
  caption: [Relação analítica entre tensão de aderência e deslizamento (carregamento monotônico) @fib2020modelcode]
) <fib_bond_slip>

Na figura, $tau_"bmax"$ é a tensão máxima de aderência, atingida ao final do trecho ascendente e mantida durante o patamar; $tau_"bu,split,1"$ e $tau_"bu,split,2"$ são as tensões de pico no modo de ruptura por _splitting_, respectivamente sem e com estribos de confinamento, valores inferiores a $tau_"bmax"$, que corresponde ao modo pull-out em concreto bem confinado. $tau_"bf"$ é a tensão residual de atrito após o colapso da aderência. Os deslocamentos $s_1$, $s_2$ e $s_3$ delimitam os quatro trechos da curva: $s_1$ marca o fim do trecho ascendente (pico), $s_2$ o fim do patamar (início do descendente) e $s_3$ o ponto em que a tensão residual $tau_"bf"$ é atingida. 

Complementarmente, o elemento de restrição de ponta controla o deslocamento relativo na extremidade da armadura, cobrindo duas situações: pontas ancoradas, de deslocamento nulo, adotando-se penalidade, e pontas não ancoradas, que impedem apenas a penetração da barra no sólido. Para o caso de lajes lisas, esse elemento é particularmente útil para representar a ancoragem das barras de flexão nas extremidades da laje, onde ganchos em "U" impedem o escorregamento excessivo.

Para o presente trabalho, a contribuição de @Durand_2021 é fundamental: o elemento de interface barra-sólido permite representar a armadura de flexão da laje sem a necessidade de compatibilizar a malha do concreto com a posição das barras, o que viabiliza a geração automática da malha e a variação do layout de armadura sem remalhamento. A aplicação ao caso da laje lisa de @palhares2018 é, portanto, direta: as barras de flexão (superior e inferior) e os ganchos em "U" podem ser discretizados como elementos de barra curva, conectados ao concreto por meio dos elementos de interface, com o envelope monotônico do fib governando a aderência.


== Estado da Arte
Este capítulo apresenta o estado atual das simulações numéricas de punção, com enfoque especial no Método dos Elementos Finitos (MEF). No contexto da modelagem numérica, observa-se que grande parte dos estudos que empregam elementos coesivos os utiliza para representar interfaces específicas entre materiais, não necessariamente para modelar diretamente a fissura diagonal característica do fenômeno da punção, como proposto na presente pesquisa.

Inicialmente, será abordado o trabalho de @Schimanowski_2025, que apresenta uma extensa revisão da aplicação do MEF na simulação do fenômeno da punção em diferentes contextos. Será dada especial atenção às lajes lisas, buscando compreender como sua modelagem numérica evoluiu ao longo do tempo.

Em seguida, será analisado o trabalho de @Palhares_2022, que constitui a principal referência e base de comparação para a presente pesquisa. Esse estudo analisa numericamente lajes ensaiadas experimentalmente por @palhares2018 e @Lima2021, investigando a influência de diferentes configurações de armadura de punção em comparação com uma laje de referência. Esta última será também considerada na presente pesquisa, permitindo uma comparação direta entre os resultados obtidos.

=== Cenário atual da modelagem numérica de punção



=== Simulação de punção via CDPM: O modelo de Palhares et al. (2022)
