
= Cronograma

O cronograma é parte essencial do planejamento, pois distribui as etapas da pesquisa no tempo e garante viabilidade prática.
A pesquisa deve ser dividida em fases ou atividades, indicando prazos de início e término, dependências entre etapas e eventuais tarefas que podem ser realizadas em paralelo.
O cronograma pode ser apresentado em forma de tabela ou gráfico de Gantt (@tab:cronograma), facilitando a visualização do plano de trabalho.

#figure(kind:table, placement: none, caption: [Exemplo de cronograma em formato de gráfico de Gantt.], [
    #import "@preview/timeliney:0.4.0"
    #set text(size: 8pt)
    #timeliney.timeline(
    show-grid: true,
    spacing: 4pt,
    line-style: ( stroke: 4pt + red),
    grid-style: ( stroke: ( dash: "dashed", thickness: 0.3pt, paint: luma(66.67%) ) ),
    {
        import timeliney: *
        
        headerline(group(([*2025*], 6)), group(([*2026*], 6)))
        headerline(
            group([Jul], [Ago], [Set], [Out], [Nov], [Dec]),
            group([Jan], [Fev], [Mar], [Abr], [Mai], [Jun]),
        )
    
        taskgroup(
        title: [*Revisão*], style: (stroke: 2pt + black), {
            task( "Revisão bibliográfica", (from: 0, to: 4), style: (stroke: 8pt + gray) )
        })

        taskgroup(title: [*Desenvolvimento da pesquisa*], style: (stroke: 2pt + black), {
            task("Implementação dos modelos", (4, 8), style: (stroke: 8pt + gray))
            task("Análises numéricas", (4, 9), style: (stroke: 8pt + gray))
            task("Análise de resultados", (6, 10), style: (stroke: 8pt + gray))
        })

        taskgroup(title: [*Elaboração da disserteção*], style: (stroke: 2pt + black), {
            task([Escrita da revisão bibliográfica], (2, 6), style: (stroke: 8pt + gray))
            task([Escrita da metodologia], (5, 7), style: (stroke: 8pt + gray))
            task([Redação dos resultados], (7, 10), style: (stroke: 8pt + gray))
        })
        
        taskgroup(title: [*Elaboração de artigos*], style: (stroke: 2pt + black), {
            task([Artigo de congresso], (5, 8.25), style: (stroke: 8pt + gray))
            task([Artigo de revista], (4.5, 10), style: (stroke: 8pt + gray))
        })

        milestone(
        at: 8.25,
        style: (stroke: (dash: "dashed")),
        align(center, [
            Submissão artigo\ congreso
        ])
        )
        
        milestone(
        at: 10,
        style: (stroke: (dash: "dashed")),
        align(center, [
            Submissão artigo\ revista
        ])
        )

        milestone(
        at: 11.8,
        style: (stroke: (dash: "dashed")),
        align(center, [
            Defesa
        ])
        )
    }
    )
    ]
)<tab:cronograma>