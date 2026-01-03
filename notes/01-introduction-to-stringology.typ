#import "../definitions.typ": *

= Introduction to Stringology

== What is Stringology?

Stringology is a field of computer science that studies algorithms working with strings. A string is a sequence of characters, like a word or a sentence.

#info_box(title: "Basic Concepts")[
  - *Alphabet* ($Sigma$): A finite set of characters.
  - *Word* (or *String*): A finite sequence of characters from an alphabet $Sigma$.
  - *Empty Word* ($epsilon$): A word with a length of 0.
  - *Length* ($|alpha|$): The number of characters in a word $alpha$.
  - $Sigma^*$: The set of all possible words over the alphabet $Sigma$, including the empty word.
  - $Sigma^+$: The set of all non-empty words, i.e., $Sigma^* backslash {epsilon}$.
]

#info_box(title: "Parts of a String")[
  - *Substring*: A word $beta$ is a substring of $alpha$ if there exist words $gamma$ and $delta$ such that $alpha = gamma beta delta$. We say that $beta$ occurs at position $|gamma|$ in $alpha$.
  - *Prefix*: A word $beta$ is a prefix of $alpha$ if there exists a word $gamma$ such that $alpha = beta gamma$.
  - *Suffix*: A word $beta$ is a suffix of $alpha$ if there exists a word $gamma$ such that $alpha = gamma beta$.
  - *Proper Prefix/Suffix/Substring*: A prefix, suffix, or substring $beta$ of $alpha$ is "proper" if $beta != alpha$.
]

#info_box(title: "Periodicity")[
  A repeating pattern in a string. The string `"ababab"` has a period of 2 because the pattern `"ab"` repeats.
]

== Types of Alphabets

#info_box(title: "Examples of Alphabets")[
  - *Binary*: $Sigma = {0, 1}$
  - *DNA*: $Sigma = {C, G, A, T}$ (cytosine, guanine, adenine, thymine). Forms DNA strands.
  - *Latin*: $Sigma = {A, B, ..., Z, ., ;, :, ...}$
  - *Unicode*: A vast set of characters.
  - *Indexed*: $Sigma = {0, 1, ..., |Sigma|-1}$.
  - *Ordered*: An alphabet is ordered if $Sigma$ is a linearly ordered set.
]

== Word Ordering

#info_box(title: "Lexicographical Ordering")[
  If $Sigma$ is an ordered alphabet, we define the lexicographical ordering on $Sigma^*$:
  $alpha < beta$ for $alpha, beta in Sigma^*$, if:
  - $|alpha| < |beta|$ and $alpha[i] = beta[i]$ for $i = 0, 1, ..., |alpha|-1$, OR
  - There exists a $k = 0, 1, ..., min{|alpha|, |beta|}-1$ such that $alpha[i] = beta[i]$ for $i = 0, 1, ..., k-1$ and $alpha[k] < beta[k]$.
]

== Concatenation and Factorization

#info_box(title: "Concatenation and Subwords")[
  - *Concatenation*: The concatenation of words $alpha, beta in Sigma^*$ is a word $alpha beta$ such that $alpha beta[:|alpha| ] = alpha$ and $alpha beta[ |alpha|:] = beta$.
  - *Subword* (or *Substring*): A word $beta$ is a subword of $alpha$ if there exist words $gamma$ and $delta$ such that $alpha = gamma beta delta$. We say that the subword $beta$ occurs at position $|gamma|$ in $alpha$.
]

#info_box(title: "Factorization")[
  - A non-empty subword is also called a *factor*.
  - $alpha = beta_1 beta_2 ... beta_k$ is a factorization (decomposition) of word $alpha$ into factors $beta_1, beta_2, ..., beta_k in Sigma^+$.
  - If $beta_1 = beta_2 = ... = beta_k = beta$, then $beta_1 beta_2 ... beta_k$ is written as $beta^k$.
]

#example_box[
  - $"ababab" = ("ab")("ab")("ab") = ("ab")^3$
]

== Borders of a Word

#info_box(title: "Border")[
  A proper prefix of a word $alpha$ that is also a suffix of $alpha$ is called a *border* of $alpha$.
]

== Problems in Stringology

Stringology helps solve many computational problems.

#info_box(
  title: "Common Problems in Stringology",
)[
  - *String Matching*: Finding a pattern in a text (e.g., finding a word on a webpage).
  - *Approximate Matching*: Finding patterns that are similar but not identical.
  - *Finding Repetitions*: Locating all repeating parts in a string.
  - *Longest Common Substring*: Finding the longest shared part of two strings.
  - *Data Compression*: Making files smaller by finding and replacing repeated patterns.
  - *Bioinformatics*: Analyzing DNA and protein sequences, which are very long strings.
]
#pagebreak()
