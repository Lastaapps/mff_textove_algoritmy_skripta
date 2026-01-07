#import "../definitions.typ": *

= Exam Tasks

This chapter contains a selection of tasks that have appeared in exams for the Text Algorithms course. Each task includes a problem statement, a proposed solution, and notes on what the examiner might focus on.

#pagebreak()

== Effective Suffix Tree Construction

=== Problem Statement
Describe an efficient algorithm for constructing a suffix tree for a given string $T$. Explain its time complexity. This is often referred to as Ukkonen's algorithm.

=== Problem Solution
An efficient method for this is *Ukkonen's algorithm*, which builds the suffix tree in linear time, specifically $O(n)$ for an alphabet of constant size or $O(n log n)$ for a general alphabet.

The algorithm constructs an *implicit suffix tree* for each prefix of the text $T$, from $T[1..1]$ to $T[1..n]$. It proceeds in $n$ phases. In phase $i$, it ensures all suffixes of $T[1..i]$ are in the tree.

#info_box(title: "Key Concepts")[
  - *Implicit Suffix Tree:* A suffix tree where suffixes ending at internal nodes might not be explicitly marked. We convert it to a real suffix tree at the end.
  - *Suffix Links:* A pointer from an internal node representing string $"xa"$ (where $x$ is a character and $a$ is a string) to another internal node representing string $a$. These are crucial for the linear-time performance.
  - *Edge Labels:* Instead of storing substrings, edges are labeled with start and end indices, making the structure space-efficient.
]

Each phase $i$ consists of extensions $j=1, ..., i$. In extension $j$, we add the suffix $T[j..i]$ to the tree. Ukkonen's algorithm uses several tricks to do this efficiently:
1. Once a character is found to be on an edge, all subsequent suffixes for that phase are also present in the tree (Rule 3). This lets us stop a phase early.
2. We follow suffix links to quickly navigate from the end of one extension to the start of the next.
3. We keep track of the "active point" (active node, active edge, active length) to manage extensions.

=== Teacher's Note
#info_box[
  The teacher will likely focus on:
  - A clear explanation of why the algorithm is linear-time. This involves understanding the role of suffix links and the rule that allows stopping a phase early.
  - The difference between an implicit and an explicit suffix tree.
  - The purpose of each of the "tricks" (e.g., active point, suffix links, rule 3).
  - You should be able to trace the algorithm on a short example string like `"banana"`.
]

#pagebreak()

== Effective Suffix Array Construction

=== Problem Statement
Describe an efficient algorithm for constructing a suffix array and its LCP array. Explain the time complexity.

=== Problem Solution
An efficient algorithm for suffix array construction is the *SA-IS algorithm*, which runs in $O(n)$ time. It is a complex algorithm based on the concepts of S-type and L-type suffixes.

A simpler, non-linear but still efficient algorithm is based on prefix doubling (also known as Manber-Myers algorithm):
1. *Initialization (k=0):* Sort suffixes based on their first character. This gives an initial ranking.
2. *Iteration:* In step $k$, we assume we have correctly sorted all suffixes based on their first $2^k$ characters. We want to sort them based on their first $2^(k+1)$ characters.
3. A suffix $S_i$ starting at index $i$ can be seen as a pair of strings of length $2^k$: $(T[i..i+2^k-1], T[i+2^k..i+2^(k+1)-1])$.
4. We can use radix sort (or another stable sort) to sort the suffixes based on these pairs, using the ranks from the previous step.
5. We repeat this process $log n$ times, doubling the length of the sorted prefixes at each step.

*Complexity:* Each step takes $O(n)$ time with radix sort. There are $O(log n)$ steps. The total time complexity is $O(n log n)$.

*LCP Array Construction (Kasai's Algorithm):*
Once the suffix array (`SA`) is built, the LCP array can be constructed in $O(n)$ time using Kasai's algorithm. It relies on the observation that the LCP value of one suffix is related to the LCP value of the previous suffix in the text order.

=== Teacher's Note
#info_box[
  - For suffix array construction, knowing the $O(n log n)$ prefix doubling algorithm in detail is usually expected.
  - Mentioning the existence of a linear-time $O(n)$ algorithm like SA-IS shows deeper knowledge.
  - For the LCP array, you must mention that it can be built in linear time after the suffix array is complete and name-drop Kasai's algorithm.
]

