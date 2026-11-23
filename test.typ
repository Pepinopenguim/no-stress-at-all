
#import "@preview/cetz:0.5.1"

#let sum-arr(a, b) = {
  a.zip(b).map(((x, y)) => x + y)
}


#let rebar = cetz.canvas({
        import cetz.draw: *
        import calc: pow
        set-style(stroke: (paint:black, thickness:0.6pt), mark:(fill:black))
        // let aux-line-style = (stroke: (paint: gray, thickness: 0.4pt))

        scale(1.4)

        let p1 = (0,0,0)
        let p2 = (1,0,0)
        let p3 = (0,1,0)
        let p4 = (0.33,0.33,1)

        let pa = (0.0, 0.5, 0.4)
        let pb = (0.5, 0.15, 0.4)
        let pc = cetz.vector.scale(cetz.vector.add(pa,pb), 0.5)

        let bullet(p) = content(p, anchor:"center",  text(baseline:-0.8pt)[●])

        perspective(x:-60deg, y:10deg, z:50deg, distance:1, sorted:false, {
            scale(2.2)
            set-style(stroke: (paint:black, thickness:0.6pt), mark:(fill:black, transform-shape:false, scale:0.9))

            // rebar
            line(pa, pb, stroke:(paint:blue, thickness:1.2pt))
            bullet(pa)
            bullet(pb)
            bullet(pc)

            content(pa, anchor:"north", padding:(x:0, y:0.1), text(gray)[$hat(bold(u))_1$])
            content(pb, anchor:"north", padding:(x:0.05, y:0.1), text(gray)[$hat(bold(u))_2$])
            content(pc, anchor:"north", padding:(x:0.05, y:0.1), text(gray)[$hat(bold(u))_3$])
            content(pa, anchor:"south", padding:(x:0, y:0.1), text(blue)[$macron(bold(u))_1$])
            content(pb, anchor:"south", padding:(x:0.05, y:0.1), text(blue)[$macron(bold(u))_2$])
            content(pc, anchor:"south-east", padding:(x:-0.05, y:0.09), text(blue)[$macron(bold(u))_3$])

            // bulk
            line(p1, p2, p3, close:true, fill:gray.lighten(95%))
            line(p1, p4)
            line(p2, p4)
            line(p3, p4)
            
            bullet(p1)
            bullet(p2)
            bullet(p3)
            bullet(p4)
            
            content(p1, anchor:"north-east", padding:(x:0, y:0.1), $bold(u)_1$)
            content(p2, anchor:"north-west", padding:(x:0, y:0), $bold(u)_2$)
            content(p3, anchor:"north-east", padding:(x:0, y:0), $bold(u)_3$)
            content(p4, anchor:"south-east", padding:(x:0.1, y:0), $bold(u)_4$)

        })

        line((-0.1,1.3), (0.4,2.3), stroke: 0.5pt, mark: (start: ">>", fill:black, scale:0.6), name:"l")
        content("l.end", anchor:"west", padding:0.1, [Elemento de Barra])
        
        line((0.45,0.3), (0.8,0.2), stroke: 0.5pt, mark: (start: ">>", fill:black, scale:0.6), name:"l")
        content("l.end", anchor:"west", padding:0.1, [Elemento de Volume Tetrahétrico])

        
    })


#let fib-pullout = {
  import "@preview/lilaq:0.5.0" as lq

  // Parâmetros do modelo (MPa e mm)
  let tbmax = 13.7
  let tbf = 5.5

  let s1 = 1.0
  let s2 = 1.1
  let s3 = 16

  let alpha = 0.58

  let s = lq.linspace(0, 20.0)

  // Lei de aderência-deslizamento fib
  let fib(s) = {
    if s <= s1 {
      tbmax * calc.pow(s / s1, alpha)
    } else if s <= s2 {
      tbmax
    } else if s <= s3 {
      tbmax - (tbmax - tbf) * (s - s2) / (s3 - s2)
    } else {
      tbf
    }
  }

  set text(size: 10pt)

  lq.diagram(
    width: 7cm,
    height: 4.5cm,

    xaxis: (subticks: none),
    yaxis: (subticks: none),

    xlabel: [$s$ [mm]],
    ylabel: [$τ_b$ [MPa]],

    lq.plot(
      s, fib,
      color: red,
      mark: none,
      label: [Modelo fib pullout],
    ),
  )
}

#fib-pullout
