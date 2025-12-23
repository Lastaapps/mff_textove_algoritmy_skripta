= Suffix Tree Construction

#set par(justify: true)
The construction of a suffix tree is a key problem in stringology. A naive approach of inserting suffixes one by one into a trie is too slow, leading to a quadratic time complexity in the length of the string. Fortunately, more advanced algorithms exist that can build a suffix tree in linear time. One of the most famous and efficient algorithms is Ukkonen's algorithm.

== Ukkonen's Algorithm

Ukkonen's algorithm is an online algorithm, which means it processes the input string from left to right, character by character, and maintains a valid suffix tree for the prefix processed so far. It achieves linear time complexity by using several clever tricks, such as suffix links, active points, and edge labels represented by string indices.

=== Key Concepts

- *Active Point:* The active point is a triple `(active_node, active_edge, active_length)` that represents the current position in the tree where the next character should be inserted. `active_node` is the current node, `active_edge` is the first character of the edge to follow, and `active_length` is the distance to traverse along that edge.
- *Suffix Links:* A suffix link from a node `u` to a node `v` means that the path from the root to `u` spells a string `αw`, and the path from the root to `v` spells the string `w`, where `w` is a non-empty string and `α` is a single character. Suffix links are crucial for achieving linear time complexity.
- *Rule 1 (Leaf Creation):* If we are at a leaf edge and the next character in the string is not found, we create a new leaf node and a new edge.
- *Rule 2 (Node Splitting):* If we are in the middle of an edge and the next character in the string does not match the character on the edge, we split the edge by creating a new internal node. A new leaf for the new suffix is created from this new internal node.
- *Rule 3 (Show Stopper):* If the character is already present, we do nothing. This is the "show stopper" condition.

=== Example

Let's trace Ukkonen's algorithm for the string `S = "banana"`. We will append the special character `\$` at the end, so `S = "banana\$"`.

- *Phase 1 (b):* Tree for "b" is created.
- *Phase 2 (ba):* Tree for "ba" is created.
- *Phase 3 (ban):* Tree for "ban" is created.
- *Phase 4 (bana):* Tree for "bana" is created.
- *Phase 5 (banan):* Tree for "banan" is created.
- *Phase 6 (banana):* Tree for "banana" is created.
- *Phase 7 (banana\$):* Final suffix tree for "banana\$" is constructed.



#enum(
  [What is the main advantage of Ukkonen's algorithm compared to a naive approach for suffix tree construction?],
  [Explain the role of suffix links in Ukkonen's algorithm.],
  [What are the three components of an active point and what do they represent?],
  [Describe the three rules used in Ukkonen's algorithm for extending the suffix tree.],
  [Construct the suffix tree for the string `S = "ababa\$"` step-by-step using Ukkonen's algorithm.]
)

#pagebreak()

== Solutions

#enum(
  [The main advantage of Ukkonen's algorithm is its linear time complexity, O(n), where n is the length of the string. A naive approach, which involves inserting each suffix into a generalized trie, has a time complexity of O(n^2).],
  [Suffix links are a crucial optimization. When a new internal node is created, a suffix link is added from the previous internal node to this new one. This allows the algorithm to move quickly from representing one suffix to the next, avoiding re-traversing the tree from the root.],
  [The active point is a triple `(active_node, active_edge, active_length)`.
    - `active_node`: The node from which the current search or insertion is happening.
    - `active_edge`: The first character of the edge from `active_node` that the active point is on.
    - `active_length`: The number of characters to traverse along `active_edge` from `active_node`.
  ],
  [
    - *Rule 1 (Leaf Creation):* If the path for the current suffix ends at a leaf edge and the next character is not on that edge, a new leaf is created to represent the new suffix.
    - *Rule 2 (Node Splitting):* If the path for the current suffix ends within an edge and the next character of the string does not match the character on the edge, the edge is split. A new internal node is created, and from this node, a new leaf edge for the new suffix is created.
    - *Rule 3 (Show Stopper):* If the character for the current suffix is already implicitly present in the tree, no change is needed. This is a "show stopper", and the algorithm can proceed to the next phase.
  ],
  [The construction of the suffix tree for `S = "ababa\$"` would proceed in phases, one for each character. It's a detailed process involving the active point and the three rules. A full step-by-step walkthrough would be quite long, but the key is to apply the rules at each step, updating the active point and using suffix links to navigate the tree efficiently as the string is processed character by character.]
)

