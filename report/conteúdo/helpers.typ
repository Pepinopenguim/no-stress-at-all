#import "@preview/cetz:0.5.1"

// Shorthands
#let prose(key) = cite(form: "prose", key)
#let year(key) = cite(form: "year", key)

#let sum-arr(a, b) = {
  a.zip(b).map(((x, y)) => x + y)
}

#let todo(body) = highlight()[#body]

// figures and such

#let bc-figure(length) = cetz.canvas(length: length, {
    import cetz.draw: *

    // Change these angles to rotate the model
    ortho(x: 110deg, y: 180deg, z: 219deg, {

      // --- Palette ---
      let slab-top   = rgb("d8dce8")
      let slab-bottom = rgb("aab3c5")
      let slab-side  = rgb("b0bcd0")
      let slab-edge  = rgb("6f7d99")
      let slab-back  = rgb("8997b0")

      let bc-simmetry-y = rgb("#95b2e1")
      let bc-simmetry-x = rgb("#e8d2c4")
      let bc-top = rgb("#a4e7a0")


      let lw = 0.3pt

      // --- Dimensions (mm) ---
      let lh  = 1250
      let bh  = 1250
      let h   = 180

      let lch = 150
      let bch = 150
      let zct = 980


      content((lh/2,bh/2,0), [this is a test])

      // --- Complete cuboid ---
      // Draws all six faces, including top, bottom,
      // front, back, left and right.
      //
      // `sides` is a 4-tuple of colors in the order (north, east, west, south):
      //   north = +Y (back), east = +X (right), west = -X (left), south = -Y (front)
      let box3(lo, hi, top, bottom, sides, ec) = {
        let (x0, y0, z0) = lo
        let (x1, y1, z1) = hi
        let (n, e, w, s) = sides

        let st = (paint: ec, thickness: lw)

        // Bottom face (-Z)
        line(
          (x0,y0,z0), (x1,y0,z0),
          (x1,y1,z0), (x0,y1,z0),
          close: true,
          fill: bottom,
          stroke: st
        )

        // Top face (+Z)
        line(
          (x0,y0,z1), (x1,y0,z1),
          (x1,y1,z1), (x0,y1,z1),
          close: true,
          fill: top,
          stroke: st
        )

        // South face (-Y)
        line(
          (x0,y0,z0), (x1,y0,z0),
          (x1,y0,z1), (x0,y0,z1),
          close: true,
          fill: s,
          stroke: st
        )

        // North face (+Y)
        line(
          (x0,y1,z0), (x1,y1,z0),
          (x1,y1,z1), (x0,y1,z1),
          close: true,
          fill: n,
          stroke: st
        )

        // West face (-X)
        line(
          (x0,y0,z0), (x0,y1,z0),
          (x0,y1,z1), (x0,y0,z1),
          close: true,
          fill: w,
          stroke: st
        )

        // East face (+X)
        line(
          (x1,y0,z0), (x1,y1,z0),
          (x1,y1,z1), (x1,y0,z1),
          close: true,
          fill: e,
          stroke: st
        )
      }

      // --- Slab ---
      box3(
        (0, 0, 0),
        (lh, bh, h),
        slab-top,
        slab-bottom,
        (slab-back, slab-side, bc-simmetry-y, bc-simmetry-x), // (N, E, W, S)
        slab-edge
      )

      // --- Column ---
      box3(
        (0, 0, -zct/3),
        (lch, bch, zct),
        bc-top,
        slab-bottom,
        (slab-back, slab-side, bc-simmetry-y, bc-simmetry-x), // (N, E, W, S)
        slab-edge
      )
      let xp1 = 1056.215
      let yp1 = 384.431
      let wp = 100
      let hp = 20

      on-layer(1, {
        box3(
        (xp1,yp1,h),
        (xp1+wp,yp1+wp,h+hp),
        slab-top,
        slab-bottom,
        (slab-back, slab-side, slab-side, slab-side),
        slab-edge
        )
        box3(
        (yp1,xp1,h),
        (yp1+wp,xp1+wp,h+hp),
        slab-top,
        slab-bottom,
        (slab-back, slab-side, slab-side, slab-side),
        slab-edge
        )

      })

      on-layer(2,{
        line(
          (xp1+wp/2,yp1+wp/2,h+hp+150),
          (xp1+wp/2,yp1+wp/2,h+20),
          mark: (start: "|", end: ">", fill: rgb("ff0000")),
          stroke: (paint: rgb("ff0000"))
        )
        line(
          (yp1+wp/2,xp1+wp/2,h+hp+150),
          (yp1+wp/2,xp1+wp/2,h+20),
          mark: (start: "|", end: ">", fill: rgb("ff0000")),
          stroke: (paint: rgb("ff0000"))
        )
      })


      on-layer(150, {
        line((0,0,0),(bh*.2, 0, 0), mark: (end: "stealth"))
        content((bh*.18, -60, 0), [$x$])
        line((0,0,0),(0, lh*.2, 0), mark: (end: "stealth"))
        content((-60, lh*.18, 0), [$y$])
        line((0,0,0), (0,0,zct*.2), mark: (end: "stealth"))
        content((0, 0, zct*.25), [$z$])
      })

      // Draw foreground content
      on-layer(100, {
        content(( lh/2,     -500,   h/2), text(fill:rgb("#623517"))[$u_x = 0$])
        content((    -500,  bh/2,   h/2), text(fill: rgb("0000ff"))[$u_y = 0$])
        content((    0,     0, zct*1.2), text(fill: rgb("#055401"))[$u_x = u_y = 0$])
        content((    0,     0, -zct/3*1.1), [$u_x = u_y = u_z = 0$])
        content((    xp1,     yp1, h+hp+250), text(fill: rgb("ff0000"))[$u_z = -25"mm"$])
        content((    yp1,     xp1, h+hp+250), text(fill: rgb("ff0000"))[$u_z = -25"mm"$])
      })

    })
  })

