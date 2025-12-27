#import "../definitions.typ": *

#set page(
  numbering: "1",
  number-align: center,
)

#set text(lang: "en")

= Suffix Tree Applications

This chapter explores various applications of suffix trees, a powerful data structure for string processing.

== Basic Applications

Suffix trees provide efficient solutions for several fundamental string problems.

=== Substring Search

Finding if a string $P$ is a substring of a text $T$.

- Construct a suffix tree for $T$, denoted as $T(sigma)$.
- Traverse $T(sigma)$ with $P$. If the traversal successfully matches $P$ to a path in the tree, $P$ is a substring.

=== Finding All Occurrences of a Pattern

To find all occurrences of a pattern $P$ in a text $sigma$:

- Build the suffix tree $T(sigma)$.
- Locate the node $v$ in $T(sigma)$ that corresponds to the string $P$. If $P$ is not explicitly represented as a node, it will be an implicit node on an edge.
- All leaves in the subtree rooted at $v$ represent occurrences of $P$. The indices associated with these leaves are the starting positions of $P$ in $sigma$.

#info_box[
  - *Complexity:*
    - Preprocessing (building $T(sigma)$): $O(N)$
    - Search (finding $P$ and its occurrences): $O(M + Z)$, where $N$ is text length, $M$ is pattern length, and $Z$ is the number of occurrences.
    - Compared to KMP algorithm, suffix trees offer better performance for multiple pattern searches after initial construction.
]

=== Finding All Occurrences of Multiple Patterns

To find all occurrences of a set of patterns {$P_1, P_2, dots, P_k$} in $sigma$:

- This can be done by repeating the single pattern search for each $P_i$.
- Alternatively, for a set of patterns, generalized suffix trees or Aho-Corasick algorithm might be more suitable.

#info_box[
  - *Complexity:*
    - Preprocessing: $O(N)$
    - Search: $O(M + Z)$, where $N$ is text length, $M = sum |P_i|$, and $Z$ is total number of occurrences.
    - Compared to Aho-Corasick: Aho-Corasick has $O(M)$ preprocessing and $O(N)$ search, which can be faster if $Z$ is large.
]

=== Counting Distinct Substrings

Every distinct substring of a text $sigma$ corresponds to a unique path from the root to an explicit or implicit node in its suffix tree $T(sigma)$.

- The number of distinct substrings can be found by summing the lengths of all paths from the root to each node (explicit and implicit), considering each unique path as a distinct substring.
- More simply, it is the total number of nodes (explicit and implicit) in the suffix tree.

== Longest Common Factor (LCF)

The longest common factor (LCF) of two strings $sigma$ and $tau$ is the longest string that is a substring of both $sigma$ and $tau$.

To determine $"LCF"(sigma, tau)$:

- Construct a generalized suffix tree for $sigma$ and $tau$ with unique terminators. For example, $T(sigma + #sym.dollar, tau + #sym.hash)$.
- The LCF corresponds to the deepest node in this generalized suffix tree that has descendants from both $sigma$ and $tau$.

#info_box[
  - *Challenge:* The generalized suffix tree also contains substrings that "cross" the boundary between the original strings, which are not true common factors.
  - *Solution:* To find LCF, identify the node $v$ which is an ancestor to leaves representing suffixes from both $sigma$ and $tau$, and has the greatest string depth. If we have $T(sigma, tau)$, the node representing $"LCF"(sigma, tau)$ is the highest node that has descendant leaves from both $sigma$ and $tau$.
]

== Generalized Suffix Tree $T(sigma, tau)$

A generalized suffix tree for two strings $sigma$ and $tau$ is a compact suffix trie of all suffixes of $sigma$ and $tau$.

- Let $n = |sigma| + |tau|$.
- It can be constructed in $O(n)$ time using extensions of Ukkonen's algorithm.

