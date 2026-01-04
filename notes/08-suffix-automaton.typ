#import "../definitions.typ": *

#pagebreak()

= Suffix Automaton

The Suffix Automaton, also known as a Directed Acyclic Word Graph (DAWG), is a minimal automaton that accepts all suffixes of a given text. It is a powerful tool used in various string algorithms, offering a compact representation of all substrings of a text.

#figure(
  image("../figures/automata-relationship.png", width: 60%),
)

== Directed Acyclic Word Graph (DAWG)

A DAWG for a string $sigma$ is a finite automaton that is:
- *Acyclic and directed.*
- Has a designated *start state* (source) and one or more *final states* (sinks).
- Each transition is labeled with a single character.
- All paths from the start state to any state spell out a substring of $sigma$.
- All suffixes of $sigma$ are accepted by the automaton.
- It is the smallest such automaton, meaning it has the minimum number of states.

The creation of a DAWG is based on the concept of minimizing a suffix trie by merging isomorphic subtrees.

=== End-Positions and Equivalence Classes

To formally define a DAWG, we introduce the concept of end-positions for substrings.

#info_box(
  title: "Terminal Set (End-Positions)",
)[
  For any non-empty substring $u$ of $sigma$, the terminal set $Pi_sigma (u)$ (or $"endpos"(u)$) is the set of all *ending positions* of occurrences of $u$ in $sigma$.

  For example, if $sigma = "abcab"$, then $Pi_sigma ("ab") = {1, 4}$.
]

We can group substrings based on their terminal sets. This partitioning forms equivalence classes.

#info_box(
  title: [Equivalence Relation $Pi_sigma$],
)[
  Two substrings $u_1$ and $u_2$ are equivalent, denoted $u_1 equiv_sigma u_2$, if $Pi_sigma (u_1) = Pi_sigma (u_2)$.
  This partitions all substrings of $sigma$ into equivalence classes. The states of the DAWG for $sigma$ correspond to these equivalence classes.
]

#example_box(
  title: "Example",
)[
  Let $sigma = "kakao"$.
  - $Pi_sigma ("a") = {1, 3}$
  - $Pi_sigma ("ka") = {1, 3}$
  - $Pi_sigma ("k") = {0, 2}$

  Here, "a" and "ka" are in the same equivalence class: $["a"]_sigma$ = $["ka"]_sigma$.
]

=== Lemmata and Properties

Several key properties emerge from these definitions.

#info_box(
  title: "Lemma 1: Isomorphism and Equivalence",
)[
  For a string $sigma dollar$ (with a unique terminal character), the subtrees of the suffix trie rooted at substrings $u_1$ and $u_2$ are isomorphic if and only if $u_1$ and $u_2$ belong to the same equivalence class, i.e., $u_1 equiv_sigma u_2$.
]

All all suffixes end at the same position $n$, they all belong to a common class. This class becomes the only finite state of the automaton.

#info_box(
  title: "Lemma 2: Relationship between Terminal Sets",
)[
  For any two substrings $u_1$ and $u_2$ where $|u_1| <= |u_2|$, exactly one of the following must be true:
  - Their terminal sets are disjoint: $Pi_sigma (u_1) inter Pi_sigma (u_2) = emptyset$
  - The terminal set of the longer string is a subset of the shorter one's: $Pi_sigma (u_2) subset.eq Pi_sigma (u_1)$
]

A direct consequence of Lemma 2 is a bound on the number of states.

#info_box(
  title: "Corollary: Number of States",
)[
  The number of equivalence classes (and thus states in the DAWG) for a string $sigma$ of length $n$ is at most $2n - 1$.
]


=== DAWG Structure

- *States:* Each state corresponds to an equivalence class $[u]_sigma$. The start state corresponds to the class of the empty string, $[epsilon]_sigma$.
- *Transitions:* A transition from a state $[u]_sigma$ to a state $[u a]_sigma$ with a character $a$ exists if $u a$ is a substring of $sigma$.
- *Sink State:* If the string $sigma$ ends with a unique character (e.g., "\$"), all suffixes have a unique end position. This causes all leaves of the suffix trie to be identified into a single sink state in the DAWG.

