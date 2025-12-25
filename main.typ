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


#include "title.typ"

#outline(title: "Table of Contents", depth: 2)

#include "notes/01-introduction-to-stringology.typ"
#include "notes/02-kmp-algorithm.typ"
#include "notes/03-suffix-tree.typ"
#include "notes/04-suffix-tree-applications.typ"
#include "notes/05-suffix-tree-construction.typ"
#include "notes/06-suffix-array.typ"
#include "notes/07-suffix-array-construction.typ"
#include "notes/08-suffix-automaton.typ"
#include "notes/09-fm-index.typ"
#include "notes/10-shift-or.typ"
#include "notes/11-rabin-karp.typ"
#include "notes/12-boyer-moore.typ"
#include "notes/13-multiple-pattern-matching.typ"
#include "notes/14-string-distance.typ"
#include "notes/15-approximate-string-matching.typ"
#include "notes/16-approximate-string-matching-2.typ"
