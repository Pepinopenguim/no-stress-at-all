// #import "/utils/todo.typ": TODO
#import "helpers.typ": todo, prose
= Revisão bibliográfica

== Referencial Teórico

O presente capítulo apresenta uma revisão atualizada do contexto atual da engenharia estrutural no que se refere à punção de lajes lisas. Depois, será apresentada uma introdução básica ao método dos elementos finitos, focada em aspectos interessantes para o caso simulado. Então, serão observados os modelos matemáticos utilizados na simulação. Por fim, será observado o estado da arte na simulação numérica e experimental de punção.

=== Punção em Lajes Lisas

As lajes lisas são sistemas estruturais laminares apoiados exclusivamente por pilares. O acúmulo de esforços e tensões, especialmente em torno da conexão laje-pila, causa uma região de grande potencial de ruptura. De acordo com #prose(<melges1995>), o acúmulo de tensões nessa região pode ser extremo a ponto da ruptura ocorrer antes do escoamento do aço, caracterizando uma ruptura frágil. 

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

A superfície de ruptura inclina-se tipicamente entre $25 degree$ e $30 degree$ em relação ao plano da laje, conforme observado experimentalmente por #prose(<regan1981>) e confirmado por #prose(<palhares2018>). A extensão horizontal dessa superfície é da ordem de $2 d$ a $3 d$, onde $d$ é a altura útil da laje.

#figure(
  image("../figuras/tronco_puncao.png", width: 70%),
  caption: [Formação do tronco de cone de punção ao redor do pilar. @palhares2018]
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

A resistência à compressão do concreto $f_c$ é o primeiro deles: a capacidade resistente cresce com $f_c$, mas a relação não é linear — formulações normativas adotam proporcionalidade com $f_c^(1\/3)$ (EN 1992-1-1:2023 e ABNT NBR 6118:2026) ou com $sqrt(f_c)$ (ACI 318-25). #prose(<melges1995>) relata que a relação não linear já havia sido observada por Graf na década de 1930, sendo que a adoção da raiz quadrada tende a superestimar a influência em concretos de alta resistência. 

A taxa de armadura de flexão $rho$ controla a abertura das fissuras de flexão: quanto maior $rho$, menor a abertura, o que melhora o engrenamento dos agregados e o efeito de pino, elevando a capacidade resistente @regan1981. 

A geometria e dimensão do pilar determinam a distribuição de tensões na ligação: pilares circulares apresentam resistência cerca de $15 percent$ superior à de pilares quadrados de área equivalente, em razão da concentração de tensões nos cantos dos pilares retangulares @regan1981, e pilares alongados (relação entre lados maior que $2$) produzem ruptura mais abrupta, com cone de punção menor e menor resistência @melges1995.

  O efeito de escala (_size effect_) é outro fator central: a resistência nominal ao cisalhamento diminui com o aumento da altura útil, uma vez que lajes mais espessas apresentam maior heterogeneidade do concreto e menor eficiência da armadura de flexão no controle da abertura de fissuras ao longo de toda a seção fissurada @melges1995. Esse efeito é incorporado nas formulações normativas por coeficientes que majoram a resistência para lajes de menor altura útil @cen_en1992_2023, @abnt_nbr6118_2026. 

Por fim, a armadura de cisalhamento é a forma mais eficiente de elevar a resistência à punção, uma vez que as demais alternativas — aumento da seção do pilar, da espessura da laje, da taxa de armadura de flexão ou da resistência do concreto — são, em geral, economicamente desfavoráveis ou arquitetonicamente indesejáveis @palhares2018. Diferentes tipos já foram investigados (estribos fechados, estribos abertos, estribos inclinados, barras dobradas e conectores tipo pino), sendo os estribos fechados e os _studs_ os mais utilizados na prática; a eficiência da armadura depende diretamente das condições de ancoragem na armadura de flexão @palhares2018 @Lima2021.

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
#import "helpers.typ": abnt-contours
#figure(
  abnt-contours(),
  caption: [Contornos críticos C e C' segundo a ABNT NBR 6118:2023.]
) <fig_nbr_contornos>

Quando a resistência no contorno C' é insuficiente, a norma permite o uso de armadura de cisalhamento. Nesse caso, a resistência é acrescida da parcela contribuída pela armadura, e a tensão resistente $tau_(R d 3)$ passa a incluir um termo proporcional a $(A_(s w) f_(y w d)) / (u_1 d)$, onde $A_(s w)$ é a área da armadura por camada, $f_(y w d)$ é a resistência de cálculo da armadura (limitada a 300 MPa para conectores e 250 MPa para estribos) e $u_1$ é o perímetro crítico.

No que se refere ao Estados Limite de Serviço (ELS), o comportamento das lajes deve assegurar condições adequadas de utilização, funcionalidade e durabilidade da estrutura, considerando principalmente o controle de deformações excessivas e da fissuração. Sob ações de serviço, a laje pode apresentar regiões não fissuradas (Estádio I) e regiões fissuradas (Estádio II), conforme a intensidade e a distribuição dos momentos fletores atuantes. Essa condição influencia a rigidez à flexão da laje e, consequentemente, sua distribuição de esforços e deformações. Além disso, a fissuração por flexão nas proximidades dos pilares é um aspecto relevante na análise do comportamento da ligação laje-pilar, uma vez que pode influenciar os mecanismos de transferência de esforços e a resistência à punção.

O Eurocode 2:2023 introduziu uma revisão profunda no dimensionamento à punção, substituindo as formulações empíricas da versão de 2004 por um modelo mecânico baseado na _Critical Shear Crack Theory_ (CSCT). A principal mudança geométrica é a redefinição do perímetro de controle básico: enquanto a versão de 2004 adotava $2d$ a partir da face do pilar, a versão de 2023 adota $0.5d_v$ (onde $d_v$ é a altura útil efetiva).

A verificação é organizada na Seção 8.4 do código. De modo similar à norma brasileira, a resistência ao puncionamento deve ser verificada na face do pilar (perímetro $u_0$) e no perímetro de controle $u_1$ (a $0.5d_v$), e, caso haja armadura de cisalhamento, em um perímetro adicional $u_"out"$ onde a armadura já não é necessária.

A resistência do concreto sem armadura, $τ_"Rd,c"$, é expressa por:

$ τ_"Rd,c" = 0.6 / γ_V k_(p b) (100 ρ_l f_(c k) d_(d g) / d_v)^(1/3) <= 0.5/γ_V sqrt(f_"ck") $

onde $k_"pb"$ é o coeficiente de aprimoramento do gradiente de punção ($1 <= k_"pb" <= 2.5$), $d_(d g)$ é o parâmetro que descreve a rugosidade da fissura, $rho_l$ é a taxa geométrica de armadura longitudinal de flexão, e $gamma_V$ é o coeficiente parcial de segurança para a resistência ao cisalhamento.
#import "helpers.typ": euro-contours
#figure(
  euro-contours(),
  caption: [Exemplos de Perímetro de controle básico segundo o Eurocode 2:2023 ($0.5d_v$).]
) <fig_ec2_perimetro>

Em relação ao ELS, a revisão de 2023 do Eurocode 2 (EN 1992-1-1:2023) o modelo europeu estabelece uma dependência direta entre o comportamento em serviço e a capacidade resistente última (ELU): a rotação da laje ($psi$) e o nível de deformação da armadura de flexão sob combinações de serviço governam a abertura da fissura crítica de cisalhamento no perímetro de controle a $0,5 d_v$, condicionando a eficiência do engrenamento dos agregados.

