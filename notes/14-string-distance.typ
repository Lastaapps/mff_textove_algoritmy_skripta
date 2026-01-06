#import "../definitions.typ": *

= String Distance Metrics

== Hamming Distance

The *Hamming distance* is defined for two strings of *equal length*. It is the number of positions at which the corresponding characters are different. It also represent the number of spelling mistakes.

#example_box(title: "Example")[
  - $d_H ("karolin", "kathrin") = 3$ (differences at positions 2, 4, 5).
  - $d_H ("apple", "apply") = 1$.
]

== Levenshtein Distance

The *Levenshtein distance*, in some strict definitions, considers the minimum number of single-character *insertions* and *deletions* required to change one string into the other. This version does not allow substitutions.

This metric is equivalent to the *LCS distance*, which is based on the Longest Common Subsequence. The distance is the total number of characters in both strings that are not part of the LCS:
$ d_L(A, B) = |A| + |B| - 2 |"LCS"(A, B)|. $
Read this as that the distance (number of errors) is equal to the original strings with the correct positions subtracted, once for each of the strings.

== Edit Distance

A more common metric, also frequently referred to as Levenshtein distance, is the general *Edit Distance*. This metric includes *substitution* as a third basic operation.
- $d_E (A, B)$ = minimum number of insertions, deletions, or substitutions to transform $A$ to $B$.

This is the version for which the Wagner-Fischer algorithm is typically presented, and it's generally assumed that the cost of each of these three operations is 1.

== Weighted Edit Distance

The concept of Edit Distance can be further generalized to *Weighted Edit Distance*, where each operation can have a different cost.
- Cost of inserting character $c$: $"cost"_"ins"(c)$
- Cost of deleting character $c$: $"cost"_"del"(c)$
- Cost of substituting character $c_1$ with $c_2$: $"cost"_"sub" (c_1, c_2)$

The goal is to find the sequence of operations with the minimum total cost. The standard Levenshtein distance (with substitutions) is a special case where all costs are uniformly 1.

#info_box(title: "When is Weighted Edit Distance a Metric?")[
  For the weighted edit distance to be considered a true *metric*, its cost functions must satisfy certain properties, which mirror the axioms of a metric space:

  1. *Non-negativity:* All costs must be non-negative.
    - $"cost"_"ins"(c) >= 0$
    - $"cost"_"del"(c) >= 0$
    - $"cost"_"sub"(c_1, c_2) >= 0$

  2. *Identity of indiscernibles:* The distance between a string and itself must be zero, and only zero.
    - This implies that $"cost"_"sub" (c, c) = 0$ for any character $c$.
    - If $"cost"_"ins" (c) > 0$ or $"cost"_"del" (c) > 0$, then $d(x,y)=0$ if and only if $x=y$.

  3. *Symmetry:* The distance from string A to string B must be the same as from B to A.
    - $"cost"_"del" (c) = "cost"_"ins" (c)$ for all characters $c$.
    - $"cost"_"sub" (c_1, c_2) = "cost"_"sub" (c_2, c_1)$ for all characters $c_1, c_2$.

  4. *Triangle inequality:* For any three strings A, B, C, the distance $d(A, C)$ must be less than or equal to $d(A, B) + d(B, C)$.
    - This requires that $"cost"_"sub" (c_1, c_3) <= "cost"_"sub" (c_1, c_2) + "cost"_"sub" (c_2, c_3)$ for all $c_1, c_2, c_3$.
    - Additionally, $"cost"_"sub" (c_1, c_2) <= "cost"_"del" (c_1) + "cost"_"ins" (c_2)$ (a substitution should not be more expensive than a deletion and an insertion).
]

== The Wagner-Fischer Algorithm

The *Wagner-Fischer algorithm* is the classic dynamic programming solution for computing the *Edit Distance* (with substitution). It fills a matrix (or table) $D$ of size $(|A|+1) times (|B|+1)$, where $D\[i, j]$ stores the edit distance between the prefix $A[1..i]$ and $B[1..j]$.

The recurrence relation for the general weighted case is:
$
  D\[i, j] = min(D\[i-1, j] + "cost"_"del" (A\[i]),
  D\[i, j-1] + "cost"_"ins" (B\[j]),
  D\[i-1, j-1] + "cost"_"sub" (A\[i], B\[j])
  ).
$

For the standard *Levenshtein distance* (all costs are 1), the recurrence simplifies to:
$
  D\[i, j] = min(
    D\[i-1, j] + 1,
    D\[i, j-1] + 1,
    D\[i-1, j-1] + c
  ).
$
where $c$ is 0 if $A\[i] = B\[j]$ and *2 otherwise* (insert and delete), 1 is used for *Edit distance*.

