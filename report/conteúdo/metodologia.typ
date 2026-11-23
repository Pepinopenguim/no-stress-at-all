
#import "helpers.typ": todo


= Metodologia

A metodologia adotada neste trabalho consiste em uma análise numérica comparativa entre o modelo de elementos finitos coesivos implementado no pacote `Serendip` (linguagem de programação Julia) e os resultados experimentais de @palhares2018 e @Lima2021, bem como os resultados numéricos de @Palhares_2022 obtidos via CDPM no ABAQUS. A estratégia é paramétrica: a partir de um modelo de referência calibrado, variam-se sistematicamente parâmetros de aderência e de resistência do aço para avaliar a sensibilidade dos resultados.

A análise numérica computacional traz benefícios consideráveis referentes ao custo e tempo associados a ensaios de punção em laje, especialmente para as dimensões apresentadas. Há, ainda, a possibilidade de isolar o efeito de cada parâmetro individualmente, o que é inviável experimentalmente. Por meio da disponibilidade de dados experimentais de alta qualidade (@palhares2018; @Lima2021), será possível realizar um benchmark de validação do modelo de forma eficiente.


== Ferramentas computacionais utilizadas

A simulação numérica do presente trabalho é realizada inteiramente no ecossistema da linguagem Julia, uma linguagem dinâmica, de alto nível e multi-paradigma, concebida especificamente para computação científica e numérica, mas com desempenho comparável ao de linguagens estaticamente tipadas como C e Fortran @julia_docs. Seu diferencial reside na combinação de agilidade computacional, obtida por meio de compilação just-in-time (JIT) especializada e inferência de tipos, que geram código de máquina eficiente para cada combinação de tipos de argumentos, com multiple dispatch, um paradigma em que a função a ser executada é escolhida dinamicamente com base no tipo de todos os argumentos, e não apenas no receptor. Esse modelo de despacho permite que um único nome tenha implementações distintas e especializadas para diferentes assinaturas, o que apresenta o Julia como uma linguagem onde a reutilização e a extensibilidade de códigos são extremamente fáceis de serem implantadas, por permitirem novas combinações de tipos para modificar comportamentos existentes, além de permitir que pacotes independentes funcionem imediatamente à importação @Bezanson_2018.

O núcleo da análise é o Serendip, um pacote de elementos finitos escrito na linguagem de programação Julia, que permite ao usuário realizar análises bidimensionais e tridimensionais de problemas estáticos e dinâmicos, sendo atualmente mantido por Raul Durand, docente do curso de Engenharia Civil da Universidade de Brasília (UnB). Seu principal objetivo é oferecer uma plataforma versátil e objetiva para o desenvolvimento de novos algoritmos, tecnologias e modelos para o Método dos Elementos Finitos (MEF) @serendip_github.

A geração de geometria e de malha é feita com o Gmsh, um gerador tridimensional de malhas de elementos finitos em código aberto, que busca apresentar uma ferramenta rápida, leve e simples de utilizar, com uso de entrada paramétrica e capacidades visuais flexíveis. A ferramenta é separada em quatro módulos — geometria, malha, solucionador e pós-processamento — que pode ser controlada com uma GUI (graphical user interface), linha de comando e arquivos de script. Além disso, o Gmsh disponibiliza uma API nativa para Julia, o que permite integrar a geração de malhas diretamente ao fluxo de simulação conduzido no Serendip @gmsh_docs.

A integração entre essas ferramentas e o Serendip ocorre por meio das APIs disponíveis no ecossistema Julia. O Gmsh oferece uma API nativa em Julia, permitindo que a geometria e a malha sejam geradas de forma programática e importadas diretamente pelo Serendip. Já o OpenCASCADE Technology (OCCT), por ser primordialmente uma biblioteca C++, é acessado por wrappers ou bindings: no ecossistema Julia, existem iniciativas como o pacote OCCT_jll.jl, que fornece binários pré-compilados do OCCT, e muitos usuários acessam funcionalidades do OpenCASCADE indiretamente por meio do Gmsh.jl, que expõe operações de geometria e fragmentação booleana do OCCT no fluxo de geração de malhas. A literatura científica relata o uso de OCCT como base para frameworks de prototipagem e inspeção de modelos CAD, evidenciando sua aplicabilidade em ferramentas de pesquisa que posteriormente podem ser integradas a diferentes ambientes de programação @slyadnev2017. Dessa forma, o Serendip pode se beneficiar de um kernel geométrico robusto sem depender de implementações nativas em Julia.

