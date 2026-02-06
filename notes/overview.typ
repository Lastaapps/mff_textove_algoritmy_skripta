#import "../definitions.typ": *

= Overview

== Other sources
- #link("https://github.com/Lastaapps/mff_textove_algoritmy_skripta")[Latest version] of this lecture notes.
- #link("https://wiki.matfyz.cz/NTIN087")[Matfyz Wiki] page.
- Martin Mareš lecture notes on #link("https://mj.ucw.cz/vyuka/dsnotes/")[Strings].

== Exact String Matching (Online)
These algorithms find occurrences of a pattern $p$ (length $m$) in a text $x$ (length $n$) without preprocessing the text $x$.
#table(
  columns: (auto, auto, auto, auto, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header(
    [*Algorithm*], [*Strategy*], [*Time*], [*Space*], [*Key Insight*]
  ),

  [Knuth-Morris-Pratt (KMP)],
  [Prefix],
  [$Theta(n+m)$],
  [$Theta(m)$],
  [Shifts based on the longest prefix],

  [Boyer-Moore (BM)],
  [Suffix],
  [$O(n m)$ \ $Omega(n/m)$],
  [$Theta(|Sigma| + m)$],
  [Matches right-to-left. Uses *Bad Character* and *Good Suffix* heuristics to skip text.],

  [Horspool],
  [Suffix],
  [$O(n m)$ \ $Omega(n/m)$],
  [$Theta(|Sigma|)$],
  [Simplified BM. Uses only the *Bad Character* heuristic.],

  [Rabin-Karp],
  [Hashing],
  [$O(m n)$],
  [$O(1)$],
  [Uses rolling hashes to compare strings.],

  [Shift-Or],
  [Bit-Parallel],
  [$Theta(n ceil(m/w))$],
  [$Theta(|Sigma| ceil(m/w))$],
  [Uses bitwise masks and operations. Very fast for $m <= w$ (word size).],
)

== Multiple Pattern Matching
Finding occurrences of a set of patterns $P = {p_1, dots, p_r}$ in text $x$. Here, $z$ denotes the total number of pattern occurrences.

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header([*Algorithm*], [*Basis*], [*Complexity*], [*Key Insight*]),
  [Aho-Corasick (AC)],
  [Trie + KMP],
  [$O(n log |Sigma| + z)$],
  [Builds a Trie of patterns with *failure links*. Generalizes KMP to sets of strings.],

  [Commentz-Walter],
  [Trie + BM],
  [$O(n dot max{|p_1|, dots, |p_r|})$],
  [Generalizes Boyer-Moore to sets. Uses a reversed trie and heuristics to shift.],

  [Generalized Rabin-Karp],
  [Hashing],
  [$O(n + z m)$],
  [Hashes all patterns into a set and checks text window.],
)

== String Distance Metrics
Measuring the "difference" between two strings.

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header([*Metric/Algorithm*], [*Measures*], [*Time*], [*Key Insight*]),
  [Hamming Distance],
  [Mismatches in strings of equal length.],
  [$O(n)$],
  [Simple character-by-character comparison.],

  [Levenshtein / Edit Distance],
  [Insertions, Deletions, Substitutions.],
  [$O(n m)$],
  [Classic DP solution (Wagner-Fischer algorithm).],

  [Ukkonen-Myers],
  [Edit Distance],
  [$O(d n)$],
  [Optimizes DP by only computing prospective diagonals. Fast when distance $d$ is small.],

  [LCS Distance],
  [Insertions and Deletions only.],
  [$O(n m)$],
  [$d_L = |A| + |B| - 2 |"LCS"(A, B)|$],
)

== Approximate Pattern Matching (Local Alignment)
Finding occurrences of $p$ in $x$ with at most $k$ errors.

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header([*Algorithm*], [*Time*], [*Space*], [*Key Insight*]),
  [DP approach],
  [$O(n m)$],
  [$O(n m)$],
  [Modifies Wagner-Fischer. First column initialized to 0, allowing matches to start anywhere.],

  [Approx. Shift-Or],
  [$O(n ceil(m/w))$],
  [$O(|Sigma| ceil(m/w))$],
  [Extends Shift-Or. Uses bit counters (columns of bits) to track mismatches. Fast for small $k$.],

  [Wu-Manber],
  [$O(k ceil(m/w) n)$],
  [$O(|Sigma| ceil(m/w))$],
  [Flexible bit-parallel DP. Can handle Levenshtein distance and regular expressions.],
)