#info_box[
  - *Problems with labels:*
    - Edge labels may refer to either $sigma$ or $tau$. A third index might be needed to identify the original string.
    - A leaf node can represent a suffix common to both $sigma$ and $tau$. Such a leaf would store references to both original strings.
]

=== LCF using $T(sigma, tau)$

To find $"LCF"(sigma, tau)$ using $T(sigma, tau)$:

- Mark each internal node $v$ based on whether its subtree contains leaves from $sigma$ (mark 1) or $tau$ (mark 2).
- Any internal node marked with both 1 and 2 represents a common factor.
- The deepest such node represents the $"LCF"(sigma, tau)$.

== Generalized Suffix Trees for Multiple Strings

The concept extends to a set of $k$ strings {$sigma_1, dots , sigma_k$}, yielding $T(sigma_1, dots, sigma_k)$.

- Construction: $O(N)$ where $N = sum |sigma_i|$.
- Applications include finding all occurrences of a pattern in any of the $k$ strings, or finding the LCF of a subset of strings.
- *Example:* Identifying common genetic sequences across multiple DNA strands.

== Exact Repeats and Maximal Repeats

=== Exact Repeats

An exact repeat is a substring that occurs at least twice in a text.

- In a suffix tree $T(sigma)$, repeating substrings are represented by internal nodes.
- The occurrences of such a repeat are given by the indices stored in the leaves of the subtree rooted at that internal node.
- *Time complexity:* $O(N+Z)$, where $Z$ is the total length of all reported repeats.

=== Maximal Repeats

A maximal repeat is an exact repeat that cannot be extended to the left or right without losing its exact repeat property.

- #underline[Non-Right Extendible (NRE):] A repeat $S$ is NRE if for its two occurrences starting at $i$ and $j$, $S[i+|S|] != S[j+|S|]$. That is, the characters immediately following the occurrences are different.
- #underline[Non-Left Extendible (NLE):] A repeat $S$ is NLE if for its two occurrences starting at $i$ and $j$, $S[i-1] != S[j-1]$. That is, the characters immediately preceding the occurrences are different.

#info_box[
  - *Observation:* Maximal repeats correspond to specific internal nodes in the suffix tree with NLE property.
  - In a string of length $N$, there are at most $N$ maximal repeats.
]

=== Node Marking for Maximal Repeats

To identify maximal repeats, nodes in the suffix tree are marked based on the characters preceding their occurrences.

- For a leaf $s$ corresponding to a suffix starting at index $i$, it is marked with the character $sigma[i-1]$ (if $i>0$).
- For an internal node $v$:
  - If any child of $v$ is marked as NLE, then $v$ is also NLE.
  - If all children of $v$ have the same mark, $v$ inherits that mark.
  - Otherwise (children have different marks), $v$ is NLE.

_Boundary nodes_ are NLE nodes whose children are not all NLE. These nodes represent the maximal repeats.

== Longest Common Ancestor (LCA) and Longest Common Prefix (LCP)

=== Lowest Common Ancestor (LCA)

The Lowest Common Ancestor LCA($alpha$, $beta$) of two nodes $alpha$ and $beta$ in a tree is the deepest node that is an ancestor of both $alpha$ and $beta$.

- LCA($alpha$, $beta$) can be found efficiently. The naive approach would be $O(max("depth of " alpha, "depth of " beta))$. More advanced techniques use preprocessing for faster queries.

=== Longest Common Prefix (LCP)

The Longest Common Prefix LCP($alpha$, $beta$) of two strings $alpha$ and $beta$ is the longest string that is a prefix of both $alpha$ and $beta$.

- In a suffix tree $T_s$, the length of the LCP of two suffixes (represented by leaves $alpha$ and $beta$) is equal to the string depth of their LCA($alpha$, $beta$).
- $"lcp"(alpha, beta) = "string_depth" "LCA"(alpha, beta)$.

== Range Minimum Query (RMQ)

A Range Minimum Query ($"RMQ"_A(i, j)$) on an array $A$ returns the index of the minimum element within the range $A[i dots j]$.