Por fim, a visualização e a inspeção dos resultados de simulação são realizadas no ParaView, uma aplicação de código aberto, multiplataforma e escalável para análise e visualização de dados científicos @paraview_readme, desenvolvida pela Kitware em colaboração com laboratórios como Los Alamos e Sandia, e construída sobre o Visualization Toolkit (VTK) como motor de processamento e renderização. No contexto de arquivos VTU — o formato XML de grade não estruturada do VTK —, o ParaView oferece suporte nativo por meio do XML Unstructured Grid Reader, que lê a extensão padrão .vtu e também séries de arquivos, permitindo carregar geometrias e campos de dados associados (pontos e células) para visualização direta. Na prática científica, isso faz do ParaView a ferramenta padrão para abrir e inspecionar resultados de simulação salvos em .vtu, frequentemente citado como o software de visualização recomendado para esse formato @ahrens2005.


== Objeto de estudo

O objeto de estudo é a laje lisa de referência ensaiada por @palhares2018 e posteriormente modelada numericamente por @Palhares_2022. Trata-se de uma laje quadrada de $2500 times 2500$ mm em planta, com espessura de $180$ mm, apoiada sobre um pilar central de seção quadrada $300 times 300$ mm. O pilar se estende $800$ mm acima e $600$ mm abaixo da laje, conforme as condições do ensaio original.

A armadura de flexão é composta por barras de $16$ mm de diâmetro na face tracionada (inferior) e $10$ mm na face comprimida (superior), espaçadas a $155$ mm em ambas as direções ortogonais, resultando em uma taxa de armadura $rho approx 0.92 percent$. O cobrimento adotado é de $20$ mm. Nas bordas livres, ganchos em "U" de $16$ mm ancoram a armadura superior, impedindo o escorregamento excessivo. A laje não possui armadura de cisalhamento — condição intencional, para isolar o comportamento da punção pura.

O carregamento é aplicado, na simulação, por oito placas de aço de $100 times 100 times 20$ mm, dispostas simetricamente em torno do pilar a uma distância radial de $1124$ mm do centro. No modelo numérico, aproveita-se a simetria dupla da geometria e do carregamento: apenas um quarto da laje é discretizado, com condições de contorno de simetria nos planos $x = 0$ e $y = 0$.

#figure(
  image("../figuras/geometria_base.pdf", width: 80%),
  caption: [Geometria do modelo numérico: quarto de laje com pilar central (cinza escuro) e placas de carregamento (cinza claro).]
) <fig_geometria>

