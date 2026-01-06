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

  Let Text `T = ...GATTAG...` and Pattern `P = CABTAA`.
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
  A "good suffix" is the part of the pattern that matched the text before a mismatch occurred.

  Let Text `T = ...AGCTAG...` and Pattern `P = TAGATAG`.
  We align `P` with `T` and compare from right to left.
  ```
  Text:    ... A G C T A G
  Pattern:   T A G A T A G
  ```
  1. `G` vs `G`: Match.
  2. `A` vs `A`: Match.
  3. `T` vs `T`: Match.
  4. `C` vs `A`: Mismatch. The character `C` in the text is the "bad character".

  The part that matched is `TAG`. This is our *good suffix*. It starts at index 4 in `P`.

  The algorithm now looks for another occurrence of `TAG` within `P = TAGATAG`.
  - It finds one at the very beginning (index 0).

  To align this other occurrence with the `TAG` found in the text, the pattern is shifted.
  The shift amount is the distance between the two occurrences in the pattern:
  `shift = (start of good suffix) - (start of other occurrence) = 4 - 0 = 4`.

  ```
  Text:      ... A G C T A G ...
  Pattern:     T A G A T A G          (Before shift)
  Pattern:             T A G A T A G  (After shift)
  ```
]

#example_box(title: "Example: Good Suffix Heuristic (Case 2)")[

  This case applies if the good suffix itself doesn't reappear in the pattern.

  Let Text `T = ...ACXTATG...` and Pattern `P = GTAGGTATG`.
  We align `P` with `T` and compare from right to left.
  ```
  Text:      ... A C X T A T G
  Pattern:   G T A G G T A T G
  ```
  A right-to-left comparison finds a partial match.
  - The suffix `TATG` of the pattern matches the text.
  - A mismatch occurs at the next character: `X` in the text vs. `G` in the pattern.

  The *good suffix* is `t = "TATG"`.

  *Step 1: Check for another `TATG` in `P = GTAGGTATG`.*
  There are no other occurrences. Case 1 does not apply.

  *Step 2: Find the longest prefix of `P` that is a suffix of `t`.*
  - Good Suffix `t`: `TATG`
  - Suffixes of `t`: `TATG`, `ATG`, `TG`, `G`.
  - Prefixes of `P`: `G`, `GT`, `GTA`, `GTAG`, ...

  The longest string that is in both lists is `"G"`.

  The algorithm shifts the pattern to align this prefix (`"G"`) with the corresponding suffix of the good suffix in the text.
  The shift amount is `m - |prefix| = 9 - 1 = 8`.

  ```
  Text:      ... A C X T A T G ...
  Pattern:   G T A G G T A T G  (Before shift)
  Pattern:                   G T A G G T A T G  (After shift)
  ```
]


=== Preprocessing

==== Bad Character Table ($"bc"$)
A table $"bc"$ of size $|Sigma|$ is created. For each character $c$ in the alphabet, $"bc"[c]$ stores the index of its rightmost occurrence in the pattern $P$. If $c$ is not in the pattern, its entry is typically set to -1. The shift is then calculated as $max(1, j - "bc"[T[i]])$, where $j$ is the mismatch position in the pattern and $T[i]$ is the "bad character" in the text.

This table can be computed in $O(m + |Sigma|)$ time:
1. Initialize all entries in $"bc"$ to -1.
  $"for" c "in" Sigma: "bc"[c] = -1$
2. Iterate through the pattern from left to right, and for each character, record its index.
  $"for" j "from" 0 "to" m-1: "bc"[P[j]] = j$

Since the loop proceeds from left to right, any character that appears multiple times will have its entry in $"bc"$ correctly overwritten with the index of its rightmost occurrence.

==== Good Suffix Table ($"gs"$)
The computation of the good suffix table is the most complex part of the preprocessing. The goal is to create a table $"gs"$ where $"gs"[j]$ stores the shift for the pattern when a mismatch occurs at position $j-1$ and the suffix $P[j..m-1]$ (the "good suffix") has matched. The computation can be done in $O(m)$ time using border arrays.

The overall shift is the maximum of the shifts proposed by the two cases of the good suffix heuristic. A common way to implement this involves two auxiliary arrays.

*Case 1 Preprocessing (Aligning with Another Occurrence)*

This case handles finding another occurrence of the good suffix $t = P[j..m-1]$ in the pattern.

- To find all suffixes of $P$ that match other substrings of $P$ efficiently, we can use a clever trick involving the border array of the *reversed* pattern, $P^R$.
- By computing the border array for $P^R$, we can determine, for each position, the length of the suffix of $P$ ending there that also appears elsewhere.
- Using this information, we can populate table $"gs"_1$, which stores the shift value for each good suffix length covered by Case 1.

*Case 2 Preprocessing (Aligning with a Border)*

This case handles situations where the good suffix does not reappear, so we must align a *border* of the pattern (a prefix that is also a suffix) with the end of the good suffix in the text.

