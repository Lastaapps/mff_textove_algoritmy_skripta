#import "../definitions.typ": *

= Approximate String Matching II: The Wu-Manber Algorithm

== Introduction

This chapter delves into one of the most efficient and practical algorithms for the *k-differences problem*: the *Wu-Manber algorithm*. It combines the correctness of dynamic programming with the speed of bit parallelism, making it a cornerstone of approximate string matching in practice (e.g., the `agrep` tool).

The algorithm solves the problem of finding all substrings in a text $T$ that have an edit distance of at most $k$ from a pattern $P$.

== Core Idea: Bit-Parallel DP

The key innovation of the Wu-Manber algorithm is to simulate the dynamic programming matrix computation using bit vectors. Instead of computing each cell $c[i, j]$ individually, it processes the matrix column by column (or diagonally), using bitwise operations to update the state for all prefixes of the pattern simultaneously.

=== State Vector Definition

For each number of errors $q$ from 0 to $k$, the algorithm maintains a bit vector $s[q]$ of length $m$. The meaning of the bits is as follows:
- $s[q,j] = 0$ if and only if the edit distance between the pattern prefix $P[1..j]$ and a substring of $T$ ending at the current position is less than or equal to $q$.
- $s[q,j] = 1$ otherwise.

A match of the entire pattern $P$ with at most $k$ errors is found at text position $i$ if, after processing $T[i]$, the last bit of the state vector for $k$ errors is 0, i.e., $s[k,m] = 0$.

=== Bitwise Update Formula

The recurrence relation from the DP matrix can be translated into a series of bitwise operations. For each character $T[i]$, the new state vectors $s'_q$ are computed from the old state vectors $s_q$.

The update for $s'_q$ involves several components:
- *Substitution*: Handled by OR-ing the previous state $s_(q-1)$ with the character mask $t[T[i]]$.
- *Deletion*: A right shift of the current state $s_q$.
- *Insertion*: A right shift of the previous state $s_(q-1)$.

For the Levenshtein distance $d_L$, the substitution costs $S=2$, for edit distance $d_E$ it is $S=1$. The formula goes as follows:

$
  s_i[q,j] = s_(i-1) [q-1,j] and s_i [q-1,j-1] and (s_(i-1) [q-S, j-1] and (s_(i-1) [q,j-1] or t[T[i],j-1]))
$

where $t[c]$ is the precomputed character mask for character $c$.
We try all the values that have less errors than us corresponding to regular update equations.
If there is an error propagating and one new coming from or, number of errors is increased.

== Algorithm Pseudocode

#code_box([
  #smallcaps([Wu-Manber-Search]) ($P$, $T$, $k$)
  ```
  // Preprocessing: Create character masks
  for c in alphabet:
    t[c] = a bitmask of length m, where t[c,j]=0 if P[j]==c, else 1

  // Initialization
  for q from 0 to k:
    s[q] = a bitmask of all 1s

  // Searching
  for i from 0 to n-1:
    // Store old states before update
    olds = s

    // Update for q=0 (exact match)
    s[0] = (olds[0] <<< 1) | t[T[i]]

    // Update for q > 0
    for q from 1 to k:
      s[q] = ((olds[q] <<< 1) | t[T[i]]) & \
             (olds[q-1]) & \
             (s[q-1] <<< 1) & \
             (olds[q-1] <<< 1)

    // Check for a match
    if s[k,m] == 0:
      report match at i
  ```
])

#example_box(title: "Example: Wu-Manber Trace")[

  Let $P = "bbba"$, $T = "bbac..."$, $k=2$, and distance is edit distance ($d_E$).
  $m=4$. We need $k+1=3$ state vectors: $s[0], s[1], s[2]$.
  Masks: $t['a'] = 1110$, $t['b'] = 0001$, $t['c'] = 1111$.

  *Initialization:*
  $s_(-1) [0] = 1111$
  $s_(-1) [1] = 1111$
  $s_(-1) [2] = 1111$

  *Step 1: i=0, T[0]='b'*
  - $s_0 [0] = (1111 <<< 1) | 0001 = 1110 | 0001 = 1111$
  - ... (complex updates for $s[1]$, $s[2]$)
  After all updates for 'b', we might get:
  $s_0 [0] = 0111$
  $s_0 [1] = 0011$
  $s_0 [2] = 0001$

  *Step 2: i=1, T[1]='b'*
  - The process repeats. If at any point $s_i [2]$ has its last bit as 0, a match is found. For example, if $s_i [2] = 0100$, it means a substring matches "bbba" with at most 2 errors.
]

