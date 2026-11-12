
#import "helpers.typ": todo


= Metodologia

A metodologia adotada neste trabalho consiste em uma análise numérica comparativa entre o modelo de elementos finitos coesivos implementado no pacote `Serendip` (linguagem de programação Julia) e os resultados experimentais de @palhares2018 e @Lima2021, bem como os resultados numéricos de @Palhares_2022 obtidos via CDPM no ABAQUS. A estratégia é paramétrica: a partir de um modelo de referência calibrado, variam-se sistematicamente parâmetros de aderência e de resistência do aço para avaliar a sensibilidade dos resultados.

A análise numérica computacional traz benefícios consideráveis referentes ao custo e tempo associados a ensaios de punção em laje, especialmente para as dimensões apresentadas. Há, ainda, a possibilidade de isolar o efeito de cada parâmetro individualmente, o que é inviável experimentalmente. Por meio da disponibilidade de dados experimentais de alta qualidade (@palhares2018; @Lima2021), será possível realizar um benchmark de validação do modelo de forma eficiente.

== Objeto de estudo

O objeto de estudo é a laje lisa de referência ensaiada por @palhares2018 e posteriormente modelada numericamente por @Palhares_2022. Trata-se de uma laje quadrada de $2500 times 2500$ mm em planta, com espessura de $180$ mm, apoiada sobre um pilar central de seção quadrada $300 times 300$ mm. O pilar se estende $800$ mm acima e $600$ mm abaixo da laje, conforme as condições do ensaio original.

A armadura de flexão é composta por barras de $16$ mm de diâmetro na face tracionada (inferior) e $10$ mm na face comprimida (superior), espaçadas a $155$ mm em ambas as direções ortogonais, resultando em uma taxa de armadura $rho approx 0.92 percent$. O cobrimento adotado é de $20$ mm. Nas bordas livres, ganchos em "U" de $16$ mm ancoram a armadura superior, impedindo o escorregamento excessivo. A laje não possui armadura de cisalhamento — condição intencional, para isolar o comportamento da punção pura.

O carregamento é aplicado por oito placas de aço de $100 times 100 times 20$ mm, dispostas simetricamente em torno do pilar a uma distância radial de $1124$ mm do centro. No modelo numérico, aproveita-se a simetria dupla da geometria e do carregamento: apenas um quarto da laje é discretizado, com condições de contorno de simetria nos planos $x = 0$ e $y = 0$.

#figure(
  image("../figuras/geometria_base.png", width: 80%),
  caption: [Geometria do modelo numérico: quarto de laje com pilar central e placas de carregamento. #todo[melhorar aparência da figura]]
) <fig_geometria>

== Geração de malha e elementos coesivos

A malha é gerada no `GeoModel` do `Serendip` a partir de uma descrição geométrica em blocos (slab, column, loadPlate) e de caminhos de armadura (barras de flexão, ganchos em U, armadura do pilar). Utiliza-se um tamanho de elemento base de $200$ mm, refinado localmente na região da ligação laje-pilar por meio da função `set_refinement`, com tamanho interno de aproximadamente $67$ mm ($200/3$) na zona de influência do pilar. Esse refinamento é essencial para capturar o gradiente de tensões na região onde o cone de punção se forma.

Após a geração da malha de volume, os *elementos coesivos* são inseridos entre todos os elementos de volume adjacentes, por meio do algoritmo `add_cohesive_elements`. Conforme discutido na Seção 2.1.4.2, o modelo de @Durand_2021_3D adota uma abordagem *discreta* para a fratura: os elementos coesivos têm espessura nula e representam a interface potencial entre dois elementos de volume. A fissura só se desenvolve onde o estado de tensões atinge o critério de escoamento do modelo constitutivo coesivo, de modo que a localização da fissura é determinada pela física do problema, não pela topologia da malha.

// #figure(
//   image("../figuras/malha_refinada.png", width: 80%),
//   caption: [Malha de elementos finitos com refinamento na região da ligação laje-pilar e inserção de elementos coesivos. #todo[substituir por figura própria]]
// ) <fig_malha>

#todo[incluir imagem da malha refinada]

== Modelos constitutivos

A Tabela @tab_materiais resume os modelos constitutivos e parâmetros adotados para cada material. A escolha de manter o concreto de volume como linear elástico é justificada pela filosofia do modelo de @Durand_2021_3D: toda a não linearidade do concreto (fissuração e amolecimento) é concentrada nos elementos coesivos, enquanto o volume apenas transmite tensões entre fissuras. Essa separação evita a dupla contagem de não linearidade que ocorreria ao se combinar CDPM no volume com elementos coesivos na interface.

#figure(
  table(
    columns: 4,
    align: center,
    stroke: 0.5pt,
    [*Material*], [*Modelo constitutivo*], [*Parâmetros*], [*Valores*],
    [Concreto (volume)], [Elástico linear], [$E$; $nu$], [$21.551$ GPa; $0.2$],
    [Concreto (coesivo)], [Mohr-Coulomb], [$f_t$; $G_F$; $mu$; $alpha$], [$1.8$ MPa; $0.134$ kN/m; $tan(55 degree)$; $5$],
    [Armadura $phi 16$], [Von Mises], [$E_s$; $f_y$], [$196.9$ GPa; $549$ MPa],
    [Armadura $phi 10$], [Von Mises], [$E_s$; $f_y$], [$126.6$ GPa; $515$ MPa],
    [Placa de carga], [Elástico linear], [$E$], [$900$ GPa],
    [Interface aço-concreto], [CEB bond-slip], [$tau_(b max)$; $tau_(b f)$; $s_1$; $s_2$; $s_3$; $alpha$], [$13.7$ MPa; $5.5$ MPa; $1$ mm; $1.1$ mm; $16$ mm; $0.58$],
  ),
  caption: [Modelos constitutivos e parâmetros adotados na simulação. #todo[melhorar aparência da tabela]]
) <tab_materiais>

