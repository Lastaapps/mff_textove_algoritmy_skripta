#import "definitions.typ": info_box

#set document(title: "Text Algorithms", author: "Gemini")
#set text(lang: "en")

#show outline.entry.where(
  level: 1
): it => {
  v(1em)
  strong(it)
}

#outline(title: "Table of Contents", depth: 2)

#include "notes/01-introduction-to-stringology.typ"
#include "notes/02-kmp-algorithm.typ"
