#let info_box(title: none, body) = {
  block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    [
      #if title != none {
        text(weight: "bold", title)
        parbreak()
      }
      #body
    ],
  )
}

#let example_box(title: none, body) = {
  box(
    stroke: 1pt + black,
    inset: 8pt,
    [
      #if title != none {
        text(weight: "bold", title)
        parbreak()
      }
      #body
    ],
  )
}

#let code_box(body) = {
  rect(
    width: 100%,
    inset: 8pt,
    fill: luma(240),
    radius: 4pt,
    body,
  )
}