Paralelemante, as verificações de ELS exigem o controle explícito da abertura de fissuras por flexão ($w_("lim")$ entre $0,2$ mm e $0,4$ mm, a depender da classe de exposição e durabilidade) e das deformações limites ($L\/250$ para aceitabilidade visual e $L\/500$ para a proteção de elementos não estruturais), avaliados por análise não linear ou tabelas de esbeltez que consideram a transição de rigidez para o Estádio II e os efeitos de enrijecimento à tração do concreto (_tension stiffening_).

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

#import "helpers.typ": aci-contours
#figure(
  caption: [Perímetro crítico $b_0$ a $d\/2$ da face do pilar segundo o ACI 318-25.],
  aci-contours()
)


No que se refere ao ELS, o @aci_318_25 adota uma abordagem desacoplada e indireta para o comportamento de lajes sob punção. O código norte-americano não estabelece uma verificação direta de tensões cisalhantes por punção em nível de serviço, concentrando a análise de cisalhamento bidirecional exclusivamente no Estado Limite Último (ELU) na seção crítica supracitada. No ELS, o desempenho da laje é garantido de maneira indireta pela prescrição de espessuras mínimas empíricas ($h_("min")$), que dispensam a verificação explícita de deformações sob cargas gravitacionais usuais. Quando a espessura da laje é inferior a esse limite, exige-se o cálculo explícito das flechas imediatas e diferidas no tempo com base no momento de inércia efetivo ($I_e$), de modo que essas garantam a aceitabilidade visual e a integridade de elementos não estruturais acoplados. Adicionalmente, o controle da fissuração na região dos apoios, onde ocorrem os picos de momento negativo simultâneos às solicitações de punção, é realizado pelo detalhamento e limitação do espaçamento das armaduras longitudinais de flexão.


Deste modo, observa-se que a ABNT NBR 6118 e o Eurocode 2 compartilham a filosofia de múltiplos contornos críticos, enquanto o ACI 318 adota um contorno único a $d\/2$. A revisão de 2023 do Eurocode 2 aproxima o perímetro de controle da face do pilar, tornando a verificação mais rigorosa na região de altas tensões cisalhantes, e substitui as expressões empíricas por um modelo mecânico.

=== Aderência Aço-Concreto

A aderência entre o aço e o concreto constitui o mecanismo físico e mecânico fundamental que possibilita o funcionamento compósito das estruturas de concreto armado @Junior_2021. Sem a adequada transferência de esforços na interface entre as barras de armadura e a matriz circundante de concreto, seria impossível garantir a integridade estrutural tanto no Estado Limite de Serviço (ELS), no controle de fissuração, deformações e no fenômeno de enrijecimento à tração (_tension stiffening_), quanto no Estado Limite Último (ELU), no tocante à ancoragem de barras, emendas por trespasse e à capacidade de rotação de rótulas plásticas.

A transferência de tensões de aderência ao longo do comprimento de embutimento da barra desenvolve-se por meio da ação combinada de três mecanismos principais:

+ Adesão Química (ou Pura): Decorre de ligações físico-químicas microscópicas formadas na interface entre os produtos de hidratação do cimento e a superfície do aço. Embora proporcione a rigidez inicial no estágio não fissurado, possui resistência bastante reduzida (da ordem de 0,1 MPa a 0,5 MPa) e degrada-se rapidamente logo aos primeiros microdeslocamentos relativos ($s &gt; 0$).
+ Atrito Friccional: Resulta da resistência ao escorregamento tangencial gerada pela rugosidade superficial do aço e pelas tensões de compressão normais que atuam perpendicularmente à interface. Essas tensões normais surgem devido à retracção do concreto ao redor da barra, além da restrição oferecida pela armadura transversal ou pelo confinamento do concreto circundante.
+ Engrenamento Mecânico (_Interlocking_): Constitui o mecanismo predominantemente responsável pela capacidade resistente em barras nervuradas. À medida que a barra sofre tração, as nervuras pressionam a matriz de concreto contra as mísulas de concreto situadas entre as saliências do aço. Essa ação gera forças inclinadas em relação ao eixo da barra, as quais possuem uma componente longitudinal (responsável pelo equilíbrio cisalhante) e uma componente radial de compressão orientada para fora. 

#figure(
  caption: [Mecanismos de transferência de esforços entre o concreto e aço. (a) Adesão química; (b) Atrito Friccional; e (c) Aderência mecânica. Fonte: @Brantschen2016],
  image("../figuras/bond_kinds.png", width: 100%),
)

A resposta última da ligação aço-concreto é condicionada pelo modo de falha da interface, governado principalmente pelo nível de confinamento do concreto e pelas dimensões do cobrimento:
- Ruptura por Arrancamento (_Pull-out failure_): Ocorre em seções com elevado confinamento (grande cobrimento $c/d_b$, presença de armadura transversal densa ou tensões de compressão transversais). Nesse cenário, as mísulas de concreto entre as nervuras são progressivamente cisalhadas, resultando em uma curva tensão-deslizamento dúctil com patamar de plastificação e tensão residual de atrito.
- Ruptura por Fendilhamento (_Splitting failure_): Ocorre em elementos com reduzido cobrimento de concreto ou sem armadura transversal de confinamento. As componentes radiais de força geradas pelo engrenamento mecânico induzem tensões de tração anulares (efeito de cunha) na massa de concreto ao redor da barra @melges1995. Ao ser atingida a resistência à tração do concreto, formam-se fissuras longitudinais de fendilhamento ao longo da armadura, provocando a perda brusca e frágil da capacidade de aderência antes que o patamar de arrancamento seja alcançado @palhares2018 @Lima2021.

A formulação analítica do comportamento local de aderência é comumente representada pela relação entre a tensão cisalhante de aderência ($tau_b$) e o deslizamento relativo ($s$). O #prose(<fib2020modelcode>) define a seguinte relação entre deslizamento e tensão de aderência:

$
tau_b (s) =
cases(
  tau_"bmax" (s / s_1)^α & "em" 0 <= s <= s_1,
  tau_"bmax" & "em" s_1 <= s <= s_2,
  tau_"bmax" - (tau_"bmax" - tau_"bf") (s - s_2)/(s_3 - s_2) & "em" s_2 <= s <= s_3,
  tau_"bf" & "em" s_3 < s,
)

$ <eq:fib_bond_slip>


Assim, o envelope monotônico é definido por uma curva em quatro trechos: ascendente, patamar, descendente e residual, que podem ser observados na @fig:fib_bond_slip.
#import "helpers.typ": fib-curve-tau
#figure(
  fib-curve-tau(1.2cm),
  caption: [Relação analítica entre tensão de aderência e deslizamento (carregamento monotônico) @fib2020modelcode]
) <fig:fib_bond_slip>

Para a @fig:fib_bond_slip e a @eq:fib_bond_slip, $tau_"bmax"$ é a tensão máxima de aderência, atingida ao final do trecho ascendente e mantida durante o patamar; $tau_"bf"$ é a tensão residual de atrito após o colapso da aderência. Os deslocamentos $s_1$, $s_2$ e $s_3$ delimitam os quatro trechos da curva: $s_1$ marca o fim do trecho ascendente (pico), $s_2$ o fim do patamar (início do descendente) e $s_3$ o ponto em que a tensão residual $tau_"bf"$ é atingida. 

