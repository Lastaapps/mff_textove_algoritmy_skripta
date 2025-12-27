= Suffix Tree Construction

#set par(justify: true)

The construction of a suffix tree is a fundamental task in stringology. While a naive approach of inserting suffixes one by one is too slow (quadratic time), Ukkonen's algorithm provides a clever and efficient solution to build a suffix tree in linear time. This algorithm is online, meaning it processes the string character by character, maintaining a valid suffix tree for the prefix seen so far.

== Implicit Suffix Trees

A standard suffix tree is a compact representation of all suffixes of a string that ends with a unique terminal symbol (e.g., `$`). An *implicit suffix tree* is a suffix tree for a string *without* a terminal symbol. In an implicit suffix tree:
- Not every suffix ends at a leaf node.
- Some suffixes may be represented by paths ending at internal nodes or even in the middle of an edge.

Ukkonen's algorithm works by building a sequence of implicit suffix trees. In each phase `i`, it extends the implicit suffix tree of the prefix `S[1..i-1]` to the implicit suffix tree of `S[1..i]`.

== Ukkonen's Algorithm: Core Ideas

Ukkonen's algorithm relies on several key concepts and optimizations to achieve its linear time complexity.

=== Algorithm Phases
The algorithm proceeds in `n` phases, where `n` is the length of the string. In phase `i`, it adds the character `S[i]` to the tree, extending all existing suffixes. This is done by performing a series of extensions, one for each suffix starting from `j=1` to `i`.

=== Extension Rules
In each extension `j` of phase `i`, we need to ensure the suffix `S[j..i]` is in the tree. Let's say the path for `S[j..i-1]` ends at a certain point. We then follow one of three rules:

#enum(start: 1)[
  *Rule 1 (Leaf Extension):* If the path for `S[j..i-1]` ends at a leaf, we simply extend the label of the edge leading to that leaf by one character, `S[i]`. The active point does not change in this case.
][
  *Rule 2 (Node Splitting):* If the path for `S[j..i-1]` ends in the middle of an edge, but the next character on the edge is not `S[i]`, we must split the edge. A new internal node is created at the split point. From this new node, we create a new leaf edge labeled with `S[i]`. The active point is then updated to this new internal node.
][
  *Rule 3 (Show Stopper):* If the suffix `S[j..i]` is already present in the tree (either ending at an internal node or implicitly on an edge), we do nothing. This is a "show stopper" because if this suffix is present, all shorter suffixes (for `j' > j`) must also be present. The active point is updated to the end of the path for `S[j..i]`.
]

=== The Active Point
To avoid re-traversing the tree from the root in every extension, we use an *active point*. The active point is a triple `(active_node, active_edge, active_length)` that keeps track of the current position in the tree.
- `active_node`: The current node.
- `active_edge`: The first character of the edge to follow from `active_node`.
- `active_length`: The distance to traverse along that edge.

The active point is updated after each extension, allowing the algorithm to resume from where it left off.

=== Suffix Links
*Suffix links* are another crucial optimization. A suffix link from an internal node `u` representing a string `αw` (where `α` is a single character and `w` is a non-empty string) points to another node `v` that represents the string `w`.

When we split an edge and create a new internal node, we also create a suffix link from the previous internal node (if any) to the new one. This allows for very fast traversal between suffixes that differ by one character at the beginning.

*Pros of Suffix Links:*
- They enable faster traversal through the tree, which is essential for the linear-time complexity.

*Cons of Suffix Links:*
- They add some complexity to the algorithm, as they need to be created and maintained correctly.

=== Edge Representation
A simple but powerful trick is to represent edge labels not as explicit strings, but as pairs of indices `(start, end)`. For leaf edges, we can use a "global end" variable that is updated in each phase. This means all leaf edges are extended implicitly in every phase without any extra work.

== Algorithm Overview

Here is a high-level overview of Ukkonen's algorithm:

#v(0.5em)
#let block(content) = {
  rect(width: 100%, inset: 8pt, fill: luma(240), radius: 4pt, content)
}

#block[
  ```
  Ukkonen(S):
    Initialize a root node and an active point (root, null, 0).
    For i from 1 to n:
      // Phase i
      For j from 1 to i:
        // Extension j
        Follow the active point to find the end of S[j..i-1].
        If S[i] is not found:
          Apply Rule 1 or 2:
            - Extend a leaf edge or split an edge and create a new leaf.
            - If a new internal node was created, create a suffix link.
          Update the active point.
        Else (Rule 3 - Show Stopper):
          Update the active point and break to the next phase.
  ```
]
#v(0.5em)

After all phases are complete, the implicit suffix tree is converted to a proper suffix tree by appending a unique terminal symbol and resolving all "infinity" edge labels to `n`.

== Tasks

#enum(
  [What is the difference between an implicit and an explicit suffix tree?],
  [Explain the role of the "active point" in Ukkonen's algorithm.],
  [What are the three extension rules in Ukkonen's algorithm, and how do they affect the active point?],
  [What is a suffix link and why is it important?],
  [How does the representation of edge labels as `(start, end)` pairs contribute to the efficiency of the algorithm?],
)

#pagebreak()

== Solutions

#enum(
  [An explicit suffix tree represents all suffixes of a string ending with a unique terminal symbol, and every suffix corresponds to a path from the root to a leaf. An implicit suffix tree is for a string without a terminal symbol, and some suffixes may end at internal nodes or on edges.],
  [The active point `(active_node, active_edge, active_length)` tracks the current position in the tree. It allows the algorithm to avoid restarting from the root for each new suffix extension, making the process much faster.],
  [
    - *Rule 1 (Leaf Extension):* Extends a leaf edge. The active point is unchanged.
    - *Rule 2 (Node Splitting):* Splits an edge and creates a new leaf. The active point is updated to the new internal node.
    - *Rule 3 (Show Stopper):* Finds the suffix already in the tree. The active point is updated to the end of the suffix's path, and the current phase ends early.
  ],
  [A suffix link from a node `u` representing `αw` to a node `v` representing `w` allows for quick traversal between suffixes. This is a key optimization for achieving linear-time complexity.],
  [Representing edge labels as `(start, end)` pairs, especially with a global "end" for leaf edges, avoids the need to update every leaf edge in every phase. This implicit extension is a major source of efficiency.],
)
