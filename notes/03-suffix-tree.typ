#import "../definitions.typ": *

= Suffix Tree

== Trie (Prefix Tree)

A Trie, also known as a prefix tree or character tree, is a specialized tree-like data structure used to store a dynamic set or associative array where keys are usually strings. It is particularly effective for "information retrieval" and string matching problems.

#info_box(title: "Trie Characteristics", [
  - A search tree representing a set of words.
  - Each edge is labeled with a character.
  - Each node represents a prefix of some words in the set.
])

=== Suffix Trie

A Suffix Trie for a word $sigma$ of length $n$ is a trie built on the set of all suffixes of $sigma$.

#info_box(title: "Suffix Trie", [
  - It stores all suffixes of a given string $sigma$.
  - The set of strings stored in the trie is all suffixes of $sigma$.
  - A special terminator character, usually #sym.dollar, is appended to the string ($sigma dollar$) to ensure that every suffix ends at a unique leaf node in the trie. This prevents one suffix from being a prefix of another suffix.
])

== Advantages and Disadvantages of Tries

When using a Suffix Trie to check if a needle $iota$ is a substring of a haystack $sigma$:

#info_box[
  - *Advantage: Time Complexity*
    - Membership can be decided in $O(m)$ time, where $m = |iota|$.
    - This assumes $O(1)$ time for branching operations (i.e., traversing an edge based on a character).
  - *Disadvantage: Space Complexity*
    - Tries can consume significant memory, especially for large alphabets or long strings, due to the number of nodes and pointers required.
]

=== Space Complexity Problem

- In the worst case, a Suffix Trie for a word of length $n$ over an alphabet $Sigma$ requires $Omega(n^2)$ space.
- This can occur regardless of whether $Sigma$ is infinite, finite, or a specific small alphabet like $\{0,1\}$.
- The $Omega(n^2)$ space complexity is a significant drawback for Suffix Tries.

== Compressed Tries and Suffix Trees

To overcome the space limitations of standard Tries and Suffix Tries, the concept of a _Compressed Trie_ (also known as a Patricia Trie) is introduced.

#info_box(title: "Patricia Trie (Compressed Trie)", [
  - A Patricia Trie is a space-optimized Trie that compacts paths in the tree.
  - _Path Compression_: It eliminates all nodes that have only one child, except for the root.
  - Edges can then be labeled with entire strings (sequences of characters) rather than single characters.
])

A _Suffix Tree_ is essentially a _Compressed Suffix Trie_ built for a word
$sigma dollar$. It is a Patricia Trie built from all suffixes of a given
string. This compression significantly reduces the space complexity while
retaining the fast search capabilities.

#info_box(title: "Suffix Tree Definition Refined", [
  - It is a compact trie constructed from the set of all suffixes of a string $sigma$.
  - A common practice is to append a unique terminator character #sym.dollar to the string (e.g., $sigma dollar$) to ensure that all suffixes end at leaf nodes and no suffix is a prefix of another.
  - _Edge Labels_: Instead of explicitly storing the string on each edge, labels are typically represented by a pair of indices `(start, end)` that point to a substring within the original text $sigma$. This approach is crucial for achieving linear space complexity.
])

== Properties of Suffix Trees

It's important to distinguish between the substrings explicitly represented in a Suffix Trie versus a Suffix Tree due to the compression.

#info_box(title: "Explicit vs. Implicit Representation", [
  - *In a Suffix Trie*:
    - Every node $v$ explicitly represents a word formed by concatenating the edge labels from the root to $v$.
    - All words represented by any node in a Suffix Trie correspond to all possible substrings of the original string $sigma$.
  - *In a Suffix Tree $T(sigma)$*:
    - Due to path compression, only some substrings of $sigma$ are explicitly represented by nodes. These typically include all suffixes of $sigma$ (as leaf nodes).
    - Other substrings are represented *implicitly* along the compressed paths (edges) of the tree.
    - Each node in $T(sigma)$ is identified with the word it explicitly represents.
])

== Space Complexity of Suffix Trees

One of the significant advantages of Suffix Trees over Suffix Tries is their improved space complexity, which is linear with respect to the length of the string.