Em carregamentos cíclicos ou alternados, modelos como os de #prose(<Murcia_Delso_2013>) incorporam o encurtamento do envelope monotônico e o fenômeno de estrangulamento (_pinching_) devido à degradação do dano na interface. Para o deslizamento de barras decorrentes da punção em lajes lisas, no entanto, apenas o caso de arrancamento é interessante.

=== O Método dos Elementos Finitos (MEF)

//#todo[Após realizar algumas simulações, revisar este texto para descrever partes do processo de elementos finitos que causaram problema / são interessantes.]


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

Para o problema de punção em lajes lisas. a não-linearidade ocorre principalmente em função do material, pela ocorrência de fraturas, escoamento do aço, coesão (e deslizamento) entre armadura e o concreto, dentre outros fatores. Nesses casos, a equação de equilíbrio deve ser reescrita em função do resíduo ($bold(R)(bold(u))$) entre as forças internas ($bold(f)_"int"$) e externas ($bold(f)_"ext"$) do sistema:

$ 
  bold(R)(bold(u)) = bold(f)_"ext" - bold(f)_"int" (bold(u)) = 0
$

As forças internas dependem do estado atual do material, e por isso o sistema não pode ser resolvido diretamente. A solução é obtida de forma incremental e iterativa, pelo método de Newton-Raphson: aplica-se a carga em pequenos passos e, em cada passo, corrige-se a solução até que o resíduo seja suficientemente pequeno. Essa correção ocorre pela alteração da rigidez interna do material, ditada pelo modelo constitutivo apropriado.

Em problemas com amolecimento acentuado, no caso da punção, a matriz tangente pode se tornar indefinida e o método pode falhar. Nesses casos, técnicas de continuação (como _arc-length_ e métodos de passo automático) e esquemas de integração implícita, como os adotados em #prose(<Durand_2019>) e #prose(<Durand_2021_3D>), são necessários para acompanhar o caminho de equilíbrio após o pico de carga.

=== Elementos Coesivos

Esta seção busca introduzir a evolução histórica dos modelos coesivos. Então, serão apresentados os modelos centrais da presente pesquisa, bidimensionais e tridimensionais. Por fim, será apresentado o modelo de interface barra-sólido, utilizado para simular a aderência das barras em relação ao concreto.

==== Contexto histórico e Evolução

A evolução dos elementos coesivos pode ser definida em quatro marcos principais, desde a concepção da zona coesiva até a consolidação como ferramenta numérica para fratura em concreto.

A ideia fundamental de que a fratura é precedida por uma zona não linear de ponta de fissura, capaz de transmitir tensões, foi introduzida de forma independente por #prose(<Dugdale_1960>) e #prose(<Barenblatt_1962>). Dugdale analisou o escoamento em chapas de aço, e propôs que a zona plástica na ponta da fissura pudesse ser representada por tensões coesivas iguais à tensão de escoamento do material. Barenblatt, por sua vez, formulou o conceito para materiais parcialmente frágeis, tratando a zona coesiva como uma região de tensões de coesão que se anulam quando as superfícies se separam completamente . Esses trabalhos estabeleceram a base conceitual do que hoje se chama de cohesive zone model (CZM).

A aplicação da zona coesiva ao concreto foi realizada por #prose(<Hillerborg_1976>), com o _Fictitious Crack Model_ (FCM). A diferença essencial em relação aos metais é que, no concreto, a zona de processo de fratura não é pequena em comparação com a estrutura; ela pode ser da ordem da dimensão global do corpo. Por isso, o modelo de Hillerborg introduziu uma relação tensão-abertura da fissura ($σ–w$) que governa a transferência de tensões ao longo da fissura, com uma curva de amolecimento que se inicia na resistência à tração do concreto e decai até zero para uma abertura crítica, introduzindo a energia de fratura $G_F$. Esse foi um dos primeiros modelos de fratura não linear para concreto que incorporou explicitamente a zona de processo de fratura (FPZ). Em paralelo, #prose(<Bazant_1983>) desenvolveram formulações complementares de fratura não linear para concreto, frequentemente citadas em conjunto com o FCM.

#figure(
  caption: [Hipóteses apresentadas por #prose(<Hillerborg_1976>) para a relação tensão-abertura],
  image("../figuras/softening_curve_76.png")
)

A transição do conceito mecânico para uma ferramenta computacional robusta ocorreu com o trabalho de #prose(<Needleman_1987>), que implementou um elemento coesivo de modo I em um código de elementos finitos para estudar a separação entre partículas e matriz. Needleman introduziu uma descrição fenomenológica baseada em um potencial de separação, do qual derivam as leis de tração-separação. A partir desse trabalho, as leis coesivas passaram a ser amplamente utilizadas em modelos numéricos de materiais e estruturas. Nas décadas seguintes, diferentes formas de leis de tração-separação foram propostas (p. ex. @Hordijk1992), cada uma adequada a diferentes materiais e modos de fratura.

Um marco na consolidação do _CZM_ como abordagem geral foi a revisão de  #prose(<Elices_2002>). Os autores revisaram o modelo da zona de processo coesiva, destacando sua capacidade de lidar com a zona não linear à frente da ponta da fissura e de prever o comportamento de estruturas não fissuradas, incluindo entalhes rombos, uma limitação comum de modelos de fratura clássicos. O trabalho também mostrou que o _CZM_, originalmente aplicado ao concreto e compósitos cimentícios, podia ser estendido com sucesso a outros materiais.

==== Formulação

A modelagem de elementos quase-frágeis possui duas principais vertentes, a de fratura distribuida, onde a influência da fratura é espalhada ao longo do elemento finito (p. ex. Modelos de Dano) e fratura discreta, onde fratura, ou seu potencial, é representada por elemento de interface próprio. 

Os elementos coesivos se inserem no contexto de abordagens discretas da ruptura, no estudo da mecânica da fratura. Eles fornecem a lei constitutiva local que governa a perda de rigidez na fissura, alimentando o resíduo e a matriz tangente global a cada iteração. O elemento é iniciado com espessura nula, sendo sujeito às variações nas tensões do problema. Quando as condições do modelo constitutivo forem atingidas, haverá o início da ruptura na interface entre os elementos. 

#figure(
  image("../figuras/interface_element.png", width: 90%),
  caption: [Elemento de interface de 8 nós (a) Em coordenadas globais (b) em coordenadas locais. Fonte: @Durand_2021_3D]
)

Essa dependência do modelo constitutivo faz parte da natureza dos elementos coesivos, e sua formulação deve ser eficiente e suficientemente representativa do material frágil sendo analisado. 

No contexto da simulação de punção em lajes lisas, os elementos coesivos apresentam características que fazem dessa uma metodologia de simulação interessante para precisão nos resultados, em função da natureza localizada, discreta e mista do fenômeno. 

A punção é um modo de falha localizado na ligação laje-pilar, que pode ocorrer de forma frágil, sem aviso prévio significativo. Essa característica favorece abordagens que representem a ruptura como uma descontinuidade explícita. Os elementos coesivos fornecem exatamente essa representação, onde a fissura é discretizada de forma própria, permitindo acompanhar a abertura e o deslizamento ao longo do desenvolvimento da fratura. Modelos de dano contínuo, por outro lado, distribuem a fissuração pelo volume do elemento, o que dificulta a distinção entre o dano difuso e a fissura crítica que efetivamente governa a punção.

