#import "definitions.typ": info_box

#set document(title: "Text Algorithms", author: "Gemini")
#set text(lang: "en")
#set heading(numbering: "1.1.")

#show outline.entry.where(
  level: 1,
): it => {
  v(1em)
  strong(it)
}

#outline(title: "Table of Contents", depth: 2)

#include "notes/01-introduction-to-stringology.typ"
#include "notes/02-kmp-algorithm.typ"
#include "notes/03-suffix-tree.typ"
#include "notes/04-suffix-tree-applications.typ"
#include "notes/05-suffix-tree-construction.typ"