=== Conversion LCA to RMQ

LCA queries can be reduced to RMQ queries.

- Perform a Depth First Search (DFS) traversal of the suffix tree, recording the depth of each node visited in an array.
- For any two nodes $alpha$ and $beta$, their LCA$(alpha, beta)$ corresponds to a Range Minimum Query on this depth array within the range of visits to $alpha$ and $beta$.

#info_box[
  - *RMQ in O(N log N) time:*
    - Preprocessing can be done in $O(N log N)$ time and space.
    - Queries can then be answered in $O(1)$ time.
]

=== RMQ±1 in O(N)

For arrays where adjacent elements differ by exactly $plus.minus 1$ ($|A[i] - A[i+1]| = 1$), RMQ can be solved in $O(N)$ time.

- This property holds for the depth array generated by a DFS traversal.
- The approach involves dividing the array into blocks, normalizing blocks, and using a combination of techniques for querying within and between blocks.
- _Algorithm:_
  - Preprocessing: $O(N)$ time and space.
  - Query: $O(1)$ time.

#info_box[
  - *Conclusion:* By combining suffix trees with RMQ±1 techniques, LCP queries can be answered in constant time after linear time and space preprocessing.
]

== Maximal Palindromic Substring

A maximal palindromic substring is the longest substring of a text that reads the same forwards and backward.

To find maximal palindromic substrings:

- Construct a generalized suffix tree for $sigma$ and its reverse $sigma^R$, i.e., $T(sigma, sigma^R)$.
- Precompute LCP arrays for constant-time LCP queries.
- Iterate through each position $i$ in $sigma$:
  - For odd length palindromes:
    - $k = "lcp"(sigma[i:], sigma^R [N-i:])$
    - The maximal palindrome is $sigma[i-k+1 : i+k]$.
  - For even length palindromes:
    - $k = "lcp"(sigma[i:], sigma^R [N-i+1:])$
    - The maximal palindrome is $sigma[i-k : i+k]$.
- _Time complexity:_ $O(N)$ after $O(N)$ preprocessing.

== Maximal Bi-palindromes

A bi-palindrome is a string that reads the same forwards and backward under a complementary alphabet mapping.

- For DNA sequences, the alphabet is {C, G, A, T}.
- Complementary pairs: $C <=> G$, $A <=> T$.
- A string $sigma$ is a bi-palindrome if $sigma^{c R} = sigma$, where $sigma^c$ is the complement of $sigma$, and $sigma^R$ is the reverse of $sigma$.

== Suffix Trees in a Sliding Window

Suffix trees can be adapted to dynamic text scenarios, such as a sliding window.

- _Ukkonen's Algorithm (1992):_
  - Efficiently updates a suffix tree when a character is appended to the right of the text (e.g., $T(sigma) mapsto T(sigma a)$).
  - Time complexity: Amortized $O(1)$ for each character.
- _Fiala & Greene (1989):_
  - Showed how to update a suffix tree when a character is removed from the left (e.g., $T(a sigma) mapsto T(sigma)$).
  - Requires backward pointers in the tree.
  - Time complexity: $O(1)$ amortized.
- These techniques allow maintaining a suffix tree for a text within a fixed-size sliding window efficiently.

#info_box[
  - *Challenge:* Efficiently updating pointers within the sliding window.
  - *Solution:* "Percolating update" mechanisms have been developed (Fiala, Greene 1989; Larsson 1999; Senft 2005) for amortized $O(1)$ updates.
]

== Data Compression: LZ77 Algorithm

The LZ77 algorithm, developed by Jacob Ziv and Abraham Lempel (1977), is a foundational dictionary-based compression algorithm.

- #underline[Idea:] Replace repeating sequences of characters with pointers to their previous occurrences in the text.
- It uses a _sliding window_ that consists of a _search buffer_ (already processed text) and a _look-ahead buffer_ (text to be compressed).

