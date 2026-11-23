
#import "@preview/cetz:0.5.3"

#set page(width: auto, height: auto, margin: 0.5cm)

#cetz.canvas(length: 0.004cm, {
  import cetz.draw: *

  // Change these angles to rotate the model
  ortho(x: 110deg, y: 180deg, z: 225deg, {

    // --- Palette ---
    let slab-top   = rgb("d8dce8")
    let slab-bottom = rgb("aab3c5")
    let slab-side  = rgb("b0bcd0")
    let slab-edge  = rgb("6f7d99")
    let slab-back  = rgb("8997b0")

    let col-top    = rgb("f0dcdc")
    let col-bottom = rgb("c49b9b")
    let col-side   = rgb("d0b0b0")
    let col-edge   = rgb("a87a7a")
    let col-back   = rgb("b88888")

    // --- Load plate palette ---
    let plate-top    = rgb("f5d78e")
    let plate-bottom = rgb("c9a85e")
    let plate-side   = rgb("dfbd72")
    let plate-edge   = rgb("a98743")
    let plate-back   = rgb("d5b366")

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
      col-top,
      col-bottom,
      col-side,
      col-back,
      col-edge
    )

    on-layer(50, {
      line((0,0,0),(bh*.8, 0, 0), mark: (end: "stealth"))
      content((bh*.85, 0, 0), [$x$])
      line((0,0,0),(0, lh*.8, 0), mark: (end: "stealth"))
      content((0, lh*.85, 0), [$y$])
      line((0,0,0), (0,0,zct*.8), mark: (end: "stealth"))
      content((0, 0, zct*.85), [$z$])
    })

    // Draw foreground content
    on-layer(100, {
      content(( lh/2,     0,   h/2), [$u_x = 0$])
      content((    0,  bh/2,   h/2), [$u_y = 0$])
      content((    0,     0, zct*1.2), [$u_x = u_y = 0$])
      content((    0,     0, -zct/3*1.1), [$u_x = u_y = u_z = 0$])
    })

  })
})
