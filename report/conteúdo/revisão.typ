// #import "/utils/todo.typ": TODO
#import "helpers.typ": todo
= Revisão bibliográfica

== Referencial Teórico

O presente capítulo apresenta uma revisão atualizada do contexto atual da engenharia estrutural no que se refere à punção de lajes lisas. Depois, será apresentada uma introdução básica ao método dos elementos finitos, focada em aspectos interessantes para o caso simulado. Por fim, serão observados os modelos matemáticos utilizados na simulação.

=== Punção em Lajes Lisas

As lajes lisas são sistemas estruturais laminares apoiados exclusivamente por pilares @albuquerque2015punção. O acúmulo de esforços e tensões, especialmente em torno da conexão laje-pila, causa uma região de grande potencial de ruptura. De acordo com @melges1995, o acúmulo de tensões nessa região pode ser extremo a ponto da ruptura ocorrer antes do escoamento do aço, caracterizando uma ruptura frágil. 

Apesar disso, a conveniência na sua execução justifica seu uso, especialmente em função da: supressão de vigas, que simplifica a execução em obra do concreto armado, obtendo-se uma execução mais ágil do projeto, redução de formas, além da economia de materiais e mão de obra; redução do pé-direito, fator que aumenta o número de pavimentos a serem executados para uma mesma altura; Simplificação do projeto de ventilação, iluminação e resistência à incêndios, por diminuição dos obstáculos e assim, concentração de calor @palhares2018.

A ruptura por punção é um evento potencialmente catastrófico: por ocorrer de forma frágil, sem aviso prévio, pode desencadear o colapso progressivo da estrutura, uma vez que a redistribuição de esforços resultante é direcionada a regiões que não foram dimensionadas para absorvê-la. Casos históricos incluem o colapso parcial do edifício Pipers Row Multi-Storey Car Park (Reino Unido, 1997) e do Skyline Plaza (EUA, 1973), ambos associados a falhas em ligações laje-pilar @palhares2018.

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
    Fonte: (a) Sagban et al. (2019); (b) Donini (2016).
  ]
)


==== Mecânica da ruptura por punção

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

==== Modos de ruptura e fissuração

A fissuração de lajes lisas submetidas à punção segue uma sequência característica. As primeiras fissuras a surgir são as radiais, que partem do contorno do pilar em direção às bordas da laje; elas marcam o fim da fase elástica do comportamento e o início da não linearidade global @melges1995. Com o aumento do carregamento, o padrão radial se intensifica. Apenas nos estágios finais, imediatamente antes da ruptura, surgem as fissuras tangenciais, que delimitam o contorno do cone de punção @regan1981.

// #figure(
//   image("../figuras/fissuracao_radial_tangencial.png", width: 70%),
//   caption: [Padrão de fissuração: fissuras radiais (fase inicial) e tangenciais (imediatamente antes da ruptura). #todo[substituir por figura própria ou adaptada de @melges1995]]
// ) <fig_fissuracao>

A depender da taxa de armadura de flexão e das condições de contorno, três modos de ruptura podem ser identificados: *Punção pura:* ruptura frágil, sem escoamento da armadura de flexão, com formação clara do tronco de cone; *Flexo-punção:* ruptura mista, em que parte da armadura de flexão escoa antes do colapso, conferindo alguma ductilidade; *Flexão pura:* ruptura dúctil, com ampla fissuração, típica de lajes com baixa taxa de armadura de flexão.

Para o caso de lajes lisas usuais, a punção pura é o modo predominante e o mais crítico, por ocorrer subitamente @Sacramento_2012.



==== Parâmetros que influenciam na resistência à punção

===== Resistência à compressão do concreto
===== Taxa de armadura de flexão
===== Geometria e dimensão do pilar
===== Efeito de escala (size effect)
===== Armadura de cisalhamento

=== O Método dos Elementos Finitos (MEF)

#todo[Após realizar algumas simulações, revisar este texto para descrever partes do processo de elementos finitos que causaram problema / são interessantes.]


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