Outro fator contribuinte se dá pelo fato de que a superfície de ruptura por punção forma um tronco de cone inclinado, no qual a fissura diagonal é submetida, simultaneamente, a abertura (modo I) e cisalhamento (modo II). Pode-se formular o elemento coesivo para esse comportamento misto, com uma superfície de escoamento do tipo Mohr-Coulomb que incorpora a contribuição cisalhante e o ângulo de atrito. Essa capacidade é essencial, pois a fissura de punção envolve transferência de tensões cisalhantes ao longo da interface, algo que leis coesivas puramente modo I não capturariam.

Uma das críticas frequentes aos modelos de dano contínuo aplicados à punção é a alta sensibilidade à malha, sendo necessário observá-la na análise de resultados @Palhares_2022, a resposta numérica varia com o refinamento, e a localização da banda de dano pode ser artificialmente difusa. A zona coesiva, ao concentrar a inelasticidade em uma interface, evita a singularidade de tensão que surgiria em uma fissura aguda e permite cálculos com malhas relativamente grosseiras, uma vez que os gradientes de deformação elevados são substituídos pelo salto de deslocamento na interface. Embora a malha ainda influencie a resposta, a dependência tende a ser menor, voltada principalmente ao formato e caminho realizado pelas fissuras, quando comparado aos modelos de dano distribuído.

Finalmente, o modelo considera a influência da energia de fratura do concreto e curva de amolecimento pós-pico, fatores que governam a punção. Após a carga máxima, a fissura diagonal se desenvolve com transferência decrescente de tensões. Os elementos coesivos incorporam explicitamente a curva de amolecimento, e o parâmetro $G_F$, permitindo representar o ramo descendente da curva carga-deslocamento, que é justamente a região em que modelos de dano contínuo podem apresentar instabilidades numéricas e perda de objetividade.


Em síntese, os elementos coesivos são adequados à punção ao alinhar a representação numérica à física do fenômeno: uma fissura discreta, em modo misto, com amolecimento e energia de fratura bem definidos, que interage com a armadura por meio de uma interface aderente. 

=== Modelos Constitutivos

Modelos constitutivos estabelecem as relações matemáticas fundamentais entre o estado de tensões e as deformações ou aberturas resultantes nos materiais, permitindo representar o comportamento não linear e a degradação de rigidez ao longo do carregamento. No âmbito do Método dos Elementos Finitos com elementos coesivos de interface, essas leis regem os critérios de início de fissuração, as superfícies de plastificação e o amolecimento pós-pico do concreto. 

A seguir, detalham-se as abordagens constitutivas adotadas no trabalho, constituindo o modelo bidimensional uma introdução, para aplicação de seu equivalente tridimensional na presente análise.

==== O modelo bidimensional

O texto de #prose(<Durand_2019>) apresenta um modelo bidimensional para elementos de interface modelados de acordo com a função de escoamento de Mohr-Coulomb. Além disso, os autores utilizam modelos de fratura não-lineares para representar o amolecimento (_softening_) da fratura ao longo de sua separação.

O modelo adota uma superfície de escoamento baseada no critério de Mohr-Coulomb com aderência, conforme proposto por #prose(<Lens_2009>) A função de escoamento $f$ é definida no espaço de tensões normal ($sigma_n$) e cisalhante $tau$ como:

$
   f(sigma, sigma_max) = abs(tau) + (sigma_n - sigma_max) tan(phi) = 0 
$ <esc_f>

#figure(
  image("../figuras/lens_modelo_const.png", width: 65%),
  caption: [Função de escoamento (sólida) e potencial plástico (tracejada) de acordo com #prose(<Lens_2009>)]
)

A função de potencial plástico ($g$), utilizada para determinar a direção do fluxo do material durante deformações plásticas, é definina por

$
  g(sigma, sigma_max) = cases(tau^2 - tau_max^2 = 0 " para " sigma_n <= 0, sigma_n^2 tan^2(phi) + tau^2 - tau_max^2 = 0 " para " sigma_n > 0) 
$

// Hordijk

Para representar o amolecimento da fratura, isto é, a translação da @esc_f para a esquerda, ao longo do eixo $sigma_n$, em relação à abertura da fissura $u_p$, os autores utilizaram a seguinte curva, definida #prose(<Hordijk1992>). que relaciona a abertura de tração com a tensão máxima do modelo:

#figure(
  image("../figuras/amolecimento_hordjark.png", width: 60%),
  caption: [Curva de amolecimento @Hordijk1992.] 
) <hordijk>

#figure(
  image("../figuras/amolecimento_modelo.png"),
  caption: [Função de Escoamento (a) $u_p = 0$, (b) $u_c > u_p > 0$, (c) $u_p = u_c$ Fonte: @Durand_2019]
)

//  $ D_(e p)$

A matriz constitutiva elastoplástica $D_"ep"$ relaciona o incremento de tensão com o incremento de deslocamento relativo. Sua derivação parte da decomposição aditiva dos deslocamentos e da condição de consistência. A matriz final é expressa como: 

$ bold(D)_(e p) = bold(D)_e - (bold(D)_e bold(r) bold(v)^T bold(D)_e) / (bold(v)^T bold(D)_e bold(r) - bold(y) bold(m) norm(bold(r))) $ <eq_Dep>

Onde $bold(D)_e$ é a matriz constitutiva elástica do elemento, $bold(v) = (partial f) / (partial sigma)$ e $bold(y) = (partial f) / (partial sigma_max)$ são derivadas da função de escoamento em função das tensões, $bold(r) = (partial g) / (partial sigma)$ é o fluxo plástico e $bold(m) = (partial sigma_max) / (partial u_p)$ é a derivada da tensão máxima em relação à abertura do elemento.

// atualização de tensões e integração implícita
Na análise não-linear de elementos finitos, e especialmente para um modelo matematicamente sensível como os elementos coesivos, a atualização de tensões é parte fundamental do processo iterativo. No modelo de #prose(<Durand_2019>), essa atualização dependerá do deslocamento relativo $Delta bold(w)$ de tal modo que, dado o valor da tensão na iteração atual $bold(sigma)^n$, a tensão de teste $bold(sigma)^(t r)$ será 

$
  bold(sigma)^(t r) = bold(sigma)^n + bold(D)_e Delta bold(w)
$

A tensão de teste apenas será válida se a condição de escoamento não for atingida, ou seja, se $f(bold(sigma)^(t r), sigma^n_"max") <= 0$. Neste caso o material ainda trabalhará como elástico, logo $bold(sigma)^(t r) = bold(sigma)^(n + 1)$. Caso contrário ($f(bold(sigma)^(t r), sigma^n_"max") > 0$), o incremento será elastoplástico e haverá fissuração, alterando o valor de $sigma_"max"^(n + 1)$. A @tens_update representa a atualização de tensões quando o material trabalha no regime elastoplástico. 

#figure(
  image("../figuras/atualiz_tensoes.png", width: 100%),
  caption: [Atualização de tensões Fonte: @Durand_2019.]
) <tens_update>

==== Modelo tridimensional <sec_cohesive_3d>

