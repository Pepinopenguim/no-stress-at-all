#import "helpers.typ": todo


= Introdução

    A falha por punção é um dos estados limites mais recorrentes em estruturas de concreto armado, ocorrendo principalmente em conexões laje-pilar. Seu comportamento é complexo, de difícil previsibilidade, o que apresenta um grande desafio na engenharia estrutural.

    Uma das principais formas de se abordar o tema 

== Objetivos

    A presente pesquisa busca realizar a análise numérica de uma laje lisa sob efeitos de ruptura de punção por meio do Método dos Elementos Finitos, com a utilização de elementos coesivos de junta. O objetivo central da pesquisa será analisar a eficiciência do método, assim como definir parâmetros para o auxílio de simulações posteriores.

    A simulação será realizada pela linguagem de programação _julia_, por meio do pacote _Serendip_, desenvolvido por #todo[Durant et al]. Os resultados obtidos serão diretamente comparados com as simulações realizadas por @de_Azevedo_Palhares_2022, que utilizou o software _ABAQUS/CDPM_ para analisar o mesmo caso, assim como os resultados experimentais obtidos pelos ensaios de @Lima2021.

== Justificativa

    A ruptura por punção em lajes lisas é um evento potencialmente catastrófico para a estabilidade local e global da estrutura, além de apresentar comportamento analiticamente complexo de se definir. Deste modo, o estudo desse fenômeno vêm crescendo no âmbito acadêmico, especialmente com a utilização de elementos finitos @Schimanowski_2025, como forma de se analisar o comportamento e a resistência estrutural do parâmetro. Porém, realizar uma análise numérica precisa é um desafio significativo, em função da não linearidade natural ao problema e à complexidade do estado tridimensional de tensões na região de ligação laje-pilar.

    Nesse contexto, os modelos tradicionais de dano contínuo, embora amplamente utilizados, apresentam uma alta dependência à malha utilizada e dificuldade na representação de deformações discretas (fissuras). A utlização de elementos coesivos surge como uma outra abordagem para o problema, ao simular a rigidez (e sua eventual perda) na interface entre elementos sólidos. Isso traz uma forma natural de observar o desenvolvimento e propagação de fissuras além de possibilitar a visualização do processo de fraturamento e do comportamento pós-ruptura da estrutura. Adicionalmente, a solução numérica proposta não apresenta necessidade de compatibilizar a malha na formulação de interface barra-sólido @Durand_2021, o que viabiliza uma modelagem eficiente da aderência e deslizamento entre armadura e concreto.

    Deste modo, a presente pesquisa se justifica pela necessidade de avaliar a capacidade desses elementos coesivos em reproduzir com fidelidade o comportamento experimental de uma laje lisa submetida à punção. Espera-se, com isso, contribuir para o avanço das técnicas de modelagem numérica de estruturas de concreto, fornecendo uma ferramenta mais realista para a previsão de modos de falha e dimensionamento seguro de ligações laje-pilar.