#info_box(title: "Linear Space Bounds for Suffix Trees", [
  For a suffix tree $T(sigma)$ built over a word $sigma$ of length $n$:
  - The number of vertices $|V(T(sigma))|$ is at most $2n + 1$.
  - The number of edges $|E(T(sigma))|$ is at most $2n$.

  _Proof Sketch_:
  - A suffix tree for a string of length $n$ will have exactly $n + 1$ leaf nodes (one for each suffix, including the empty suffix or using a terminator).
  - In a rooted tree where every internal node (parent) has at least two children, the number of leaves is always greater than the number of internal nodes. Specifically, a binary tree with $L$ leaves has $L-1$ internal nodes. For general trees with at least 2 children per internal node, the number of internal nodes is at most $L-1$.
  - Therefore, a suffix tree has at most $n$ internal nodes.
  - The total number of nodes (vertices) is $n$ (internal) + $n + 1$ (leaves) = $2n + 1$.
  - For any tree, the number of edges is $|V| - 1$, so $|E(T(sigma))| <= (2n + 1) - 1 = 2n$.
])

#info_box(title: "Edge Label Representation and Space", [
  - The overall space complexity for a Suffix Tree, considering both nodes and edges, is $O(n)$, where $n = |sigma|$.
  - _Edge Labels_: Edge labels, representing substrings $sigma[i..j]$, are stored as pairs of indices $(i, j)$ pointing into the original string.
    - Storing each index $i$ or $j$ requires $O(log n)$ space (to represent numbers up to $n$).
    - In a practical sense, if the machine's word size $w$ is sufficient to hold these indices (i.e., $w >= log n$), then each index can be considered $O(1)$ space, making the storage of $(i, j)$ pairs effectively $O(1)$.
])

== Basic Problem: Substring Search

The primary application of a Suffix Tree is to efficiently determine if a given pattern (needle) $iota$ is a substring of a larger text (haystack) $sigma$.

#info_box(title: "Substring Search in a Suffix Tree", [
  - *Input*: A Suffix Tree $T(sigma)$ for a text $sigma$, and a pattern $iota$.
  - *Question*: Is $iota$ a substring of $sigma$? (i.e., is $iota$ represented in $T(sigma)$?)

  - *Approach*: To find $iota$ in $T(sigma)$, we traverse the tree starting from the root.
    - At each node, we select the outgoing edge whose label matches the next character(s) of $iota$.
    - The efficiency of this "branching operation" (selecting the correct edge) heavily depends on how the children of a node are represented.
])

=== Tree Representation

The practical implementation of a Suffix Tree relies on efficient representation of its nodes and edges.

#info_box(title: "Representing Nodes and Edges", [
  - Each node typically stores references to its children.
  - Edges are implicitly represented by pointers to the original string, using `(start_index, end_index)` pairs, rather than explicitly storing the substring. This allows for constant-time traversal of an edge after determining which edge to follow.
  - The choice of data structure for storing a node's children (e.g., linked list, hash table, array) significantly impacts the efficiency of branching operations.
])

== Node Representations and Branching Efficiency

The method chosen to represent the children of a node in a Suffix Tree significantly affects the time complexity of the "branching operation" – determining which outgoing edge to follow during a search. Here are common approaches:

#info_box(title: "Node Representation Strategies", [
  - *1. Linked List*:
    - *Branching Time*: $O(alpha)$ (proportional to the number of children $alpha$ of the current node).
    - *Total Search Time*: $O(m dot alpha)$, where $m$ is pattern length.
  - *2. Ordered List*:
    - Children are stored in a sorted list.
    - *Branching Time*: $O(log alpha)$ using binary search.
    - Can be faster on average and on search failure compared to an unordered linked list.
    - *Variant*: "Move-to-front" heuristic can improve average performance for frequently accessed children.
  - *3. Binary Search Tree (BST)*:
    - Stores children in a BST.
    - *Branching Time*: $O(log alpha)$.
    - Useful when $alpha$ is large.
    - *Additional Space*: $O(alpha)$.
    - *Total Search Time*: $O(m dot log alpha)$.
  - *4. Array Indexed by Alphabet (Indexed Array)*:
    - An array where each index corresponds to a character in the alphabet $Sigma$.
    - *Branching Time*: $O(1)$ (direct lookup).
    - *Space*: $Theta(|Sigma|)$ per node.
    - Advantageous for small alphabets or when nodes tend to have many children across the alphabet.
  - *5. Hashing*:
    - Uses a hash table to store children.
    - *Branching Time*: $O(1)$ on average.
    - *Perfect Hashing*: Can guarantee $O(1)$ worst-case time for static trees.
    - *Practical Variants*: Single hash table for the entire tree (e.g., S. Kurtz's approach).
  - *6. Mixed Representation*:
    - Combines different strategies based on node characteristics (e.g., depth, number of children).
    - *Near Root*: Nodes with many children might use arrays or hash tables.
    - *Near Leaves*: Nodes with few children might use linked lists.
    - *Leaf Elimination*: Information from leaf nodes can sometimes be stored in their parents to save memory.
    - *Middle Part*: Hashing or BSTs.
])