Seguindo a aplicação e análise feita nos modelos coesivos em #prose(<Durand_2019>), que apresentou uma abordagem bidimensional do modelo, que se mostra uma limitação natural do modelo. Assim, para superar essa limitação, #prose(<Durand_2021_3D>) apresenta uma extensão tridimensioal do modelo constitutivo, que é a base utilizada nesse trabalho para analisar a punção em lajes lisas.

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

A matriz constitutiva elastoplástica $bold(D)_(e p)$ mantém a mesma estrutura da @eq_Dep, porém agora operando com vetores de três componentes. 


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

O modelo 3D foi validado por #prose(<Durand_2021_3D>) por meio de ensaios de tração e cisalhamento puros (patch tests) e, posteriormente, aplicado à simulação de experimentos clássicos da literatura, como vigas entalhadas submetidas à torção e placas com duplo entalhe em modo misto. Os resultados demonstraram boa concordância com as curvas experimentais de carga-CMOD, incluindo o ramo de amolecimento, e padrões de fissuração compatíveis com os observados experimentalmente.

É importante destacar que o modelo 3D apresenta uma limitação em relação ao tipo de elemento de volume utilizado: #prose(<Durand_2021_3D>) observaram que elementos hexaédricos interferem no desenvolvimento das fissuras, tendendo a aumentar a carga de pico ou gerar múltiplas fissuras em regiões onde se esperava apenas uma. Por outro lado, elementos tetraédricos e piramidais proporcionaram padrões de fissuração mais realistas. Essa observação é particularmente relevante para o presente trabalho, pois a escolha do tipo de elemento de volume na malha da laje influenciará diretamente a qualidade dos resultados da simulação de punção.

==== Modelagem da Aderência do Aço
// problema de compatibilidade malha entre aço e concreto
Segundo #prose(<Durand_2021>), a modelagem de armaduras em meios sólidos por elementos finitos apresenta duas problemáticas clássicas: A primeira, em relação à dificuldade de representar o elemento numericamente, isto é, sua relação geométrica com a discretização do problema, e a segunda, referente à definição de um modelo de interface adequado para modelar a ligação entre aço e concreto, incluindo o escorregamento. 

Atualmente existem três abordagens para a abordar a geometria e influência das barras no concreto armado: 


#figure(
  caption: [Abordagens para aplicação de barras em concreto armado no MEF],
  table(
  columns: (2),
  align: (left, left),
  inset: 8pt,
  stroke: none,
  table.hline(),
  table.header(
    [*Abordagem*],
    [*Características*],
  ),
  table.hline(stroke: 0.8pt),
  [*Distribuída*],
  [
    Assume uma rigidez equivalente para o elemento de volume, incorporando a contribuição da barra. Entretanto, necessita da hipótese de aderência perfeita, além de dificultar a recuperação de tensões específicas ao aço.
  ],
  table.hline(stroke: 0.8pt),
  [*Embutida*],
  [
    Representa a barra como um elemento próprio, inserido no interior do elemento de volume. Essa abordagem apresenta maior esforço computacional e maior complexidade na aplicação de condições de contorno.
  ],
  table.hline(stroke: 0.8pt),
  [*Discreta*],
  [
    Depende implicitamente da malha, uma vez que representa seus elementos ao longo dos contatos entre elementos. Isso afeta diretamente a distribuição dos nós ao longo do volume e, consequentemente, o comportamento de fissuração do concreto.
  ],
  table.hline(),
)
)

#figure(
  caption: [Representação dos modelos (a) distribuídos, (b) embutido e (c) discretos @hipolito2016aplicacao],
  image("../figuras/modelos_barras.png")
) <fig:modelos_barras>


Para superar essas limitações, especialmente em simulações tridimensionais, o modelo apresentado por #prose(<Durand_2021>) utiliza um elemento discreto com acoplamento, de interface contínuo barra-sólido (_rod-solid interface element_) que dispensa a compatibilidade de malha e permite a aplicação direta de condições de contorno nos nós da barra. Diferentemente do modelo embutido apresentado na @fig:modelos_barras (b), o elemento é formulado a partir de pontos de controle virtuais interiores ao elemento de volume, localizados, inicialmente, nas mesmas coordenadas espaciais dos nós da barra. 

#figure(
  caption: [Modelo de Elemento discreto com acoplamento @hipolito2016aplicacao.],
  image("../figuras/modelos_barras_semi-embutido.png", width: 55%)
)

A partir desses pontos, calcula-se o deslocamento relativo entre barra e sólido por interpolação das funções de forma do elemento de volume, obtendo-se o vetor de deslocamentos relativos $tilde(bold(w))$ em coordenadas locais alinhadas com a barra. Para simulações tridimensionais, será adodotado o elemento expresso pela @fig:interface_tetra.

#import "helpers.typ": rebar

#figure(
  rebar,
  caption: [Elemento de interface de barra de 3 nós, embutido em um elemento tetrahétrico de 4 nós.]
) <fig:interface_tetra>

A matriz $tilde(bold(B))$ relaciona os deslocamentos nodais do sólido e da barra aos deslocamentos relativos no ponto de integração, e a matriz de rigidez do elemento é obtida por integração numérica ao longo do comprimento da barra. Diferentemente de elementos de mola pontuais, as forças de contato são distribuídas continuamente ao longo do comprimento, o que permite recuperar a distribuição de tensões de aderência nos pontos de integração de forma análoga a elementos finitos convencionais.

Para o comportamento constitutivo da interface, #prose(<Durand_2021>) adota um modelo que combina o envelope monotônico do _fib Model Code_ @fib2020modelcode com o modelo cíclico de #prose(<Murcia_Delso_2013>).

Complementarmente, o elemento de restrição de ponta controla o deslocamento relativo na extremidade da armadura, cobrindo duas situações: pontas ancoradas, de deslocamento nulo, adotando-se penalidade, e pontas não ancoradas, que impedem apenas a penetração da barra no sólido. Para o caso de lajes lisas, esse elemento é particularmente útil para representar a ancoragem das barras de flexão nas extremidades da laje, onde ganchos em "U" impedem o escorregamento excessivo.

Para o presente trabalho, a contribuição de #prose(<Durand_2021>) é fundamental: o elemento de interface barra-sólido permite representar a armadura de flexão da laje sem a necessidade de compatibilizar a malha do concreto com a posição das barras, o que viabiliza a geração automática da malha e a variação do layout de armadura sem remalhamento. A aplicação ao caso da laje lisa de #prose(<palhares2018>) é, portanto, direta: as barras de flexão (superior e inferior) e os ganchos em "U" podem ser discretizados como elementos de barra curva, conectados ao concreto por meio dos elementos de interface, com o envelope monotônico do fib governando a aderência.


== Estado da Arte
Este capítulo apresenta o estado atual das simulações numéricas de punção, com enfoque especial no Método dos Elementos Finitos (MEF). No contexto da modelagem numérica, observa-se que grande parte dos estudos que empregam elementos coesivos os utiliza para representar interfaces específicas entre materiais, não necessariamente para modelar diretamente a fissura diagonal característica do fenômeno da punção, como proposto na presente pesquisa.

Inicialmente, será abordado o trabalho de #prose(<Schimanowski_2025>), que apresenta uma extensa revisão da aplicação do MEF na simulação do fenômeno da punção em diferentes contextos. Será dada especial atenção às lajes lisas, buscando compreender como sua modelagem numérica evoluiu ao longo do tempo.

