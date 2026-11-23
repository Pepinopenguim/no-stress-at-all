#import "@preview/cetz:0.5.1"

#let sum-arr(a, b) = {
  a.zip(b).map(((x, y)) => x + y)
}

#let todo(body) = highlight()[#body]

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


      let lw = 0.3pt

      // --- Dimensions (mm) ---
      let lh  = 1250
      let bh  = 1250
      let h   = 180

      let lch = 150
      let bch = 150
      let zct = 980

      

      // --- Complete cuboid ---
      // Draws all six faces, including top, bottom,
      // front, back, left and right.
      // 
      content((lh/2,bh/2,0), [this is a test])
      // 

      let box3(lo, hi, top, bottom, side, back, ec) = {
        let (x0, y0, z0) = lo
        let (x1, y1, z1) = hi

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

        // Front face (-Y)
        line(
          (x0,y0,z0), (x1,y0,z0),
          (x1,y0,z1), (x0,y0,z1),
          close: true,
          fill: side,
          stroke: st
        )

        // Back face (+Y)
        line(
          (x0,y1,z0), (x1,y1,z0),
          (x1,y1,z1), (x0,y1,z1),
          close: true,
          fill: back,
          stroke: st
        )

        // Left face (-X)
        line(
          (x0,y0,z0), (x0,y1,z0),
          (x0,y1,z1), (x0,y0,z1),
          close: true,
          fill: side,
          stroke: st
        )

        // Right face (+X)
        line(
          (x1,y0,z0), (x1,y1,z0),
          (x1,y1,z1), (x1,y0,z1),
          close: true,
          fill: side,
          stroke: st
        )
      }

      // --- Slab ---
      box3(
        (0, 0, 0),
        (lh, bh, h),
        slab-top,
        slab-bottom,
        slab-side,
        slab-back,
        slab-edge
      )

      // --- Column ---
      box3(
        (0, 0, -zct/3),
        (lch, bch, zct),
        slab-top,
        slab-bottom,
        slab-side,
        slab-back,
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
        slab-side,
        slab-back,
        slab-edge
        )
        box3(
        (yp1,xp1,h),
        (yp1+wp,xp1+wp,h+hp),
        slab-top,
        slab-bottom,
        slab-side,
        slab-back,
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
        on-layer(2, {
          // drawing symmetry conditions
          let (nx, nz) = (12, 2)
          let (dx, dz) = (lh / (nx+1), h / (nz+1))
          let start = (dx, 0, dz)
          let size = 50

          for i in range(nx) {
            for k in range(nz) {
              let (x, _, z) = sum-arr(start, (i * dx, 0, k * dz))
              line(
                (x, -size, z),
                (x, 0, z),
                mark: (end: ">", fill: rgb("0000ff")),
                stroke: (paint: rgb("0000ff"))
              )
            }

          // drawing symmetry conditions
          let (ny, nz) = (12, 2)
          let (dy, dz) = (bh / (ny+1), h / (nz+1))
          let start = (0, dy, dz)
          let size = 50

          for i in range(ny) {
            for k in range(nz) {
              let (_, y, z) = sum-arr(start, (0, i * dy, k * dz))
              line(
                (-size, y, z),
                (0, y, z),
                mark: (end: ">", fill: rgb("0000ff")),
                stroke: (paint: rgb("0000ff"))
              )
            }
          }
          }
        })
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
        content(( lh/2,     -500,   h/2), text(fill:rgb("0000ff"))[$u_x = 0$])
        content((    -500,  bh/2,   h/2), text(fill: rgb("0000ff"))[$u_y = 0$])
        content((    0,     0, zct*1.2), [$u_x = u_y = 0$])
        content((    0,     0, -zct/3*1.1), [$u_x = u_y = u_z = 0$])
        content((    xp1,     yp1, h+hp+250), text(fill: rgb("ff0000"))[$u_z = -25"mm"$])
        content((    yp1,     xp1, h+hp+250), text(fill: rgb("ff0000"))[$u_z = -25"mm"$])

          
      })

    })
  }

)


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