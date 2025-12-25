
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

= Suffix Automaton

== Introduction

A *Suffix Automaton*, also known as a *Directed Acyclic Word Graph (DAWG)*, is a powerful data structure used to represent all substrings of a given text. It is the smallest deterministic finite automaton (DFA) that recognizes all suffixes of the text. This means it can also recognize all substrings of the text.

== Definition

For a given text `$T$`, its suffix automaton is a directed acyclic graph where:
- Nodes are states.
- Edges are transitions labeled with characters.
- There is one initial state (source) and one or more terminal states (sinks).
- Every path from the initial state represents a substring of `$T$`.
- Every substring of `$T$` corresponds to at least one path from the initial state.

A key property is that it contains the minimum number of states to represent all substrings of `$T$`.

#box(
  stroke: 1pt + black,
  inset: 8pt,
)[
  *Example:*
  For the text `$T = "ab"`, the substrings are `{"a", "b", "ab"}`. The suffixes are `{"ab", "b"}`.
  The suffix automaton would have paths for "a", "b", and "ab".
]

== Properties

For a text of length `$n$`:
- The number of states is at most `$2n+1$`.
- The number of transitions is at most `$3n$`.
- It can be built in `$O(n)$` time.

== From Suffix Trie to Suffix Automaton

A suffix automaton can be conceptualized as a minimized version of a suffix trie.
1. Start with a suffix trie for the text.
2. Identify and merge isomorphic subtrees. Two subtrees are isomorphic if they have the same topology and edge labels.
3. The resulting graph is the suffix automaton.

== Compacted DAWG (CDAWG)

A *Compacted DAWG (CDAWG)* is a further compressed version of the DAWG. It is created by replacing chains of single-character transitions with a single edge labeled with a string, similar to the compression of a trie into a suffix tree.
- A CDAWG has at most `$n+1$` vertices and `$2n$` edges.

== Tasks

1. What is the main difference between a suffix trie and a suffix automaton for the same text?
2. How many states and transitions can a suffix automaton for the text `$T = "banana"` (length 6) have at most?
3. What is the primary advantage of a suffix automaton over a suffix tree?

#pagebreak()

== Solutions

=== Task 1: Suffix Trie vs. Suffix Automaton

- *Suffix Trie*: A tree structure that represents all suffixes of a text. Each edge is labeled with a single character. Different occurrences of the same substring might correspond to different paths from the root. It can have up to `$O(n^2)$` nodes.
- *Suffix Automaton*: A minimized graph where all paths starting from the initial state that spell out the same substring lead to the same state. It has a linear number of states and transitions in the length of the text. It is a more compact representation.

=== Task 2: States and Transitions for "banana"

For `$T = "banana"`, `$n=6$`.
- Maximum number of states: `$2n + 1 = 2 * 6 + 1 = 13$`.
- Maximum number of transitions: `$3n = 3 * 6 = 18$`.
The actual number of states and transitions for a given string is usually smaller than this theoretical maximum.

=== Task 3: Advantage of Suffix Automaton over Suffix Tree

The primary advantage of a suffix automaton is its size. While both can be built in linear time and can solve many of the same problems, the suffix automaton is smaller. A suffix automaton has at most `$2n+1$` states, while a suffix tree can have up to `$2n-1$` nodes (for a string of length `$n>1$`). However, the suffix automaton is a more complex structure, and for some applications, the suffix tree can be conceptually simpler to use.