Em seguida, serão apresentadas pesquisas contemporâneas no contexto da aplicação de elementos coesivos, análise de punção pelo MEF e ensaios experimentais de punção em lajes lisas, em que serão revisados os trabalhos de #prose(<palhares2018>) e #prose(<Lima2021>).

=== Revisão do Estado da Arte da modelagem numérica de punção @Schimanowski_2025

A modelagem numérica da punção em lajes tem evoluído significativamente nas últimas décadas, impulsionada pela necessidade de prever um modo de falha que é abrupto e potencialmente catastrófico. Em sua pesquisa, #prose(<Schimanowski_2025>) apresentam uma revisão extensiva e sistemática do estado da arte sobre a simulação numérica da punção, analisando a produção científica de alta qualidade até o início de 2025.

#figure(
  caption: [Publicações científicas de alta qualidade em punção ao longo dos anos. Em azul, publicações de análise numérica, em cinza, número total de publicações realizadas. Fonte: @Schimanowski_2025],
  image("../figuras/punshing_shear_papers_over_time.png", width: 80%)
)

Os autores destacam que, embora os estudos experimentais ainda dominem o campo, as investigações numéricas via Método dos Elementos Finitos (MEF) cresceram exponencialmente na última década. Esse avanço é justificado pelo custo significativamente menor das simulações em relação aos ensaios, pela capacidade de avaliar múltiplos parâmetros rapidamente e pela possibilidade de explorar cenários críticos antes da implementação em projeto. Contudo, a revisão ressalta que a modelagem numérica da punção é um desafio complexo, exigindo conhecimento aprofundado de programação, teorias constitutivas e do próprio MEF, além de cuidadosa definição de condições de contorno, malhas e métodos de solução.

Para organizar a vasta literatura, #prose(<Schimanowski_2025>) dividem os estudos numéricos em oito cenários principais. O caso mais simples e fundamental, que também é tema de análise da presente pesquisa, que serve de base para a validação da maioria dos modelos, é o de punção simétrica em lajes lisas de concreto armado convencional, sem aberturas ou armadura de cisalhamento. Nesse contexto, os pesquisadores avaliam a sensibilidade dos resultados a diferentes tipos de elementos (sólidos 3D, cascas, axissimétricos), modelos constitutivos (desde elásticos até dano plástico e fissuração distribuída) e estratégias de modelagem da armadura (embutida, discreta ou distribuída). A revisão aponta que, embora a carga de ruptura seja geralmente bem capturada, a rigidez inicial e a carga de fissuração ainda apresentam desvios em relação aos dados experimentais. Além disso, grande parte dos modelos adota a hipótese de aderência perfeita entre aço e concreto, o que é uma limitação, dado que a interação na interface é um fator crítico para o comportamento pós-pico.

A partir desse caso base, a revisão avança para cenários mais complexos e representativos da prática real. Destaca-se o crescimento dos estudos sobre punção assimétrica, incluindo carregamentos excêntricos, momentos desbalanceados e ligações de borda e canto, que são mais críticos, mas historicamente menos estudados que as ligações internas. Outros temas em evidência incluem a punção sob carregamentos cíclicos e sísmicos, a influência de aberturas próximas ao pilar, o uso de materiais alternativos (como concretos leves e compósitos reforçados com fibras), técnicas de reforço estrutural e diferentes configurações de armadura de cisalhamento. Os autores também abordam cenários complexos, como o colapso progressivo, lajes protendidas, lajes nervuradas, painéis sanduíche e tabuleiros de pontes.

Por fim, #prose(<Schimanowski_2025>) identificam lacunas importantes na literatura e apontam direções promissoras para pesquisas futuras. Os principais desafios transversais que persistem na modelagem numérica são a sensibilidade dos resultados ao modelo constitutivo (frequentemente acompanhada de dependência de malha), a representação precisa da interação entre concreto e armadura (incluindo o escorregamento e a perda de aderência) e o alto custo computacional de análises com malhas refinadas. Como perspectivas futuras, os autores sugerem a simulação sob condições dinâmicas (sísmicas), a análise de lajes com novos materiais (concreto leve, compósitos reforçados com fibras), o desenvolvimento e a avaliação de sistemas avançados de reforço ao cisalhamento, e a exploração da punção em sistemas estruturais complexos, como lajes nervuradas, painéis sanduíche e lajes com núcleos vazados.

Em síntese, a revisão evidencia que a modelagem numérica da punção está em um estágio de maturidade que permite não apenas validar experimentos, mas também investigar fenômenos complexos e orientar o projeto estrutural. Ao mesmo tempo, a identificação das lacunas e desafios reforça a relevância de abordagens inovadoras, como o uso de elementos coesivos para representar a fratura discreta e a modelagem explícita da aderência aço-concreto, que buscam superar as limitações dos modelos de dano contínuo tradicionalmente empregados.



== Aplicação de Elementos Coesivos na Modelagem Discreta de Interfaces e Fratura

No contexto da modelagem numérica via MEF, a aplicação de elementos coesivos permite representar descontinuidades discretas, transferência de esforços em modo misto (Abertura Modo I e Cisalhamento Modo II) e mecanismos de atrito/engrenamento sem a dependência de malha inerente aos modelos de dano contínuo distribuído. A atual seção apresenta, três pesquisas contemporâneas mas abrangentes que aplicam essa metodologia, realizadas por #prose(<Xu_2025>), #prose(<Liu_2022>) e #prose(<Gudzulic_2025>).

Em seu texto, #prose(<Xu_2025>) avaliam a capacidade de aderência e a resposta de arranque (_push-out_) em colunas curtas de tubo de aço preenchido com Concreto de Ultra-Alto Desempenho (UHPCFST). Elementos coesivos 3D (`COH3D8`) são alocados na interface tubo-UHPC e inseridos em lote entre elementos sólidos de UHPC (`C3D8R`) para simular o lascamento e descolamento da matriz.

A relação tração-separação elástica linear inicial (não acoplada) é expressa por:

$ vec(t_n, t_s, t_t) = mat(K_"nn", 0, 0; 0, K_"ss", 0; 0, 0, K_"tt") vec(delta_n, delta_s, delta_t) $

Que representa a relação mecânica clássica entre tração, rigidez e deslocamentos para um corpo. Na notação, $< n, s, t> $ representam, respectivamente, a direção normal e as duas tangenciais.

O início do dano interfacial é regido pelo critério de Tensão Nominal Máxima (_Maximum Nominal Stress Criterion_):

$ max({ (<t_n>) / (t_n^0), (t_s) / (t_s^0), (t_t) / (t_t^0) }) = 1 $

Os autores observaram que modelos convencionais de dano plástico associados apenas ao atrito de Coulomb não conseguiam reproduzir o fenômeno de destacamento do concreto. A inserção dos elementos coesivos entre os elementos do UHPC permitiu que, ao atingirem o critério de ruptura, as superfícies coesivas falhassem e permitissem o escorregamento, lascamento e fraturamento livre do concreto, reproduzindo com precisão o lascamento e o efeito de cunha observados nos ensaios de arranque (push-out).

Além disso, a calibração dos parâmetros constitutivos dos elementos coesivos (rigidez $K_n, K_s, K_t$, tensões de pico de 20% a 40% da resistência e energia de fratura) resultou em uma excelente concordância com as curvas experimentais, com erros inferiores a 5% para a carga de escoamento e para a capacidade última de aderência. 