#let rebar = cetz.canvas(length: 1.5cm, {
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
        content("l.end", anchor:"west", padding:0.1, [Elemento de Volume])

        
    })


#let fib-curve-tau(length) = cetz.canvas(length: length, {
  import cetz.draw: *
  import calc: pow

  // Pull-out model parameters
  let s1 = 1.2
  let s2 = 2.5
  let s3 = 5.2

  let taumax = 3.5
  let taubf = 0.7

  // Axes
  line((0, 0), (6.5, 0),
    stroke: (paint: black, thickness: 1.3pt),
    mark: (end: "stealth")
  )
  line((0, 0), (0, 4.5),
    stroke: (paint: black, thickness: 1.3pt),
    mark: (end: "stealth")
  )

  // Pull-out curve: initial nonlinear increase
  let last = (0, 0)
  for i in range(100) {
    let si = s1 * i / 100
    let yi = taumax * pow((si / s1), .3)
    line(
      last,
      (si, yi),
      stroke: (paint: red, thickness: 0.8pt)
    )
    last = (si, yi)
  }


  // Maximum bond stress plateau
  line((s1, taumax), (s2, taumax),
    stroke: (paint: red, thickness: 0.8pt)
  )

  // Descending branch
  line((s2, taumax), (s3, taubf),
    stroke: (paint: red, thickness: 0.8pt)
  )

  // Residual bond stress
  line((s3, taubf), (6.3, taubf),
    stroke: (paint: red, thickness: 0.8pt)
  )

  // Horizontal reference lines
  for y in (taumax, taubf) {
    line((0, y), (s3, y),
      stroke: (paint: black, thickness: 0.6pt, dash: "dashed")
    )
  }

  // Vertical reference lines
  for x in (s1, s2, s3) {
    line((x, 0), (x, if x == s3 {taubf} else {taumax}),
      stroke: (paint: black, thickness: 0.6pt, dash: "dashed")
    )
  }

  // Axis labels
  content((6.75, 0), [$"slip"$ $s$],
    anchor: "west"
  )
  content((0, 4.75), [$tau_b$],
    anchor: "center"
  )

  // Stress labels
  content((-0.08, taumax), [$tau_(b max)$],
    anchor: "east"
  )
  content((-0.08, taubf), [$tau_("bf")$],
    anchor: "east"
  )

  // Slip labels
  content((s1, -0.35), [$s_1$],
    anchor: "north"
  )
  content((s2, -0.35), [$s_2$],
    anchor: "north"
  )
  content((s3, -0.35), [$s_3$],
    anchor: "north"
  )

  // Legend
  line((5.5, 2.7), (5.85, 2.7),
    stroke: (paint: red, thickness: 0.8pt)
  )
  content((6, 2.7), [*pull-out*],
    anchor: "west"
  )

})

