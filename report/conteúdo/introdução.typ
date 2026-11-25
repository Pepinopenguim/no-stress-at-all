#import "helpers.typ": todo, prose



= Introdução

    A falha por punção é um dos estados limites mais recorrentes em estruturas tradicionais de concreto armado, especialmente em lajes lisas. Seu comportamento é caracterizado pela concentração de cargas e reações em uma região de pequena área, em torno do pilar, que leva ao desenvolvimento de altos esforços de cisalhamento e alto risco de ruptura repentina.

    Apesar disso, a adoção de lajes lisas, sistemas estruturais laminares apoiados diretamente em pilares, sem o auxílio de vigas, em estruturas cotidianas se provou um grande facilitador durante a fase de execução da obra, em função de um tempo de armação e concretagem reduzido, além da simplificação na aplicação de revestimento @Junior_2021. Essas economias provam-se suficientes para justificar a maior minuciosidade no cálculo, que prova-se muitas vezes de difícil previsibilidade. 

    Uma das principais formas de se abordar o problema, portanto, está na análise numérica, tradicionalmente realizada por meio do Método dos Elementos Finitos (MEF). O MEF consiste na discretização do domínio contínuo em um conjunto de elementos interconectados por nós, sobre os quais se aplicam as equações constitutivas e as condições de contorno do problema. Essa abordagem permite aproximar a solução de problemas estruturais complexos, cujas soluções analíticas são inviáveis ou inexistentes, possibilitando a avaliação de tensões, deformações e deslocamentos em regiões críticas. No contexto da punção em lajes lisas, o MEF se destaca por permitir a análise do estado tridimensional de tensões na ligação laje-pilar e a simulação de diferentes cenários de carregamento e configurações geométricas, complementando os ensaios experimentais, que, embora fundamentais, apresentam elevado custo e limitações de escala. 
    
    Contudo, a precisão dos resultados numéricos está diretamente condicionada à escolha do modelo constitutivo, ao tipo de elemento finito e à qualidade da malha adotada, aspectos que serão discutidos ao longo deste trabalho.

== Objetivos

  A presente pesquisa busca modelar numericamente experimentos sob efeitos de ruptura de punção por meio do Método dos Elementos Finitos, com a utilização de elementos coesivos. O objetivo central da pesquisa será analisar a eficiência do método, assim como definir parâmetros para o auxílio de simulações posteriores.

  A simulação será realizada pela linguagem de programação _julia_, por meio do pacote _Serendip_. Os resultados obtidos serão diretamente comparados com as simulações realizadas por @Palhares_2022, que utilizou o software _ABAQUS/CDPM_ para analisar o mesmo caso, assim como os resultados experimentais obtidos pelos ensaios de @Lima2021.

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
  [Investigar a influência da resistência à tração ($f_t$), energia de fratura ($G_F$), ângulo de atrito ($phi$) e parâmetro ($alpha$), identificando os parâmetros mais relevantes para a resposta estrutural.],
  
  table.hline(),
)
) <tab:resumo-objs>

== Justificativa

  A ruptura por punção em lajes lisas é um evento potencialmente catastrófico para a estabilidade local e global da estrutura, além de apresentar comportamento analiticamente complexo de se definir. Deste modo, o estudo desse fenômeno vêm crescendo no âmbito acadêmico, especialmente com a utilização de elementos finitos @Schimanowski_2025, como forma de se analisar o comportamento e a resistência estrutural do parâmetro. Porém, realizar uma análise numérica precisa é um desafio significativo, em função da não linearidade natural ao problema e à complexidade do estado tridimensional de tensões na região de ligação laje-pilar.

  Nesse contexto, os modelos tradicionais de dano contínuo, embora amplamente utilizados, apresentam uma alta dependência à malha utilizada e dificuldade na representação de deformações discretas (fissuras). A utilização de elementos coesivos surge como uma outra abordagem para o problema, ao simular a rigidez (e sua eventual perda) na interface entre elementos sólidos. Isso traz uma forma natural de observar o desenvolvimento e propagação de fissuras além de possibilitar a visualização do processo de fraturamento e do comportamento pós-ruptura da estrutura.  Uma das vantagens dessa abordagem é a possibilidade de acompanhar a evolução da fratura como uma descontinuidade explícita, permitindo analisar a sequência de fissuração e a formação de superfícies de ruptura, como o tronco de punção. Adicionalmente, a solução numérica proposta não apresenta necessidade de compatibilizar a malha na formulação de interface barra-sólido @Durand_2021, o que viabiliza uma modelagem eficiente da aderência e deslizamento entre armadura e concreto.

  Essa formulação também permite recuperar as distribuições de tensões axiais e de tensões de aderência ao longo das barras, possibilitando avaliar o comportamento da armadura de flexão, incluindo a ocorrência de escoamento e eventual perda de aderência nas regiões próximas ao pilar. Essa análise é relevante para a previsão da resistência à punção, uma vez que a contribuição da armadura está associada, entre outros fatores, aos efeitos de pino e de ancoragem.