#pagebreak()

== Pattern Matching with a Suffix Array

=== Problem Statement
Describe how to use a pre-built suffix array to find all occurrences of a pattern $P$ in a text $T$.

=== Problem Solution
A suffix array `SA` stores the starting positions of all suffixes of $T$ in lexicographical order.
To find occurrences of a pattern $P$ of length $m$:
1. Since the suffix array is sorted, all suffixes prefixed by $P$ will form a contiguous block in the `SA`.
2. We can find this block using two binary searches on the suffix array.
  - One search to find the start of the block (the first suffix $>= P$).
  - Another search to find the end of the block (the last suffix that starts with $P$).
3. The time complexity of a single binary search is $O(m log n)$, as each comparison with a suffix takes $O(m)$ time. The total time for finding the block is therefore $O(m log n)$.
4. Once the block (from index `start` to `end` in the `SA`) is found, all values `SA[i]` for $i$ from `start` to `end` are the starting positions of $P$ in $T$.

*Improvement with LCP Array:*
The search can be accelerated to $O(m + log n)$ using the LCP array to avoid re-comparing characters of $P$ at each step of the binary search.

=== Teacher's Note
#info_box[
  - The key is understanding that suffixes starting with the pattern form a contiguous block.
  - You must be able to state and justify the $O(m log n)$ complexity of the basic binary search approach.
  - For a better grade, mention the $O(m + log n)$ improvement using the LCP array.
]

#pagebreak()

== Aho-Corasick Algorithm

=== Problem Statement
Describe the Aho-Corasick algorithm for finding all occurrences of a finite set of patterns. Define the "fail function" and explain its role and construction.

=== Problem Solution
The Aho-Corasick algorithm finds all occurrences of a set of patterns (a dictionary) in a text in a single pass.
1. *Trie Construction:* First, all patterns are inserted into a trie. Some nodes are marked as "output" nodes if they represent a complete pattern.
2. *Fail Function:* For each node `u`, the fail link `f(u)` points to the node representing the longest proper suffix of the string at `u` that is also a prefix of some pattern.
3. *Searching:* The text is processed character by character. We traverse the trie. If a transition doesn't exist, we follow fail links until a transition is found or we reach the root. When we enter a node, we check for output patterns at that node and also at all nodes reachable via fail links.

*Fail Function Construction:*
The fail links are computed using a Breadth-First Search (BFS) starting from the root. For each node `u` and for each character `c` leading to a child `v`, the fail link `f(v)` is found by starting at `f(u)` and following its fail links until a node with a transition for `c` is found.

*Complexity:* $O(N+M+Z)$, where $N$ is text length, $M$ is total length of patterns, and $Z$ is number of matches.

=== Teacher's Note
#info_box[
  - A clear definition of the fail function is critical.
  - Explain why fail links are useful for not "rewinding" the text pointer.
  - Be ready to explain the BFS-based construction of fail links.
  - The amortized analysis for the linear-time search is a key theoretical point.
]

#pagebreak()

== Edit Distance (Wagner-Fischer)

=== Problem Statement
Provide the recurrence relation for computing the edit distance (Levenshtein distance) between two strings, $A$ and $B$, using dynamic programming. Explain the algorithm and its complexity.

=== Problem Solution
The Levenshtein distance is the minimum number of single-character edits (insertions, deletions, substitutions) to change string $A$ into $B$. The Wagner-Fischer algorithm solves this using dynamic programming.

We construct a matrix $D$ where $D[i, j]$ is the edit distance between the prefix $A[1..i]$ and $B[1..j]$.

#info_box(title: "Recurrence Relation")[
  - $D[i, 0] = i$
  - $D[0, j] = j$
  - For $i > 0, j > 0$:
    $D[i, j] = min(
      D[i-1, j] + 1, // Deletion
      D[i, j-1] + 1, // Insertion
      D[i-1, j-1] + "cost"(i, j) // Substitution
    )$
    where $"cost"(i, j)$ is 0 if $A[i] = B[j]$ and 1 otherwise.
]

*Complexity:*
- *Time:* $O(|A| dot |B|)$, as each cell is computed in constant time.
- *Space:* $O(|A| dot |B|)$. This can be optimized to $O(min(|A|, |B|))$.

=== Teacher's Note
#info_box[
  - You must write the full recurrence relation, including base cases.
  - Explain what each of the three main terms corresponds to.
  - State the time and space complexity and explain the space optimization.
]

