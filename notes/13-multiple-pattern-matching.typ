#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

#import "../definitions.typ": *

= Multiple Pattern Matching

== Introduction

*Multiple Pattern Matching* is the problem of finding all occurrences of a set of patterns $P = {p_1, p_2, ..., p_k}$ in a text $T$. A naive approach would be to search for each pattern separately, but this is inefficient. Specialized algorithms can solve this problem much faster.

== Aho-Corasick Algorithm

The *Aho-Corasick algorithm* is a highly efficient algorithm for this problem, developed by Alfred V. Aho and Margaret J. Corasick in 1975. It can be seen as a generalization of the Knuth-Morris-Pratt (KMP) algorithm.

The algorithm builds a finite automaton from the set of patterns and then uses this automaton to process the text in a single pass.

=== Data Structures

1. *Trie:* A trie (prefix tree) is built from all the patterns in the set $P$. Each node in the trie represents a prefix of one or more patterns.

2. *Failure Links (fail function):* Each node in the trie has a failure link. For a node $u$ representing prefix $s$, `fail(u)` points to the node representing the longest proper suffix of $s$ that is also a prefix of some pattern. This is analogous to the failure function in KMP.

3. *Output Function (out):* Each node $u$ has an output function `out(u)` which stores the set of patterns that end at this node. To find all matches, the output links are followed as well. If `fail(u)` corresponds to a pattern, this pattern is also considered a match.

=== The Algorithm

1. *Preprocessing:*
  - Build a trie from the set of patterns.
  - Compute the failure links for all nodes in the trie. This is typically done using a breadth-first traversal.
  - Compute the output function for all nodes.

2. *Searching:*
  - Process the text $T$ character by character, starting from the root of the trie.
  - For each character, follow the corresponding edge in the trie.
  - If no edge exists for the current character, follow the failure links until a valid transition can be made or the root is reached.
  - At each node visited, check the output function to report any patterns that end at the current position.

=== Complexity

- *Preprocessing:* $O(m log alpha)$, where $m$ is the total length of all patterns and $alpha$ is the alphabet size.
- *Searching:* $O(n log alpha + z)$, where $n$ is the text length and $z$ is the number of matches. For an indexed alphabet, this becomes $O(n + m + z)$.

== Commentz-Walter Algorithm

The *Commentz-Walter algorithm*, developed by Beate Commentz-Walter in 1979, is a generalization of the Boyer-Moore algorithm for multiple patterns. It uses the same right-to-left scanning approach and combines the bad character and good suffix heuristics, adapted for a set of patterns stored in a trie.

== Rabin-Karp for Multiple Patterns

The Rabin-Karp algorithm can be extended to search for multiple patterns, especially if they are all of the same length.
- Compute the hash for each pattern and store them in a hash table.
- Compute the rolling hash for each window of the text.
- For each window, check if its hash value exists in the pattern hash table.
- If it does, perform a full comparison to verify the match.

== Tasks

1. What is the role of the failure links in the Aho-Corasick algorithm?
2. How is the Aho-Corasick algorithm a generalization of KMP?
3. When would you prefer to use a multi-pattern Rabin-Karp approach over Aho-Corasick?

#pagebreak()

== Solutions

=== Task 1: Role of Failure Links

Failure links are crucial for the efficiency of the Aho-Corasick algorithm. When a mismatch occurs while traversing the trie (i.e., the current text character does not correspond to any edge from the current node), the failure link provides an immediate jump to another node in the trie. This new node represents the longest proper suffix of the current prefix that is also a prefix of some pattern. This is equivalent to "shifting" the patterns in a way that avoids re-scanning the text, similar to the failure function in KMP. It ensures that the algorithm processes the text in a single pass without backtracking.

=== Task 2: Aho-Corasick as a Generalization of KMP

The KMP algorithm preprocesses a single pattern to create a failure function that identifies the longest proper suffix of a prefix that is also a prefix of the pattern. The Aho-Corasick algorithm extends this concept to a set of patterns.
- The trie in Aho-Corasick represents the prefixes of all patterns, analogous to the single pattern in KMP.
- The failure links in Aho-Corasick are a generalization of the KMP failure function, defined over the states of the trie instead of the positions in a single pattern.
Essentially, Aho-Corasick builds a KMP-like automaton for a whole dictionary of patterns simultaneously.

=== Task 3: Rabin-Karp vs. Aho-Corasick

The Rabin-Karp approach for multiple patterns is particularly attractive when:
- All patterns are of the same length. This simplifies the rolling hash calculation, as the window size is constant.
- The set of patterns is dynamic, i.e., patterns are frequently added or removed. In Rabin-Karp, adding or removing a pattern just means adding or removing its hash from a hash table, which is very fast. In Aho-Corasick, the entire automaton would need to be rebuilt, which is a much more expensive operation.
- Simplicity of implementation is a concern. The basic Rabin-Karp algorithm is often easier to implement than Aho-Corasick.
However, for a fixed set of patterns of varying lengths, Aho-Corasick generally offers better worst-case performance guarantees.
