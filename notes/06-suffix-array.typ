#import "../definitions.typ": *

= Suffix Array

== Introduction

A *Suffix Array* is a data structure that provides a space-efficient alternative to suffix trees. It was introduced by Udi Manber and Gene Myers in 1990. A suffix array stores all suffixes of a text in lexicographical order. While it is slower for some operations than a suffix tree, its smaller memory footprint makes it a valuable tool for many string processing tasks, especially in bioinformatics.

To handle suffixes properly, we usually append a special character that is lexicographically smaller than any other character to the end of the text. Let's denote it with \$ This ensures that no suffix is a prefix of another, which simplifies certain algorithms.

== Definition

A suffix array `SA` for a text $T$ of length $n$ is an array of integers of length $n$, which stores the starting positions of all suffixes of $T$ in lexicographical order.

- $"SA"[i]$ is the starting position of the $i$-th suffix in the lexicographically sorted list of all suffixes.
- Formally, for a text $T$, let $T_j$ denote the suffix of $T$ starting at position $j$. Then $T_"SA"[0], dots, T_"SA"[n-1]$ is the sorted sequence of suffixes of $T$.

#example_box(title: "Example")[
  Let the text be $T = "banana"$. With the special character, $T = "banana\$"$. The suffixes are:
  - 0: "banana\$"
  - 1: "anana\$"
  - 2: "nana\$"
  - 3: "ana\$"
  - 4: "na\$"
  - 5: "a\$"
  - 6: "\$"

  Lexicographically sorted suffixes:
  1. "\$" (from index 6)
  2. "a\$" (from index 5)
  3. "ana\$" (from index 3)
  4. "anana\$" (from index 1)
  5. "banana\$" (from index 0)
  6. "na\$" (from index 4)
  7. "nana\$" (from index 2)

  The suffix array is $"SA" = (6, 5, 3, 1, 0, 4, 2)$.
]

== Suffix Array Construction

=== Naive Construction (SASimple)

The most straightforward way to construct a suffix array is to generate all suffixes and then sort them.

- *Step 1:* Generate all $n$ suffixes of the text $T$.
- *Step 2:* Sort these suffixes lexicographically. Standard sorting algorithms can be used.
- *Step 3:* Store the original starting indices of the sorted suffixes in the suffix array.

The complexity of this approach is dominated by the sorting step. Comparing two suffixes can take up to $O(n)$ time. With $n$ suffixes, sorting takes $O(n^2 log n)$ time using a comparison-based sort like quicksort.

=== Advanced Construction: $O(n log n)$ Method (SAComplex)

A more efficient method builds the suffix array by iteratively comparing prefixes of increasing lengths. This is a simplified version of more complex linear-time algorithms. The main idea is to sort suffixes based on their first $2k$ characters, using the sort order from the first $k$ characters.

The algorithm works as follows:
- We start with sorting suffixes based on their first character. This gives us an initial ordering.
- Then, in each step, we sort the suffixes based on their first $2k$ characters. To do this, we can represent each suffix by a pair of ranks: the rank of its first $k$ characters, and the rank of the following $k$ characters.
- We can then sort the suffixes based on these pairs.
- This process is repeated $log n$ times, doubling the length of the considered prefixes in each step, until the prefixes are long enough to distinguish all suffixes.

This method has a time complexity of $O(n log n)$.

== Inverse Suffix Array (ISA)

The *Inverse Suffix Array*, often denoted as "ISA" or "Rank", is an array that for each suffix, gives its lexicographical rank.

- $"ISA"[i] = j$ if and only if $"SA"[j] = i$.
- In other words, $"ISA"[i]$ stores the rank of the suffix starting at position $i$.
- The $"ISA"$ can be computed from the $"SA"$ in $O(n)$ time and vice-versa.

#example_box(title: "Example")[
  For $T = "banana\$"$ and $"SA" = (6, 5, 3, 1, 0, 4, 2)$:
  - $"ISA"[6]$ (rank of "\$") = 0
  - $"ISA"[5]$ (rank of "a\$") = 1
  - $"ISA"[3]$ (rank of "ana\$") = 2
  - $"ISA"[1]$ (rank of "anana\$") = 3
  - $"ISA"[0]$ (rank of "banana\$") = 4
  - $"ISA"[4]$ (rank of "na\$") = 5
  - $"ISA"[2]$ (rank of "nana\$") = 6
  So, $"ISA" = (4, 3, 6, 2, 5, 1, 0)$.
]

