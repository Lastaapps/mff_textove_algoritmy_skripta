#import "../definitions.typ": *

= Multiple Pattern Matching

== Introduction

*Multiple Pattern Matching* is the problem of finding all occurrences of a set of patterns $P = {p_1, p_2, ..., p_k}$ in a text $T$. A naive approach would be to search for each pattern separately, but this is inefficient. Specialized algorithms can solve this problem much faster.

== Aho-Corasick Algorithm

The *Aho-Corasick algorithm* is a highly efficient algorithm for this problem, developed by Alfred V. Aho and Margaret J. Corasick in 1975. It finds all occurrences of a set of patterns in a text in time proportional to the text length plus the number of matches.

The algorithm first builds a finite automaton from the set of patterns and then uses this automaton to process the text in a single pass.

=== Core Concepts

1. *Trie:* A trie (prefix tree) is built from all the patterns. Each node represents a prefix. Paths from the root spell out prefixes of the patterns.

2. *Failure Links (fail function):* Each node $u$ has a failure link, $f(u)$, that points to another node. $f(u)$ points to the node corresponding to the longest proper suffix of the string represented by $u$ that is also a prefix of some pattern in the dictionary. This is a generalization of the KMP failure function.

3. *Output Function (out):* Each node $u$ has an output set, $"out"(u)$, which contains any patterns that end at state $u$. To find all possible matches, we must also consider patterns ending at states reachable by following failure links.

=== Preprocessing: Building the Automaton

The preprocessing phase constructs the trie and computes the failure and output links.

==== Trie Construction
This is a standard procedure. We iterate through each pattern in the dictionary and add it to the trie. For each node, we also initialize its $"out"$ set.
- Create a root node (state 0).
- For each pattern $p$:
  - Start from the root. For each character in $p$, follow the corresponding edge. If an edge doesn't exist, create a new node.
  - Add the pattern $p$ to the $"out"$ set of the final node for $p$.
This takes $O(M)$ time, where $M$ is the total length of all patterns.

==== Failure Function Computation
The failure links are computed using a Breadth-First Search (BFS) starting from the root.
- The failure link of the root is set to itself.
- We process nodes level by level. For each node $u$ and for each character $c$ that leads to a child $v$:
  1. Start at `f(u)` and follow its failure links until a node `w` is found that has a transition on character `c`. Let this transition lead to state $w'$.
  2. Set `f(v) = w'`.
  3. If no such `w` is found (i.e., we reach the root and it has no transition on `c`), set `f(v)` to the root.
This process also takes $O(M)$ time.

==== Output Function Computation
The initial `out(u)` only contains patterns that *exactly* end at state `u`. However, a match also occurs if a suffix of the current string is a pattern. For example, if we match `"she"`, we have also matched `"he"`. This is handled by "chaining" the outputs along the failure links.

During the search, when we are at a state `u`, we report all patterns in `out(u)`, then we traverse the failure links `f(u)`, `f(f(u))`, and so on, reporting all patterns in their `out` sets until we reach the root. This ensures all dictionary suffixes are found. The cost of this is accounted for by the $z$ term in the search complexity.

=== Example of Aho-Corasick
Let the dictionary be $P = {"he", "she", "his", "hers"}$.

==== Trie and Failure Links
First, we build the trie. Then, we compute the failure links (f).
- `f(1)` (for "h"): root(0)
- `f(2)` (for "s"): root(0)
- `f(3)` (for "he"): `f(1)` is root, which has no 'e' transition. So `f(3)` is root(0).
- `f(4)` (for "sh"): `f(2)` is root. root has a transition on 'h' to state 1. So `f(4) = 1`.
- `f(5)` (for "hi"): `f(1)` is root. root has a transition on 'i' to nowhere. So `f(5)` is root(0).
- and so on...

