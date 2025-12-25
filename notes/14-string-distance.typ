
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

= String Distance Metrics

== Introduction

In many applications, we need to quantify how different two strings are. This is done using *string distance metrics*. A metric `d(s1, s2)` is a function that takes two strings and returns a real number, satisfying certain properties (non-negativity, identity of indiscernibles, symmetry, and triangle inequality).

== Hamming Distance

The *Hamming distance* is defined for two strings of *equal length*. It is the number of positions at which the corresponding characters are different.

#box(
  stroke: 1pt + black,
  inset: 8pt,
)[
  *Example:*
  - `d_H("karolin", "kathrin") = 3` (differences at positions 2, 4, 5).
  - `d_H("apple", "apply") = 1`.
]

== Levenshtein Distance

The *Levenshtein distance* is defined for two strings of *any length*. It is the minimum number of single-character edits (*insertions* or *deletions*) required to change one string into the other.

- `d_L(s1, s2)` = minimum number of insertions and deletions to transform `s1` to `s2`.

#box(
  stroke: 1pt + black,
  inset: 8pt,
)[
  *Example:*
  To transform "saturday" to "sunday":
  1. "saturday" $arrow.r$ "s*u*turday" (delete 'a', 't')
  2. "suturday" $arrow.r$ "sunday" (insert 'n')
  This is not optimal. A better way:
  "saturday" $arrow.r$ "sunday" requires 3 changes (2 deletions, 1 insertion).
  The Levenshtein distance `d_L("saturday", "sunday")` is 3.
]

== Edit Distance

The *Edit Distance*, also known as Levenshtein distance with substitution, includes a third operation: *replacement* (or substitution) of a character.
- `d_E(s1, s2)` = minimum number of insertions, deletions, or replacements to transform `s1` to `s2`.

Usually, the cost of each operation is 1.

== Wagner-Fischer Algorithm

The edit distance is commonly computed using a dynamic programming approach known as the *Wagner-Fischer algorithm*. It uses a matrix `D` of size `(m+1) x (n+1)`, where `m` and `n` are the lengths of the two strings.

- `D[i, j]` stores the edit distance between the first `i` characters of string 1 and the first `j` characters of string 2.
- The matrix is filled based on the recurrence relation:
  `$D[i, j] = min(
      D[i-1, j] + 1, // deletion
      D[i, j-1] + 1, // insertion
      D[i-1, j-1] + cost(s1[i], s2[j])
  )$`
  where `cost` is 0 if the characters are the same, and 1 otherwise.

The value `D[m, n]` contains the edit distance between the two full strings. The time and space complexity is `$O(m*n)$`.

== Longest Common Subsequence (LCS)

The problem of finding the *Longest Common Subsequence (LCS)* is closely related to edit distance. The length of the LCS of two strings can be calculated from their Levenshtein distance.
- `|LCS(s1, s2)| = ( |s1| + |s2| - d_L(s1, s2) ) / 2`

== Tasks

1. Calculate the Hamming distance between "1011101" and "1001001".
2. What are the three basic operations considered in the standard Edit Distance?
3. Fill the first row and first column of the dynamic programming matrix for computing the edit distance between "cat" and "dog".

#pagebreak()

== Solutions

=== Task 1: Hamming Distance

Strings: "1011101" and "1001001"
They have the same length (7).
- Position 2: 1 vs 0 (different)
- Position 4: 1 vs 0 (different)
- Position 5: 0 vs 0 (same)
The Hamming distance is 2.

=== Task 2: Edit Distance Operations

The three basic operations for the standard (Levenshtein) edit distance are:
1. *Insertion*: Adding a character to a string.
2. *Deletion*: Removing a character from a string.
3. *Substitution* (or Replacement): Changing one character to another.

Each of these operations is typically assigned a cost of 1.

=== Task 3: DP Matrix for "cat" and "dog"

Let `s1 = "cat"` and `s2 = "dog"`. The matrix `D` will be 4x4.
The first row and column are initialized based on the cost of insertions and deletions to transform a prefix into an empty string.

- `D[0, 0] = 0` (distance from empty to empty is 0).
- First row (deletions from "cat" to empty):
  - `D[0, 1] = 1` ("c" to "")
  - `D[0, 2] = 2` ("ca" to "")
  - `D[0, 3] = 3` ("cat" to "")
- First column (insertions to create "dog" from empty):
  - `D[1, 0] = 1` ("" to "d")
  - `D[2, 0] = 2` ("" to "do")
  - `D[3, 0] = 3` ("" to "dog")

The initialized matrix would start like this:
```
  ε d o g
ε 0 1 2 3
c 1
a 2
t 3
```
