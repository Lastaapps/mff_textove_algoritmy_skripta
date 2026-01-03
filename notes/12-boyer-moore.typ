#import "../definitions.typ": *

= Boyer-Moore Algorithm

== Introduction

The *Boyer-Moore algorithm* is a highly efficient string searching algorithm, developed by Robert S. Boyer and J Strother Moore in 1977. It is considered one of the fastest string searching algorithms in practice.

The key idea is to start comparisons from the end of the pattern, rather than the beginning. This allows for larger shifts of the pattern along the text, leading to fewer comparisons.

== Right-to-Left Scanning

Unlike KMP or brute-force, Boyer-Moore aligns the pattern with the text and compares the characters from right to left.
- If a mismatch occurs, it uses precomputed tables to shift the pattern as far as possible to the right.
- The shift is determined by two heuristics: the *Bad Character Heuristic* and the *Good Suffix Heuristic*.

== Bad Character Heuristic

When a mismatch occurs, suppose the text character is $c$ and it aligns with pattern character $p$. The "bad character" is $c$. The heuristic proposes a shift based on the last occurrence of $c$ in the pattern *before* the mismatch position.

- Let the mismatch occur at index $j$ of the pattern $P$. We look for the rightmost occurrence of character $c$ in $P[0..j-1]$. Let this be at index $k$. The pattern is shifted so that $P[k]$ aligns with text character $c$. Shift = $j-k$.
- If $c$ does not appear in $P[0..j-1]$, the pattern is shifted completely past the mismatch position. Shift = $j+1$.

In practice, a simpler version is often used where the shift is based on the rightmost occurrence of $c$ anywhere in the pattern (this is the Boyer-Moore-Horspool variant).

#example_box(title: "Example: Bad Character Heuristic")[

  Let Text `T = ...G*A*TTAG...` and Pattern `P = C*A*BTAA`.
  The scan goes from right to left.
  - `A` vs `G`: Mismatch. The bad character in the text is `G`. `G` does not appear in `P`. We can shift the entire pattern past this point. Shift = length of P = 6.
]


== Good Suffix Heuristic

This heuristic is triggered when a mismatch occurs after a partial match. Let $t$ be the suffix of the pattern that matched the text correctly (the "good suffix"). The algorithm proposes a shift based on other occurrences of this good suffix.

#info_box(title: "The Two Cases of Good Suffix Shift")[
  *Case 1: The good suffix appears elsewhere in the pattern.*
  Shift the pattern to align the text's good suffix with the *rightmost* other occurrence of that same suffix in the pattern. This other occurrence must not be a suffix of the pattern itself.

  *Case 2: The good suffix does not appear elsewhere, but a prefix of the pattern matches a suffix of the good suffix.*
  If an exact match for the good suffix is not found, shift the pattern to the right to align the longest prefix of the pattern that is also a suffix of the good suffix.
]

The algorithm always takes the maximum of the shifts proposed by the Bad Character and Good Suffix heuristics.

#example_box(title: "Example: Good Suffix Heuristic (Case 1)")[

  Let Text `T = ...CTA*G*TAG...` and Pattern `P = GTA*A*TAG`.
  - Mismatch at `A` vs `G`. The good suffix `t` that matched is `"TAG"`.
  - The algorithm looks for another occurrence of `"TAG"` in `P`. It finds one at the beginning: `P = G*TAA*TAG`.
  - The pattern is shifted right to align this second occurrence with the text. The shift is 4.

  ```
  Text:    ...CTA*G*TAG...
  Pattern:   GTA*A*TAG
  Shift ->       GTAATAG
  ```
]

#example_box(title: "Example: Good Suffix Heuristic (Case 2)")[

  Let Text `T = ...GCA*T*AAGC...` and Pattern `P = TTA*A*AAGC`.
  - Mismatch at `A` vs `T`. The good suffix is `t = "AAGC"`.
  - Let's assume `"AAGC"` does not appear elsewhere in `P`.
  - Now, we check for a prefix of `P` that is a suffix of `t`. The longest such prefix is `"AAGC"` -> `"AGC"` -> `"GC"` -> `"C"`. Let's say `P` starts with `GC...`: `P = GC...TAAAAGC`.
  - The pattern is shifted to align the prefix `GC` with the suffix `GC` of the matched part of the text.

  ```
  Text:    ...GCATA*A*AGC...
  Pattern:   TTAAA*A*AGC
  Shift ->       TTAAAAGC  // (Assuming no other rule gives a larger shift)
  ```
]


