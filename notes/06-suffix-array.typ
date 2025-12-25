
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm)
)

#set heading(numbering: "1.1")

= Suffix Array

== Introduction

A *Suffix Array* is a data structure that provides a space-efficient alternative to suffix trees. It was introduced by Udi Manber and Gene Myers in 1990. A suffix array stores all suffixes of a text in lexicographical order. While it is slower for some operations than a suffix tree, its smaller memory footprint makes it a valuable tool for many string processing tasks, especially in bioinformatics.

== Definition

A suffix array `SA` for a text `$T$ of length $n$` is an array of integers of length `$n$`, which stores the starting positions of all suffixes of `$T$` in lexicographical order.

- `$SA[i]$` is the starting position of the `$i$`-th suffix in the lexicographically sorted list of all suffixes.
- Formally, for a text `$T$`, let `$T_j$` denote the suffix of `$T$` starting at position `$j$`. Then `$T_SA[0], T_SA[1], ..., T_SA[n-1]$` is the sorted sequence of suffixes of `$T$`.

#box(
  stroke: 1pt + black,
  inset: 8pt,
)[
  *Example:*
  Let the text be `$T = "banana"$`. The suffixes are:
  - `"banana"` (starting at 0)
  - `"anana"` (starting at 1)
  - `"nana"` (starting at 2)
  - `"ana"` (starting at 3)
  - `"na"` (starting at 4)
  - `"a"` (starting at 5)

  Lexicographically sorted suffixes:
  1. `"a"` (from index 5)
  2. `"ana"` (from index 3)
  3. `"anana"` (from index 1)
  4. `"banana"` (from index 0)
  5. `"na"` (from index 4)
  6. `"nana"` (from index 2)

  The suffix array is `$SA = (5, 3, 1, 0, 4, 2)$`.
]

== Inverse Suffix Array (ISA)

The *Inverse Suffix Array*, often denoted as `ISA` or `Rank`, is an array that for each suffix, gives its lexicographical rank.

- `ISA[i] = j` if and only if `SA[j] = i`.
- In other words, `ISA[i]` stores the rank of the suffix starting at position `i`.
- The `ISA` can be computed from the `SA` in `$O(n)$` time and vice-versa.

#box(
  stroke: 1pt + black,
  inset: 8pt,
  [*Example:*]
  For `$T = "banana"` and `$SA = (5, 3, 1, 0, 4, 2)$`:
  - `ISA[0]` (rank of "banana") = 3
  - `ISA[1]` (rank of "anana") = 2
  - `ISA[2]` (rank of "nana") = 5
  - `ISA[3]` (rank of "ana") = 1
  - `ISA[4]` (rank of "na") = 4
  - `ISA[5]` (rank of "a") = 0
  So, `$ISA = (3, 2, 5, 1, 4, 0)$`.
)

== Searching for a Pattern

A pattern `$P$` of length `$m$` can be found in the text `$T$` by performing a binary search on the suffix array.

- The time complexity of a simple binary search is `$O(m log n)$`, as each comparison takes `$O(m)$` time.
- This can be improved by using the LCP array.

== LCP Array

The *LCP (Longest Common Prefix) array* stores the length of the longest common prefix between adjacent suffixes in the sorted suffix array.

- `$LCP[i]$` is the length of the LCP between the suffixes starting at `$SA[i-1]$` and `$SA[i]$`.
- `$LCP[0]$` is usually undefined or set to 0.

#box(
  stroke: 1pt + black,
  inset: 8pt,
  [*Example:*]
  For `$T = "banana"`, `$SA = (5, 3, 1, 0, 4, 2)$`.
  Sorted suffixes:
  - `i=0`: `"a"`
  - `i=1`: `"ana"` (LCP with `"a"` is 1) -> `$LCP[1]=1$`
  - `i=2`: `"anana"` (LCP with `"ana"` is 3) -> `$LCP[2]=3$`
  - `i=3`: `"banana"` (LCP with `"anana"` is 0) -> `$LCP[3]=0$`
  - `i=4`: `"na"` (LCP with `"banana"` is 0) -> `$LCP[4]=0$`
  - `i=5`: `"nana"` (LCP with `"na"` is 2) -> `$LCP[5]=2$`
  The LCP array is `$LCP = (0, 1, 3, 0, 0, 2)$`.
)

The LCP array can be computed in `$O(n)$` time using Kasai's algorithm, given the text and the suffix array.

== Tasks

1. Construct the Suffix Array (SA) for the text `$T = "abracadabra"`.
2. Given the SA from the previous task, construct the Inverse Suffix Array (ISA).
3. Given the SA and ISA, construct the LCP array for `$T = "abracadabra"`.

#pagebreak()

== Solutions

=== Task 1: Suffix Array for "abracadabra"

Text `$T = "abracadabra"`, length `$n=11$`.
Suffixes:
- 0: `abracadabra`
- 1: `bracadabra`
- 2: `racadabra`
- 3: `acadabra`
- 4: `cadabra`
- 5: `adabra`
- 6: `dabra`
- 7: `abra`
- 8: `bra`
- 9: `ra`
- 10: `a`

Sorted suffixes:
1. `a` (10)
2. `abra` (7)
3. `abracadabra` (0)
4. `acadabra` (3)
5. `adabra` (5)
6. `bra` (8)
7. `bracadabra` (1)
8. `cadabra` (4)
9. `dabra` (6)
10. `ra` (9)
11. `racadabra` (2)

Suffix Array `$SA = (10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2)$`.

=== Task 2: Inverse Suffix Array for "abracadabra"

Using `$SA = (10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2)$`:
- `ISA[10] = 0`
- `ISA[7] = 1`
- `ISA[0] = 2`
- `ISA[3] = 3`
- `ISA[5] = 4`
- `ISA[8] = 5`
- `ISA[1] = 6`
- `ISA[4] = 7`
- `ISA[6] = 8`
- `ISA[9] = 9`
- `ISA[2] = 10`

Inverse Suffix Array `$ISA = (2, 6, 10, 3, 7, 4, 8, 1, 5, 9, 0)$`.

=== Task 3: LCP Array for "abracadabra"

Sorted suffixes and their LCPs:
- `i=0`: `a`
- `i=1`: `abra` (LCP with `a` is 1) -> `$LCP[1]=1$`
- `i=2`: `abracadabra` (LCP with `abra` is 4) -> `$LCP[2]=4$`
- `i=3`: `acadabra` (LCP with `abracadabra` is 1) -> `$LCP[3]=1$`
- `i=4`: `adabra` (LCP with `acadabra` is 1) -> `$LCP[4]=1$`
- `i=5`: `bra` (LCP with `adabra` is 0) -> `$LCP[5]=0$`
- `i=6`: `bracadabra` (LCP with `bra` is 3) -> `$LCP[6]=3$`
- `i=7`: `cadabra` (LCP with `bracadabra` is 0) -> `$LCP[7]=0$`
- `i=8`: `dabra` (LCP with `cadabra` is 0) -> `$LCP[8]=0$`
- `i=9`: `ra` (LCP with `dabra` is 0) -> `$LCP[9]=0$`
- `i=10`: `racadabra` (LCP with `ra` is 2) -> `$LCP[10]=2$`

LCP Array `$LCP = (0, 1, 4, 1, 1, 0, 3, 0, 0, 0, 2)$`.
