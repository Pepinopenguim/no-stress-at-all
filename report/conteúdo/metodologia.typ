
#import "helpers.typ": todo, prose


= Metodologia

A metodologia adotada neste trabalho é organizada em cinco etapas complementares, alinhadas aos objetivos específicos. Inicialmente, define-se um modelo de referência da laje lisa ensaiada por @palhares2018, calibrado com base nas propriedades experimentais dos materiais e comparado aos resultados numéricos de @Palhares_2022. Em seguida, realiza-se um estudo de convergência de malha, variando o tamanho base e o refinamento local na ligação laje-pilar, para definir a discretização adotada nas etapas seguintes. Na terceira etapa, conduz-se uma análise de sensibilidade dos parâmetros do concreto coesivo — $f_t​$, $G_F​$, $ϕ$ e $α$ — sobre a carga de pico, a rigidez e o ramo de amolecimento. A quarta etapa avalia os padrões de fissuração e as tensões na armadura, comparando os resultados numéricos com os mapas experimentais e com as leituras de (_strain gauges_). Por fim, o modelo é estendido para as configurações de armadura de punção ensaiadas por @Lima2021, avaliando a influência do tipo de ancoragem sobre a carga de pico e o modo de ruptura. A análise é realizada no pacote `Serendip`, na linguagem `Julia`, com geração de malha pelo `Gmsh` e pós-processamento no _ParaView_.

== Estratégia geral e etapas da pesquisa

A pesquisa é organizada em cinco etapas, cada uma correspondendo a um dos objetivos específicos apresentados na Introdução. A @tab:rastreabilidade sintetiza essa correspondência, relacionando cada objetivo ao conjunto de casos simulados, às métricas de avaliação, aos critérios de aceitação adotados e às entregas esperadas (figuras e tabelas) na Análise dos Resultados.

#pagebreak()
#rotate(-90deg, reflow: true)[
  #figure(
    caption: [Matriz de rastreabilidade entre objetivos específicos, casos simulados, métricas, critérios e entregas.],
    table(
      columns: (0.4fr, 1.3fr, 1.3fr, 1.4fr, 1.3fr),
      align: (center, left, left, left, left),
      stroke: none,
      inset: 6pt,
      table.hline(),
      table.header(
        [*Obj.*], [Objetivo], [*Casos / variáveis*], [*Métricas*], [*Entrega*],
      ),
      table.hline(stroke: 0.8pt),

      [I],
      [Analisar a influência do refinamento da malha de elementos finitos na convergência das curvas carga-deslocamento.],
      [Malhas M100-R3, M100-R5, M100-R7, M200-R3, M200-R5, M200-R7],
      [
        Curva carga-deslocamento,\
        Carga de Pico $P_(max)$,\
        Rigidez inicial $K_0$,\
        Deslocamento de carga máxima $delta_(P_(max))$,\
        Energia pós-pico,\
        Tempo de processamento],
      [Gráficos de convergência e tabela comparativa],
      table.hline(stroke: 0.4pt),
      
      [II],
      [Comparar os padrões de fissuração numéricos com os observados experimentalmente.],
      [Modelo de referência e variantes selecionadas na etapa II],
      [Mapas de abertura coesiva em pré-pico,pico e pós-pico;\
      Ângulo da fissura diagonal;\
      Geometria do tronco de punção],
      [Mapas de fissuração e comparação com experimentos],
      
      table.hline(stroke: 0.4pt),
      [III],
      [Verificar a distribuição de tensões na armadura e a representação do comportamento de aderência.],
      [Modelo de referência],
      [Tensão axial e de aderência ao longo das barras;\
      Carga de início de escoamento],
      [Campos de tensão],
      
      table.hline(stroke: 0.4pt),
      [IV],
      [Avaliar a sensibilidade dos resultados aos parâmetros do concreto.],
      [Variação de $f_t$, $G_F$, $phi$ e $zeta$ em torno do modelo de referência, mantida a malha escolhida na etapa I],
      [$P_(max)$, $K_0$, $delta_(P_(max))$,\
      Forma do ramo de amolecimento,\
      Sensibilidade normalizada #block(breakable: false)[$S = (Delta R \/ R) \/ (Delta p \/ p)$]],
      [Gráficos de sensibilidade e tabela de ranking],
      table.hline(),
    )
  ) <tab:rastreabilidade>
]