=== General Properties
- The DAWG is a directed acyclic graph with one source and typically one sink.
- The number of states is at most $2n+1$ and the number of transitions is at most $3n$.
- Searching for a pattern in a DAWG is similar to traversing a Suffix Trie.

== Compacted DAWG (CDAWG)

A Compacted DAWG (CDAWG) further reduces the number of states and edges by compressing chains of states with single transitions, much like a suffix tree compresses a suffix trie.

#info_box(
  title: "Lemma 3: Isomorphism in Suffix Trees",
)[
  Let $u_1$ and $u_2$ be nodes in a suffix tree $T(sigma)$ with $|u_1| <= |u_2|$. The subtrees rooted at $u_1$ and $u_2$ are isomorphic if and only if they contain the same number of leaves and $u_1$ is a suffix of $u_2$.
]

- The CDAWG has at most $n+1$ vertices and $2n$ edges, making it very space-efficient.

== Construction Algorithms

- *Blumer et al. (1985):* An online algorithm for DAWG construction in linear time.
- *Crochemore (1986):* An offline construction for DAWGs.
- *Blumer et al. (1987):* Offline construction for CDAWG, which can be inefficient as it requires building a DAWG first.
- *Crochemore & Vérin (1997):* A direct offline construction for CDAWGs from the suffix tree.
- *Inenaga et al. (2005):* An online construction for CDAWGs.

== Tasks

=== Task 1
Define the equivalence relation $Pi_sigma$. What is its role in the construction of a DAWG?

=== Task 2
For $sigma = "ababa"$, calculate the terminal sets $Pi_sigma ("a")$, $Pi_sigma ("b")$, and $Pi_sigma ("aba")$.

=== Task 3
State Lemma 2 regarding the relationship between terminal sets of two substrings. What is its implication for the structure of the DAWG?

=== Task 4
What are the key differences between a DAWG and a CDAWG in terms of structure and complexity?

=== Task 5
Why is adding a unique terminal symbol to the string useful when constructing a DAWG?

#pagebreak()

== Solutions

=== Solution 1
The equivalence relation $Pi_sigma$ partitions the set of all substrings of a string $sigma$. Two substrings $u_1$ and $u_2$ are equivalent if their terminal sets (sets of end positions) are identical: $Pi_sigma (u_1) = Pi_sigma (u_2)$. The states of the DAWG correspond directly to these equivalence classes. The process of merging isomorphic subtrees in a suffix trie is formalized by identifying nodes that fall into the same equivalence class.

=== Solution 2
For $sigma = "ababa"$:
- Occurrences of $"a"$ end at positions 0, 2, and 4. So, $Pi_sigma ("a") = {0, 2, 4}$.
- Occurrences of $"b"$ end at positions 1 and 3. So, $Pi_sigma ("b") = {1, 3}$.
- Occurrences of $"aba"$ end at positions 2 and 4. So, $Pi_sigma ("aba") = {2, 4}$.

=== Solution 3
Lemma 2 states that for any two substrings $u_1$ and $u_2$ with $|u_1| <= |u_2|$, their terminal sets are either disjoint ($Pi_sigma (u_1) inter Pi_sigma (u_2) = emptyset$) or the set for the longer string is a subset of the set for the shorter one ($Pi_sigma (u_2) subset.eq Pi_sigma (u_1)$). This property imposes a hierarchical (tree-like) structure on the equivalence classes when ordered by inclusion, which is fundamental to the overall structure and linear size of the DAWG.

=== Solution 4
A DAWG is a minimal automaton for all suffixes, created by merging equivalent states from a suffix trie. A CDAWG is a "compacted" version of a DAWG, where linear chains of states with single transitions are compressed into single edges labeled with strings (not just single characters). This is analogous to the suffix tree vs. suffix trie relationship.
- *Complexity:* DAWG has $O(n)$ states and transitions. CDAWG reduces this further, with at most $n+1$ vertices and $2n$ edges, offering better space efficiency.

=== Solution 5
Adding a unique terminal symbol (like "\$") to the string ensures that every suffix of the string is unique and does not appear elsewhere inside the string. This simplifies the structure of the automaton. Specifically, it guarantees that there is a single, well-defined sink state, as the terminal set for each suffix $sigma[j..n]$ becomes simply {n}. This means all states representing suffixes are merged into one final state.

#pagebreak()