As armaduras foram distribuidas de acordo com o projeto. Para melhor representar o comportamento das barras durante a ruptura de punção, especialmente o efeito pino, as barras de reforço da laje foram modeladas como vigas no modelo de elementos finitos. As barras restantes, dos pilares, foram dimensionadas como barras, para economia computacional. 


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
  caption: [asdf],
  table(
    columns: 5,
    align: (center, center, center, center, center),
    stroke: none,
    table.hline(),
    table.header(
      [Caso],
      [$s$ (mm)],
      [$s_r$ (mm)],
      [Número de Nós],
      [Papel no estudo],
    ),
    table.hline(stroke: 0.8pt),
    [M100-R3], [100], [$s\/3 = 33.3$], [$approx 33k$], table.cell(rowspan: 3)[#todo()[asdf]],
    [M100-R5], [100], [$s\/5 = 20.0$], [$approx 43k$],
    [M100-R7], [100], [$s\/7 = 14.3$], [$approx 54k$],
    table.hline(stroke: 0.6pt),
    [M200-R3], [200], [$s\/3 = 66.7$], [9057], table.cell(rowspan: 3)[#todo()[asdf]],
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

=== Concreto (Volume)

O concreto de volume é modelado como elástico linear. Essa escolha segue as recomendações apresentadas por @Durand_2019 e @Durand_2021_3D, na qual a degradação do material e a propagação de fissuras são tratadas exclusivamente pelos elementos coesivos inseridos nas interfaces. Deste modo, como o problema é predominantemente dominado pela flexão e cisalhamento, assume-se a hipótese que a linearidade do concreto não teria efeito considerável no resultado global. Assim, o volume permanece íntegro e sua resposta mecânica depende apenas do módulo de elasticidade e do coeficiente de Poisson.

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

=== Concreto (Coesivo)
Os elementos coesivos utilizam o critério de Mohr-Coulomb para governar a abertura e o deslizamento das fissuras. Os parâmetros foram calibrados seguindo as diretrizes de @Durand_2019 e @Durand_2021_3D. Adota-se a resistência à tração ($f_t$) e a energia de fratura ($G_F$). A tangente do ângulo de atrito ($tan(55 °)$) é consistente com a faixa experimental de 54° a 57° reportada pelos autores. Por fim, o parâmetro $alpha$ controla os deslocamentos elásticos relativos na interface.

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
      [Fator de deslocamento elástico], [$alpha$], [$#alpha_c$],
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
      table.cell(rowspan: 2)[$phi.alt 10$], [Módulo de elasticidade], [$E_s$], [$#Es2$ GPa],
      [Tensão de escoamento], [$f_y$], [$#fy2$ MPa],
      table.hline(),
    )
  ]
)<tab_armadura>

=== Placa de carga
A placa de carga foi modelada como **elástica linear** com um módulo de elasticidade artificialmente elevado. O objetivo desta escolha é fazer com que a placa se comporte como um corpo rígido, garantindo que a carga aplicada seja distribuída de forma perfeitamente uniforme sobre a superfície do concreto, sem deformações locais significativas que pudessem distorcer os resultados.

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
      [Topo do pilar ], [$u_x = u_y = 0$], [Restrição lateral, correspondente ao quadro metálico de reação do ensaio],
      [Planos de simetria], [$u_x = 0$ em $x = 0$ \ $u_y = 0$ em $y = 0$], [Restrição de deslocamento normal aos planos de corte],
      [Placas de carregamento], [$u_z = -25$ mm \ (incremental)], [Deslocamento prescrito nos pontos de controle das placas],
      
      table.hline(),
    )
  ]
)<tab:cc>

Optou-se por controle de deslocamento nas placas de carregamento, para melhor simular os ensaios realizados por @palhares2018 e @Lima2021, com deslocamento incremental de $25$ mm é suficiente para levar a laje à ruptura e capturar o ramo descendente. Diferentemente das simulações realizadas por @Palhares_2022


== Pós-processamento

Os resultados são extraídos em três níveis:

1. *Curva carga-deslocamento global*: soma das reações nos pontos de carregamento, multiplicada por quatro para reconstituir a carga total, versus o deslocamento vertical médio em pontos equidistantes das bordas da laje (LVDTs $L_01$, $L_06$, $L_07$ e $L_12$ no ensaio original).
2. *Campos de dano e fissuração*: distribuição da variável de dano escalar $d$ nos elementos coesivos, permitindo visualizar a formação do cone de punção e comparar com os mapas de fissuração experimentais.
3. *Tensões na armadura*: distribuição de tensões axiais nas barras de flexão e na armadura de cisalhamento, para verificar se há escoamento e comparar com as leituras dos extensômetros do ensaio.

A comparação com @Palhares_2022 é feita em duas frentes: (i) a curva carga-deslocamento, que permite avaliar a acurácia global; e (ii) o padrão de fissuração, que permite avaliar a capacidade de o modelo coesivo capturar a fissura discreta diagonal, algo que o CDPM não consegue representar explicitamente.

// #figure(
//   image("../figuras/pos_processamento.png", width: 80%),
//   caption: [Exemplo de pós-processamento: curva carga-deslocamento e campos de dano. #todo[substituir por figura própria]]
// ) <fig_pos_processamento>
// 
#todo[incluir imagem]