A pesquisa distingue três momentos quanto ao uso dos dados:

+ _Calibração_: Definição do conjunto de parâmetros do modelo de referência a
  partir das propriedades experimentais dos materiais @palhares2018 e das
  diretrizes de #prose(<Durand_2019>) e #prose(<Durand_2021_3D>)#[;]
+ _Validação_: Comparação do modelo calibrado com os resultados experimentais
  de #prose(label("palhares2018")) e #prose(<Lima2021>) e com a simulação numérica de #prose(<Palhares_2022>), sem novo ajuste de parâmetros;
+ _Análise de sensibilidade_: Variação sistemática de parâmetros em torno do modelo calibrado, para identificar sua influência relativa sobre a resposta estrutural.

== Ferramentas computacionais utilizadas

As ferramentas computacionais utilizadas neste trabalho são apresentadas a seguir, abrangendo a linguagem de programação adotada, o pacote de elementos finitos empregado, os recursos para geração de geometria e malha, a integração com bibliotecas geométricas e, por fim, as ferramentas de visualização e inspeção dos resultados.

=== Linguagem de programação Julia

A simulação numérica do presente trabalho é realizada inteiramente no ecossistema da linguagem Julia, uma linguagem dinâmica, de alto nível e multi-paradigma, concebida especificamente para computação científica e numérica, mas com desempenho comparável ao de linguagens estaticamente tipadas como C e Fortran @julia_docs. Seu diferencial reside na combinação de agilidade computacional, obtida por meio de compilação just-in-time (JIT) especializada e inferência de tipos, que geram código de máquina eficiente para cada combinação de tipos de argumentos, com multiple dispatch, um paradigma em que a função a ser executada é escolhida dinamicamente com base no tipo de todos os argumentos, e não apenas no receptor. Esse modelo de despacho permite que um único nome tenha implementações distintas e especializadas para diferentes assinaturas, o que apresenta o Julia como uma linguagem onde a reutilização e a extensibilidade de códigos são extremamente fáceis de serem implantadas, por permitirem novas combinações de tipos para modificar comportamentos existentes, além de permitir que pacotes independentes funcionem imediatamente à importação @Bezanson_2018.

=== Pacote de elementos finitos Serendip

O núcleo da análise é o Serendip, um pacote de elementos finitos escrito na linguagem de programação Julia, que permite ao usuário realizar análises bidimensionais e tridimensionais de problemas estáticos e dinâmicos, sendo atualmente mantido por Raul Durand, docente do curso de Engenharia Civil da Universidade de Brasília (UnB). Seu principal objetivo é oferecer uma plataforma versátil e objetiva para o desenvolvimento de novos algoritmos, tecnologias e modelos para o Método dos Elementos Finitos (MEF) @serendip_github.

=== Geração de geometria e malha com Gmsh

A geração de geometria e de malha é feita com o Gmsh, um gerador tridimensional de malhas de elementos finitos em código aberto, que busca apresentar uma ferramenta rápida, leve e simples de utilizar, com uso de entrada paramétrica e capacidades visuais flexíveis. A ferramenta é separada em quatro módulos — Geometria, Malha, Solucionador e Pós-processamento — que pode ser controlada com uma GUI (graphical user interface), linha de comando e arquivos de script. Além disso, o Gmsh disponibiliza uma API nativa para Julia, o que permite integrar a geração de malhas diretamente ao fluxo de simulação conduzido no Serendip @gmsh_docs.

#figure(
  caption: [Interface gráfica do `gmsh`. Fonte: @featool_gmsh_2017],
  image("../figuras/gmsh_gui.webp", width: 80%)
)

=== Integração com OpenCASCADE Technology (OCCT)