#example_box(
  title: "Example: Levenshtein Distance for \"SUNDAY\" and \"SATURDAY\"",
)[

  We compute the matrix $D$. The final distance is $D[6, 8] = 3$.

  #table(
    columns: 10,
    align: center,
    [], [*ε*], [*S*], [*A*], [*T*], [*U*], [*R*], [*D*], [*A*], [*Y*],
    [*ε*], [0], [1], [2], [3], [4], [5], [6], [7], [8],
    [*S*], [1], [0], [1], [2], [3], [4], [5], [6], [7],
    [*U*], [2], [1], [1], [2], [2], [3], [4], [5], [6],
    [*N*], [3], [2], [2], [2], [3], [3], [4], [5], [6],
    [*D*], [4], [3], [3], [3], [3], [4], [3], [4], [5],
    [*A*], [5], [4], [3], [4], [4], [4], [4], [3], [4],
    [*Y*], [6], [5], [4], [4], [5], [5], [5], [4], [3],
  )
]

== Optimizing the Dynamic Programming Approach

The $O(n m)$ complexity of the Wagner-Fischer algorithm can be too slow for very long strings. Faster algorithms exploit properties of the DP matrix.

=== The Diagonal Property

A "diagonal" $d$ in the DP matrix consists of all cells $(i, j)$ where $j-i = d$. This property is key to many optimizations.

#info_box(title: "Lemma: Diagonal Property")[
  For any cell $(i, j)$ in the DP matrix for Levenshtein distance:
  $D\[i, j] - D\[i-1, j-1]$ is either 0 or 1.
]

*Proof:*
- The value $D\[i, j]$ is the minimum of three possibilities: $D\[i-1, j]+1$, $D\[i, j-1]+1$, and $D\[i-1, j-1] + c$.
- Both $D\[i-1, j]$ and $D\[i, j-1]$ are at least $D\[i-1, j-1]-1$. So the first two options in the `min` function are at least $D\[i-1, j-1]$.
- The third option is either $D\[i-1, j-1]$ (if characters match) or $D\[i-1, j-1]+1$ (if they don't).
- Therefore, the minimum, $D\[i, j]$, must be at least $D\[i-1, j-1]$.
- We can also get from prefix $A[..i-1], B[..j-1]$ to $A[..i], B[..j]$ with at most one extra operation (a substitution, or a delete+insert pair). So, $D\[i, j] <= D\[i-1, j-1] + 1$.
- Combining these, $D\[i-1, j-1] <= D\[i, j] <= D\[i-1, j-1] + 1$.

This property means values along a diagonal are non-decreasing and only increase in steps of 0 or 1.

#example_box(title: "Example of the Diagonal Property")[
  Let $A = "KITTEN"$ and $B = "SITTING"$. Consider the main diagonal ($d=0$) of their DP matrix.

  #table(
    columns: 9,
    align: center,
    [], [*ε*], [*S*], [*I*], [*T*], [*T*], [*I*], [*N*], [*G*],
    [*ε*], [*0*], [1], [2], [3], [4], [5], [6], [7],
    [*K*], [1], [*1*], [2], [3], [4], [5], [6], [7],
    [*I*], [2], [2], [*1*], [2], [3], [4], [5], [6],
    [*T*], [3], [3], [2], [*1*], [2], [3], [4], [5],
    [*T*], [4], [4], [3], [2], [*1*], [2], [3], [4],
    [*E*], [5], [5], [4], [3], [2], [*2*], [3], [4],
    [*N*], [6], [6], [5], [4], [3], [3], [*2*], [3],
  )

  The values along the main diagonal are: 0, 1, 1, 1, 1, 2, 2.
  Let's check the difference property:
  - $D\[1,1] - D\[0,0] = 1-0 = 1$
  - $D\[2,2] - D\[1,1] = 1-1 = 0$
  - $D\[3,3] - D\[2,2] = 1-1 = 0$
  - $D\[4,4] - D\[3,3] = 1-1 = 0$
  - $D\[5,5] - D\[4,4] = 2-1 = 1$
  - $D\[6,6] - D\[5,5] = 2-2 = 0$

  As the lemma states, the difference is always 0 or 1.
]

=== The Ukkonen-Myers Algorithm
This property is the foundation for faster algorithms like the *Ukkonen-Myers algorithm*.

*Core Idea:* Instead of computing the value for every cell, the algorithm finds the furthest-reaching cell on each diagonal $d$ that can be computed with at most $k$ edits. Let this be row `r`. The algorithm then only needs to compute the values for the next edit count, `k+1`, starting from these frontier cells.