== Extensions and Variations

The Wu-Manber framework is highly flexible.

=== Finding the Minimal $k$ for a Match

Instead of searching for a match with a fixed number of errors $k$, we can also solve the problem of finding the *minimal* number of errors $k^*$ for which an approximate match of pattern $P$ in text $T$ exists.

- *Problem:* Find the minimal $k^*$ such that there is at least one $k^*$-approximate occurrence of $P$ in $T$.

- *Solution:* The solution involves an iterative application of the Wu-Manber algorithm.
  1. First, test for an exact match ($k=0$) using a fast algorithm like Shift-Or.
  2. If no exact match is found, iterate the Wu-Manber algorithm for exponentially increasing values of $k$. For example, test $k = 1, 3, 7, ..., 2^B-1$.
  3. Stop when a match is found for some $k=2^B -1$. We then know that the minimal $k^*$ is in the range $[2^(B-1), 2^B -1]$. A binary search can be performed in this range to find the exact $k^*$, but simply running WM for each value in the range is often sufficient.

- *Time Complexity:* If the minimal number of errors is $k^*$, the total work is dominated by the last successful iteration. The total complexity is $O(4k^* ceil(m/w) n)$, where $w$ is the word size. This is very efficient if the best match is a good one (i.e., $k^*$ is small).

=== Searching with Wildcards
The algorithm can be adapted to handle wildcards like `?` (matches any single character) or the Kleene star `*` (matches any sequence of zero or more characters).
- For `?`, the corresponding position in all character masks $t[c]$ is set to 0, ensuring it always matches.
- For `*`, the logic is more involved. Let the pattern be $P = p_1 * p_2 * ... * p_r$.

We introduce a new bit vector $t^*$ of length $m$, where $t^*[j] = 0$ if $P[j]$ is a `*` and 1 otherwise.

The definition of the state vectors `s[q]` is modified to handle the zero-cost matching of `*`. An observation is that if we have a q-approximate match ending just before a `*`, we can extend this to a q-approximate match at the `*` position, and also at any position after it, for free.

The update rule for the state vector $s[q]$ is adjusted to reflect this. The new state $s'[q]$ is computed, and then it is AND-ed with a mask derived from the previous state and the $t^*$ vector.
$ s'_q = s'_q and (s_(q-1) or t^*) $
This operation effectively says that if a q-1 approximate match was possible at the previous step, we can treat the current position as a match regardless of the character, provided it's a wildcard position.

=== Multiple Patterns
To search for a finite set of patterns, the Wu-Manber algorithm can be adapted by concatenating all patterns into a single, long super-pattern. The core algorithm is then run on this super-pattern, but it requires special handling to manage the boundaries between the original patterns.

- *Idea:* Combine patterns $P_1, P_2, ..., P_r$ into one pattern $P = P_1 P_2 ... P_r$. Process $P$ as a single needle and then apply corrections for potential errors occurring at the boundaries.

- *Boundary Correction:* A special bitmask, let's call it $M$, is used to identify the start of each original pattern within the concatenated super-pattern.
  - The mask $M$ has a $0$ at the starting position of each sub-pattern and $1$s everywhere else. For example, if $P_1$ has length $m_1$ and $P_2$ has length $m_2$, the mask would start with $01...1(m_1-1 " times")01...1(m_2-1 " times"})...$
  - This mask is used to prevent invalid matches that span across pattern boundaries.