A simulação coesiva evidenciou claramente a transição do comportamento interfacial: na fase não danificada, a resposta é governada pela rigidez elástica dos elementos coesivos. Após a degradação total das tensões coesivas, a transferência de carga passa a ser mantida exclusivamente pelo atrito e pelo confinamento mecânico exercido pelo tubo de aço.

Com uma abordagem similar, #prose(<Liu_2022>) investigam a transferência de esforços e os mecanismos de fraturamento na interface entre concreto pré-moldado antigo (C30) e concreto moldado posteriormente no local (C35), em vigas com diferentes configurações geométricas de chaves de cisalhamento, submetidas à flexão em quatro pontos.

A iniciação do dano na interface entre os concretos novo e antigo é governada pelo critério Quadrático de Tensão Nominal (Quadratic Nominal Stress Damage Criterion – Quads Damage):

$ ( (t_n) / (t_n^0) )^2 + ( (t_s) / (t_s^0) )^2 + ( (t_t) / (t_t^0) )^2 = 1 $

Nesta formulação, $t_n$ representa a tensão nominal normal à interface, enquanto $t_s$ e $t_t$ correspondem às tensões nominais cisalhantes nas duas direções tangenciais ortogonais. Os termos $t_n^0 = t_s^0 = t_t^0 = 0,6 "MPa"$ definem as resistências nominais de pico (limiares de início de dano) nas respetivas direções.

A interface foi discretizada com elementos coesivos tridimensionais de espessura nula (COH3D8), enquanto o comportamento não linear do concreto foi representado pelo modelo de plasticidade com dano (Concrete Damaged Plasticity – CDP). Adicionalmente, o contato tangencial foi descrito por uma formulação de atrito do tipo penalty, com coeficiente de atrito de Coulomb de 0,6. Essa estratégia permitiu representar a evolução da transferência de esforços, inicialmente dominada pela adesão química e posteriormente governada pela atuação combinada do atrito e do engrenamento mecânico nas paredes das chaves de cisalhamento.

O modelo numérico reproduziu os três modos de ruptura observados experimentalmente: falha dominada pela interface, falha mista entre interface e substrato e rasgamento da raiz da chave de cisalhamento. Os resultados também demonstraram que a geometria das chaves influencia significativamente a capacidade resistente à flexão, sendo a quantidade de chaves o parâmetro de maior sensibilidade, seguida pela profundidade, formato, altura e inclinação. A comparação entre as curvas carga-deslocamento experimentais e numéricas apresentou boa concordância para a maioria das configurações, com diferenças na carga de pico predominantemente inferiores a 2,5%, embora tenha sido observada uma discrepância de 37,1% para a configuração com altura de chave de 60 mm. Esses resultados demonstram a capacidade do modelo em representar a evolução do dano interfacial, a redistribuição de tensões e a alteração das trajetórias de fissuração em função da geometria das chaves de cisalhamento.


Finalmente, #prose(<Gudzulic_2025>) simulam a propagação de fissuras discretas, a falha por cisalhamento em modo misto e o efeito de escala em vigas de concreto armado, combinando elementos de interface coesiva no concreto com elementos de acoplamento elastoplásticos de aderência na armadura.

#figure(
  caption: [ Superfície de fratura coesiva com dilatância apresentada por #prose(<Gudzulic_2025>)],
  image("../figuras/camacho_ortiz_model.png", width: 80%)
)

A superfície de ruína coesiva-friccional estende o modelo de #prose(<Snozzi_2012>), incorporando o efeito de dilatância induzida pela rugosidade e o atrito entre as faces da fissura, que caracteriza a superfície de falha de #prose(<Camacho_1996>):

$
  F
  =
  sqrt(
    (1/β^2 norm(bold(t)_T)^2 + chevron.l t'_(x') chevron.r^2_+)
    /
    (q_c^2)
  )
  -
  1
  =
  0
$

Na equação, $F$ é a função da superfície de falha coesiva, $β = f_s / f_t$ é a razão entre as resistências ao cisalhamento e à tração, $bold(t)_T$ é o vetor de trações tangenciais no plano da fissura, $t'_(x')$ é a tração normal à fissura, $chevron.l t'_(x') chevron.r_+$ representa a parte positiva de $t'_(x')$ pelo operador de Macaulay e $q_c$ é a função de amolecimento coesivo que descreve a evolução da resistência residual.

A função de escoamento é dada por

$
  f_μ(bold(t)'_μ) = norm(bold(t)'_μ) - μ|chevron.l t'_(x') chevron.r^2_+| <= 0
$