#pagebreak()

== Longest Common Subsequence (LCS)

=== Problem Statement
Describe an algorithm to find the length of the Longest Common Subsequence (LCS) of two strings, $A$ and $B$.

=== Problem Solution
A subsequence is a sequence that can be derived from another sequence by deleting some or no elements without changing the order of the remaining elements. The LCS problem is solved using dynamic programming.

Let $L[i, j]$ be the length of the LCS of the prefixes $A[1..i]$ and $B[1..j]$.

#info_box(title: "Recurrence Relation for LCS")[
  - If $i=0$ or $j=0$, $L[i,j] = 0$.
  - If $A[i] = B[j]$:
    $L[i, j] = 1 + L[i-1, j-1]$
  - If $A[i] != B[j]$:
    $L[i, j] = max(L[i-1, j], L[i, j-1])$
]

The length of the LCS for the full strings is $L[ |A|, |B| ]$. To reconstruct the actual subsequence, one can backtrack from this cell.

*Complexity:*
- *Time:* $O(|A| dot |B|)$.
- *Space:* $O(|A| dot |B|)$, which can be optimized to $O(min(|A|, |B|))$ if only the length is needed.

=== Teacher's Note
#info_box[
  - The key is the recurrence relation. You must distinguish between the case where characters match and where they don't.
  - Be prepared to explain how to reconstruct the subsequence itself by backtracking through the DP table.
  - Contrast this with the Longest Common *Substring* problem, which is different and can be solved with a suffix tree or generalized suffix tree.
]

#pagebreak()

== NFA from Regular Expression

=== Problem Statement
Describe an algorithm to construct a Nondeterministic Finite Automaton (NFA) from a given regular expression.

=== Problem Solution
*Thompson's construction* is a standard algorithm for this. It is a syntax-directed approach that builds an NFA by composing smaller NFAs for sub-expressions. Each NFA built has exactly one start state and one final state.

1. *Base Cases:*
  - For an empty string expression $epsilon$, create an NFA with a single transition from start to final on $epsilon$.
  - For a character `c` in the alphabet, create an NFA with a single transition from start to final on `c`.

2. *Inductive Steps:*
  - *Union (r|s):* Create a new start state with $epsilon$-transitions to the start states of the NFAs for `r` and `s`. Create a new final state and add $epsilon$-transitions from the final states of `r` and `s` to it.
  - *Concatenation (rs):* The final state of `r`'s NFA becomes the start state of `s`'s NFA (often merged or linked by an $epsilon$-transition). The start state of `r` and final state of `s` become the new NFA's start and final states.
  - *Kleene Star (r\*):* Create a new start and final state. Add $epsilon$-transitions: from the new start to `r`'s start, from `r`'s final to its start, from `r`'s final to the new final, and from the new start to the new final (to accept the empty string).

*Complexity:* The resulting NFA has at most $2m$ states, where $m$ is the length of the regular expression. The construction takes $O(m)$ time.

=== Teacher's Note
#info_box[
  - You need to know the construction patterns for all three main operations: union, concatenation, and star.
  - Drawing the simple diagrams for each composition step is the best way to explain it.
  - Mentioning the properties of the constructed NFA (one start, one final state) is important.
]

#pagebreak()

== Space Complexity Comparison

=== Problem Statement
Compare the space complexity of the following data structures for a string of length $n$: Suffix Trie, Suffix Tree, Suffix Automaton (DAWG), CDAWG, and Suffix Array.

=== Problem Solution
#info_box(title: "Space Complexity on String of Length n")[
  - *Suffix Trie:* $O(n^2)$ states/nodes in the worst case (e.g., for string "a...az"). Each node can have pointers for the entire alphabet size, so space is $O(n^2|Sigma|)$.
  - *Suffix Tree:* $O(n)$ nodes. By using a hash map at each node (or other tricks), the space can be $O(n log |Sigma|)$ or $O(n)$ if the alphabet is constant. This is a huge improvement over the trie.
  - *Suffix Automaton (DAWG):* At most $2n+1$ states. Space is $O(n)$. It is generally the smallest of the tree/graph structures.
  - *CDAWG (Compacted DAWG):* At most $n+1$ vertices. Space is $O(n)$.
  - *Suffix Array:* $O(n)$ integers. This is the most space-efficient of all these structures.
  - *FM-index:* Based on the Burrows-Wheeler Transform (BWT), it can be highly compressed. Its space complexity can be close to the k-th order empirical entropy of the text, often much smaller than $O(n)$, while still supporting fast pattern matching.
]

