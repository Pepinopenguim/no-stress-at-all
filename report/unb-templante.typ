#import "@preview/cetz:0.4.1"


// ❱❱❱ Logo UnB
#let logo = cetz.canvas({
    import cetz.draw: *

    let half = {
        let bzr = ((0, 1.84), (2,0.9), (1.3,0.817), (1.55, 0.92))

        merge-path(fill: blue.darken(30%), stroke:0pt, {
            bezier(..bzr)
            line((), (2,2), (0,2), (0,1.84))
        })

        let bzr = bzr.map( pt => (pt.at(0), pt.at(1)-0.12))
        bzr.at(0).at(1) = 1.7

        merge-path(fill: green.darken(30%), stroke:0pt, {
            bezier(..bzr)
            line((), (2,0), (0,0), (0,1.7) )
        })
    }

    half
    set-origin((4.12, 0))
    scale(x:-1)
    half
})


// ❱❱❱ Função principal do template
#let relatório(
    lingua: "pt",
    título: "Título",
    subtítulo: auto,
    tipo: auto,
    programa: none,
    departamento: none,
    faculdade: none,
    orientador: none,
    coorientador: none,
    membros-internos: (),
    membros-externos: (),
    autor: none,
    nivel: none,
    ano: none,
    resumo-ing: none,
    resumo-pt: none,
    agradecimentos: none,
    publicação: "G.TD-",
    data: datetime(day:1, month:1, year:2024),
    bibliografia: none,
    estilo: none,
    corpo,
) = {

    set page(
        paper: "a4",
        margin: (top:25mm, bottom:25mm, left:25mm, right:25mm),
        header: context {
        },

    )

    show outline: set block(above: 1.2em)
    show outline.entry.where(level: 1): set block(above: 1.5em)

    show outline: it => {
        show heading: set align(center)
        show heading: h => upper(h)
        it
    }
    
    let tipo = tipo
    assert(tipo in ("Tese", "Dissertação", "TCC", "Seminário"),
        message: "O tipo deve ser 'Tese', 'Dissertação', 'TCC' ou 'Seminário'.")

    [
        #place(box(scale(logo, x:211mm, y:120mm, reflow:true)), dx:-25mm, dy:-25mm)
        #place(rect(width: 211mm, height: 100mm, fill:blue.darken(30%)), dx:-25mm, dy:175mm)

        #v(10.5cm)

        #align(center, upper(text(size:19pt, weight:"bold")[
            #título
        ]))

        #v(7mm)

        #align(center, upper(text(size:16pt, weight:"bold")[
            #autor
        ]))

        #v(7mm)

        #align(center, upper(text(size:16pt, weight: "bold")[
            #subtítulo \
            #departamento
        ]))

        // #v(5cm)
        #v(1fr)

        #align(center, upper(text(size:20pt, weight: "bold")[
            #faculdade
        ]))
        #v(2mm)
        #align(center, upper(text(size:24pt, weight: "bold")[
            UNIVERSIDADE DE BRASÍLIA
        ]))
        #v(0cm)
    ]

    
    pagebreak(weak:true)

    // ❱❱❱ Folha de rosto
    
    align(center, upper(text(size:14pt, weight:"bold")[
        UNIVERSIDADE DE BRASÍLIA \
        FACULDADE DE TECNOLOGIA \
        DEPARTAMENTO DE ENGENHARIA CIVIL E AMBIENTAL 
    ]))

    v(4cm)

    align(center, upper(text(size:18pt, weight:"bold")[
        #título
    ]))

    v(3cm)
    
    align(center, upper(text(size:18pt, weight:"bold")[
        #autor
    ]))

    v(2cm)

    align(center, upper(text(size:18pt, weight:"regular")[
        ORIENTADOR: #orientador
    ]))

    v(2cm)

    align(center, upper(text(size:14pt)[
        #subtítulo \
        PUBLICAÇÃO: #publicação
    ]))
    
    v(1cm)

    align(center, upper(text(size:14pt)[
        BRASÍLIA/DF: #data.month()/#data.year()
    ]))

    pagebreak()


    if tipo in ("Dissertação", "Dissertation", "Tese", "Thesis") {

        // ❱❱❱ Folha de assinaturas

        align(center, upper(text(size:14pt, weight:"bold")[
            UNIVERSIDADE DE BRASÍLIA \
            FACULDADE DE TECNOLOGIA \
            DEPARTAMENTO DE ENGENHARIA CIVIL E AMBIENTAL 
        ]))

        v(8mm)

        align(center, upper(text(size:14pt, weight:"regular")[
            #título
        ]))

        v(8mm)
        
        align(center, upper(text(size:18pt, weight:"bold")[
            #autor
        ]))

        v(1cm)

        par(justify: true,
        upper(text(size:13pt)[
            #tipo SUBMETIDA AO DEPARTAMENTO DE ENGENHARIA
            CIVIL E AMBIENTAL DA FACULDADE DE TECNOLOGIA DA UNIVERSIDADE DE
            BRASÍLIA COMO PARTE DOS REQUISITOS NECESSÁRIOS PARA A OBTENÇÃO
            DO GRAU DE DOUTOR.
        ]))

        v(0.5cm)

        upper(text(size:12pt)[
            APROVADA POR:
            #v(1cm)
            #line(length: 50%)
            #orientador \
            (Orientador) \
            #v(5mm)
            #if coorientador != none [
                #line(length: 50%)
                #coorientador \
                (Coorientador) \
                #v(5mm)
            ]
            
            #for membro in membros-internos [
                #line(length: 50%)
                #membro \
                (Examinador Interno) \
                #v(5mm)
            ]

            #for membro in membros-externos [
                #line(length: 50%)
                #membro \
                (Examinador Externo) \
                #v(5mm)
            ]
        ])

        v(1cm)

        align(center, upper(text(size:14pt)[
            DATA: BRASÍLIA/DF, #data.day()/#data.month()/#data.year()
        ]))


        pagebreak()

        // ❱❱❱ Ficha catalográfica
        align(center, upper(text(size:18pt, weight:"bold")[
            FICHA CATALOGRÁFICA
        ]))
        pagebreak()
        // ❱❱❱ Dedicatoria
        pagebreak()
        // ❱❱❱ Agradecimentos
        pagebreak()
        // ❱❱❱ Resumo em português
        pagebreak()
        // ❱❱❱ Abstract in English
        pagebreak()
        // ❱❱❱ Sumário
        pagebreak()
        // ❱❱❱ Lista de Figuras
        pagebreak()
        // ❱❱❱ Lista de Tabelas
        pagebreak()
        // ❱❱❱ Lista de Abreviaturas e Siglas
        pagebreak()
    } else {
        //  ❱❱❱ Sumário
        outline(title: "Sumário", )
        pagebreak()
    }


    set page(
    header: context {
    },
    footer: context [
        #set align(right)
        #counter(page).display(
        "1/1",
        both: true,
        )
    ],
    )

    set text(size: 12pt)
    set par(leading: 0.8em, first-line-indent: (amount:2em), justify: true )
    counter(page).update(1)
    set heading(numbering: "1.1.", supplement: "Seção")
    show heading: it => {
        if it.level == 1 { return it }
        block(sticky: true)[
            #set text(size:13pt)
            #v(0.8em)
            // set block(spacing: 1em)
            #it
            #v(0.8em)
        ]
    }

    show heading.where(level:1): it => { 
        pagebreak(weak: true)
        counter(math.equation).update(0)
        counter(figure.where(kind: image)).update(0)
        counter(figure.where(kind: table)).update(0)
        counter(figure.where(kind: raw)).update(0)

        block(sticky: true)[
            #set text(14pt, weight:"bold")
            #let num = counter(heading).display()
            #if it.numbering==none { upper(it.body) } else {
                upper[#num~#upper(it.body)]
            }
            #v(0.5em)
        ] 
    }

    set math.equation(supplement: "Eq.",numbering: num =>
        numbering("(1.1)", counter(heading).get().first(), num)
    )

    show figure.where(kind: table): set figure(supplement: "Tabela")
    show figure.where(kind: table): set figure.caption(position: top)
    show figure.where(kind: image): set figure(supplement: "Figura")

    set figure(numbering: num =>
        numbering("1.1", counter(heading).get().first(), num)
    )

    corpo

    // ❱❱❱ Bibliografia
    // set heading(numbering: none)
    show heading.where(level:1): it => { 
        it 
    }
    bibliography(bibliografia, style: estilo, title: "Referências Bibliográficas")
}


// ❱❱❱ Função para apêndices e anexos
#let adendos(corpo) = {
    counter(heading).update( (0, 0) )
    set heading(numbering: "A.1.", supplement: "Apêndice")
    corpo
}

