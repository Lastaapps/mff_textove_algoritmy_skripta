#import "../definitions.typ": *

= Approximate String Matching

== Introduction

*Approximate String Matching* is the problem of finding all occurrences of a pattern $P$ in a text $T$ with at most $k$ errors. The definition of "error" depends on the string distance metric used (e.g., Hamming, Levenshtein, Edit distance, or theirs weighted variants).

- *Input:* A text $T$, a pattern $P$, and an integer $k > 0$.
- *Output:* All positions $i$ in $T$ where a substring of $T$ ending at $i$ has a distance of at most $k$ from $P$.

== Dynamic Programming Approach

The classic dynamic programming algorithm for edit distance (Wagner-Fischer) can be adapted for approximate string matching.
- A matrix $c[0..n, 0..m]$ is used, where $c[i, j]$ stores the minimum edit distance between the pattern $P[1..j]$ and any substring of the text ending at position $i$ (i.e., a substring $T[i'..i]$ for some $i' <= i$).
- The recurrence relation is the same as in the Wagner-Fischer algorithm for edit distance:
  $
    c[i, j] = min(c[i-1, j] + 1, c[i, j-1] + 1, c[i-1, j-1] + delta(T[i], P[j]))
  $
- An occurrence is found at position $i$ if $c[i, m] <= k$.

The initialization of the DP matrix is slightly different:
- $c[0, j]$ is initialized to represent the cost of matching a prefix of the pattern with an empty string, so $c[0, j] = j$.
- The first column $c[i, 0]$ is always 0. This is a key difference from the standard edit distance algorithm. It allows a match to start at any position in the text without any penalty for deleting the beginning of the text.

The complexity of this approach is $O(n m)$, where $n$ is the text length and $m$ is the pattern length.

#example_box(title: "Example: DP Matrix")[

  Let's find all approximate occurrences of the pattern $P = "stress"$ in the text $T = "rests"$ with at most $k=2$ errors using Levenshtein distance.

  The DP matrix $c$ will have dimensions $(|T|+1) times (|P|+1)$. The cell $c[i, j]$ stores the minimum distance between the first $j$ characters of the pattern and a substring of the text ending at $i-1$.

  The table below shows the computed values. The first row is initialized from 0 to $m$, and the first column is all zeros.

  #table(
    columns: (1cm, 1cm, 1cm, 1cm, 1cm, 1cm, 1cm, 1cm),
    align: center,
    [$$], [$#sym.epsilon$], [*s*], [*t*], [*r*], [*e*], [*s*], [*s*],
    [*#sym.epsilon*], [0], [1], [2], [3], [4], [5], [6],
    [*r*], [0], [1], [2], [2], [3], [4], [5],
    [*e*], [0], [1], [2], [3], [2], [3], [4],
    [*s*], [0], [1], [2], [3], [3], [2], [3],
    [*t*], [0], [1], [1], [2], [3], [3], [4],
    [*s*], [0], [1], [2], [2], [3], [4], [3],
  )

  The last row of the matrix is $[0, 1, 2, 2, 3, 4, 3]$. We look for values less than or equal to $k=2$.
  - $c[3, 6] = 2 <= 2$: An occurrence ending at text position 3 ("res") corresponding to "stres" with 2 errors.
  - $c[5, 6] = 3 > 2$: No occurrence ending at position 5.

  We can see that $c[i, m] <= k$ indicates that a substring of $T$ ending at $i-1$ is a k-approximate match of $P$.
]

== Approximate Shift-Or Algorithm

The Shift-Or algorithm, which uses bit parallelism for exact matching, can be modified to handle $k$ mismatches, which is particularly effective for Hamming distance. The core idea is to change the state vector to keep track of the number of errors instead of a simple match/mismatch state.

There are two main approaches to this:

=== Counter-based Approach

In this approach, the state vector $s$ is composed of counters instead of bits.
- $s[j]$ stores the number of mismatches between the pattern prefix $P[1..j]$ and the current text window.
- The size of each counter, $B$, needs to be large enough to store up to $m$ errors, so $B = ceil(log_2(m+1))$ bits. This makes the total state vector significantly larger than in the exact algorithm.

*Preprocessing:*
A mask table $t$ is precomputed. For each character $c$ in the alphabet and each position $j$ in the pattern, $t[c, j]$ is a B-bit vector that is $0$ if $P[j] == c$ and $1$ otherwise.

*Update Step:*
The update rule for the state vector $s$ at each step $i$ (for character $T[i]$) becomes an addition instead of a bitwise OR:
$ s_i = (s_(i-1) >>> B) + t[T[i]] $
The operation $>>> B$ is a logical right shift of the entire state vector by $B$ bits (one counter position). A match with at most $k$ errors is found at position $i$ if the counter $s[m]$ is less than or equal to $k$.

#code_box([
  #smallcaps([Approximate-Shift-Or-Counters]) ($P$, $T$, $k$)
  ```
  // Preprocessing
  B = ceil(log2(m+1))
  for c in alphabet:
    for j from 1 to m:
      if P[j] == c:
        t[c, j] = 0 // B-bit zero
      else:
        t[c, j] = 1 // B-bit one

  // Searching
  s = 0 // Entire state vector of m*B bits
  for i from 0 to n-1:
    s = (s >>> B) + t[T[i]]
    if s[m] <= k:
      report match at i
  ```
])