=== Teacher's Note
#info_box[
  - The key is to have the big-O complexities memorized and to be able to rank the structures by space usage.
  - Suffix Array is the most compact of the uncompressed structures.
  - Suffix Trie is the least compact by far.
  - You should be able to briefly justify *why* the trie is $O(n^2)$ and the tree is $O(n)$ (path compression).
]

#pagebreak()

== Bit Parallelism (Shift-Or Algorithm)

=== Problem Statement
Explain the main idea of bit parallelism for string matching and describe an example algorithm, like Shift-Or.

=== Problem Solution
Bit parallelism takes advantage of the native bitwise operations of a processor (AND, OR, SHIFT) to perform multiple operations in a single step. It is very fast for small patterns (e.g., length up to 64 or 128).

*Shift-Or Algorithm:*
The algorithm maintains a state mask (an integer) `S` of length `m` (pattern length). The `i`-th bit of `S` is 0 if the prefix of the pattern `P[1..i]` is a suffix of the text processed so far.

1. *Preprocessing:* Create a character mask `C` for each character in the alphabet. `C[char]` is a bitmask of length `m` where the `i`-th bit is 0 if `P[i] == char`, and 1 otherwise.
2. *Searching:* Initialize the state `S` to all 1s. For each character `t` of the text:
  - `S = (S << 1) | C[t]`
  - The `<< 1` shifts the state, effectively matching the next character.
  - The `| C[t]` updates the mask based on the current text character. A 0 can only be preserved if the new character `t` matches the corresponding pattern character.
3. *Match:* A match is found if the most significant bit of `S` becomes 0.

*Complexity:* Preprocessing is $O(|Sigma|m)$. Searching is $O(n)$. This is extremely fast in practice for small `m`.

=== Teacher's Note
#info_box[
  - The core idea is using bits to represent the state of a parallel NFA simulation.
  - You must explain the preprocessing step (character masks) and the update formula for the state mask.
  - Be clear that this method's main limitation is the dependency on the machine's word size (e.g., 64 bits).
]

#pagebreak()

== Finding All Repeated Substrings

=== Problem Statement
Describe an algorithm to find all pairs of indices (i, j) such that the substrings starting at these positions are identical for some length k > 0.

=== Problem Solution
This problem is equivalent to finding all substrings that appear more than once. This can be solved efficiently using a suffix tree or a suffix array with an LCP array.

*Using a Suffix Tree:*
1. Build the suffix tree for the text $T$.
2. Every internal node in the suffix tree represents a substring that is repeated at least twice in the text.
3. The leaves in the subtree of an internal node `u` correspond to the starting positions of the suffixes that contain the substring represented by `u`.
4. By traversing the tree (e.g., with a DFS), we can visit each internal node. For each internal node, we can report all pairs of leaves in its subtree to get the required (i, j) pairs. The string represented by the path to the node gives the repeated substring.

*Complexity:* Building the suffix tree is $O(n)$. Traversing it and reporting the leaves under each internal node can be done in time proportional to the number of pairs, which can be large. Finding just the repeated substrings themselves is linear.

=== Teacher's Note
#info_box[
  - The key insight is that *internal nodes* of a suffix tree correspond to repeated substrings.
  - You should be able to explain what the leaves under an internal node represent.
  - An alternative solution using the Suffix Array and LCP array exists: any LCP value greater than 0 indicates a repeated substring between adjacent suffixes in the array.
]

#pagebreak()

== Ukkonen-Meyers Algorithm Idea

=== Problem Statement
Explain the main idea of the Ukkonen-Meyers algorithm for approximate string matching.

=== Problem Solution
The Ukkonen-Meyers algorithm finds occurrences of a pattern $P$ in a text $T$ with at most $k$ errors (edit distance) in $O(n k)$ or even $O(n)$ time on average, which is much better than the standard $O(m n)$ DP approach for large $m$.

*Main Idea:*
The algorithm is an optimization of the classic dynamic programming approach. The DP matrix for edit distance has a special property: the values in adjacent cells can differ by at most 1.
$D[i, j]$ is the edit distance between $P[1..j]$ and some substring of $T$ ending at $T[i]$.