This changes the problem from filling a matrix to a search over the diagonals. The resulting time complexity is $O(k(m+n))$ or simply $O(k n)$ if $n$ is the length of the longer string, where $k$ is the edit distance between the strings (or a specified maximum threshold). This is much faster if the strings are similar (i.e., $k$ is small).

== Longest Common Subsequence (LCS) Distance

The *Longest Common Subsequence (LCS)* of two strings is the longest sequence of characters that appears in the same order in both strings, but not necessarily consecutively.

==== LCS Length Calculation
The length of the LCS can be found using dynamic programming, similar to edit distance. Let $L\[i,j]$ be the length of the LCS of prefixes $A[1..i]$ and $B[1..j]$.

#info_box(title: "Recurrence Relation for LCS Length")[
  - If $i=0$ or $j=0$, $L\[i,j] = 0$.
  - If $A\[i] = B\[j]$: $L\[i, j] = 1 + L\[i-1, j-1]$
  - If $A\[i] != B\[j]$: $L\[i, j] = max(L\[i-1, j], L\[i, j-1])$
]

==== LCS Distance
The LCS length can be used to define a distance metric. This metric counts the number of characters that are *not* part of the LCS.
$ d_"LCS"(A, B) = |A| + |B| - 2 |"LCS"(A, B)|. $
This value represents the total number of insertions and deletions needed to transform A to B if no substitutions are allowed.

== Tasks

=== Task 1
Calculate the Hamming distance between "PALE" and "POLE".

=== Task 2
Using the Wagner-Fischer algorithm, compute the full dynamic programming matrix to find the Levenshtein distance (with substitutions) between the strings "CAT" and "CAR".

=== Task 3
Explain the Diagonal Property of the edit distance DP matrix. Why is this property useful for creating faster algorithms?

=== Task 4
What is the main advantage of the Ukkonen-Myers algorithm over the standard Wagner-Fischer algorithm, and in what scenario is it most beneficial?

=== Task 5
What is the relationship between the LCS Distance and the strict Levenshtein distance (which only allows insertions and deletions)? Provide the formula.

#pagebreak()

== Solutions

=== Solution 1
The strings "PALE" and "POLE" have the same length (4). We compare them character by character:
- P vs P (same)
- A vs O (different)
- L vs L (same)
- E vs E (same)
There is one position with different characters. The Hamming distance is 1.

=== Solution 2
We compute the matrix $D$ for $A="CAT"$ and $B="CAR"$. The cost of insertion, deletion, and substitution is 1.

#table(
  columns: 5,
  align: center,
  [], [*ε*], [*C*], [*A*], [*R*],
  [*ε*], [0], [1], [2], [3],
  [*C*], [1], [0], [1], [2],
  [*A*], [2], [1], [0], [1],
  [*T*], [3], [2], [1], [1],
)
The final edit distance is $D\[3,3]=1$, which corresponds to substituting 'T' with 'R'.

=== Solution 3
The Diagonal Property states that for any cell $(i,j)$ in the Levenshtein DP matrix, the value $D\[i,j]$ differs from the value of the previous diagonal cell $D\[i-1,j-1]$ by either 0 or 1.
- *Usefulness:* This property is crucial because it means we don't have to compute every cell value from scratch. If we know the value of a cell on a diagonal, we know the next cell on that diagonal will have the same value or be one greater. Algorithms like the Ukkonen-Myers algorithm exploit this to avoid filling the entire $O(n m)$ matrix, instead only tracking the changes along diagonals, which leads to significant speedups, especially when the edit distance is small.

=== Solution 4
The main advantage of the Ukkonen-Myers algorithm is its improved time complexity. While Wagner-Fischer is always $O(n m)$, Ukkonen-Myers runs in $O(k d)$, where $d$ is the length of the strings and $k$ is the actual edit distance.
- *Most Beneficial Scenario:* It is most beneficial when the two strings are very similar, meaning the edit distance `k` is small. For example, in DNA sequencing, where one might be looking for matches with only a few mutations, `k` would be much smaller than `n` or `m`, making the algorithm significantly faster than Wagner-Fischer.

=== Solution 5
The strict Levenshtein distance that only allows insertions and deletions is equivalent to the LCS distance.
The formula is:
$ d_L(A, B) = |A| + |B| - 2 |"LCS"(A, B)|. $
This formula works because the most efficient way to make two strings equal using only insertions and deletions is to find their longest common subsequence, keep those characters, and delete all other characters from both strings. The number of deletions is $|A| - |"LCS"|$ and the number of insertions is $|B| - |"LCS"|$. Summing these gives the formula.

#pagebreak()
