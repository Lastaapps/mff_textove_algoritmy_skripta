#import "../definitions.typ": *

= Suffix Automaton

== Introduction

A *Suffix Automaton*, also known as a *Directed Acyclic Word Graph (DAWG)*, is a powerful data structure used to represent all substrings of a given text. It is the smallest deterministic finite automaton (DFA) that recognizes all suffixes of the text. This means it can also recognize all substrings of the text.
It's based on the idea of identification of common subtrees of suffix tree.

== Definition

For a given text $T$, its suffix automaton is a directed acyclic graph where:
- Nodes are states.
- Edges are transitions labeled with characters.
- There is one initial state (source) and one or more terminal states (sinks).
- Every path from the initial state represents a substring of $T$.
- Every substring of $T$ corresponds to at least one path from the initial state.

A key property is that it contains the minimum number of states to represent all substrings of $T$.

== Properties

For a text of length $n$:
- The number of states is at most $2n+1$.
- The number of transitions is at most $3n$.
- It can be built in $O(n)$ time.

== The Suffix Link ($pi$) Relation

A crucial concept in a suffix automaton is the *suffix link*, denoted as $pi(v)$ for a state $v$.

#info_box(title: "Definition: Suffix Link")[
  For a state $v$ that is not the initial state, the suffix link $pi(v)$ points to the state corresponding to the longest proper suffix of the strings ending at $v$. The set of strings ending at a state $v$ is denoted `end-pos(v)`.
]

The suffix links form a tree structure on the states of the automaton, with the root of this tree being the initial state. This structure is fundamental to the linear-time construction algorithm.

#info_box(title: "Lemma: Suffix Link Tree")[
  The graph of suffix links is a tree with the initial state as its root. This is because for any state $v$, the length of the longest string at $pi(v)$ is strictly smaller than the length of the longest string at $v$.
]

== Suffix Automaton Construction

The suffix automaton can be built in linear time using an online algorithm. The algorithm processes the input string $T$ character by character, extending the automaton at each step.

Let's assume we have built the automaton for a prefix $P$ and now we want to extend it with a new character $c$.
1. Let `last` be the state corresponding to the whole prefix $P$. We create a new state, `cur`, for the new string $P+c$. `len(cur)` is set to `len(last) + 1`.
2. We start from `last` and follow the suffix links. For each state `p` on this path:
  - If `p` does not have a transition for the character `c`, we add a transition from `p` to `cur`.
  - If `p` does have a transition on `c`, we stop. Let this transition go to state `q`.

3. If we reached the initial state without finding any transition for `c`, we set $pi("cur")$ to the initial state.
4. If we stopped at a state `p` with a transition to `q`, we have two cases:

#info_box(title: "Lemma: Length Condition")[
  Let `len(v)` be the length of the longest string corresponding to state $v$.
  - *Case 1:* If `len(q) == len(p) + 1`, the transition from `p` to `q` is "tight". We can simply set $pi("cur") = q$.
  - *Case 2:* If `len(q) > len(p) + 1`, the path to `q` represents strings longer than just `p`'s longest string plus `c`. This means we need to split the state `q`.
]

*Splitting a State (Case 2):*
- We create a new state, `clone`. `len(clone)` is set to `len(p) + 1`.
- The transitions from `clone` are copied from `q`. The suffix link $pi("clone")$ is set to $pi(q)$.
- We then set $pi(q)$ and $pi("cur")$ to `clone`.
- Finally, we walk up the suffix link path from `p` again. For any state whose transition on `c` pointed to `q`, we redirect it to `clone`. This continues as long as the state's `c` transition points to `q`.

This process ensures the automaton correctly represents all substrings after adding each character, and with careful implementation, maintains the overall $O(n)$ time complexity.

== From Suffix Trie to Suffix Automaton

A suffix automaton can be conceptualized as a minimized version of a suffix trie.
1. Start with a suffix trie for the text.
2. Identify and merge isomorphic subtrees. Two subtrees are isomorphic if they have the same topology and edge labels.
3. The resulting graph is the suffix automaton.

== Compacted DAWG (CDAWG)

A *Compacted DAWG (CDAWG)* is a further compressed version of the DAWG. It is created by replacing chains of single-character transitions with a single edge labeled with a string, similar to the compression of a trie into a suffix tree.
- A CDAWG has at most $n+1$ vertices and $2n$ edges.

== Tasks

=== Task 1
What is the main difference between a suffix trie and a suffix automaton for the same text?

=== Task 2
How many states and transitions can a suffix automaton for the text $T = "banana"$ (length 6) have at most?

=== Task 3
What is the primary advantage of a suffix automaton over a suffix tree?

#pagebreak()

== Solutions

=== Solution 1
- *Suffix Trie*: A tree structure that represents all suffixes of a text. Each edge is labeled with a single character. Different occurrences of the same substring might correspond to different paths from the root. It can have up to $O(n^2)$ nodes.
- *Suffix Automaton*: A minimized graph where all paths starting from the initial state that spell out the same substring lead to the same state. It has a linear number of states and transitions in the length of the text. It is a more compact representation.

=== Solution 2
For $T = "banana"$, $n=6$.
- Maximum number of states: $2n + 1 = 2 dot 6 + 1 = 13$.
- Maximum number of transitions: $3n = 3 dot 6 = 18$.
The actual number of states and transitions for a given string is usually smaller than this theoretical maximum.

=== Solution 3
The primary advantage of a suffix automaton is its size. While both can be built in linear time and can solve many of the same problems, the suffix automaton is smaller. A suffix automaton has at most $2n+1$ states, while a suffix tree can have up to $2n-1$ nodes (for a string of length $n>1$). However, the suffix automaton is a more complex structure, and for some applications, the suffix tree can be conceptually simpler to use.

#pagebreak()
