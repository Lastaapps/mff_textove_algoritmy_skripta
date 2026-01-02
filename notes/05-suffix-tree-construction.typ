#import "../definitions.typ": *

= Suffix Tree Construction

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
*Suffix links* are the most important optimization for achieving linear time complexity. A suffix link from an internal node `u` representing a string `αw` (where `α` is a single character and `w` is a non-empty string) points to another node `v` that represents the string `w`.

Their power becomes clear when we perform a sequence of extensions. Suppose we just inserted a suffix `αw` by splitting an edge and creating a new internal node `u`. To insert the next suffix, `w`, we would normally have to go back to the root and traverse the path for `w` from scratch. However, if `u` has a suffix link to `v` (which represents `w`), we can simply jump to `v` in a single step. This saves a significant amount of re-traversal.

In the algorithm, after a split (Rule 2), we follow the suffix link from the *parent* of the newly created leaf and update the active point from there. This ensures that in each phase, the total number of steps is proportional to the number of extensions, not the length of the suffixes.

*Pros of Suffix Links:*
- They enable nearly constant-time traversal between consecutive suffixes, which is the key to the overall linear-time complexity.

*Cons of Suffix Links:*
- They add some complexity to the algorithm, as they need to be created and maintained correctly.

=== Edge Representation
A simple but powerful trick is to represent edge labels not as explicit strings, but as pairs of indices `(start, end)`. For leaf edges, we can use a "global end" `(start, ∞)` variable that is updated in each phase. This means all leaf edges are extended implicitly in every phase without any extra work.

== Algorithm Overview

Here is a more detailed high-level overview of Ukkonen's algorithm that highlights the use of suffix links:

#v(0.5em)
#code_box[
  ```
  Ukkonen(S):
    Initialize tree, active_point = (root, null, 0)
    last_split_node = null

    For i from 1 to n:
      // Phase i: Add S[i] to the tree
      For j from 1 to i:
        // Extension j: Ensure S[j..i] is in the tree
        If active_point needs update:
          Follow suffix link from active_point.node if available,
          otherwise traverse from root.

        If S[i] is not found at active_point:
          // Rule 2: Split edge or create new leaf
          new_node = split_edge() or create_leaf()

          If last_split_node is not null:
            Create suffix link from last_split_node to new_node.

          last_split_node = new_node

          // Follow suffix link for next extension
          active_point = (active_point.node.suffix_link, ...)
        Else:
          // Rule 3: Show Stopper
          last_split_node = null
          // Update active_point for S[i] and break to next phase
          break
  ```
]
#v(0.5em)

After all phases are complete, the implicit suffix tree is converted to a proper suffix tree by appending a unique terminal symbol and resolving all "infinity" edge labels to `n`.

== The Path to O(n) Complexity

A naive analysis of the nested loops in the algorithm suggests a complexity of $O(n^2)$. However, the combination of the tricks described above ensures a linear time complexity. Here's an intuitive explanation:

- *Active Point Traversal:* The active point can move down the tree (increasing `active_length`) or across the tree using suffix links. The total number of downward moves is at most `n`.
- *Suffix Links:* Each suffix link jump is an O(1) operation. The number of suffix link traversals is bounded by the number of extensions, which itself is limited.
- *Show Stopper:* Rule 3 ensures that we only perform as many extensions in a phase as we need to. The number of extensions per phase is not always `i`.
- *Amortized Analysis:* A more rigorous amortized analysis shows that the total work done across all phases is proportional to `n`. The key insight is that for every step down the tree (increasing `active_length`), we never have to re-traverse that part of the path again. Suffix links let us "reset" our position efficiently without going all the way back to the root.

The combination of these factors ensures that the total number of operations is O(n), assuming the alphabet size is constant (e.g., using a hash map or array for branching). If the alphabet is large, the complexity might be O(n log |Σ|) due to branching.

== Tasks

=== Task 1
What is the difference between an implicit and an explicit suffix tree?

=== Task 2
Explain the role of the "active point" in Ukkonen's algorithm.

=== Task 3
What are the three extension rules in Ukkonen's algorithm, and how do they affect the active point?

=== Task 4
What is a suffix link and why is it important?

=== Task 5
How does the representation of edge labels as `(start, end)` pairs contribute to the efficiency of the algorithm?

#pagebreak()

== Solutions

=== Solution 1
An explicit suffix tree represents all suffixes of a string ending with a unique terminal symbol, and every suffix corresponds to a path from the root to a leaf. An implicit suffix tree is for a string without a terminal symbol, and some suffixes may end at internal nodes or on edges.

=== Solution 2
The active point `(active_node, active_edge, active_length)` tracks the current position in the tree. It allows the algorithm to avoid restarting from the root for each new suffix extension, making the process much faster.

=== Solution 3
- *Rule 1 (Leaf Extension):* Extends a leaf edge. The active point is unchanged.
- *Rule 2 (Node Splitting):* Splits an edge and creates a new leaf. The active point is updated to the new internal node.
- *Rule 3 (Show Stopper):* Finds the suffix already in the tree. The active point is updated to the end of the suffix's path, and the current phase ends early.

=== Solution 4
A suffix link from a node `u` representing `αw` to a node `v` representing `w` allows for quick traversal between suffixes. This is a key optimization for achieving linear-time complexity.

=== Solution 5
Representing edge labels as `(start, end)` pairs, especially with a global "end" for leaf edges, avoids the need to update every leaf edge in every phase. This implicit extension is a major source of efficiency.

#pagebreak()