#example_box[
  *Trie and Failure Links for {"he", "she", "his", "hers"}*
  ```
        (0) --h--> (1) --e--> (3){he} --r--> (8){hers} --s--> (9)
         |          |
         |          --i--> (5){his} --s--> (6)
         |
         --s--> (2) --h--> (4) --e--> (7){she}
  ```
  *Failure Links Table:*
  #table(
    columns: 4,
    inset: 10pt,
    align: (center, left, center, left),
    [*State (string)*],
    [*Failure Link (f)*],
    [*Output ("out")*],
    [*Chained Output*],

    [0 (root)], [0], [\{\}], [\{\}],
    [1 ("h")], [0], [\{\}], [\{\}],
    [2 ("s")], [0], [\{\}], [\{\}],
    [3 ("he")], [0], [{"he"}], [{"he"}],
    [4 ("sh")], [1], [\{\}], [\{\}],
    [5 ("hi")], [0], [{"his"}], [{"his"}],
    [6 ("his")], [2], [\{\}], [\{\}],
    [7 ("she")], [3], [{"she"}], [{"she", "he"}],
    [8 ("her")], [0], [\{\}], [\{\}],
    [9 ("hers")], [2], [{"hers"}], [{"hers"}],
  )

  *Note on Chained Output:* When we reach state 7 ("she"), we report "she". We then follow its fail link, f(7)=3. State 3 is an output node for "he", so we report "he" as well. This finds all dictionary suffixes.
]

=== Complexity Analysis
Let $N$ be the length of the text, $M$ be the total length of all patterns, and $z$ be the total number of occurrences of all patterns in the text.

- *Preprocessing Time:*
  - Trie construction: $O(M)$.
  - Failure link computation: $O(M)$.
  - *Total Preprocessing: $O(M)$*.

- *Search Time:*
  - The algorithm traverses the text once, making $N$ character transitions.
  - The total number of times failure links are followed during the search is amortized to $O(N)$.
  - At each position, we may report several matches by following output links. The total cost of reporting all matches is proportional to the total number of matches, $z$.
  - *Total Search Time: $O(N+z)$*.

This makes the Aho-Corasick algorithm extremely efficient for a fixed dictionary.

== Commentz-Walter Algorithm

The *Commentz-Walter algorithm*, developed by Beate Commentz-Walter in 1979, is a generalization of the Boyer-Moore algorithm for multiple patterns. It uses the same right-to-left scanning approach and combines the bad character and good suffix heuristics, adapted for a set of patterns stored in a trie.

== Rabin-Karp for Multiple Patterns

The Rabin-Karp algorithm can be extended to search for multiple patterns, especially if they are all of the same length.
- Compute the hash for each pattern and store them in a hash table.
- Compute the rolling hash for each window of the text.
- For each window, check if its hash value exists in the pattern hash table.
- If it does, perform a full comparison to verify the match.

== Tasks

=== Task 1
What is the role of the failure links in the Aho-Corasick algorithm?

=== Task 2
How is the Aho-Corasick algorithm a generalization of KMP?

=== Task 3
When would you prefer to use a multi-pattern Rabin-Karp approach over Aho-Corasick?

#pagebreak()

== Solutions

=== Solution 1
Failure links are crucial for the efficiency of the Aho-Corasick algorithm. When a mismatch occurs while traversing the trie (i.e., the current text character does not correspond to any edge from the current node), the failure link provides an immediate jump to another node in the trie. This new node represents the longest proper suffix of the current prefix that is also a prefix of some pattern. This is equivalent to "shifting" the patterns in a way that avoids re-scanning the text, similar to the failure function in KMP. It ensures that the algorithm processes the text in a single pass without backtracking.

=== Solution 2
The KMP algorithm preprocesses a single pattern to create a failure function that identifies the longest proper suffix of a prefix that is also a prefix of the pattern. The Aho-Corasick algorithm extends this concept to a set of patterns.
- The trie in Aho-Corasick represents the prefixes of all patterns, analogous to the single pattern in KMP.
- The failure links in Aho-Corasick are a generalization of the KMP failure function, defined over the states of the trie instead of the positions in a single pattern.
Essentially, Aho-Corasick builds a KMP-like automaton for a whole dictionary of patterns simultaneously.

=== Solution 3
The Rabin-Karp approach for multiple patterns is particularly attractive when:
- All patterns are of the same length. This simplifies the rolling hash calculation, as the window size is constant.
- The set of patterns is dynamic, i.e., patterns are frequently added or removed. In Rabin-Karp, adding or removing a pattern just means adding or removing its hash from a hash table, which is very fast. In Aho-Corasick, the entire automaton would need to be rebuilt, which is a much more expensive operation.
- Simplicity of implementation is a concern. The basic Rabin-Karp algorithm is often easier to implement than Aho-Corasick.
However, for a fixed set of patterns of varying lengths, Aho-Corasick generally offers better worst-case performance guarantees.

#pagebreak()