Apesar da incorporação de um comprimento representativo $h$ no modelo de #prose(<Durand_2021_3D>), com o objetivo de reduzir a dependência dos resultados em relação ao tamanho dos elementos, a sensibilidade da formulação à discretização ainda precisa ser verificada para o caso particular da punção. A avaliação da influência do refinamento da malha na região da ligação laje-pilar é, portanto, importante para verificar a convergência dos resultados de carga e deslocamento e identificar condições de discretização que proporcionem resultados estáveis. Além disso, os parâmetros constitutivos do modelo coesivo, como a resistência à tração do concreto (ft), a energia de fratura (GF), o ângulo de atrito (φ) e o parâmetro α, responsável pelos deslocamentos elásticos relativos, podem exercer diferentes influências sobre a resposta estrutural. As particularidades da punção em lajes lisas, especialmente o estado triaxial de tensões na região de ligação e a predominância de modos mistos de fratura, justificam a investigação da sensibilidade desses parâmetros, de modo a identificar sua influência sobre a carga de pico e o comportamento do ramo de amolecimento.

  Outro fator central no estudo da punção é o custo elevado da análise experimental. Ensaios de punção exigem volumes significativos de concreto, armaduras de reforço em quantidade considerável, mão de obra especializada e maquinário de grande porte, como pórticos de reação, macacos hidráulicos e sistemas de aquisição de dados. A um só ensaio, somam-se ainda os custos de instrumentação, moldagem, cura e transporte, o que torna a campanha experimental economicamente inviável para a exploração sistemática de parâmetros. Nesse contexto, um modelo numérico de boa acurácia representa uma economia substancial, por permitir substituir parte dos ensaios por simulações, além de viabilizar estudos paramétricos extensos (variação de geometria, armadura, resistência do concreto) e auxiliar no planejamento de campanhas experimentais, ao indicar previamente os cenários mais críticos e as faixas de carga de interesse.

  O modelo numérico permite uma vasta customização. A partir da laje de referência de @palhares2018, podem-se explorar sistematicamente variações na geometria, na taxa e no arranjo da armadura de flexão, na resistência do concreto e, sobretudo, nas configurações de armadura de cisalhamento, como o número de camadas, espaçamento e, em particular, o tipo de ancoragem na armadura de flexão, que é justamente o objeto dos ensaios de @Lima2021. A avaliação dessas configurações também permite investigar a influência da ancoragem da armadura de punção na transferência de esforços e na eficiência do reforço, verificando a capacidade do modelo em reproduzir os acréscimos de resistência e as alterações no modo de ruptura observados experimentalmente. Além disso, o modelo permite investigar cenários que a campanha experimental não cobriu, como carregamentos assimétricos, aberturas próximas ao pilar e lajes com mais de um vão, ampliando o escopo de aplicação dos resultados para situações reais de projeto. Dessa forma, o modelo numérico não substitui os ensaios, mas os complementa e estende, permitindo que os achados experimentais sejam generalizados para um conjunto mais amplo de configurações estruturais com um custo computacional marginal.

  Deste modo, a presente pesquisa se justifica pela necessidade de avaliar a capacidade desses elementos coesivos em reproduzir com fidelidade o comportamento experimental de uma laje lisa submetida à punção. Essa avaliação envolve não apenas a previsão da resposta global da estrutura, mas também a convergência numérica, a influência dos parâmetros constitutivos, a reprodução dos padrões de fissuração e a representação da interação entre armadura e concreto. Espera-se, com isso, contribuir para o avanço das técnicas de modelagem numérica de estruturas de concreto, fornecendo uma ferramenta mais realista para a previsão de modos de falha e dimensionamento seguro de ligações laje-pilar.

