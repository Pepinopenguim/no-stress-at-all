#import "helpers.typ": todo, prose



= Introdução

    A falha por punção é um dos estados limites mais recorrentes em estruturas tradicionais de concreto armado, especialmente em lajes lisas. Seu comportamento é caracterizado pela concentração de cargas e reações em uma região de pequena área, em torno do pilar, que leva ao desenvolvimento de altos esforços de cisalhamento e alto risco de ruptura repentina.

    Apesar disso, a adoção de lajes lisas, sistemas estruturais laminares apoiados diretamente em pilares, sem o auxílio de vigas, em estruturas cotidianas se provou um grande facilitador durante a fase de execução da obra, em função de um tempo de armação e concretagem reduzido, além da simplificação na aplicação de revestimento @Junior_2021. Essas economias provam-se suficientes para justificar a maior minuciosidade no cálculo, que prova-se muitas vezes de difícil previsibilidade. 

    Uma das principais formas de se abordar o problema, portanto, está na análise numérica, tradicionalmente realizada por meio do Método dos Elementos Finitos (MEF). O MEF consiste na discretização do domínio contínuo em um conjunto de elementos interconectados por nós, sobre os quais se aplicam as equações constitutivas e as condições de contorno do problema. Essa abordagem permite aproximar a solução de problemas estruturais complexos, cujas soluções analíticas são inviáveis ou inexistentes, possibilitando a avaliação de tensões, deformações e deslocamentos em regiões críticas. No contexto da punção em lajes lisas, o MEF se destaca por permitir a análise do estado tridimensional de tensões na ligação laje-pilar e a simulação de diferentes cenários de carregamento e configurações geométricas, complementando os ensaios experimentais, que, embora fundamentais, apresentam elevado custo e limitações de escala. 
    
    Contudo, a precisão dos resultados numéricos está diretamente condicionada à escolha do modelo constitutivo, ao tipo de elemento finito e à qualidade da malha adotada, aspectos que serão discutidos ao longo deste trabalho.

== Objetivos <sec:objetivos>

  A presente pesquisa busca modelar numericamente experimentos sob efeitos de ruptura de punção por meio do Método dos Elementos Finitos, com a utilização de elementos coesivos. O objetivo central da pesquisa será analisar a eficiência do método, assim como definir parâmetros para o auxílio de simulações posteriores.

  A simulação será realizada pela linguagem de programação _julia_, por meio do pacote _Serendip_. Os resultados obtidos serão diretamente comparados com as simulações realizadas por #prose(<Palhares_2022>), que utilizou o software _ABAQUS/CDPM_ para analisar o mesmo caso, assim como os resultados experimentais obtidos pelos ensaios de #prose(<Lima2021>).

  Para que o objetivo central seja atingido de forma sistemática, define-se a pesquisa em cinco objetivos específicos, denominados pela @tab:resumo-objs:

#figure(
  caption: [Objetivos específicos da presente pesquisa],
  table(
  columns: (0.8fr, 2fr, 3fr),
  align: (center, left, left),
  inset: 8pt,
  stroke: none,
  table.hline(),
  table.header(
    [*Objetivo*],
    [*Aspecto Analisado*],
    [*Finalidade*],
  ),
  table.hline(),

  [I],
  [Refinamento da malha de elementos finitos],
  [Avaliar a sensibilidade dos resultados ao tamanho dos elementos, verificando a convergência da curva carga-deslocamento, da carga de pico e do deslocamento correspondente.],table.hline(stroke: 0.8pt),

  [II],
  [Padrões de fissuração],
  [Verificar a capacidade do modelo em reproduzir a evolução das fissuras, a localização da fissura diagonal e a geometria do tronco de punção, comparando os resultados numéricos e experimentais.],
  table.hline(stroke: 0.8pt),

  [III],
  [Tensões na armadura],
  [Avaliar a distribuição de tensões axiais e de aderência nas barras, verificando a representação do escoamento do aço e da perda de aderência nas proximidades do pilar.],
  table.hline(stroke: 0.8pt),

  [IV],
  [Parâmetros do concreto],
  [Investigar a influência da resistência à tração ($f_t$), energia de fratura ($G_F$), ângulo de atrito ($phi$) e parâmetro ($zeta$), identificando os parâmetros mais relevantes para a resposta estrutural.],
  
  table.hline(),
)
) <tab:resumo-objs>

== Justificativa

A ruptura por punção em lajes lisas é um fenômeno complexo, cuja previsão numérica representa um desafio devido à não linearidade do concreto e ao estado tridimensional de tensões na ligação laje-pilar. Nesse contexto, os elementos coesivos apresentam-se como uma alternativa aos modelos tradicionais de dano contínuo, permitindo representar explicitamente a formação e a propagação de fissuras, bem como o comportamento pós-ruptura. Associada à formulação de interface barra-sólido, essa abordagem também possibilita representar a interação entre armadura e concreto sem a necessidade de compatibilização das malhas @Durand_2021.

Além disso, a modelagem numérica permite ampliar a investigação de diferentes configurações estruturais, reduzindo a dependência de ensaios experimentais, que apresentam custos elevados.

Dessa forma, esta pesquisa busca avaliar a capacidade dos elementos coesivos de reproduzir o comportamento de lajes lisas submetidas à punção simétrica, considerando a resposta estrutural, a convergência numérica, a influência dos parâmetros constitutivos e a interação entre armadura e concreto. Espera-se contribuir para o aprimoramento da modelagem numérica e da previsão da resistência de ligações laje-pilar.