#info_box[
  - *Process:*
    - Initialize the search buffer (e.g., with spaces) and load the beginning of the input into the look-ahead buffer.
    - Find the longest match $S$ that is a prefix of the look-ahead buffer and exists in the search buffer.
    - Encode $S$ as a triplet $(3, 5, "d")$:
      - `offset`: Distance from the current position to the start of $S$ in the search buffer.
      - `length`: The length of $S$.
      - `next_char`: The character immediately following $S$ in the look-ahead buffer.
    - Shift the sliding window by `length + 1` characters.
  - *Example:*
    - Text: `accabracadabrarrar`
    - Find `cabra` (length 5) at offset 3 in search buffer, followed by `d`.
    - Encoded as $(3, 5, "d")$.
  - *Gzip implementation:* Uses a sliding window of $2^{15}$ bytes (search buffer) and a look-ahead buffer of $256$ bytes.
]

=== Implementation of Sliding Window

- _Suffix Trees:_ Can be used to efficiently find the longest match in the search buffer.
- _Hash Tables:_ Common for LZ77 implementations (e.g., in Deflate, used by gzip and zlib), offering good practical performance.

== Pros and Cons of Suffix Trees

=== Advantages

- Small alphabet sizes.
- Static (unchanging) text $sigma$.
- Frequent queries for short patterns $P$ where $|P| << |sigma|$.

=== Disadvantages

- High space complexity: Typically requires $10N$ to $30N$ bytes in practice for a text of length $N$.
  - Research efforts (e.g., Stefan Kurtz) have focused on reducing this space requirement, achieving around $10.1N$ on average and $20N$ in the worst case.

  == Tasks

1. Given a text `$T$`, how can you use a suffix tree to find the longest substring that appears at least twice?
2. Explain how you would find the shortest unique substring of a text `$T$` using its suffix tree.
3. How does a suffix tree help in the LZ77 compression algorithm?

#pagebreak()

== Solutions

=== Task 1: Longest Repeating Substring

The longest substring that appears at least twice in a text corresponds to the deepest internal node in the suffix tree of that text.
1. *Build the Suffix Tree:* Construct the suffix tree for the text `$T$`.
2. *Traverse the Tree:* Perform a traversal (like DFS) of the tree to find the string-depth of every node. An internal node represents a substring that is repeated.
3. *Find Deepest Node:* The internal node with the greatest string-depth represents the longest repeated substring. The path from the root to this node spells out the substring.

=== Task 2: Shortest Unique Substring

A unique substring corresponds to a path in the suffix tree that leads to a leaf node and is not a prefix of any other suffix. The shortest unique substring is found by identifying the shallowest leaf node.
1. *Build the Suffix Tree:* Construct the suffix tree for `$T$`.
2. *Find Shallowest Leaf:* Traverse the tree to find the leaf node with the minimum string-depth. A leaf node represents a suffix that occurs once. We are interested in the shortest prefix of a suffix that is unique. This corresponds to the path to a leaf node.
3. *Identify the Substring:* The path from the root to this shallowest leaf spells out a suffix. The shortest unique substring is the path from the root to the parent of that leaf, plus one character. More simply, any path that ends at a leaf represents a unique suffix. The shortest such unique substring is the one corresponding to the path to the leaf with the smallest string depth.

=== Task 3: Suffix Trees in LZ77

The LZ77 compression algorithm works by finding the longest prefix of the look-ahead buffer that has occurred previously in the search buffer. A suffix tree can be used to make this search very efficient.
1. *Data Structure:* A suffix tree is built for the contents of the search buffer.
2. *Searching:* To find the longest match, you can traverse the suffix tree with the characters from the look-ahead buffer. The longest path you can trace from the root corresponds to the longest match found in the search buffer.
3. *Updating:* As the sliding window moves, characters are added to and removed from the buffers. This requires a dynamic suffix tree that can be updated efficiently. While conceptually elegant, this is complex. In practice, hash tables are often used as a simpler and very fast alternative for finding matches in LZ77 implementations.

