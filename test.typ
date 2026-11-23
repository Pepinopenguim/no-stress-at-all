
#import "@preview/cetz:0.5.1"

#let sum-arr(a, b) = {
  a.zip(b).map(((x, y)) => x + y)
}