A integração entre essas ferramentas e o Serendip ocorre por meio das APIs disponíveis no ecossistema Julia. O Gmsh oferece uma API nativa em Julia, permitindo que a geometria e a malha sejam geradas de forma programática e importadas diretamente pelo Serendip. Já o OpenCASCADE Technology (OCCT), por ser primordialmente uma biblioteca C++, é acessado por wrappers ou bindings: no ecossistema Julia, existem iniciativas como o pacote OCCT_jll.jl, que fornece binários pré-compilados do OCCT, que podem ser acessados indiretamente por meio do Gmsh.jl, que expõe operações de geometria e fragmentação booleana do OCCT no fluxo de geração de malhas. A literatura científica relata o uso de OCCT como base para frameworks de prototipagem e inspeção de modelos CAD, evidenciando sua aplicabilidade em ferramentas de pesquisa que posteriormente podem ser integradas a diferentes ambientes de programação @slyadnev2017. Dessa forma, o Serendip pode se beneficiar de um kernel geométrico robusto sem depender de implementações nativas em Julia.

=== Visualização e inspeção dos resultados com ParaView

Por fim, a visualização e a inspeção dos resultados de simulação são realizadas no ParaView, uma aplicação de código aberto, multiplataforma e escalável para análise e visualização de dados científicos @paraview_readme, desenvolvida pela Kitware em colaboração com laboratórios como Los Alamos e Sandia, e construída sobre o Visualization Toolkit (VTK) como motor de processamento e renderização. No contexto de arquivos VTU — o formato XML de grade não estruturada do VTK —, o ParaView oferece suporte nativo por meio do XML Unstructured Grid Reader, que lê a extensão padrão .vtu e também séries de arquivos, permitindo carregar geometrias e campos de dados associados (pontos e células) para visualização direta. Na prática científica, isso faz do ParaView a ferramenta padrão para abrir e inspecionar resultados de simulação salvos em .vtu, frequentemente citado como o software de visualização recomendado para esse formato @ahrens2005.

#figure(
  caption: [Interface gráfica do `ParaView`, ilustrando a visualização de uma armadura e de resultados de simulação a título exemplificativo, sem relação com os resultados obtidos neste trabalho.],
  image("../figuras/paraview_gui.jpg", width: 80%)
)

== Objeto de estudo

O objeto de estudo é a laje lisa de referência ensaiada por @palhares2018 e posteriormente modelada numericamente por @Palhares_2022. Trata-se de uma laje quadrada de $2500 times 2500$ mm em planta, com espessura de $180$ mm, apoiada sobre um pilar central de seção quadrada $300 times 300$ mm. O pilar se estende $800$ mm acima e $600$ mm abaixo da laje, conforme as condições do ensaio original.

A armadura de flexão é composta por barras de $16$ mm de diâmetro na face tracionada (inferior) e $10$ mm na face comprimida (superior), espaçadas a $155$ mm em ambas as direções ortogonais, resultando em uma taxa de armadura $rho approx 0.92 percent$. O cobrimento adotado é de $20$ mm. Nas bordas livres, ganchos em "U" de $16$ mm ancoram a armadura superior, impedindo o escorregamento excessivo. A laje não possui armadura de cisalhamento — condição intencional, para isolar o comportamento da punção pura.

O carregamento é aplicado, na simulação, por oito placas de aço de $100 times 100 times 20$ mm, dispostas simetricamente em torno do pilar a uma distância radial de $1124$ mm do centro. No modelo numérico, aproveita-se a simetria dupla da geometria e do carregamento: apenas um quarto da laje é discretizado, com condições de contorno de simetria nos planos $x = 0$ e $y = 0$.

#figure(
  image("../figuras/geometria_base.pdf", width: 80%),
  caption: [Geometria do modelo numérico: quarto de laje com pilar central (cinza escuro) e placas de carregamento (cinza claro).]
) <fig_geometria>

As armaduras foram distribuidas de acordo com o projeto. As barras de reforço de toda a estrutura foram modeladas como treliças no modelo de elementos finitos. 


#import "@preview/cetz:0.5.1"
#figure(
  grid(
    columns: (1fr, 0.65fr),
    gutter: 1em,

    // Left: reinforcement figure
    image("../figuras/bars.pdf", width: 100%),

    // Right: legend
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      let colors = (
        (rgb("#E67E00"), [Reforço superior $phi.alt 16$]),
        (rgb("#B41E2D"), [Reforço inferior $phi.alt 10$]),
        (rgb("#00734B"), [Ganchos em U $phi.alt 16$]),
        (rgb("#005AAA"), [Reforço de Coluna $phi.alt 16$]),
      )

      content((0, 0), [
        *Legenda*
      ], anchor: "west")

      for i in range(colors.len()) {
        let (color, label) = colors.at(i)
        let y = -1.0 - i * 0.6

        line(
          (0, y),
          (0.8, y),
          stroke: (paint: color, thickness: 2pt)
        )

        content(
          (1.1, y),
          label,
          anchor: "west"
        )
      }
    })
  ),
  caption: [Layout do reforço estrutural],
)