- First, we compute the standard `border` array (often denoted $b$) for the pattern $P$, where $b[i]$ is the length of the longest proper border of $P[0..i]$. This can be done in $O(m)$ time using an algorithm similar to KMP's prefix function.
- Let the good suffix be $t = P[j..m-1]$. We are looking for the longest border of the whole pattern $P$, say $p_"border"$, that is also a suffix of $t$.
- We can precompute a table, say $"gs"_2$, where $"gs"_2[j]$ stores the length of the longest border of $P$ that is a suffix of $P[j..m-1]$.
- This can be computed by iterating through the border array of $P$. The $"gs"$ table is filled from right to left with $m - b[m-1]$ for the longest border, then $m - b[b[m-1]-1]$ for the next longest, and so on.

*3. Combining for the Final $"gs"$ Table*

The final $"gs"$ table is constructed by taking the maximum of the shifts from both cases for each position.

This ensures that for any good suffix, we take the shift that moves the pattern the furthest to the right. The entire process, while intricate, can be optimized to run in $O(m)$ time.

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

== Boyer-Moore-Horspool Variant

A popular and practical simplification of the Boyer-Moore algorithm was proposed by R. Nigel Horspool in 1980. It eliminates the complex Good Suffix heuristic, making it easier to implement while maintaining excellent performance on average.

=== The Core Idea

The Horspool algorithm uses only one heuristic, which is a modified version of the Bad Character rule. The key insight is that the Good Suffix heuristic's main role is to guarantee that the pattern always shifts to the right. Horspool modifies the Bad Character rule to ensure this, removing the need for the Good Suffix table.

=== The Horspool Heuristic

The shift is *always* determined by the text character aligned with the *last* character of the pattern, let's call this character $c$. This is true regardless of where the mismatch (if any) occurred during the right-to-left comparison.

The shift amount is the distance from the end of the pattern to the rightmost occurrence of $c$ in the prefix of the pattern, i.e., excluding the last character.

=== Preprocessing - The Shift Table

A single shift table (let's call it `shift`) is precomputed. It stores the shift value for each character in the alphabet.

1. Initialize the shift table for all characters to the length of the pattern, $m$.
  $ "for" c "in" Sigma: "shift"[c] = m $

2. For each character in the pattern's prefix (all but the last character), update its entry in the shift table. The value is the distance from that character's position to the end of the pattern's prefix.
  $ "for" j "from" 0 "to" m-2: "shift"[P[j]] = m - 1 - j $

#example_box(title: "Shift Table for P = 'TAGATAG'")[
  Let `P = TAGATAG`, so `m=7`.
  - The prefix is `TAGATA` (length 6).
  - Initialize all shifts to 7.
  - `for j from 0 to 5`: `shift[P[j]] = 7 - 1 - j`
    - `j=0, P[0]='T'`: `shift['T'] = 6`
    - `j=1, P[1]='A'`: `shift['A'] = 5`
    - `j=2, P[2]='G'`: `shift['G'] = 4`
    - `j=3, P[3]='A'`: `shift['A'] = 3` (overwrites previous)
    - `j=4, P[4]='T'`: `shift['T'] = 2` (overwrites previous)
    - `j=5, P[5]='A'`: `shift['A'] = 1` (overwrites previous)
  - The final table (for relevant chars): $"shift"['T']=2, "shift"['A']=1, "shift"['G']=4$. All other alphabet characters have a shift of 7.
]

=== The Search Algorithm

1. Align the pattern with the start of the text.
2. Repeat until the pattern goes past the end of the text:
  - Let $c$ be the character in the text aligned with the last character of the pattern, $P[m-1]$.
  - Compare the pattern with the text from right to left.
  - If the whole pattern matches, report an occurrence.
  - Regardless of whether there was a match or a mismatch, shift the pattern to the right by $"shift"[c]$.

=== Complexity

- *Preprocessing:* $O(m + |Sigma|)$
- *Worst-Case Performance:* $O(n m)$. This is worse than the original Boyer-Moore and happens with periodic patterns (e.g., text $a^n$ and pattern $a^m$).
- *Average Performance:* Excellent, often approaching $O(n/m)$ for random text and large alphabets, making it one of the fastest algorithms in practice.

Because of its simplicity and great average-case speed, the Horspool variant is often preferred over the full Boyer-Moore algorithm for many applications.

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
The last occurrence of 'e' in "needle" is at index 5 (0-indexed). The length of the pattern is 6.
The distance from the end is $m - 1 - 5 = 6 - 1 - 5 = 0$.
The Bad Character table for 'e' would indicate a shift of 0. That's why max has to be used.

=== Solution 2
The right-to-left scan allows the algorithm to make larger jumps. When a mismatch occurs early in the comparison (i.e., far to the right of the pattern), the algorithm can use information about the text character to shift the pattern by a significant amount. For example, if the mismatched text character does not appear in the pattern at all, the pattern can be shifted completely past that character, skipping many potential alignments that a left-to-right scan would have to check.

=== Solution 3
The Boyer-Moore-Horspool algorithm simplifies the original Boyer-Moore algorithm by completely eliminating the Good Suffix Heuristic. It relies solely on a modified version of the Bad Character Heuristic. The shift is always based on the text character that aligns with the last character of the pattern. This makes the preprocessing and the main loop simpler, as there is no need to compute the complex Good Suffix table or to calculate the maximum of two different shift values.

#pagebreak()
