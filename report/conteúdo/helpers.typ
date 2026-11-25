#import "@preview/cetz:0.5.1"
#import cetz.draw: *

// Shorthands
#let prose(key) = cite(form: "prose", key)
#let year(key) = cite(form: "year", key)

#let sum-arr(a, b) = {
  a.zip(b).map(((x, y)) => x + y)
}

#let todo(body) = highlight()[#body]

// figures and such

#let bc-figure(length) = cetz.canvas(length: length, {


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

#let abnt-contours() = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *

    // ------------------------------------------------------------
    // Parâmetros
    // ------------------------------------------------------------
    let d2 = 0.85  // afastamento 2d a partir da face da coluna
    let cinza = rgb("#9d9d9d")
    let fino = 0.55pt
    let cheio = 0.9pt
    let tracejado = (paint: black, thickness: 0.75pt, dash: "dashed")
    let tracejado-fino = (paint: black, thickness: fino, dash: "dashed")
    let ponto = (paint: black, thickness: fino)

    // ------------------------------------------------------------
    // Álgebra vetorial 2D
    // ------------------------------------------------------------
    let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
    let sub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
    let mul(a, k) = (a.at(0) * k, a.at(1) * k)
    let cross(a, b) = a.at(0) * b.at(1) - a.at(1) * b.at(0)
    let dot(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1)
    let norm(a) = {
      let l = calc.sqrt(dot(a, a))
      (a.at(0) / l, a.at(1) / l)
    }

    // ------------------------------------------------------------
    // Acessórios
    // ------------------------------------------------------------
    let seta(a, b, escala: 0.45) = line(
      a, b, mark: (end: "triangle", fill: black, scale: escala), stroke: ponto)
    let cota(a, b) = { seta(a, b); seta(b, a) }
    let extensao(a, b) = line(a, b, stroke: ponto)
    let legenda(pos, body, size: 11pt) = content(pos, text(size: size)[#body])

    // Seção cruciforme: braços 2L × 2s (polígono anti-horário)
    let cruz(L, s) = (
      (s, L), (-s, L), (-s, s), (-L, s), (-L, -s), (-s, -s),
      (-s, -L), (s, -L), (s, -s), (L, -s), (L, s), (s, s),
    )

    // ============================================================
    // (a) Seção circular → contorno concêntrico
    // o = origem do painel; T(x, y) desloca o ponto para o painel
    // ============================================================
    let painel-circular(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let r = 0.8
      circle(T(0, 0), radius: r + d2, stroke: tracejado)
      circle(T(0, 0), radius: r, fill: cinza, stroke: cheio)

      extensao(T(r, 1.55), T(r, 2.4))
      extensao(T(r + d2, 1.55), T(r + d2, 2.4))
      cota(T(r, 2.28), T(r + d2, 2.28))
      legenda(T(r + d2 / 2, 2.7), $2d$)

      seta(T(2.05, 0.75), T(calc.cos(30deg) * r, calc.sin(30deg) * r))
      legenda(T(2.3, 0.85), $C$)
      seta(T(2.35, -1.2), T(calc.cos(-40deg) * (r + d2), calc.sin(-40deg) * (r + d2)))
      legenda(T(2.6, -1.32), $C'$)
    }

    // ============================================================
    // (b) Seção retangular → contorno de cantos arredondados
    // ============================================================
    let painel-retangular(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let a = 1.0   // meia-largura da coluna
      let b = 0.65  // meia-altura
      rect(T(-a, -b), T(a, b), fill: cinza, stroke: cheio)
      rect(T(-a - d2, -b - d2), T(a + d2, b + d2), radius: d2, stroke: tracejado)

      extensao(T(a, b + 0.12), T(a, 2.1))
      extensao(T(a + d2, b + d2 + 0.08), T(a + d2, 2.1))
      cota(T(a, 1.98), T(a + d2, 1.98))
      legenda(T(a + d2 / 2, 2.35), $2d$)

      seta(T(2.25, -.5), T(a, -0.5))
      legenda(T(2.55, -.5), $C$)
      seta(T(2.35, .45), T(a + d2, 0.45))
      legenda(T(2.7, .45), $C'$)

      legenda(T(0.35, -2.45), [Perímetro])
      legenda(T(0.6, -3.0), [crítico])
      seta(T(0.3, -2.25), T(-a - d2 * calc.cos(45deg), -b - d2 * calc.sin(45deg)))
    }

    // ============================================================
    // (c) Seção cruciforme → retas e arcos alternados
    // ============================================================
    let painel-cruciforme(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let L = 1.4   // meio-comprimento dos braços
      let s = 0.4   // meia-espessura dos braços
      let pts = cruz(L, s)

      line(..pts.map(pt => add(pt, o)), close: true, fill: cinza, stroke: cheio)

      let t = .8
      //drawing straight lines
      for (pt0, pt1) in (
        ((L+t,- s), (L+t,+ s)),
        ((-L - t,- s), (-L - t,+ s)),
        ((-s,- L - t), (+s , - L - t )),
        ((-s, L + t), (+s ,  L + t )),
        ((L + t / calc.sqrt(2), s+ t / calc.sqrt(2)), (s + t / calc.sqrt(2), L + t / calc.sqrt(2))),
        ((L + t / calc.sqrt(2), - s - t / calc.sqrt(2)), (s + t / calc.sqrt(2), - L - t / calc.sqrt(2))),
        ((- L - t / calc.sqrt(2), s+ t / calc.sqrt(2)), (- s - t / calc.sqrt(2), L + t / calc.sqrt(2))),
        ((- L - t / calc.sqrt(2), - s - t / calc.sqrt(2)), (- s - t / calc.sqrt(2), - L - t / calc.sqrt(2))),
      ) {
        line(add(pt0,o), add(pt1,o), stroke: tracejado)
      }

      for (c, start, delta) in (
         ((L+t, s), 0deg, 45deg),
         ((L+t, -s), 0deg, -45deg),
         ((s, L + t), 90deg, -45deg),
         ((-s, L + t), 90deg, +45deg),
         ((s, -L - t), -90deg, +45deg),
         ((-s, -L - t), -90deg, -45deg),
         ((-L - t , -s ), 180deg, 45deg),
         ((-L - t , +s ), 180deg, -45deg),
       ) {
         arc(add(o, c ), radius: t, start: start, delta: delta, stroke: tracejado)
       }

      seta(T(0, L), T(.4, L + t + .4))
      legenda(T(.6, L + t + .6), $C$)
      seta(T(2.4, -0.6), T(L + d2, -0.3))
      legenda(T(2.7, -0.7), $C'$)

      extensao(T(L + 0.05, s), T(L + d2 + 0.85, s))
      extensao(T(L + 0.05, s + d2), T(L + d2 + 0.85, s + d2))
      cota(T(L + d2 + 0.65, s), T(L + d2 + 0.65, s + d2))
      legenda(T(L + d2 + 1.35, s + d2 / 2), $2d$)

      extensao(T(-L, s + 0.05), T(-L, s + d2 + 0.75))
      extensao(T(-L - d2, s + 0.05), T(-L - d2, s + d2 + 0.75))
      cota(T(-L, s + d2 + 0.6), T(-L - d2, s + d2 + 0.6))
      legenda(T(-L - d2 / 2, s + d2 + 1.05), $2d$)

      line(T(-L, - s), T(-s,-L), stroke: tracejado)
      cota(T((-L - s)/2, (-L - s)/2), T((-L - s)/2 - t * calc.cos(45deg),(-L - s)/2 - t * calc.sin(45deg)))
      legenda(T((-L - s)/2, (-L - s)/2 - t*.75), [$2d$])

      line(T(s, -L), T(s,- L - t), stroke: tracejado)
      line(T(s, -L), T(s + t * calc.cos(45deg),- L - t * calc.sin(45deg)), stroke: tracejado)
      legenda(T(s + t * calc.cos(45deg),- L - t * calc.sin(45deg) - .6), [Trecho curvo])


      let w = (s + d2 + o.at(0), s + d2 + o.at(1)) // canto vivo do contorno
      line(w, T(w.at(0) - o.at(0), s), stroke: tracejado-fino)
      line(w, T(s, w.at(1) - o.at(1)), stroke: tracejado-fino)

    }

    // ============================================================
    // Disposição horizontal: só a origem muda entre os painéis
    // ============================================================
    painel-circular((0, 0))
    painel-retangular((6.4, 0))
    painel-cruciforme((12.8, 0))
  })
}


#let euro-contours() = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *

    // ------------------------------------------------------------
    // Parâmetros
    // ------------------------------------------------------------
    let d2 = 0.85  // afastamento 2d a partir da face da coluna
    let cinza = rgb("#9d9d9d")
    let fino = 0.55pt
    let cheio = 0.9pt
    let tracejado = (paint: black, thickness: 0.75pt, dash: "dashed")
    let tracejado-fino = (paint: black, thickness: fino, dash: "dashed")
    let ponto = (paint: black, thickness: fino)

    // ------------------------------------------------------------
    // Álgebra vetorial 2D
    // ------------------------------------------------------------
    let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
    let sub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
    let mul(a, k) = (a.at(0) * k, a.at(1) * k)
    let cross(a, b) = a.at(0) * b.at(1) - a.at(1) * b.at(0)
    let dot(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1)
    let norm(a) = {
      let l = calc.sqrt(dot(a, a))
      (a.at(0) / l, a.at(1) / l)
    }

    // ------------------------------------------------------------
    // Acessórios
    // ------------------------------------------------------------
    let seta(a, b, escala: 0.45) = line(
      a, b, mark: (end: "triangle", fill: black, scale: escala), stroke: ponto)
    let cota(a, b) = { seta(a, b); seta(b, a) }
    let extensao(a, b) = line(a, b, stroke: ponto)
    let legenda(pos, body, size: 11pt) = content(pos, text(size: size)[#body])

    // Seção cruciforme: braços 2L × 2s (polígono anti-horário)
    let cruz(L, s) = (
      (s, L), (-s, L), (-s, s), (-L, s), (-L, -s), (-s, -s),
      (-s, -L), (s, -L), (s, -s), (L, -s), (L, s), (s, s),
    )

    // ============================================================
    // (a) Seção circular → contorno concêntrico
    // o = origem do painel; T(x, y) desloca o ponto para o painel
    // ============================================================
    let painel-circular(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let r = 0.8
      circle(T(0, 0), radius: r + d2, stroke: tracejado)
      circle(T(0, 0), radius: r, fill: cinza, stroke: cheio)

      extensao(T(r, 1.55), T(r, 2.4))
      extensao(T(r + d2, 1.55), T(r + d2, 2.4))
      cota(T(r, 2.28), T(r + d2, 2.28))
      legenda(T(r + d2 / 2, 2.7), $2d$)

      seta(T(r + d2, 0), T(r + d2 + .75, 0))
      legenda(T(r + d2 + 1.1, 0), $u_1$)
    }

    // ============================================================
    // (b) Seção retangular → contorno de cantos arredondados
    // ============================================================
    let painel-retangular(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let a = 1.0   // meia-largura da coluna
      let b = 0.65  // meia-altura
      rect(T(-a, -b), T(a, b), fill: cinza, stroke: cheio)
      rect(T(-a - d2, -b - d2), T(a + d2, b + d2), radius: d2, stroke: tracejado)

      extensao(T(a, b + 0.12), T(a, 2.1))
      extensao(T(a + d2, b + d2 + 0.08), T(a + d2, 2.1))
      cota(T(a, 1.98), T(a + d2, 1.98))
      legenda(T(a + d2 / 2, 2.35), $2d$)

      seta(T(2.35, .45), T(a + d2, 0.45))
      legenda(T(2.7, .45), $u_1$)
      extensao(T(-a,b + d2), T(-a - 1.2*d2, b+ d2))
      extensao(T(-a,-b - d2), T(-a - 1.2*d2, -b - d2))
      cota(T(-a -1.2*d2, b + d2), T(-a - 1.2*d2, -b - d2))
      legenda(T(-a - 1.5*d2, 0), [$b_1$])

      extensao(T(-a - d2,-b ), T(-a - d2, -b - 1.4*d2))
      extensao(T(a + d2,-b ), T(a + d2, -b - 1.4*d2))
      cota(T(-a - d2, -b - 1.3*d2), T(a + d2, -b - 1.3*d2))
      legenda(T(0, -b - 1.6*d2), [$b_2$])

    }

    // ============================================================
    // (c) Seção cruciforme → retas e arcos alternados
    // ============================================================
    let painel-cruciforme(o) = {
      let T(x, y) = (x + o.at(0), y + o.at(1))
      let L = 1.4   // meio-comprimento dos braços
      let s = 0.4   // meia-espessura dos braços
      let pts = cruz(L, s)

      line(..pts.map(pt => add(pt, o)), close: true, fill: cinza, stroke: cheio)

      let t = .8
      //drawing straight lines
      for (pt0, pt1) in (
        ((L+t,- s), (L+t,+ s)),
        ((-L - t,- s), (-L - t,+ s)),
        ((-s,- L - t), (+s , - L - t )),
        ((-s, L + t), (+s ,  L + t )),
        ((L + t / calc.sqrt(2), s+ t / calc.sqrt(2)), (s + t / calc.sqrt(2), L + t / calc.sqrt(2))),
        ((L + t / calc.sqrt(2), - s - t / calc.sqrt(2)), (s + t / calc.sqrt(2), - L - t / calc.sqrt(2))),
        ((- L - t / calc.sqrt(2), s+ t / calc.sqrt(2)), (- s - t / calc.sqrt(2), L + t / calc.sqrt(2))),
        ((- L - t / calc.sqrt(2), - s - t / calc.sqrt(2)), (- s - t / calc.sqrt(2), - L - t / calc.sqrt(2))),
      ) {
        line(add(pt0,o), add(pt1,o), stroke: tracejado)
      }

      for (c, start, delta) in (
         ((L+t, s), 0deg, 45deg),
         ((L+t, -s), 0deg, -45deg),
         ((s, L + t), 90deg, -45deg),
         ((-s, L + t), 90deg, +45deg),
         ((s, -L - t), -90deg, +45deg),
         ((-s, -L - t), -90deg, -45deg),
         ((-L - t , -s ), 180deg, 45deg),
         ((-L - t , +s ), 180deg, -45deg),
       ) {
         arc(add(o, c ), radius: t, start: start, delta: delta, stroke: tracejado)
       }

      seta(T(2.4, -0.6), T(L + d2, -0.3))
      legenda(T(2.7, -0.7), $u_1$)



      line(T(-L, - s), T(-s,-L), stroke: tracejado)
      cota(T((-L - s)/2, (-L - s)/2), T((-L - s)/2 - t * calc.cos(45deg),(-L - s)/2 - t * calc.sin(45deg)))
      legenda(T((-L - s)/2, (-L - s)/2 - t*.75), [$2d$])


    }

    // ============================================================
    // Disposição horizontal: só a origem muda entre os painéis
    // ============================================================
    painel-circular((0, 0))
    painel-retangular((6.4, 0))
    painel-cruciforme((12.8, 0))
  })
}