== Geração de malha e elementos coesivos

A malha é gerada no `GeoModel` do `Serendip`, que utiliza funções base das bibliotecas `Gmsh.jl` e `OpenCASCADE`, a partir de uma descrição geométrica em blocos e de caminhos de armadura. Realiza-se aqui uma investigação paramétrica restrita a duas variáveis:

- Tamanho base do elemento, $s$;
- Tamanho do elemento na zona de refino, na região de ruptura laje-pilar, $s_r$.

Adotam-se inicialmente $s in {100, 200} "mm"$ e $s_r in {s\/3, s\/5, s\/7}$. Assim, o refino local acompanha o tamanho base e evita que a comparação entre casos misture efeitos de tamanho global e tamanho local. A zona refinada é centrada em $[0, 0, h/2]$ e se estende por $2h$ na vertical. Esse refino é essencial para capturar o gradiente de tensões na região onde o cone de punção se forma.

Após a geração da malha de volume, os elementos coesivos são inseridos entre todos os elementos de volume adjacentes. Conforme a @sec_cohesive_3d, o modelo de @Durand_2021_3D adota uma abordagem discreta para a fratura: os elementos coesivos têm espessura nula e representam a interface potencial entre dois elementos de volume. A fissura só se desenvolve onde o estado de tensões atinge o critério de escoamento do modelo constitutivo coesivo, de modo que a localização da fissura é determinada pela física do problema, não pela topologia da malha. O caso final será escolhido pela melhor relação entre precisão dos resultados — carga de pico, rigidez inicial, queda pós-pico e formação do cone de punção — e tempo de processamento, e não simplesmente pela malha mais refinada.

#figure(
  caption: [Casos de Malhas propostas para o estudo.],
  table(
    columns: (1fr, .5fr, .5fr, .5fr),
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header(
      [Caso],
      [$s$ (mm)],
      [$s_r$ (mm)],
      [Número de Nós],
    ),
    table.hline(stroke: 0.8pt),
    [M100-R3], [100], [$s\/3 = 33.3$], [$approx 33k$],
    [M100-R5], [100], [$s\/5 = 20.0$], [$approx 43k$],
    [M100-R7], [100], [$s\/7 = 14.3$], [$approx 54k$],
    table.hline(stroke: 0.6pt),
    [M200-R3], [200], [$s\/3 = 66.7$], [9057],
    [M200-R5], [200], [$s\/5 = 40.0$], [10401],
    [M200-R7], [200], [$s\/7 = 28.6$], [12947],
    table.hline(),
  )
)

#figure(
  image("../figuras/M200R7.pdf", width: 80%),
  caption: [Malha M200-R7 com refinamento na ligação laje-pilar e inserção de elementos coesivos.]
) <fig_malha>

== Modelos constitutivos

A escolha dos modelos constitutivos adotados na simulação busca representar o comportamento dos materiais, evitando redundâncias numéricas. A filosofia central do modelo de @Durand_2021_3D é concentrar toda a não linearidade do concreto nos elementos coesivos. Dessa forma, o volume de concreto atua apenas transmitindo tensões entre fissuras. Essa separação evita a dupla contagem de não linearidade que ocorreria ao se combinar um modelo de dano contínuo no volume com elementos coesivos na interface. Os modelos e suas respectivas propriedades são detalhados a seguir.

#let Ec = 21.551
#let nu = 0.2
#let ft = 1.8
#let GF = 0.134
#let alpha_c = 5

#let Es1 = 196.9
#let fy1 = 549
#let Es2 = 126.6
#let fy2 = 515

#let Eplate = 900

#let taumax = 13.7
#let taures = 5.5
#let s1 = 1
#let s2 = 1.1
#let s3 = 16
#let alpha_aco = 0.58

=== Concreto (Comportamento Volumétrico)