== LCP Array

The *LCP (Longest Common Prefix) array* stores the length of the longest common prefix between adjacent suffixes in the sorted suffix array.

- $"LCP"[i]$ is the length of the LCP between the suffixes starting at $"SA"[i-1]$ and $"SA"[i]$.
- $"LCP"[0]$ is usually undefined or set to 0.

#example_box(title: "Example")[
  For $T = "banana\$"$ and $"SA" = (6, 5, 3, 1, 0, 4, 2)$.
  Sorted suffixes:
  - $i=0$: "\$"
  - $i=1$: "a\$" (LCP with "\$" is 0) $arrow.r$ $L[1]=0$
  - $i=2$: "ana\$" (LCP with "a\$" is 1) $arrow.r$ $L[2]=1$
  - $i=3$: "anana\$" (LCP with "ana\$" is 3) $arrow.r$ $L[3]=3$
  - $i=4$: "banana\$" (LCP with "anana\$" is 0) $arrow.r$ $L[4]=0$
  - $i=5$: "na\$" (LCP with "banana\$" is 0) $arrow.r$ $L[5]=0$
  - $i=6$: "nana\$" (LCP with "na\$" is 2) $arrow.r$ $L[6]=2$
  The LCP array is $"LCP" = (0, 0, 1, 3, 0, 0, 2)$.
]

== LCP Array Construction

A naive way to compute the LCP array would be to compare adjacent suffixes in the suffix array character by character, which would take $O(n^2)$ time in the worst case. A much more efficient method is Kasai's Algorithm.

=== Kasai's Algorithm

Kasai's algorithm computes the LCP array in $O(n)$ time, given the text, the suffix array (SA), and the inverse suffix array (ISA). The algorithm is based on the following observation:

Let $h$ be the LCP of a suffix $T_i$ and its predecessor in the sorted list of suffixes. The LCP of the next suffix $T_i+1$ and its predecessor is at least $h-1$.

The algorithm iterates through the suffixes in the order of their starting positions in the text.

*Algorithm:*
1. Initialize an LCP array and a variable $h=0$.
2. For $i$ from 0 to $n-1$:
  a. Find the rank of the current suffix $T_i$: $"rank" = "ISA"[i]$.
  b. If $"rank"=0$, continue (it has no predecessor).
  c. Find the previous suffix in the sorted order: $j = "SA"["rank"-1]$.
  d. While characters match between $T_i[h..]$ and $T_j[h..]$: $h = h+1$.
  e. Set $"LCP"["rank"] = h$.
  f. If $h>0$, $h = h-1$.

== Searching for a Pattern

A pattern $P$ of length $m$ can be found in the text $T$ by performing a binary search on the suffix array.

- A simple binary search takes $O(m log n)$ time, as each comparison between $P$ and a suffix takes $O(m)$ time.
- With the LCP array, this can be accelerated. By keeping track of the LCP between the pattern and the suffixes at the low, mid, and high pointers of the binary search, we can avoid re-comparing the same prefixes. This improved binary search runs in $O(m + log n)$ time.

== Tasks

=== Task 1
Construct the Suffix Array ($"SA"$) for the text $T = "abracadabra$"$ using the naive $O(n^2 log n)$ method.

=== Task 2
Given the $"SA"$ from the previous task, construct the Inverse Suffix Array ($"ISA"$).

=== Task 3
Construct the LCP array for $T = "abracadabra$"$ using Kasai's algorithm. Show the steps.

=== Task 4
How would you find the number of occurrences of the pattern "abra" in "abracadabra\$" using the suffix array?

#pagebreak()

== Solutions

=== Solution 1
Text $T = "abracadabra\$"$, length $n=12$.
Suffixes:
- 0: "abracadabra\$"
- 1: "bracadabra\$"
- 2: "racadabra\$"
- 3: "acadabra\$"
- 4: "cadabra\$"
- 5: "adabra\$"
- 6: "dabra\$"
- 7: "abra\$"
- 8: "bra\$"
- 9: "ra\$"
- 10: "a\$"
- 11: "\$"

