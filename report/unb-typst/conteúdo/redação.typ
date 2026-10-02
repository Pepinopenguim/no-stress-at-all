= Redação científica

A redação científica é a modalidade de escrita formal e técnica utilizada para comunicar, de maneira clara, precisa, objetiva e imparcial, os processos, resultados e discussões de uma pesquisa. Mais do que um mero relato, trata-se da principal ferramenta para a disseminação do conhecimento.

Antes de redigir um trabalho científico, o pesquisador deve ter o _pleno conhecimento_ do conteúdo que será apresentado. Isto pode ser desdobrado em três níveis de profundidade:

+ *Domínio da própria pesquisa*: O autor deve conhecer detalhadamente a metodologia, os resultados, limitações e conclusões do seu trabalho.  
+ *Conhecimento do estado da arte*: O autor deve estar familiarizado com os principais trabalhos relacionados ao tema, compreendendo as contribuições, lacunas e debates existentes na área.  
+ *Contextualização ampla*: O autor deve entender o contexto mais amplo em que a pesquisa está inserida, incluindo implicações práticas, sociais e éticas.  

== Características do texto científico

A escrita de texto científico deve seguir algumas características fundamentais que garantem a clareza, precisão e objetividade da comunicação. As principais características são:

- Impessoalidade
- Objetividade
- Coerência e coesão textual
- Clareza e precisão
- Sinteticidade

== Equações

As expressões matemáticas podem ser do tipo #emph[inline] e #[display]. 
A expressões #emph[inline] aparecem ao longo do texto. Já as expressões do tipo #emph[display] são destacadas, ocupando uma linha inteira e centralizadas.
Por exemplo, $F = m a$ é uma equação #emph[inline]. Já a seguinte equação é do tipo #emph[display]:
$
    ∫_(-1)^(+1) f(x) dif x 
    ≈ ∑_(i=1)^n f(x_i) w_i
$<eq:quadratura>
onde, $f$ é a função a ser integrada numericamente, $n$ é o número de pontos de integração, $x_i$ são os pontos de integração e $w_i$ os pesos associados.

Deve se observar que as equações #emph[display] são também parte integrante da frase, não devendo ser isoladas do parágrafo em que estão inseridas. Além disso, uma equação numerada nunca deve ser citada sem que tenha sido apresentada anteriormente no texto.


As equaçães #emph[inline] são digitadas entre caracteres `$$`. Já as equações do tipo #emph[display] são digitadas entre caracteres `$ $` garantindo espaço após o primeiro `$` e antes do último `$`.

Para referenciar equações, é necessário atribuir uma etiqueta a cada equação que se deseja referenciar. A etiqueta é definida logo após a equação, entre caracteres `< >`. Para citar a equação, utiliza-se o símbolo `@` seguido da etiqueta. Por exemplo, a @eq:quadratura é uma fórmula de quadratura numérica.

== Tabelas e figuras

Tabelas e figuras são elementos flutuantes na estrutura do texto. Isto é, elas podem ser posicionadas em locais diferentes do texto, dependendo do espaço disponível e da estética do documento. Diferentemente das equações, as tabelas e figuras não são parte de um parágrafo, mas sim elementos independentes que complementam o texto.

As tabelas são criadas usando as funções `figure` e `table`.
A função `figure` é usada para definir o elemento flutuante, incluindo a numeração e a legenda. Já a função `table` é usada para definir o conteúdo e formatação da tabela, incluindo as colunas, linhas e células.
As figuras são etiquetadas usando `< >` após a definição da figura.
Para referenciar a tabela, utiliza-se o símbolo `@` seguido da etiqueta. Por exemplo, a @tab:modelos apresenta as características dos modelos numéricos utilizados numa pesquisa. 

#figure(placement:none,
  caption: [Características dos modelos numéricos utilizados.], 
  align(center)[
    #table(
       columns: (4),
       align: (center, center, center, center),
       stroke: none,
       table.hline(),
       table.header(
         [*Modelo*], [*Elementos*], [*Nós*], [*DOFs*]
       ),
       table.hline(stroke: 0.8pt),
       [M1], [1808], [5432], [10864],
       [M2], [1808], [5432], [10864],
       [M3], [2108], [8432], [16864],
       [M4], [2108], [8432], [16864],
       table.hline(),
    )
  ]
)<tab:modelos>


As figuras com são criadas também usando a função `figure` para incluir a numeração e a legenda.
As figuras são etiquetadas e citadas da mesma forma que as tabelas.
Por exemplo, a @fig:tração-separação apresenta as curvas de tração-separação para concreto segundo o modelo de Hordijk (1991) e um modelo bilinear simplificado.

#figure(
    caption: [Função de tração-separação para concreto, segundo o modelo de #cite(<hordijk:91>, form:"prose") e um modelo bilinear simplificado.],
    [
        #import "@preview/lilaq:0.5.0" as lq
        #let wc = 3
        #let x = lq.linspace(0, wc*1.0)
        #let ft = 2.4 // MPa
        #let hordijk(w) = ft*( (1 + 27*calc.pow(w/wc,3))*calc.exp(-6.93*w/wc) - 28*(w/wc)*calc.exp(-6.93) )
        #let x-bl = (0, 0.15*wc, wc) 
        #let y-bl = (ft, 0.25*ft, 0)

        #set text(size: 10pt)
        #lq.diagram(
            width: 7cm, height: 4.5cm,
            xaxis: (subticks:none),
            yaxis: (subticks:none),
            xlabel: [$w$ [mm]],
            ylabel: [$σ_n$ [MPa]],
            lq.plot(x, hordijk, color:red, mark:none, label:[Modelo de Hordijk]),
            lq.plot(x-bl, y-bl, color:blue, mark:none, label:[Modelo bilinear]),
        )
    ]
)<fig:tração-separação>

== Citações e bibliografia

Para elaborar a bibliografia, é necessário criar um arquivo (`.bib`) com as referências bibliográficas.
Cada referência bibliográfica corresponde a um item no arquivo `.bib`, que deve seguir o formato BibTeX.
Para usar o estilo de citação de acordo com as normas da ABNT, é preciso incorporar o arquivo de estilo `.csl` correspondente no documento principal. A ABNT não fornece oficialmente um arquivo `.csl`.
Contudo, existem arquivos `.csl` criados por terceiros que seguem as normas da ABNT.


As citações são inseridas no texto utilizando a sequência `@chave`, onde `chave` é o identificador da publicação no arquivo `.bib`. Também é possível citar utilizando o comando `#cite()`, que permite formatar a citação. 
Por exemplo, a citação @zienkiewicz:95  faz uso da sintaxe `@chave`.
Já a citação -- #cite(<cundall:79>, form:"prose") -- utiliza o comando `#cite()`, que permite formatar a citação de forma
a integrá-la ao texto.