Nesta expressão, $f_μ$ é a função de escoamento por atrito, $bold(t)'_μ$ é o vetor de tração tangencial de atrito atuante nas faces da fissura, $μ$ é o coeficiente de atrito de Coulomb e $chevron.l -t'_(x') chevron.r_+$ é a parte positiva da tensão normal compressiva efetiva entre as faces da fissura, de modo que o termo $μ|chevron.l -t'_(x') chevron.r_+|$ representa a resistência friccional mobilizada.

Os resultados obtidos por #prose(<Gudzulic_2025>) demonstraram que a combinação de elementos de interface coesiva no concreto com elementos de acoplamento elastoplásticos de aderência foi capaz de reproduzir a formação de fissuras, os modos de falha e a capacidade resistente de vigas de concreto armado em diferentes escalas geométricas. A inclusão da dilatância induzida pela rugosidade mostrou-se relevante para capturar mecanismos de falha dominados por cisalhamento e o confinamento passivo mobilizado pela armadura. O modelo também reproduziu o efeito de escala na resistência nominal ao cisalhamento, em boa concordância com os ensaios de referência, e a abordagem discreta evitou a necessidade de limitadores de localização típicos de modelos contínuos, embora a sensibilidade de malha tenha sido analisada separadamente.



=== Estudos Numéricos de Punção em Lajes Lisas Utilizando o Método dos Elementos Finitos (MEF)

A análise numérica via Método dos Elementos Finitos (MEF) consolidou-se como uma ferramenta indispensável para a investigação do fenômeno de punção em ligações laje-pilar. Por se tratar de uma ruína frágil governada por um estado tridimensional e altamente complexo de tensões na vizinhança do apoio, a simulação computacional permite acessar distribuições internas de tensões, deformações na massa de concreto e na armadura, além do desenvolvimento progressivo do dano que seriam de difícil ou impossível instrumentação em ensaios de laboratório.

Como destacado por #prose(<Schimanowski_2025>), embora os estudos experimentais ainda sejam preponderantes, o volume de pesquisas dedicadas à simulação numérica da punção cresceu de forma expressiva na última década. Esse avanço é impulsionado pelo custo marginal reduzido das análises paramétricas em comparação às campanhas físicas, aliado ao desenvolvimento de modelos constitutivos não lineares mais sofisticados e ao aumento da capacidade de processamento computacional.


Nas simulações tridimensionais da ligação laje-pilar via MEF, a representação da não linearidade física do concreto é predominantemente efetuada por meio de modelos contínuos baseados na mecânica do dano e na plasticidade, especialmente o Modelo _Concrete Damaged Plasticity_ (CDP), implementado de forma pioneira e amplamente difundido no código comercial ABAQUS, o CDP combina a plasticidade isotrópica com a degradação de rigidez por dano escalar à compressão ($d_c$) e à tração ($d_t$). 

No trabalho de #prose(<Genikomsou_2015>), o modelo CDP foi rigorosamente calibrado para investigar a punção simétrica em lajes lisas. Foi demonstrado que o comportamento numérico é fortemente sensível ao ângulo de dilatância do concreto ($psi$), ao parâmetro de viscosidade ($mu$) utilizado na regularização viscoplástica para estabilização numérica, e ao modelo de amolecimento por tração. A adoção da lei bilinear de Petersson ancorada na energia de fratura do concreto ($G_F$) provou ser determinante para evitar a dependência excessiva do refinamento da malha.

 Estendendo essa metodologia, #prose(<Milligan_2020>) aplicaram o modelo CDP para avaliar a influência do índice de retangularidade de pilares na resistência e na rotação da laje, evidenciando a concentração heterogênea de tensões cisalhantes nos cantos de apoios alongados. Paralelemante, investigações comparativas entre o modelo CDP (ABAQUS) e o modelo `Cementitious2` do _software_ ATENA — este último baseado na teoria da banda de fissuras (_crack band theory_) com amolecimento exponencial e superfície de plastificação de Menetrey-Willam — demonstraram que ambas as abordagens capturam com precisão a curva carga-deslocamento e a transição do modo de falha com a variação da taxa de armadura longitudinal ($rho$).

Trabalhos como o de #prose(<Gouda_2025>) aplicaram esquemas iterativos de Newton-Raphson para simular o carregamento em etapas (nível de serviço, ciclos de carga e incremento até a ruína) em ligações de borda, avaliando a perda de capacidade resistente decorrente do momento fletor transferido e comparando as estimativas numéricas com as prescrições do ACI 318-19.

Em situações não contempladas pelas normas de projeto convencionais — como lajes apoiadas em pilares em "L" ou de canto reentrante —, simulações tridimensionais via ATENA (empregando elementos sólidos `CSIsoBrick` e elementos de treliça `CCIsoTruss` para o aço) demonstraram excelente capacidade preditiva @albuquerque2015punção. As análises numéricas permitiram mapear os picos de tensão no canto reentrante e validar critérios de convergência baseados no equilíbrio de forças e na energia relativa.



=== Estudos experimentais sobre o comportamento à punção de lajes lisas

A investigação experimental de lajes lisas de concreto armado desempenha um papel indispensável na compreensão dos mecanismos físicos de falha, e no desenvolvimento das formulações normativas. É com base nos resultados experimentais que se analisam padrões, criam-se hipóteses e desenvolvem-se modelos numéricos. Por se tratar de um fenômeno localizado e com elevado grau de triaxialidade de tensões na ligação laje-pilar, a realização de ensaios em escala real ou reduzida permite observar a progressão do dano, perda de rigidez e geometria da superfície de ruína.

Devido às dimensões e complexidade de um pavimento completo, a prática experimental adota a simplificação de isolar a região do pilar delimitada pela linha de momentos fletores nulos. O elemento de ensaio típico consiste em uma laje quadrada ou circular apoiada sobre um trecho de pilar central (_stub column_), estendendo-se superior e inferiormente à laje.

No contexto dos modelos numéricos desenvolvidos na presente pesquisa, adota-se como _benchmark_ a campanha experimental realizada por #prose(<palhares2018>) e #prose(<Lima2021>) no Laboratório de Estruturas da Universidade de Brasília (UnB), com  foco central na eficiência e no tipo de ancoragem da armadura de cisalhamento (estribos fechados em cruz) nas barras de flexão. A laje de referência possui dimensão de $2500 times 2500$ mm, com espessura total de 180 mm e altura útil $d approx 144$ mm, apoiada sobre um pilar central quadrado de $300 times 300$ mm. 

#figure(
  caption: [Esquema do sistema de Ensaios utilizado por Palhares (2018) e Lima (2021).],
  image("../figuras/lima_palhares_laje.png", width: 80%)
)

A tese de #prose(<Lima2021>) englobou o programa experimental completo com 20 lajes lisas, divididas em 5 séries de 4 lajes cada. A dissertação de #prose(<palhares2018>) concentrou-se especificamente nos ensaios e análises detalhadas da Série 3 desse mesmo programa.



Palhares observou que todas as lajes armadas romperam por punção com a superfície de ruptura cortando a região da armadura de cisalhamento. O padrão de fissuração iniciou com fissuras radiais a aproximadamente 25% da carga máxima e fissuras tangenciais a cerca de 70%.

A alteração na ancoragem dos estribos não reduziu a resistência última à punção para a taxa testada ($rho_"sw" approx 0,13%$). A laje com ancoragem apenas na zona comprimida (FS-09) apresentou o melhor desempenho, indicando que estribos que não envolvem totalmente a armadura de flexão são uma opção construtiva viável e segura.

Lima expandiu a verificação para 20 modelos locais, organizados em 5 séries de concretagem. O autor confirmou que a ancoragem dita "parcial" (envolvendo apenas a armadura de flexão comprimida) oferece capacidade resistente igual ou superior à ancoragem completa. Esse resultado é de grande impacto prático, pois simplifica significativamente a montagem e o posicionamento das armaduras no canteiro de obras.

Ainda no contexto do ensaio experimental de punção em lajes lisas, @Barakat_2025 investigou o comportamento de lajes lisas de concreto armado reforçadas com barras não metálicas de polímero reforçado com fibra de vidro (GFRP), com objetivo de avaliar sua influência, junto com a resistência à compressão do concreto e taxa de armadura na rigidez e fissuração das lajes, além de confrontar os resultados experimentais com as previsões de normas internacionais (ACI 440.11-22, JSCE-97 e CAN/CSA S806-12).

#figure(
  caption: [Geometria e reforço para os ensaios realizados por @Barakat_2025],
  image("../figuras/bakarat_slab.png", width: 80%)
)

O autor observou que todas as lajes apresentaram ruptura frágil por punção. A sequência de fissuração iniciou-se com fissuras de flexão (entre 22% e 29% da carga de pico), seguidas por fissuras radiais partindo da face do pilar (entre 38% e 47% da carga) e culminou no surgimento de fissuras circunferenciais na carga máxima, formando o cone de punção característico. Não houve ruptura das barras de GFRP nem esmagamento do concreto à flexão. Também foi observado que o aumento da taxa de armadura de flexão de GFRP de 1,2% para 1,8% elevou a capacidade à punção em 19%, 27% e 24% para os concretos de 30 MPa, 60 MPa e 90 MPa, respectivamente. Ao dobrar a taxa para 2,4%, o aumento na capacidade à punção atingiu 40%, 34% e 37%. Além disso, taxas maiores aumentaram significativamente a rigidez pós-fissuração ($k_p$) e reduziram as flechas no vão. 

Também observou-se que as lajes armadas com aço convencional apresentaram resistência à punção entre 71% e 84% superior às suas correspondentes em GFRP com a mesma taxa (1,2%). Essa diferença decorre do menor módulo de elasticidade do GFRP (um quarto do módulo do aço), o que reduz a ação de pino, eleva a linha neutra e resulta em aberturas de fissuras mais amplas, diminuindo o engrenamento dos agregados.

A norma ACI 440.11-22 mostrou-se excessivamente conservadora (razão média $V_"exp"/V_"pred" = 1,81$), principalmente por penalizar o efeito da rigidez axial em concretos de alta resistência. As normas CAN/CSA S806-12 (média $1,06$) e JSCE-97 (média $1,18$) apresentaram melhor precisão na estimativa da resistência resistente.