#set text(lang: "en")
#set page(
  paper: "a4",
  margin: (top: 3cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
)

#let today = datetime.today()
#let commit = "2d31591"

#align(center)[
  #v(2cm)
  #text(size: 2.5em, weight: "bold")[Text Algorithms]
  #v(1.5cm)

  #text(size: 1.2em)[
    Lecture Notes
  ]
  #v(1cm)
  #text(size: 1.1em)[
    Based on the lectures of doc. RNDr. Tomáš Dvořák, CSc.
  ]
  #v(3cm)

  #text(size: 1.2em)[Authors: Petr Laštovička]
  #v(0.5cm)
  #text(size: 1.2em)[With a great contribution of: Gemini 2.5 Pro]

  #v(6cm)

  #text(size: 1.1em)[
    #link("https://github.com/Lastaapps/mff_textove_algoritmy_skripta")[Newest version available at GitHub]
  ]
  #v(0.5cm)

  #text(size: 1.1em)[
    Winter Semester 2025/2026
  ]
  #v(1cm)

  #text(size: 0.8em)[
    Generated on: #today.display("[year]-[month]-[day]"),
    commit: #commit
  ]
  #v(0.2cm)
  #text(size: 0.8em)[
  ]
]