O volume (_bulk_) de concreto é modelado como elástico linear. Essa escolha segue as recomendações apresentadas por #prose(<Durand_2019>) e #prose(<Durand_2021_3D>), na qual a degradação do material e a propagação de fissuras são tratadas exclusivamente pelos elementos coesivos inseridos nas interfaces. Deste modo, como o problema é predominantemente dominado pela flexão e cisalhamento, assume-se a hipótese que a linearidade do concreto não teria efeito considerável no resultado global. Assim, o volume permanece íntegro e sua resposta mecânica depende apenas do módulo de elasticidade e do coeficiente de Poisson.

#figure(placement: none,
  caption: [Propriedades do concreto de volume.],
  align(center)[
    #table(
      columns: (3),
      align: (center, center, center),
      stroke: none,
      table.hline(),
      table.header([*Parâmetro*], [*Símbolo*], [*Valor*]),
      table.hline(stroke: 0.8pt),
      [Módulo de elasticidade], [$E_c$], [$#Ec$ GPa],
      [Coeficiente de Poisson], [$nu$], [$#nu$],
      table.hline(),
    )
  ]
)<tab_conc_vol>

=== Concreto (Elementos de Interface)
Os elementos coesivos utilizam o critério de Mohr-Coulomb para governar a abertura e o deslizamento das fissuras. Os parâmetros foram calibrados seguindo as diretrizes de @Durand_2019 e @Durand_2021_3D. Adota-se a resistência à tração ($f_t$) e a energia de fratura ($G_F$). A tangente do ângulo de atrito, $tan(55 °)$, é consistente com a faixa experimental de 54° a 57° reportada pelos autores. Por fim, o parâmetro $zeta$ controla os deslocamentos elásticos relativos na interface.

#figure(placement: none,
  caption: [Propriedades do concreto coesivo.],
  align(center)[
    #table(
      columns: (3),
      align: (center, center, center),
      stroke: none,
      table.hline(),
      table.header([*Parâmetro*], [*Símbolo*], [*Valor*]),
      table.hline(stroke: 0.8pt),
      [Resistência à tração], [$f_t$], [$#ft$ MPa],
      [Energia de fratura], [$G_F$], [$#GF$ kN/m],
      [Tangente do ângulo de atrito], [$tan(55°)$], [$approx 1.43$],
      [Fator de deslocamento elástico], [$zeta$], [$#alpha_c$],
      table.hline(),
    )
  ]
)<tab_conc_coes>

=== Armadura
Para as barras de aço, adota-se o critério de Von Mises com elastoplasticidade perfeita. A escolha deste modelo se deve à sua ampla validação para o escoamento de metais dúcteis e à sua simplicidade numérica. A calibração das tensões de escoamento ($f_y$) e dos módulos de elasticidade ($E_s$) foi realizada com base nos valores experimentais reportados por @palhares2018, distinguindo as armaduras de 16 mm e 10 mm.

#figure(placement: none,
  caption: [Propriedades das armaduras.],
  align(center)[
    #table(
      columns: (4),
      align: (center, center, center, center),
      stroke: none,
      table.hline(),
      table.header([*Armadura*], [*Parâmetro*], [*Símbolo*], [*Valor*]),
      table.hline(stroke: 0.8pt),
      table.cell(rowspan: 2)[$phi.alt 16$], [Módulo de elasticidade], [$E_s$], [$#Es1$ GPa],
      [Tensão de escoamento], [$f_y$], [$#fy1$ MPa],
      table.hline(stroke: 0.4pt),
      table.cell(rowspan: 2)[$phi.alt 10$], [Módulo de elasticidade], [$E_s$], [$#Es2$ GPa #footnote[
  O módulo de elasticidade da armadura de $phi.alt 10$ ($E_s = 126.6$ GPa) foi adotado conforme o relatório experimental de @palhares2018 e deve ser confrontado com valores usuais de projeto (~200 GPa) para barras de aço CA-50.
]],
      [Tensão de escoamento], [$f_y$], [$#fy2$ MPa],
      table.hline(),
    )
  ]
)<tab_armadura>


=== Placa de carga
A placa de carga foi modelada como elástica linear com um módulo de elasticidade artificialmente elevado. O objetivo desta escolha é fazer com que a placa se comporte como um corpo rígido, garantindo que a carga aplicada seja distribuída de forma perfeitamente uniforme sobre a superfície do concreto, sem deformações locais significativas que pudessem distorcer os resultados.

#figure(placement: none,
  caption: [Propriedades da placa de carga.],
  align(center)[
    #table(
      columns: (3),
      align: (center, center, center),
      stroke: none,
      table.hline(),
      table.header([*Parâmetro*], [*Símbolo*], [*Valor*]),
      table.hline(stroke: 0.8pt),
      [Módulo de elasticidade], [$E$], [$#Eplate$ GPa],
      table.hline(),
    )
  ]
)<tab_placa>