== Suffix Tree Traversal for Pattern Matching

Searching for a pattern $iota$ within a text $sigma$ using its Suffix Tree
$T(sigma)$ involves traversing the tree. Two main approaches are discussed:
"slowscan" and "fastscan."

#info_box(title: "Pattern Matching Approaches", [
  - *Problem*: Determine if $iota$ is a substring of $sigma$, or equivalently, if $iota$ is represented by an explicit or implicit node in $T(sigma)$.

  - *General Steps*:
    1. Start at the root of $T(sigma)$.
    2. For the current node and the current character $iota[i]$ of the pattern, select an outgoing edge whose label matches the next character(s) of $iota$.
    3. Proceed along that edge.
])

#info_box(title: "Slowscan", [
  - After selecting an edge, compare the remaining characters of the pattern $iota[i+1:]$ with the characters $gamma[1:]$ on the edge label, character by character.
  - *Time Complexity*: $O(B dot m)$, where $B$ is the time for branching (selecting an edge, e.g., $O(1)$, $O(log alpha)$, $O(alpha)$) and $m = |iota|$ is the length of the pattern. This can be slow if $m$ is large and $B$ is not $O(1)$.
])

#info_box(title: "Fastscan", [
  - This approach is used when we assume the pattern $iota$ is already known to be a substring of $sigma$, and we only need to locate the corresponding node.
  - Instead of character-by-character comparison along the edge (Step 2 above), we only need to ensure the correct edge is chosen. Once an edge $gamma$ is chosen, we know how many characters ($|gamma|$) it consumes from the pattern.
  - If $|gamma| < |iota[i:]|$: Advance the pattern pointer $i$ by $|gamma|$ and continue the traversal from the child node.
  - If $|gamma| == |iota[i:]|$ (or $iota[i:]$ is a prefix of $gamma$): The search ends; the pattern is found (either at a node or implicitly along an edge).
  - *Time Complexity*: $O(B dot k)$, where $B$ is the branching time, and $k$ is the number of visited nodes. Since $k <= |iota|$, this is more efficient as character comparisons along edges are avoided.
])

== Suffix Tree Construction Algorithms

Constructing a Suffix Tree efficiently is crucial for its practical applications. Over the years, several algorithms have been developed, each with its own advantages and complexities. These can broadly be categorized into in-memory and external memory algorithms.

=== In-Memory Construction Algorithms

- _Weiner (1973)_:
  - *Time Complexity*: $O(n dot log alpha)$ over an ordered alphabet.
- _McCreight (1976)_:
  - An improvement on Weiner's algorithm.
  - *Time Complexity*: $O(n dot log alpha)$ over an ordered alphabet.
  - Constructs the tree by incrementally inserting suffixes $sigma[i:] + dollar$ for $i = 0..n$.
- _Ukkonen (1992)_:
  - *Time Complexity*: $O(n dot log alpha)$ over an ordered alphabet.
  - Often considered a bit slower than McCreight in practice but more space-efficient.
  - An _on-line algorithm_: It can construct $T(sigma + "char")$ from $T(sigma)$ in amortized $O(log alpha)$ time.
  - Constructs the tree by incrementally inserting prefixes $sigma[:i]$ for $i = 1..n$ and finally the #sym.dollar terminator.
- _Farach (1997)_:
  - *Time Complexity*: $O(n)$ over an indexed alphabet (a significant theoretical improvement to linear time).
  - Uses a divide-and-conquer approach, combining trees built for even and odd positions.
  - Primarily of theoretical interest due to its complexity.

=== External Memory Construction Algorithms

For very large texts that do not fit into RAM, specialized external memory algorithms are required.

- _Tian, Tata, Hankins, Patel (2004) TDD_:
  - *Time Complexity*: $O(n^2)$ over an ordered alphabet.
  - Designed for large trees in external memory, though input is assumed to fit into RAM.
  - Utilizes virtual memory structure, claiming fast performance even in RAM.
  - A later evaluation by Peter Bašista (2012) suggested it's faster than Ukkonen/McCreight on random data, but not necessarily on real-world data.
  - Example application: Human genome (`approx. 3GB`).
- _Other Disk-Oriented Algorithms_:
  - *Phoophakdee, Zaki (2007) TRELLIS*.
  - *Barsky, Stege, Thomo, Upton (DiGeST 2008, B2ST 2009)*: These handle cases where the input itself does not fit into RAM.
  - *Mansour, Allam, Skiadopoulos, Kalnis (ERA 2011)*: Offered sequential and parallel versions for building suffix trees on human genome files, achieving construction times of around 19 minutes on an 8-core PC (16 GB RAM) and 8.3 minutes on a Linux cluster (16 nodes, 1 core/node, 4 GB RAM/node).

