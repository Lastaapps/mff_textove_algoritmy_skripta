#import "../definitions.typ": info_box
#set text(lang: "en")

= Introduction to Stringology

== What is Stringology?

Stringology is a field of computer science that studies algorithms working with strings. A string is a sequence of characters, like a word or a sentence.

#info_box(
  title: "Basic Concepts")[
    - *Alphabet*: A set of characters, like `{A, B, C}` or `{0, 1}`.
    - *String*: A sequence of characters from an alphabet.
      - The *empty string* (`epsilon`) has no characters.
      - The *length* of a string is its number of characters (e.g., `|"hello"| = 5`).
    - *Parts of a String*:
      - *Prefix*: The beginning of a string (e.g., `"he"` in `"hello"`).
      - *Suffix*: The end of a string (e.g., `"llo"` in `"hello"`).
      - *Substring*: A part of a string (e.g., `"ell"` in `"hello"`).
    - *Periodicity*: A repeating pattern in a string. The string `"ababab"` has a period of 2 because the pattern `"ab"` repeats.
  ]
)

== Problems in Stringology

Stringology helps solve many computational problems.

#info_box(
  title: "Common Problems in Stringology")[
    - *String Matching*: Finding a pattern in a text (e.g., finding a word on a webpage).
    - *Approximate Matching*: Finding patterns that are similar but not identical.
    - *Finding Repetitions*: Locating all repeating parts in a string.
    - *Longest Common Substring*: Finding the longest shared part of two strings.
    - *Data Compression*: Making files smaller by finding and replacing repeated patterns.
    - *Bioinformatics*: Analyzing DNA and protein sequences, which are very long strings.
  ]
)