Sorted suffixes:
1. "\$" (11)
2. "a\$" (10)
3. "abra\$" (7)
4. "abracadabra\$" (0)
5. "acadabra\$" (3)
6. "adabra\$" (5)
7. "bra\$" (8)
8. "bracadabra\$" (1)
9. "cadabra\$" (4)
10. "dabra\$" (6)
11. "ra\$" (9)
12. "racadabra\$" (2)

Suffix Array $"SA" = (11, 10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2)$.

=== Solution 2
Using $"SA" = (11, 10, 7, 0, 3, 5, 8, 1, 4, 6, 9, 2)$:
- $"ISA"[11] = 0$
- $"ISA"[10] = 1$
- $"ISA"[7] = 2$
- $"ISA"[0] = 3$
- $"ISA"[3] = 4$
- $"ISA"[5] = 5$
- $"ISA"[8] = 6$
- $"ISA"[1] = 7$
- $"ISA"[4] = 8$
- $"ISA"[6] = 9$
- $"ISA"[9] = 10$
- $"ISA"[2] = 11$

Inverse Suffix Array $"ISA" = (3, 7, 11, 4, 8, 5, 9, 2, 6, 10, 1, 0)$.

=== Solution 3
We have $T$, $"SA"$, and $"ISA"$. We iterate $i$ from 0 to 11.
- $h=0$
- $i=0 (T_0="abracadabra$")$: $"ISA"[0]=3$. prev suffix is $"SA"[2]=7$ ("abra\$"). LCP is 4. $"LCP"[3]=4$. $h=3$.
- $i=1 (T_1="bracadabra$")$: $"ISA"[1]=7$. prev suffix is $"SA"[6]=8$ ("bra\$"). LCP is 3. $"LCP"[7]=3$. $h=2$.
- $i=2 (T_2="racadabra$")$: $"ISA"[2]=11$. prev suffix is $"SA"[10]=9$ ("ra\$"). LCP is 2. $"LCP"[11]=2$. $h=1$.
- $i=3 (T_3="acadabra$")$: $"ISA"[3]=4$. prev suffix is $"SA"[3]=0$ ("abracadabra\$"). LCP is 1. $"LCP"[4]=1$. $h=0$.
- $i=4 (T_4="cadabra$")$: $"ISA"[4]=8$. prev suffix is $"SA"[7]=1$ ("bracadabra\$"). LCP is 0. $"LCP"[8]=0$. $h=0$.
- $i=5 (T_5="adabra$")$: $"ISA"[5]=5$. prev suffix is $"SA"[4]=3$ ("acadabra\$"). LCP is 1. $"LCP"[5]=1$. $h=0$.
- $i=6 (T_6="dabra$")$: $"ISA"[6]=9$. prev suffix is $"SA"[8]=4$ ("cadabra\$"). LCP is 0. $"LCP"[9]=0$. $h=0$.
- $i=7 (T_7="abra$")$: $"ISA"[7]=2$. prev suffix is $"SA"[1]=10$ ("a\$"). LCP is 1. $"LCP"[2]=1$. $h=0$.
- $i=8 (T_8="bra$")$: $"ISA"[8]=6$. prev suffix is $"SA"[5]=5$ ("adabra\$"). LCP is 0. $"LCP"[6]=0$. $h=0$.
- $i=9 (T_9="ra$")$: $"ISA"[9]=10$. prev suffix is $"SA"[9]=6$ ("dabra\$"). LCP is 0. $"LCP"[10]=0$. $h=0$.
- $i=10 (T_10="a$")$: $"ISA"[10]=1$. prev suffix is $"SA"[0]=11$ ("\$"). LCP is 0. $"LCP"[1]=0$. $h=0$.
- $i=11 (T_11="$")$: $"ISA"[11]=0$. No predecessor.

Final LCP array: $"LCP" = (0, 0, 1, 4, 1, 1, 0, 3, 0, 0, 0, 2)$.

=== Solution 4
1. Binary search for "abra" in the suffix array.
2. All suffixes starting with "abra" will form a contiguous block in the sorted suffix array.
3. We find the first occurrence ("abra\$") at $"SA"[2]=7$.
4. We find the last occurrence ("abracadabra\$") at $"SA"[3]=0$.
5. The suffixes from index 2 to 3 in the SA start with "abra".
6. The number of occurrences is $3 - 2 + 1 = 2$.
7. The starting positions are $"SA"[2]=7$ and $"SA"[3]=0$.

#pagebreak()