=== Preprocessing

==== Bad Character Table
A table `bc` of size $|Sigma|$ is created. `bc[c]` stores the index of the rightmost occurrence of character `c` in the pattern. If `c` is not in the pattern, it's set to -1. This takes $O(m + |Sigma|)$ time.

==== Good Suffix Table
This is more complex and requires two arrays, `gs` (the good suffix shifts) and a helper array `suff`.

1. *Compute `suff` array:* `suff[i]` is the length of the longest suffix of $P$ that starts at position $i$. This can be computed in $O(m)$ time by comparing the pattern with its suffixes. A simpler way is to note that `suff[i]` is the length of the longest common prefix between $P$ and $P[i..m-1]$.

2. *Compute `gs` for Case 1:*
  For each $i$ from $0$ to $m-1$, if `suff[i] > 0`, it means we found a good suffix of length `k = suff[i]` ending at position $i+k-1$. We can set `gs[m-k]` to the shift `m - 1 - i`. We iterate from right to left to ensure we get the rightmost occurrence.

3. *Compute `gs` for Case 2:*
  For this case, we need the lengths of the pattern's borders (prefixes that are also suffixes). Let `j` be the length of the longest border of $P$. For all positions in `gs` that were not filled by Case 1, we set the shift to `m - j`. This is the safe shift that aligns the pattern's border with the tail of the good suffix.

This entire preprocessing for the `gs` table can be done in $O(m)$ time.

== The Algorithm

1. *Preprocessing:*
  - Compute the Bad Character (BC) table.
  - Compute the Good Suffix (GS) table.

2. *Searching:*
  - Align the pattern with the start of the text.
  - Compare the pattern with the text from right to left.
  - If the whole pattern matches, report an occurrence.
  - If a mismatch occurs at $T[i]$ with $P[j]$, shift the pattern by the maximum of the values given by $"BC"[T[i]]$ and $"GS"[j]$.
  - Repeat until the end of the text is reached.

== Boyer-Moore-Horspool

A simpler variant of the Boyer-Moore algorithm, proposed by Nigel Horspool in 1980. It uses only a modified version of the bad character heuristic.
- When a mismatch occurs, the shift is determined by the text character corresponding to the *last* character of the pattern, regardless of where the mismatch happened.
- This is simpler to implement and performs well in practice, though its worst-case complexity is higher.

== Tasks

=== Task 1
For the pattern $P = "needle"$, and a mismatch with the character 'e' in the text, what would the Bad Character shift be?

=== Task 2
What is the main advantage of the right-to-left scan in the Boyer-Moore algorithm?

=== Task 3
How does the Boyer-Moore-Horspool algorithm simplify the original Boyer-Moore algorithm?

#pagebreak()

== Solutions

=== Solution 1
Pattern $P = "needle"$. Let's say the comparison is with a text window and the mismatching character is 'e'.
The last occurrence of 'e' in "needle" is at index 4 (0-indexed). The length of the pattern is 6.
The distance from the end is $m - 1 - 4 = 6 - 1 - 4 = 1$.
The Bad Character table for 'e' would indicate a shift of 1. So, the pattern would be shifted one position to the right.

=== Solution 2
The right-to-left scan allows the algorithm to make larger jumps. When a mismatch occurs early in the comparison (i.e., far to the right of the pattern), the algorithm can use information about the text character to shift the pattern by a significant amount. For example, if the mismatched text character does not appear in the pattern at all, the pattern can be shifted completely past that character, skipping many potential alignments that a left-to-right scan would have to check.

=== Solution 3
The Boyer-Moore-Horspool algorithm simplifies the original Boyer-Moore algorithm by completely eliminating the Good Suffix Heuristic. It relies solely on a modified version of the Bad Character Heuristic. The shift is always based on the text character that aligns with the last character of the pattern. This makes the preprocessing and the main loop simpler, as there is no need to compute the complex Good Suffix table or to calculate the maximum of two different shift values.

#pagebreak()
