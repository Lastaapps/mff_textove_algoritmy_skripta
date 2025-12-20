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
    ]
  )
}