#let abnt_contours() = {
  import "@preview/cetz:0.5.3": canvas, draw
  canvas(length: 0.008cm, {
  import draw: *


  let p(x, y) = (x, -y)
  let fino = 0.30mm
  let cheio = 0.56mm
  let tracejado = (paint: black, thickness: 0.60mm,dash: (array: (1.8mm, 1.6mm)), cap: "butt")
  let cinza = rgb("#999999")

  // Mantém a mesma área e as mesmas margens da imagem original.
  rect(p(0, 0), p(1959, 803), stroke: none)

  let segmento(a, b, stroke: fino) = line(p(..a), p(..b), stroke: stroke)
  let curva(a, b, c, d) = bezier(p(..a), p(..d), p(..b), p(..c))
  let legenda(x, y, body) = content(p(x, y), body)
  // Setas com ponta triangular preenchida, na proporção da referência.
  let seta(a, b, ponta: 27, largura: 17, stroke: fino) = {
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let r = calc.sqrt(dx * dx + dy * dy)
    let (ux, uy) = (dx / r, dy / r)
    let base = (b.at(0) - ponta * ux, b.at(1) - ponta * uy)
    segmento(a, base, stroke: stroke)
    line(p(..b),
      p(base.at(0) - largura / 2 * uy, base.at(1) + largura / 2 * ux),
      p(base.at(0) + largura / 2 * uy, base.at(1) - largura / 2 * ux),
      close: true, fill: black, stroke: none)
  }
  let cota(a, b) = {
    seta(a, b, ponta: 29, largura: 17)
    seta(b, a, ponta: 29, largura: 17)
  }
  let C = text(style: "italic")[C]
  let Cp = text(style: "italic")[C′]
  let dois-d = text(style: "italic", weight: "bold")[2d]
  let chamada(x, y, body) = legenda(x, y, text(size: 16.7pt, body))

  // (a) Seção circular e perímetro crítico concêntrico.
  circle(p(236, 335), radius: 196, stroke: tracejado)
  circle(p(236, 334), radius: 61, fill: cinza, stroke: cheio)
  segmento((297, 51), (297, 293))
  segmento((433, 51), (433, 271))
  cota((298, 72), (432, 72))
  legenda(365, 32, dois-d)
  seta((307, 415), (274, 385))
  legenda(327, 428, C)
  seta((366, 543), (328, 509))
  legenda(397, 567, Cp)

  // (b) Seção retangular e contorno com quatro cantos arredondados.
  merge-path(close: true, stroke: tracejado, {
    segmento((761, 152), (925, 152))
    curva((925, 152), (1005, 152), (1069, 219), (1069, 299))
    segmento((1069, 299), (1069, 372))
    curva((1069, 372), (1069, 452), (1005, 516), (925, 516))
    segmento((925, 516), (761, 516))
    curva((761, 516), (682, 516), (618, 452), (618, 372))
    segmento((618, 372), (618, 299))
    curva((618, 299), (618, 219), (682, 152), (761, 152))
  })
  rect(p(762, 273), p(925, 393), fill: cinza, stroke: cheio)
  segmento((925, 51), (925, 255))
  segmento((1068, 51), (1068, 265))
  cota((926, 72), (1067, 72))
  legenda(996, 32, dois-d)
  seta((897, 449), (865, 396))
  legenda(916, 459, C)
  seta((1054, 539), (1002, 494))
  legenda(1088, 547, Cp)
  segmento((1181, 671), (913, 671))
  seta((913, 671), (791, 520))
  chamada(1045, 636, [Perímetro])
  chamada(1045, 702, [crítico])

  // (c) Seção cruciforme; o contorno externo alterna retas e arcos.
  merge-path(close: true, stroke: tracejado, {
    segmento((1475, 100), (1583, 100))
    curva((1583, 100), (1606, 100), (1620, 106), (1638, 124))
    segmento((1638, 124), (1728, 217))
    curva((1728, 217), (1749, 240), (1759, 269), (1759, 299))
    segmento((1759, 299), (1759, 389))
    curva((1759, 389), (1759, 414), (1747, 435), (1728, 454))
    segmento((1728, 454), (1633, 548))
    curva((1633, 548), (1617, 561), (1602, 566), (1580, 566))
    segmento((1580, 566), (1477, 566))
    curva((1477, 566), (1450, 566), (1433, 558), (1415, 540))
    segmento((1415, 540), (1327, 452))
    curva((1327, 452), (1306, 431), (1297, 413), (1297, 386))
    segmento((1297, 386), (1297, 300))
    curva((1297, 300), (1297, 268), (1307, 240), (1330, 216))
    segmento((1330, 216), (1428, 119))
    curva((1428, 119), (1441, 106), (1457, 100), (1475, 100))
  })
  line(..((1501, 236), (1557, 236), (1557, 307), (1628, 307),
    (1628, 360), (1557, 360), (1557, 430), (1501, 430),
    (1501, 360), (1430, 360), (1430, 307), (1501, 307)).map(q => p(..q)),
    close: true, fill: cinza, stroke: cheio)

  // Cotas de afastamento 2d.
  segmento((1288, 100), (1393, 100))
  seta((1289, 100), (1459, 269))
  segmento((1433, 299), (1493, 238))
  legenda(1342, 64, dois-d)
  segmento((1626, 102), (1848, 102))
  segmento((1582, 235), (1720, 235))
  segmento((1771, 235), (1848, 235))
  cota((1825, 103), (1825, 234))
  legenda(1886, 165, dois-d)
  seta((1595, 396), (1563, 365))
  legenda(1613, 410, C)
  seta((1720, 549), (1678, 510))
  legenda(1756, 565, Cp)

  // Construção auxiliar no canto reentrante e indicação do trecho curvo.
  segmento((1433, 368), (1493, 428))
  segmento((1499, 432), (1499, 565),
    stroke: (thickness: fino, dash: (array: (1.0mm, 0.65mm))))
  segmento((1492, 435), (1400, 527),
    stroke: (thickness: fino, dash: (array: (1.0mm, 0.65mm))))
  line(p(1499, 452), p(1517, 452), p(1517, 432), stroke: fino)
  line(p(1485, 420), p(1472, 433), p(1485, 446), stroke: fino)
  segmento((1663, 694), (1439, 694))
  seta((1439, 694), (1439, 575))
  chamada(1552, 658, [Trecho])
  chamada(1552, 721, [curvo])
})

}