=== Interface aço-concreto
A interação entre a armadura e o concreto é descrita pelo modelo _CEB bond-slip_ (aderência-deslizamento). Este modelo é escolhido por capturar com precisão as fases de aderência e permitir a recuperação das tensões de aderência ao longo do comprimento de ancoragem. Os parâmetros adotados buscam representar o comportamento de barras nervuradas em condições normais de ancoragem, conforme implementado no pacote Serendip.

#figure(placement: none,
  caption: [Propriedades da interface aço-concreto (CEB bond-slip).],
  align(center)[
    #table(
      columns: (3),
      align: (center, center, center),
      stroke: none,
      table.hline(),
      table.header([*Parâmetro*], [*Símbolo*], [*Valor*]),
      table.hline(stroke: 0.8pt),
      [Tensão máxima de aderência], [$tau_(b max)$], [$#taumax$ MPa],
      [Tensão residual de aderência], [$tau_(b f)$], [$#taures$ MPa],
      [Deslizamento inicial], [$s_1$], [$#s1$ mm],
      [Deslizamento de pico], [$s_2$], [$#s2$ mm],
      [Deslizamento residual], [$s_3$], [$#s3$ mm],
      [Fator de forma], [$alpha$], [$#alpha_aco$],
      table.hline(),
    )
  ]
)<tab_bond_slip>


== Condições de contorno e carregamento

As condições de contorno refletem as condições do ensaio experimental, aplicadas na placas de carregamento, e a simetria do modelo, com deslocamento vertical e paralelo ao eixo de simetria livres. A @fig:cc apresenta as condições de contorno para a geometria apresentada, enquanto a @tab:cc as descreve.

#import "helpers.typ": bc-figure
#figure(
  caption: [Condições de contorno aplicadas no modelo numérico],
  bc-figure(0.006cm)
)<fig:cc>



#figure(placement: none,
  caption: [Condições de contorno e carregamento adotados na simulação.],
  align(center)[
    #table(
      columns: (3),
      align: (center, center, left),
      stroke: none,
      table.hline(),
      table.header(
        [*Região*], [*Condição*], [*Descrição*]
      ),
      table.hline(stroke: 0.8pt),
      
      [Base do pilar], [$u_x = u_y = u_z = 0$], [Apoio fixo, correspondente à fixação do pilar na mesa de ensaio],
      [Topo do pilar ], [$u_x = u_y = 0" "$#footnote[Diferentemente de #prose(<Palhares_2022>), escolheu-se não fixar o topo do pilar em $u_z = 0$ para melhor representar as condições de ensaio. Porém, não se espera que esse fator altere o resultado consideravelmente.]], [Restrição lateral, correspondente ao quadro metálico de reação do ensaio],
      [Planos de simetria], [$u_x = 0$ em $x = 0$ \ $u_y = 0$ em $y = 0$], [Restrição de deslocamento normal aos planos de corte],
      [Placas de carregamento], [$u_z = -25$ mm \ (incremental)], [Deslocamento prescrito nos pontos de controle das placas],
      
      table.hline(),
    )
  ]
)<tab:cc>

Optou-se por controle de deslocamento nas placas de carregamento, para melhor simular os ensaios realizados por @palhares2018 e @Lima2021, com deslocamento incremental de $25$ mm é suficiente para levar a laje à ruptura e capturar o ramo descendente. Diferentemente das simulações realizadas por @Palhares_2022

== Procedimento de Análise Numérica
A análise não linear é conduzida por controle de deslocamento, com deslocamento vertical prescrito de $-25$ mm nos pontos de controle das placas de carregamento, subdividido em $100$ incrementos, com saída de resultados a cada $2$ incrementos (total de $50$ quadros). O processo iterativo adota tolerância de convergência de $1$ kN e controle automático de incremento, fator praticamente necessário para convergência do modelo, de modo que o passo é reduzido caso a convergência não seja atingida dentro do número máximo de iterações e ampliado nas fases de resposta suave. Esses parâmetros foram mantidos idênticos em todas as simulações, de modo que a comparação entre casos reflita apenas a variação das grandezas em estudo.

No processo de iteração do MEF, aplica-se um processo de reaplicação da carga $R(u) = f_"ext" - f_"int"$ como forma de redirecionar a linha de tensão-deformação para um falor mais próximo da realidade. Esse processo é feito ao longo de um `span`de iterações, para não afetar bruscamente o resultado.


== Pós-processamento

O pós-processamento da análise numérica é organizado em três etapas complementares: 
+ Extração e organização dos dados de saída gerados pelo Serendip;
+ Visualização tridimensional dos campos de deslocamento, tensão e dano no ParaView; 
+ Visualização qualitativa do padrão de fissuras, comparação do ângulo do cone de punção com os resultados experimentais e numéricos.
+ Geração dos gráficos de comparação com os resultados experimentais de @palhares2018 e @Lima2021, além dos resultados numéricos obtidos por @Palhares_2022.

= Resultados esperados

Os resultados esperados são organizados segundo os cinco objetivos e se apoiam nos ensaios de @palhares2018 e @Lima2021, nas simulações de @Palhares_2022 e nas diretrizes de modelagem coesiva de @Durand_2019 e @Durand_2021_3D. Eventuais desvios serão discutidos na Análise dos Resultados. A @tab:resumo-esp sintetiza as expectativas ao final da seção.

== Convergência de malha

Espera-se que a rigidez inicial $K_0$ se mostre pouco sensível ao refinamento, uma vez que, na fase elástica, a resposta é governada pelo concreto de volume e pela armadura, cujos elementos apresentam convergência mais rápida do que os elementos coesivos. Espera-se que a carga de pico $P_(max)$ estabilize a partir de determinado refinamento, mas que o deslocamento de pico $delta_(P_(max))$, o ramo de amolecimento e a energia pós-pico permaneçam sensíveis a refinamentos adicionais, comportamento consistente com a literatura de modelos coesivos. A presença do comprimento representativo $h$ no modelo de @Durand_2021_3D deve reduzir, mas não eliminar, essa dependência.

Em termos práticos, espera-se que os casos M200 apresentem custo computacional substancialmente menor, porém com variação do formato das fissuras, isto é, formação de fissuras menos "lineares", enquanto os casos M100 apresentem maior estabilidade nesse quesito. A escolha final deverá recair sobre a malha que concilie convergência das métricas da curva e custo computacional, com preferência pela malha mais grosseira que atenda às tolerâncias.



== Padrões de fissuração

Espera-se que o modelo coesivo reproduza a sequência de fissuração observada
experimentalmente: fissuras radiais de flexão na face tracionada, seguidas
de fissuras circunferenciais e, por fim, da fissura diagonal que define o
tronco de punção. Diferentemente da abordagem contínua de @Palhares_2022,
que representa o dano de forma distribuída, espera-se que o modelo coesivo
capture a fissura diagonal como descontinuidade explícita, permitindo
identificar sua localização, orientação e extensão.

Espera-se que o ângulo do tronco de punção se situe na faixa tipicamente
observada em lajes lisas sem armadura de cisalhamento (aproximadamente
$25 degree$ a $45 degree$ em relação à face inferior da laje), e que a
geometria do cone formado numericamente seja comparável à observada nos
ensaios de @palhares2018 e @Lima2021. Espera-se, ainda, que a comparação
com os mapas de @Palhares_2022 evidencie a vantagem do modelo coesivo em
representar a descontinuidade, ainda que a resposta global seja semelhante.

== Tensões na armadura
Espera-se que o modelo capture o escoamento da armadura de flexão nas regiões próximas ao pilar, consistente com o comportamento observado nos ensaios de @palhares2018, em que a armadura inferior atinge o escoamento antes da ruptura por punção. Espera-se que os campos de tensão de aderência ao longo das barras apresentem concentração nas proximidades do pilar, compatível com o efeito de ancoragem e com o efeito pino, e que a perda de aderência se manifeste nas regiões onde a fissuração radial é mais intensa.

A comparação com as leituras dos (_strain gauges_) deverá indicar se o modelo reproduz qualitativamente a distribuição de tensões axiais, ainda que quantitativamente possa haver desvios decorrentes da idealização da interface aço-concreto. Espera-se, também, concordância qualitativa com os resultados de #prose(<Palhares_2022>), que utilizou modelo de aderência equivalente no ABAQUS.

== Sensibilidade dos parâmetros do concreto

Espera-se que $f_t$ e $G_F$ exerçam influência dominante sobre a resposta, com $f_t$ controlando o início da fissuração e não-linearidade da análise, por determinar o início da fissuração e $G_F$ controlando o ramo de amolecimento e a energia pós-pico. Espera-se que o ângulo de atrito $phi$ apresente influência secundária sobre $P_(max)$, com efeito mais perceptível no modo misto, em que a componente de atrito contribui para a transmissão de esforços na interface coesiva. Espera-se, por fim, que $zeta$ apresente influência na rigidez inicial do problema, atuando sobretudo nos deslocamentos elásticos relativos na interface'. Assim, expectativa é que $f_t$ apresente os impactos significativos nos resultados, seguido por $G_F$, $phi$ e então, $zeta$, com $G_F$ assumindo a liderança quando se considera a energia pós-pico. Os parâmetros identificados como dominantes deverão ser objeto de calibração cuidadosa na etapa de validação; os demais podem ser fixados nos valores de referência sem prejuízo significativo.

== Síntese

A @tab:resumo-esp sintetiza as expectativas por objetivo, com uma indicação
do grau de confiança e da base principal de cada hipótese.

#figure(
  caption: [Síntese dos resultados esperados por objetivo específico.],
  table(
    columns: (0.3fr, 2fr, 1.6fr),
    align: (center, left, center, left),
    stroke: none,
    inset: 6pt,
    table.hline(),
    table.header(
      [*Obj.*], [*Resultado esperado*], [*Base principal*],
    ),
    table.hline(stroke: 0.8pt),

    [I],
    [$K_0$ pouco sensível ao refinamento; $P_(max)$ estável a partir de
     R5; pós-pico e energia sensíveis ao refinamento],
    [Teoria de modelos coesivos; @Durand_2021_3D],

    table.hline(stroke: 0.4pt),

    [II],
    [Fissura diagonal explícita, com ângulo entre $25 degree$ e
     $45 degree$; sequência de fissuração coerente com os ensaios],
    [@palhares2018; @Lima2021; @Palhares_2022],
    table.hline(stroke: 0.4pt),

    [III],
    [Escoamento da armadura próximo ao pilar; concentração de aderência;
     perda de aderência em regiões fissuradas],
    [@palhares2018; @Palhares_2022],

    table.hline(stroke: 0.4pt),

    [IV],
    [$f_t$ e $G_F$ dominantes; $phi$ secundário; $ζ$ de baixa
     influência sobre a resposta global],
    [@Durand_2019; @Durand_2021_3D],
    
    table.hline(),
  )
) <tab:resumo-esp>

== Limitações esperadas


Entre as limitações reconhecidas do modelo, adota-se comportamento volumétrico simplificado em compressão, cujo efeito esperado é mínimo, e considera-se o concreto como homogêneo e isotrópico, hipótese clássica e inerente ao MEF. A fissuração é restrita aos elementos coesivos, de modo que o volume permanece contínuo e sem dano distribuído, enquanto as armaduras são representadas por elementos de barra, sem consideração explícita do efeito de pino; alternativamente, elementos de viga poderiam ser empregados para capturar esse mecanismo, sob o risco de possível aumento articial da rigidez.

Do ponto de vista constitutivo e paramétrico, o modelo fib adotado é simplificado e não considera a variação das tensões confinantes, aspecto que pode ter impacto mais relevante na resposta. Além disso, os parâmetros sugeridos são provenientes de ensaios sem confinamento, e a resistência à tração e demais variáveis foram obtidas da literatura, e não de calibração específica para o caso em estudo.