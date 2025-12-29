#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

#import "../definitions.typ": *

= Approximate String Matching

== Introduction

*Approximate String Matching* is the problem of finding all occurrences of a pattern $P$ in a text $T$ with at most $k$ errors. The definition of "error" depends on the string distance metric used (e.g., Hamming, Levenshtein, or Edit distance).

- *Input:* A text $T$, a pattern $P$, and an integer $k > 0$.
- *Output:* All positions `i` in $T$ where a substring of $T$ ending at `i` has a distance of at most $k$ from $P$.

== Dynamic Programming Approach

The classic dynamic programming algorithm for edit distance (Wagner-Fischer) can be adapted for approximate string matching.
- A matrix `c[0..n, 0..m]` is used, where `c[i, j]` stores the minimum edit distance between the pattern $P[1..j]$ and any substring of the text ending at position `i`.
- The recurrence relation is the same as in the Wagner-Fischer algorithm.
- An occurrence is found at position `i` if $c[i, m] <= k$.

The initialization of the DP matrix is slightly different:
- `c[0, j]` is initialized to represent the cost of matching a prefix of the pattern with an empty string.
- The first column `c[i, 0]` is always 0, as an empty pattern has 0 distance to any prefix of the text.

The complexity of this approach is $O(n*m)$, where $n$ is the text length and $m$ is the pattern length.

== Approximate Shift-Or Algorithm

The Shift-Or algorithm, which uses bit parallelism for exact matching, can be modified to handle $k$ mismatches. This is particularly effective for the Hamming distance.

- Instead of a single bit vector where each position is 0 (match) or 1 (mismatch), each entry in the vector becomes a counter.
- $s[j]$ stores the number of mismatches between the pattern prefix $P[1..j]$ and the current text window.
- The size of each counter needs to be `ceil(log2(m+1))` bits. The total state vector is thus larger.

=== Update Step

The update rule for the state vector $s$ becomes an addition instead of an OR operation:
$s_i = (s_(i-1) >> B) + "mask"[T[i]]$
where $B$ is the number of bits per counter, and the mask table now contains vectors of counters.

- $"mask"[c][j]$ is 0 if $P[j] == c$, and a vector representing 1 otherwise.
- A match with at most $k$ errors is found at position `i` if $s[m] <= k$.

The complexity becomes $O(ceil(m*B/w) * n)$, where $w$ is the machine word size. For small $k$, this can be optimized further.

== Tasks

1. How does the dynamic programming matrix for approximate matching differ from the one for simple edit distance calculation?
2. In the approximate Shift-Or algorithm, why does each entry in the bit vector need to be a counter instead of a single bit?
3. What is the main limitation of the basic DP approach for approximate string matching?

#pagebreak()

== Solutions

=== Task 1: DP Matrix Difference

The main difference is in the interpretation and initialization.
- In the standard *edit distance* calculation between two full strings `s1` and `s2`, the cell `D[i,j]` stores the distance between the prefix `s1[1..i]` and `s2[1..j]`. The first row and column are initialized with increasing costs (0, 1, 2, ...).
- In *approximate string matching*, we are looking for the best match of a pattern $P$ against *any* substring of the text $T$. The cell `c[i,j]` stores the minimum distance between $P[1..j]$ and any substring of $T$ ending at position `i`. Because of this, the first column `c[i,0]` (matching an empty pattern) is always initialized to 0. This allows a potential match to start at any position in the text.

=== Task 2: Counters in Approximate Shift-Or

In the exact Shift-Or algorithm, each bit in the vector $s$ represents a binary state: either a prefix of the pattern matches perfectly (0) or it doesn't (1).

In the approximate version, we need to keep track of the *number* of errors (mismatches). A single bit is not enough to store this information. Therefore, each entry $s[j]$ becomes a counter that stores the accumulated number of errors for the match of the pattern prefix $P[1..j]$. If this counter exceeds $k$, it can be capped at $k+1$, as we are only interested in matches with at most $k$ errors. This requires multiple bits per entry, making the state vector larger.

=== Task 3: Limitation of the DP Approach

The main limitation of the basic dynamic programming approach for approximate string matching is its time and space complexity of $O(n*m)$. For long texts and patterns, this can be very slow and memory-intensive. While it is very general and can handle different scoring schemes, its quadratic complexity makes it impractical for many large-scale applications, such as searching for a pattern in a large genome database. More advanced algorithms, like the bit-parallel ones (e.g., approximate Shift-Or) or filtration methods, are used to achieve better performance, especially when the number of allowed errors $k$ is small.