== Regular Expression Matching
Finding substrings that match a pattern defined by a regular expression $v$ of size $m$.

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header([*Method*], [*Strategy*], [*Complexity*], [*Key Insight*]),
  [NFA Simulation],
  [Regex -> NFA -> Simulation],
  [Search: $O(m n)$],
  [Build NFA (e.g., Thompson's) and simulate active states for each text character.],

  [DFA Simulation],
  [Regex -> NFA -> DFA -> Simulation],
  [Search: $O(n)$],
  [Convert NFA to an equivalent DFA for linear-time search. Construction can be exponential.],

  [Bit-Parallel NFA],
  [Bitwise NFA Simulation],
  [Search: $O(m n / w)$],
  [Simulates the NFA using bit vectors, very fast for $m <= w$.],

  [Filtering],
  [Filter + Verify],
  [Varies (often sublinear)],
  [Quickly find mandatory substrings, then verify full regex match locally (e.g., grep).],
)

== Text Indexing (Offline)
Preprocessing text $x$ to allow fast queries.

=== Suffix Trees
A compressed trie of all suffixes.
- *Space:* $Theta(n)$ words (typically $10n - 30n$ bytes).
- *Search Time:* $O(m)$ or $O(m log |Sigma|)$.
- *Construction Algorithms:*
  - *Weiner / McCreight:* $O(n log |Sigma|)$. Inserts suffixes from longest to shortest.
  - *Ukkonen:* $O(n log |Sigma|)$. Online (left-to-right). Uses *suffix links* and *open edges* (representing suffixes extending to the current end).
  - *Farach:* $O(n)$ for integer alphabets. Uses divide & conquer (merging odd/even trees).

=== Suffix Arrays (SA)
An array of integers representing the lexicographical order of suffixes.
- *Space:* $Theta(n)$ integers (usually $4n$ bytes). More compact than trees.
- *Search Time:* $O(m log n)$ (binary search) or $O(m + log n)$ with LCP array.
- *Construction Algorithms:*
  - *Prefix Doubling (Manber-Myers):* $O(n log n)$. Sorts by prefixes of length $2^k$.
  - *DC3 / Kärkkäinen-Sanders:* $Theta(n)$. Recursive divide & conquer (sorts positions $i mod 3 != 0$, then merges with $i mod 3 = 0$).
  - *SA-IS:* Linear time, induced sorting (state-of-the-art).

=== Suffix Automata
- *DAWG:* Minimal deterministic automaton for all suffixes. Minimal vertices ($< 2n$).
- *CDAWG:* Compacted DAWG. Compresses single-child paths. Space often smaller than suffix trees.

=== Compressed Indexes
- *FM-Index:* Based on *Burrows-Wheeler Transform (BWT)*.
  - *Space:* $O(n)$ *bits* (approaches entropy).
  - *Query:* Counts occurrences in $O(m)$ using *Occ* (rank) lookups.
  - *Key Concept:* `Occ(a, i)` counts occurrences of char `a` in `BWT[0..i]`.

== Problem-Solution Mapping
A guide to which structure solves which problem efficiently.

#table(
  columns: (auto, auto, auto, auto),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { luma(230) },
  table.header(
    [*Problem*], [*Definition*], [*Efficient Solution*], [*Complexity*]
  ),
  [Longest Common Substring],
  [Longest string in both $x$ and $y$.],
  [Generalized Suffix Tree of $x \# y \$$],
  [$O(n+m)$],

  [LCA],
  [Lowest Common Ancestor of two suffixes.],
  [Suffix Tree + Preprocessing],
  [$O(1)$ query],

  [LCP],
  [Longest Common Prefix of two suffixes.],
  [Suffix Array + LCP Table + RMQ],
  [$O(1)$ query],

  [Maximal Repeats],
  [Repeats that cannot be extended left/right.],
  [Suffix Tree (internal nodes)],
  [$O(n)$],

  [Palindromes],
  [Maximal palindromes.],
  [Suffix Tree of $x$ and $x^R$ + LCA],
  [$O(n)$],

  [Compression],
  [Lossless compression (LZ77).],
  [Suffix Tree (sliding window) or BWT],
  [$O(n)$],
)