#example_box(title: "Example: Counter-based Shift-Or")[

  Let $P = "bbba"$, $T = "abbac... "$, $k=2$.
  Here $m=4$. We need $B = ceil(log_2(5)) = 3$ bits per counter. The state vector $s$ has $4 dot 3 = 12$ bits.

  The mask table $t$ for characters 'a' and 'b' would look like this (showing only relevant entries):
  - $t['a'] = [001, 001, 001, 000]$ (mismatch, mismatch, mismatch, match)
  - $t['b'] = [000, 000, 000, 001]$ (match, match, match, mismatch)

  Let's trace the first few steps:
  1. *Initial state:* $s_(-1) = [000, 000, 000, 000]$.
  2. *i=0, T[0]='a':*
    $s_0 = (s_(-1) >>> 3) + t['a']$
    $s_0 = [000, 000, 000, 000] + [001, 001, 001, 000] = [001, 001, 001, 000]$.
  3. *i=1, T[1]='b':*
    $s_1 = (s_0 >>> 3) + t['b']$
    $s_1 = [000, 001, 001, 001] + [000, 000, 000, 001] = [000, 001, 001, 010]$.
    The last counter $s_1 [4]$ is 2, indicating 2 errors for matching "bbba" against "ab".

  This continues for the entire text. A match is reported whenever the last counter's value is $<= k$.
]

*Complexity:* The complexity is $O(ceil(m B/w) n)$, where $w$ is the machine word size. Since $B$ is $O(log m)$, this is $O(n m log(m) / w)$.

=== Overflow-based Approach (for small k)

When $k$ is much smaller than $m$, using $log_2(m+1)$ bits per counter is wasteful. We only need to know if the number of errors is within our budget $k$.

This approach uses fewer bits per counter and an extra "overflow" vector.
- The number of bits per counter $B$ is reduced to just $ceil(log_2(k+1))$.
- An additional state vector $"ov"$ of $m$ bits is used to track whether a counter has overflowed.

The update becomes more complex, involving checks for overflow and propagating it. While more bit-manipulation-heavy, it is faster because more counters fit into a single machine word.

*Complexity:* The complexity becomes $O(ceil(m log(k)/w) n)$. This is a significant improvement over the counter-based approach when $k$ is small.


== Tasks

=== Task 1
How does the dynamic programming matrix for approximate matching differ from the one for simple edit distance calculation?

=== Task 2
In the approximate Shift-Or algorithm, why does each entry in the bit vector need to be a counter instead of a single bit?

=== Task 3
What is the main limitation of the basic DP approach for approximate string matching?