Para representar o amolecimento da fratura, isto é, a translação da @esc_f para a esquerda, ao longo do eixo $sigma_n$, em relação à abertura da fissura $u_p$, os autores utilizaram a seguinte curva, definida @Hordijk1992. que relaciona a abertura de tração com a tensão máxima do modelo:

#figure(
  image("../figuras/amolecimento_hordjark.png", width: 80%),
  caption: [Curva de amolecimento de Hordijk #todo[revisar necessidade de mudar imagem]] 
) <hordijk>

#figure(
  image("../figuras/amolecimento_modelo.png"),
  caption: [Função de Escoamento (a) $u_p = 0$, (b) $u_c > u_p > 0$, (c) $u_p = u_c$ #todo[revisar necessidade de mudar imagem]]
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

==== O modelo 3D de Durand & Silva

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

*Runge-Kutta (Método de Ralston):* Em vez de avaliar a matriz de rigidez global $bold(K)$ apenas no início de cada incremento, o método de Ralston faz duas avaliações: uma no início ($bold(K)_1 = bold(K)(bold(U)^n)$) e outra em um ponto intermediário do incremento ($bold(K)_2 = bold(K)(bold(U)^n + 2/3 Delta bold(U))$). A matriz de rigidez final é uma média ponderada:

$
  tilde(bold(K)) = 1/4 bold(K)_1 + 3/4 bold(K)_2
$

Essa aproximação melhora significativamente a acurácia da solução e reduz o número de iterações necessárias para a convergência.

*Passo Automático (Automatic Stepping):* O tamanho do incremento de carga $Delta T$ é ajustado dinamicamente com base no erro de truncamento $e r r = norm(Delta bold(F)_"ext" - Delta bold(F)_"int")$. Se o incremento converge com sucesso, o passo é aumentado; se falha, é reduzido. O fator de escala $q$ é definido como:

$
  q = (1 + tanh(log_10 (t o l) / (e r r)))
$

O novo passo é calculado como $Delta T^(n+1) = q Delta T^n$, com limites para evitar passos muito pequenos ($0.2$) ou muito grandes ($0.9$). Essa técnica permite que a análise avance de forma eficiente nas regiões estáveis e desacelere automaticamente próximo ao pico de carga e no ramo de amolecimento.


// aplicação

O modelo 3D foi validado por @Durand_2021_3D por meio de ensaios de tração e cisalhamento puros (patch tests) e, posteriormente, aplicado à simulação de experimentos clássicos da literatura, como vigas entalhadas submetidas à torção e placas com duplo entalhe em modo misto. Os resultados demonstraram boa concordância com as curvas experimentais de carga-CMOD, incluindo o ramo de amolecimento, e padrões de fissuração compatíveis com os observados experimentalmente.

É importante destacar que o modelo 3D apresenta uma limitação em relação ao tipo de elemento de volume utilizado: @Durand_2021_3D observaram que elementos hexaédricos interferem no desenvolvimento das fissuras, tendendo a aumentar a carga de pico ou gerar múltiplas fissuras em regiões onde se esperava apenas uma. Por outro lado, elementos tetraédricos e piramidais proporcionaram padrões de fissuração mais realistas. Essa observação é particularmente relevante para o presente trabalho, pois a escolha do tipo de elemento de volume na malha da laje influenciará diretamente a qualidade dos resultados da simulação de punção.

==== Interface barra-sólido

// problema de compatibilidade malha entre aço e concreto

// elemento de interface contínuo

// modelo cíclico de bond slip

// restrição de ponta

// Aplicação

==== Fib bond-Slip

A característica essencial do concreto armado está na contribuição do aço para a resistência do concreto, especialmente na tração. No caso de punção de lajes lisas, a flexão 

== Estado da Arte

=== Cenário atual da modelagem numérica de punção

=== Simulação de punção via CDPM: O modelo de Palhares et al. (2022)