Os parâmetros do concreto coesivo seguem @Durand_2019 e @Durand_2021_3D: $f_t = 1.8$ MPa (resistência à tração), $G_F = 0.134$ kN/m (energia de fratura), $tan(phi) = tan(55 degree) approx 1.43$ (tangente do ângulo de atrito, consistente com a faixa experimental de $54 degree$ a $57 degree$ reportada pelos autores) e $alpha = 5$ (fator de controle dos deslocamentos elásticos relativos).

Para a armadura, adota-se o critério de Von Mises com elastoplasticidade perfeita, calibrado com os valores experimentais de @palhares2018: $f_y = 549$ MPa para as barras de $16$ mm e $f_y = 515$ MPa para as barras de $10$ mm. A placa de carga é modelada como elástica linear com módulo de $900$ GPa, de modo a se comportar como um corpo rígido e distribuir uniformemente a carga aplicada.

== Modelo de aderência aço-concreto

A interface entre armadura e concreto é simulada pelo *elemento de interface contínuo barra-sólido* de @Durand_2021, discutido na Seção 2.1.4.3. Para o comportamento constitutivo, adota-se o *envelope monotônico do fib Model Code 2020* (Seção 20.5.1), que é suficiente para o carregamento monotônico do ensaio. A curva é definida pelos parâmetros $tau_(b max)$, $tau_(b f)$, $s_1$, $s_2$, $s_3$ e $alpha$, conforme a Figura @fib_bond_slip.

Os valores adotados são baseados nas recomendações do fib MC2020 para o *modo de ruptura por splitting* (Seção 20.5.1, Tabela 20.5-1), uma vez que o cobrimento de $20$ mm é inferior a $5 phi$ (situação típica de lajes lisas com armadura passante). Adotou-se $tau_(b max) = 13.7$ MPa, $tau_(b f) = 5.5$ MPa, $s_1 = 1$ mm, $s_2 = 1.1$ mm, $s_3 = 16$ mm e $alpha = 0.58$, valores calibrados a partir das prescrições do código para o concreto da laje ($f_(c m) approx 30$ MPa) e o diâmetro das barras.

// #figure(
//   image("../figuras/bond_slip.png", width: 70%),
//   caption: [Envelope monotônico do bond-slip adotado, conforme fib Model Code 2020. #todo[substituir por figura própria]]
// ) <fig_bond_slip>

#todo[incluir imagem]

A rigidez tangente inicial da interface é calculada como $k_s = 2 tau_(b max) / s_1$, seguindo a formulação de @Durand_2021, e a rigidez normal é adotada como $k_n = 150 k_s$, valor de penalidade suficiente para impedir a penetração da barra no concreto sem causar condicionamento excessivo do sistema.

== Condições de contorno e carregamento

As condições de contorno refletem as condições do ensaio experimental e a simetria do modelo:

- *Base do pilar* ($z = -600$ mm): deslocamentos $u_x = u_y = u_z = 0$ (apoio fixo, correspondente à fixação do pilar na mesa de ensaio).
- *Topo do pilar* ($z = 800 + 180 = 980$ mm): $u_x = u_y = 0$ (restrição lateral, correspondente ao quadro metálico de reação do ensaio).
- *Planos de simetria*: $u_x = 0$ em $x = 0$ e $u_y = 0$ em $y = 0$.
- *Carregamento*: deslocamento prescrito de $-25$ mm em $z$ nos pontos de controle das placas, aplicado de forma incremental.

Optou-se por *controle de deslocamento* em vez de controle de força, pois a resposta pós-pico da punção apresenta amolecimento acentuado (queda abrupta de carga). Com controle de força, o método de Newton-Raphson não conseguiria atravessar o ponto limite. O deslocamento de $25$ mm é suficiente para levar a laje à ruptura e capturar o ramo descendente.

== Estratégia de solução não-linear

A análise é realizada com o `MechAnalysis` do `Serendip`, que implementa o método de Newton-Raphson com *passo automático* (Seção 2.1.4.2, Eq. 2.16) e correção de deriva. Os parâmetros de controle são:

- Número máximo de incrementos: $100$.
- Número de saídas: $50$.
- Tolerância de convergência: $1$ kN no resíduo de forças.

A escolha do passo automático é particularmente importante para o problema de punção, pois a rigidez global sofre variações bruscas quando a fissura diagonal se propaga: próximo ao pico de carga, incrementos muito grandes causam divergência; incrementos muito pequenos tornam a análise proibitivamente cara. O passo automático ajusta $Delta T$ dinamicamente com base no erro de truncamento, permitindo atravessar o pico e capturar o ramo de amolecimento.

== Estudo paramétrico
#todo[definir processo de estudo paramétrico]

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