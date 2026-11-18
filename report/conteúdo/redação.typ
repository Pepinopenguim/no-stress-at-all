= MODELOS DE TABELA E GRÁFICO

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

#figure(
    caption: [Função de tração-separação para concreto, um modelo bilinear simplificado.],
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