=== Task 4
Construct the DP matrix for approximate string matching with $T = "bananabandana"$, $P = "bana"$, and $k=1$. Identify all occurrences.

#pagebreak()

== Solutions

=== Solution 1
The main difference is in the interpretation and initialization.
- In the standard *edit distance* calculation between two full strings $s^1$ and $s^2$, the cell $D[i,j]$ stores the distance between the prefix $s^1[1..i]$ and $s^2[1..j]$. The first row and column are initialized with increasing costs (0, 1, 2, ...).
- In *approximate string matching*, we are looking for the best match of a pattern $P$ against *any* substring of the text $T$. The cell $c[i,j]$ stores the minimum distance between $P[1..j]$ and any substring of $T$ ending at position $i$. Because of this, the first column $c[i,0]$ (matching an empty pattern) is always initialized to 0. This allows a potential match to start at any position in the text.

=== Solution 2
In the exact Shift-Or algorithm, each bit in the vector $s$ represents a binary state: either a prefix of the pattern matches perfectly (0) or it doesn't (1).

In the approximate version, we need to keep track of the *number* of errors (mismatches). A single bit is not enough to store this information. Therefore, each entry $s[j]$ becomes a counter that stores the accumulated number of errors for the match of the pattern prefix $P[1..j]$. If this counter exceeds $k$, it can be capped at $k+1$, as we are only interested in matches with at most $k$ errors. This requires multiple bits per entry, making the state vector larger.

=== Solution 3
The main limitation of the basic dynamic programming approach for approximate string matching is its time and space complexity of $O(n m)$. For long texts and patterns, this can be very slow and memory-intensive. While it is very general and can handle different scoring schemes, its quadratic complexity makes it impractical for many large-scale applications, such as searching for a pattern in a large genome database. More advanced algorithms, like the bit-parallel ones (e.g., approximate Shift-Or) or filtration methods, are used to achieve better performance, especially when the number of allowed errors $k$ is small.

=== Solution 4
We construct the matrix $c[0..13, 0..4]$. The last column, $c[i, 4]$, gives the minimum distance between "bana" and any substring of T ending at position $i-1$.

#table(
  columns: (1cm, 1cm, 1cm, 1cm, 1cm, 1cm),
  align: center,
  [$$], [$#sym.epsilon$], [*b*], [*a*], [*n*], [*a*],
  [*#sym.epsilon*], [0], [1], [2], [3], [4],
  [*b*], [0], [0], [1], [2], [3],
  [*a*], [0], [1], [0], [1], [2],
  [*n*], [0], [1], [1], [0], [*1*],
  [*a*], [0], [1], [1], [1], [*0*],
  [*n*], [0], [1], [2], [1], [*1*],
  [*a*], [0], [1], [2], [2], [*1*],
  [*b*], [0], [0], [1], [2], [2],
  [*a*], [0], [1], [0], [1], [2],
  [*n*], [0], [1], [1], [0], [*1*],
  [*d*], [0], [1], [1], [1], [*1*],
  [*a*], [0], [1], [1], [1], [*1*],
  [*n*], [0], [1], [2], [1], [*1*],
  [*a*], [0], [1], [2], [2], [*1*],
)

To find the occurrences, we scan the last column for values $v <= k=1$:
- $c[4, 4] = 0$: Exact match found ending at index 3 ("bana").
- $c[5, 4] = 1$: Match with 1 error found ending at index 4 ("banan").
- $c[6, 4] = 1$: Match with 1 error found ending at index 5 ("banana").
- $c[9, 4] = 1$: Match with 1 error found ending at index 8 ("bananaban").
- $c[10, 4] = 1$: Match with 1 error found ending at index 9 ("bananaband").
- $c[11, 4] = 1$: Match with 1 error found ending at index 10 ("bananabanda").
- $c[12, 4] = 1$: Match with 1 error found ending at index 11 ("bananabandan").
- $c[13, 4] = 1$: Match with 1 error found ending at index 12 ("bananabandana").

#pagebreak()