#pagebreak(weak: true)

== Tasks

=== Task 1
Construct the suffix trie for the string `banana$`. Clearly show all nodes, edges, and leaf nodes. Then, transform this suffix trie into a compressed suffix trie (suffix tree). Highlight the differences and the compaction achieved.

=== Task 2
Explain why a unique terminator character (e.g., #sym.dollar) is appended to a string before constructing its suffix tree. Provide an example where the absence of a terminator would lead to ambiguity or an incorrect suffix tree structure.

=== Task 3
Compare and contrast the space complexity of a standard suffix trie versus a suffix tree for a string of length $n$. Briefly explain the mechanism that allows suffix trees to achieve better space efficiency.

#pagebreak()

== Solutions

=== Solution 1
- *Suffix Trie for `banana$`:*
  (This would ideally be a diagram. Textual representation is difficult but let's describe key paths)
  - Root
    - b -> a -> n -> a -> n -> a -> \$ (leaf for "banana\$")
    - a -> n -> a -> n -> a -> \$ (leaf for "anana\$")
    - n -> a -> n -> a -> \$ (leaf for "nana\$")
    - a -> n -> a -> \$ (leaf for "ana\$")
    - n -> a -> \$ (leaf for "na\$")
    - a -> \$ (leaf for "a\$")
    - \$ (leaf for "\$")
  Each character is an edge. Many nodes would have only one child.

- *Compressed Suffix Trie (Suffix Tree) for `banana$`:*
  (Again, a diagram is best. Description of compressed paths)
  - Root
    - `banana$` (leaf)
    - `a`
      - `nana$` (leaf)
      - `na$` (leaf)
      - `$` (leaf)
    - `na$` (leaf)
    - `$` (leaf)

  This is still a bit simplified without showing all intermediate compressed paths, but the key is that edges are labeled with *substrings* instead of single characters, eliminating nodes that have only one child. For example, `b` -> `a` -> `n` would become a single edge `ban`.

=== Solution 2
- *Why a unique terminator?*
  A unique terminator character (e.g., #sym.dollar) is appended to the string ($sigma$#sym.dollar) to ensure that:
  1. *Every suffix ends at a unique leaf node:* Without a terminator, if one suffix is a prefix of another (e.g., "ban" is a prefix of "banana"), the shorter suffix would end at an internal node, not a leaf. This violates a fundamental property of suffix trees where each suffix corresponds to a unique path from the root to a leaf.
  2. *No suffix is a prefix of another:* This property is crucial for algorithms that rely on traversing the tree to find suffixes. The terminator guarantees that all suffixes are distinct and clearly delimited.

- *Example of ambiguity:*
  Consider the string `banana`.
  - Suffixes: `banana`, `anana`, `nana`, `ana`, `na`, `a`.
  - Here, `a` is a suffix, and `ana` starts with `a`. If there's no terminator, the path for `a` would end at an internal node from which the path for `ana` continues. This makes it impossible to distinguish between the end of the suffix `a` and an intermediate point in the suffix `ana`.
  - With `banana$`, all suffixes become `banana$`, `anana$`, `nana$`, `ana$`, `na$`, `a$`, `$` – ensuring unique paths to distinct leaf nodes.

=== Solution 3
- *Space Complexity Comparison:*
  - *Standard Suffix Trie:* For a string of length $n$ over an alphabet $Sigma$, the worst-case space complexity is $O(n^2)$. This is because, in the worst case (e.g., a string like `aaaaa`), the trie can have $O(n^2)$ nodes and edges, as each suffix adds nodes.
  - *Suffix Tree:* For a string of length $n$, the space complexity is $O(n)$. This is a significant improvement to linear space.

- *Mechanism for Space Efficiency:*
  The improved space efficiency of suffix trees is achieved through *path compression*.
  1. *Elimination of Redundant Nodes:* In a standard suffix trie, any node that has only one child (and is not a leaf or the root) can be eliminated. The edges leading into and out of such a node are merged into a single edge.
  2. *Edge Label Representation:* Instead of labeling edges with single characters, suffix trees label edges with *substrings* of the original text. These substring labels are not explicitly stored as separate strings. Instead, they are represented by a pair of indices `(start_index, end_index)` that point to the corresponding portion within the original string. This means that an edge label, no matter how long the substring it represents, only takes constant space (two integers) to store. This compact representation is the primary reason for the linear space complexity.

#pagebreak()