The key observation is that values along the diagonals of the DP matrix are non-decreasing. The algorithm reformulates the problem to find, for each diagonal `d`, the furthest row `r` one can reach with at most `e` errors.

This means instead of filling the whole $O(m n)$ table, we only compute the furthest reachable point on each relevant diagonal for each number of errors $e=0, 1, ..., k$. This is much more efficient as we only need to track $k$ active diagonals at a time.

=== Teacher's Note
#info_box[
  - This is an advanced topic. The main point is not the full implementation, but the high-level idea.
  - You must state that it's an optimization of the standard DP algorithm for edit distance.
  - The key insight to mention is the "diagonal" property of the DP matrix and that the algorithm efficiently computes the furthest-reaching match on each diagonal for a given number of errors.
]

#pagebreak()

== Normal Form of a Word

=== Problem Statement
Explain what the "normal form" of a word is and how it can be computed.

=== Problem Solution
The normal form of a word $w$ is its shortest prefix that can be used to construct $w$ through concatenation and taking prefixes. This is directly related to the concept of the *smallest period* of a word.

If a word $w$ has a period `p`, it means $w$ is a prefix of $p^k$ for some integer $k$. The smallest such string `p` is the smallest period of $w$. The normal form of $w$ is this smallest period.

*Computation:*
The normal form can be found using the *border array* (also known as the failure function from KMP). The border array, `pi`, for a string $w$ of length $m$ stores at `pi[i]` the length of the longest proper prefix of $w[1..i]$ that is also a suffix of $w[1..i]$.

The length of the smallest period of $w$ is given by the formula: `m - pi[m]`, if `m` is divisible by `m - pi[m]`. If it is not divisible, then the smallest period is `m` itself (the word is unperiodic).

*Example:* For $w = "ababab"$, $m=6$. The border array's last element is `pi[6] = 4` (for "abab"). Length of period candidate is $6-4=2$. Since 6 is divisible by 2, the period is 2. The normal form is the prefix of length 2, which is `"ab"`.

=== Teacher's Note
#info_box[
  - Connect the "normal form" to the "smallest period" of a string.
  - The crucial part is the computation using the border array (KMP failure function).
  - Be ready to state the formula `m - pi[m]` and the divisibility condition.
]

#pagebreak()

== Palindrome Problem

=== Problem Statement
Describe an efficient algorithm to find all palindromic substrings in a given string.

=== Problem Solution
*Manacher's Algorithm* is a classic linear-time $O(n)$ algorithm for this problem.

The naive approach of checking every substring takes $O(n^3)$ or $O(n^2)$ with optimizations. Manacher's algorithm avoids re-computation by exploiting the palindromic structure already found.

*Main Idea:*
1. *Preprocessing:* The input string `S` is transformed into a new string `T` by inserting a special character (e.g., "\#") between all characters and at the ends. This makes all palindromes (both even and odd length) have an odd length and a clear center in `T`. E.g., "aba" -> "\#a\#b\#a\#" and "abba" -> "\#a\#b\#b\#a\#".
2. *Expansion:* The algorithm maintains an array `P` where `P[i]` stores the radius of the palindrome centered at `T[i]`. It iterates through `T`, calculating `P[i]` for each `i`.
3. *Optimization:* When calculating `P[i]`, it uses the information from palindromes already found. If `i` is within the bounds of a previously found large palindrome (centered at `C` with right boundary `R`), the value `P[i]` can be initialized based on its mirror image `P[i_mirror]` where `i_mirror = 2*C - i`. This often allows skipping many character comparisons.
4. The algorithm only expands around `i` when the mirror value doesn't provide the full answer or when `i` is outside the current rightmost boundary `R`.

*Complexity:* Although it seems complex, the right boundary `R` only ever moves forward. The amortized analysis shows that the total number of character comparisons is linear, leading to an overall $O(n)$ time complexity.

=== Teacher's Note
#info_box[
  - The main algorithm to mention is Manacher's.
  - You must explain the preprocessing step of inserting '\#' and why it's useful (to handle even/odd palindromes uniformly).
  - The core optimization is using previously computed palindrome radii (`P` array) to avoid redundant comparisons. Explaining the "center" `C` and "right boundary" `R` is key to showing you understand the optimization.
]
#pagebreak()