- *State Vector Updates:*
  - For an *exact match* ($q=0$), the update rule for the state vector $s[0]$ is modified to prevent a pattern from matching outside its intended starting position. The character masks are updated as $t'[c] = t[c] | M$, and the update is $s'[0] = (s[0] <<< 1 | t'[T[i]])$.
  - For an *approximate match* with $q >= 1$, the update must allow for errors at the beginning of each sub-pattern. This is done by applying the mask to the final state vector for each level of error $q$. For $q=1$, the update is $s'[1] = s'[1] & M$, which allows for one mismatch at the start of each pattern.
  - For a general $q > 1$, a modified mask $M_q$ (with $q$ zeros at the start of each pattern section) is used: $s'[q] = s'[q] & M_q$.

This technique allows the algorithm to find all occurrences of any of the patterns from the set, while maintaining its efficiency.

=== Combining Exact and Approximate Matching
The algorithm can be modified to enforce that some parts of the pattern must match exactly, while others can match approximately. This is useful for patterns where certain characters are more significant than others.

- *Idea:* For specific positions in the pattern, the operations of *Insert*, *Delete*, and *Replace* are effectively forbidden.
- *Mechanism:* This is achieved by introducing a new bit vector, let's call it $e$ (for "exact"), of length $m$.
  - $e[j] = 1$ if the character $P[j]$ must match exactly.
  - $e[j] = 0$ if the character $P[j]$ can be part of an approximate match.

The state update formula is then modified to incorporate this mask. The original formula computes the state based on previous states and the character mask. The new formula ensures that for positions marked in $e$, no errors are allowed.

The simplified update part $(s^1 & s^2 & s^3)$ (which combines the results of deletion, insertion, and substitution from the previous states) is OR-ed with the exact mask $e$. This forces the bits corresponding to exact-match positions to $1$, effectively preventing an approximate match from being considered valid at those positions.

The modified update looks like this: (approx, see the slides)
$
  s'_q = ((((s_q <<< 1) or t[T[i]]) and (((s_q-1 <<< 1))) or e) and (s_q-1 <<< 1 or t[T[i]]) and s_q-1)
$

This ensures that for any position $j$ where $e[j]=1$, the state bit $s'[q, j]$ can only become 0 if there is an exact match path, not through an error-introducing path.

== Tasks

=== Task 1
What is the main innovation of the Wu-Manber algorithm compared to the standard dynamic programming approach?

=== Task 2
In the Wu-Manber algorithm, what does the bit vector $s[q]$ represent?

=== Task 3
How would you modify the preprocessing step (character masks) to handle the wildcard `?` in a pattern like $"a?c"$?

=== Task 4
Explain the strategy to find the single best approximate match of a pattern $P$ in a text $T$, not just all matches with at most $k$ errors.

=== Task 5
When searching for multiple patterns by concatenating them, what is the purpose of the boundary mask $M$?

#pagebreak()

== Solutions

=== Solution 1
The main innovation of the Wu-Manber algorithm is the application of *bit parallelism* to the dynamic programming solution for approximate string matching. Instead of calculating each cell of the DP matrix one by one ($O(m n)$), it represents entire columns or diagonals as bit vectors. It then computes the next set of vectors using a constant number of fast, word-level bitwise operations (shifts, ANDs, ORs). This parallelizes the computation and reduces the complexity, making it significantly faster when the pattern length $m$ is not much larger than the machine word size.

=== Solution 2
The bit vector $s[q]$ (for $q$ from 0 to $k$) is a state vector where the $j$-th bit being 0 indicates that the prefix of the pattern of length $j$, $P[1..j]$, can be matched with a substring of the text ending at the current position with an edit distance of *at most* $q$. A 1 indicates the distance is greater than $q$. When the last bit, $s[k,m]$, is 0, the entire pattern has been matched with at most $k$ errors.

=== Solution 3
To handle a wildcard `?` at position $j$ in the pattern (e.g., in $"a?c"$), you would modify the precomputation of the character masks. For the wildcard position $j$, the $j$-th bit in *every* character mask $t[c]$ would be set to 0. This ensures that regardless of the current character $T[i]$ in the text, the $| t[T[i]]$ operation in the update formula will always result in a 0 at position $j$, simulating a "free" match.

=== Solution 4
To find the single best match (i.e., the one with the minimum edit distance), you can use an iterative approach with the Wu-Manber algorithm:
1. Initialize a variable `best_k` to infinity and `best_position` to null.
2. Iterate $k$ from 0 up to a reasonable maximum (or the pattern length $m$).
3. In each iteration, run the full Wu-Manber algorithm for the current value of $k$.
4. If the algorithm finds one or more matches at this $k$:
  - Record the current $k$ as `best_k`.
  - Record the position(s) of the match(es).
  - Stop the search and report `best_k` and the corresponding position(s).
5. If the loop completes without finding any matches, it means no match was found within the tested range.

This works because the first $k$ for which a match is found is, by definition, the minimum possible edit distance.

=== Solution 5
When searching for a set of patterns concatenated into a single super-pattern, the boundary mask $M$ is crucial for managing the divisions between the original patterns. Its primary purposes are:
- It prevents a single match from incorrectly spanning across the boundary of two adjacent sub-patterns.
- For exact matches ($q=0$), it ensures that a match for a sub-pattern can only begin at its designated starting position within the super-pattern.
- For approximate matches ($q > 0$), it is used to correctly allow for errors (like deletions or substitutions) at the very beginning of a sub-pattern, which would otherwise be treated as a continuation of the previous sub-pattern.

#pagebreak()
