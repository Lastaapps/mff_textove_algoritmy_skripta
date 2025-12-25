
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

= Boyer-Moore Algorithm

== Introduction

The *Boyer-Moore algorithm* is a highly efficient string searching algorithm, developed by Robert S. Boyer and J Strother Moore in 1977. It is considered one of the fastest string searching algorithms in practice.

The key idea is to start comparisons from the end of the pattern, rather than the beginning. This allows for larger shifts of the pattern along the text, leading to fewer comparisons.

== Right-to-Left Scanning

Unlike KMP or brute-force, Boyer-Moore aligns the pattern with the text and compares the characters from right to left.
- If a mismatch occurs, it uses precomputed tables to shift the pattern as far as possible to the right.
- The shift is determined by two heuristics: the *Bad Character Heuristic* and the *Good Suffix Heuristic*.

== Bad Character Heuristic

When a mismatch occurs at text character `$T[i]$` (which corresponds to pattern character `$P[j]$`), and `$T[i] = c$`, the bad character heuristic proposes a shift based on the last occurrence of character `$c$` in the pattern `$P$`.

- If `$c$` appears in `$P$` to the left of position `$j$`, the pattern is shifted to align this last occurrence of `$c$` with `$T[i]$`.
- If `$c$` does not appear in `$P$` at all, the pattern can be shifted completely past `$T[i]$`.

A *Bad Character (BC)* table is precomputed to store the shift for each character in the alphabet. `$BC[c]` is the distance from the end of the pattern to the last occurrence of `$c$`.

== Good Suffix Heuristic

This heuristic is used when a partial match is found. Suppose the comparison stops at pattern position `$j$` because of a mismatch, but the suffix of the pattern from `$j+1$` to `$m$` (the "good suffix") matched the text.

The good suffix heuristic proposes a shift to align the pattern with the text such that:
1. Another occurrence of the good suffix in the pattern aligns with the matched text segment.
2. If such an occurrence does not exist, the pattern is shifted by the smallest amount to align a prefix of the pattern with a suffix of the good suffix.
3. If no such alignment is possible, the pattern can be shifted completely past the matched segment.

A *Good Suffix (GS)* table is precomputed to store the shift for each possible good suffix length.

== The Algorithm

1. *Preprocessing:*
  - Compute the Bad Character (BC) table.
  - Compute the Good Suffix (GS) table.

2. *Searching:*
  - Align the pattern with the start of the text.
  - Compare the pattern with the text from right to left.
  - If the whole pattern matches, report an occurrence.
  - If a mismatch occurs at `$T[i]` with `$P[j]`, shift the pattern by the maximum of the values given by `$BC[T[i]]$` and `$GS[j]$`.
  - Repeat until the end of the text is reached.

== Boyer-Moore-Horspool

A simpler variant of the Boyer-Moore algorithm, proposed by Nigel Horspool in 1980. It uses only a modified version of the bad character heuristic.
- When a mismatch occurs, the shift is determined by the text character corresponding to the *last* character of the pattern, regardless of where the mismatch happened.
- This is simpler to implement and performs well in practice, though its worst-case complexity is higher.

== Tasks

1. For the pattern `$P = "needle"`, and a mismatch with the character 'e' in the text, what would the Bad Character shift be?
2. What is the main advantage of the right-to-left scan in the Boyer-Moore algorithm?
3. How does the Boyer-Moore-Horspool algorithm simplify the original Boyer-Moore algorithm?

#pagebreak()

== Solutions

=== Task 1: Bad Character Shift for "needle"

Pattern `$P = "needle"`. Let's say the comparison is with a text window and the mismatching character is 'e'.
The last occurrence of 'e' in "needle" is at index 4 (0-indexed). The length of the pattern is 6.
The distance from the end is `$m - 1 - 4 = 6 - 1 - 4 = 1$`.
The Bad Character table for 'e' would indicate a shift of 1. So, the pattern would be shifted one position to the right.

=== Task 2: Advantage of Right-to-Left Scan

The right-to-left scan allows the algorithm to make larger jumps. When a mismatch occurs early in the comparison (i.e., far to the right of the pattern), the algorithm can use information about the text character to shift the pattern by a significant amount. For example, if the mismatched text character does not appear in the pattern at all, the pattern can be shifted completely past that character, skipping many potential alignments that a left-to-right scan would have to check.

=== Task 3: Boyer-Moore-Horspool Simplification

The Boyer-Moore-Horspool algorithm simplifies the original Boyer-Moore algorithm by completely eliminating the Good Suffix Heuristic. It relies solely on a modified version of the Bad Character Heuristic. The shift is always based on the text character that aligns with the last character of the pattern. This makes the preprocessing and the main loop simpler, as there is no need to compute the complex Good Suffix table or to calculate the maximum of two different shift values.
