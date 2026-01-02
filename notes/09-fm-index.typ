#import "../definitions.typ": *

= FM-Index

== Introduction

The *FM-Index*, introduced by Paolo Ferragina and Giovanni Manzini in 2000, is a compressed full-text index that allows for efficient pattern searching in a very small memory footprint. It is based on the Burrows-Wheeler Transform (BWT) and is widely used in bioinformatics for tasks like DNA sequence alignment.

The *FM-index* can locate any pattern $P$ in a text $T$ of length $n$ in $O(|P|)$ time, which is independent of the text size.

== Burrows-Wheeler Transform (BWT)

The $"BWT"$ is a reversible permutation of a text. The $"BWT"$ of a text $T$ is created as follows:
1. Form a conceptual matrix of all cyclic shifts of $T$.
2. Sort the rows of this matrix lexicographically.
3. The $"BWT"$ is the last column of the sorted matrix.

#example_box[
  *Example:*
  For $T = "banana"$, append a special end-of-string character "\$" which is lexicographically smaller than any other character. $T = "banana$"$.

  Sorted rotations:
  ```
  $banana
  a$banan
  ana$ban
  anana$b
  banana$
  na$bana
  nana$ba
  ```

  The last column is `"annb$aa"`. This is the BWT. The first column is `"$aaabnn"`.
]

== Key Components of the FM-Index

The *FM-index* consists of:
1. The $"BWT"$ of the text.
2. A *C-table* (Count table).
3. An *Occ* (Occurrence) data structure.

=== C-Table

The *C-table* for an alphabet $Sigma$ is an array where $C[c]$ stores the number of characters in the text that are lexicographically smaller than $c$.
- It can be computed by scanning the text once.
- It helps to map a character to the range of rows in the sorted matrix that start with that character.

=== Occ Function

The $"Occ"(c, i)$ function returns the number of occurrences of character $c$ in the prefix of the $"BWT"$ string of length $i$, i.e., $"BWT"[0..i-1]$.
- A naive implementation would take $O(i)$ time.
- The *FM-index* uses a pre-computed data structure to answer $"Occ"$ queries much faster.

=== Efficient Occ Data Structure

To make $"Occ"$ queries efficient, a simple scan is not feasible. Two common approaches are checkpointing and wavelet trees.

*Checkpointing:*
A simple method is to store the full occurrence counts at regular intervals (checkpoints) in the BWT string. For a query $"Occ"(c, i)$, you find the nearest checkpoint before `i`, retrieve the stored counts, and then scan the remaining part of the string to `i`. This balances space and time but is not the most efficient.

*Wavelet Trees:*
A more powerful and standard solution is to use a *wavelet tree*. A wavelet tree is a data structure built on the BWT string that can answer `rank` (Occ), `select`, and `access` queries in logarithmic time with respect to the alphabet size.

#info_box(title: "Wavelet Tree for Occ")[
  1. *Structure:* The wavelet tree is a binary tree where leaves represent characters of the alphabet. Each internal node represents a subset of the alphabet. At each node, a bit-vector stores, for each character in its sequence, whether that character belongs to the alphabet subset of its left child (bit 0) or right child (bit 1).

  2. *Querying Occ(c, i):* To find the number of occurrences of `c` up to position `i`, we traverse the tree from the root to the leaf for `c`.
    - At the root, we check if `c` belongs to the left or right half of the alphabet. Suppose it's the right (bit 1). We compute the number of 1s up to position `i` in the root's bit-vector. Let this be $i'$. This tells us how many characters from the right half's alphabet appear in the prefix.
    - We then move to the right child and recursively ask for the rank of the appropriate bit at the new position $i'$.
    - This continues until we reach the leaf for `c`. The final rank is the answer.

  3. *Performance:* With a supporting structure for the bit-vectors that allows for $O(1)$ rank queries, the total time for an `Occ` query on the wavelet tree is $O(log|Sigma|)$. The space complexity is $O(n log|Sigma|)$.
]

== LF-Mapping (Last-to-First Mapping)

The core of the FM-index search is the LF-mapping property. For the $i$-th character of the BWT (which is $T["SA"[i]-1]$), its corresponding character in the first column is at index $j = C["BWT"[i]] + "Occ"("BWT"[i], i)$. This allows us to move from a character in the last column to its corresponding position in the first column.

#example_box[
  *LF-Mapping Example:*
  Let's use our example where $T = "banana$"$ and BWT = "annb\$aa". The C-table is $C = ('\$': 0, 'a': 1, 'b': 4, 'n': 5)$.

  Let's find the mapping for index $i=5$. The character is $"BWT"[5] = 'a'$.
  - We need to calculate $"Occ"('a', 5)$, which is the number of 'a's in the prefix $"BWT"[0..4] = "annb$"$. The count is 1.
  - The C-table value is $C['a'] = 1$.
  - The new index is $j = C['a'] + "Occ"('a', 5) = 1 + 1 = 2$.

  So, the 'a' at index 5 in the Last column corresponds to the 'a' at index 2 in the First column. This step is the fundamental operation used in the backward search.
]

== Pattern Search

To find a pattern $P$, the *FM-index* performs a backward search:
1. Start with the last character of $P$. Find the range of rows in the sorted matrix that start with this character using the *C-table*.
2. For the second to last character, update the range by using the *LF-mapping* on the previous range.
3. Repeat this process for all characters in $P$, from right to left.
4. If at any point the range becomes empty, the pattern does not exist.
5. If the final range is not empty, it corresponds to all occurrences of the pattern in the text.

== Tasks

=== Task 1
What is the purpose of the *Burrows-Wheeler Transform* in the context of the *FM-Index*?

=== Task 2
Given the $"BWT"$ string `"annb$aa"` and a *C-table*, explain how you would start a search for the pattern `"ana"`.

=== Task 3
Why is the search in the *FM-index* performed backward (from the last character of the pattern to the first)?

#pagebreak()

== Solutions

=== Solution 1
The *Burrows-Wheeler Transform* groups identical characters together in the $"BWT"$ string. For example, all 'a's in the original text tend to be clustered in the $"BWT"$. This property is crucial for compression. In the context of the *FM-index*, the $"BWT"$ enables the *LF-mapping* property, which is the core mechanism for the efficient backward search algorithm. It allows us to find the occurrences of a pattern by iteratively refining a range in the suffix array without explicitly storing the suffix array itself.

=== Solution 2
Given BWT = `"annb$aa"`.
Let's assume a simplified C-table for the alphabet `{"\$", "a", "b", "n"}`:
- $C["\$"] = 0$
- $C[a] = 1$ (one '\$')
- $C[b] = 4$ (one '\$' + three 'a's)
- $C[n] = 5$ (one '\$' + three 'a's + one 'b')

Search for "ana":
1. Start with the last character, 'a'.
2. From the C-table, the range for 'a' is $[C[a], C[b]-1] = [1, 3]$. So, the suffixes starting with 'a' are at indices 1, 2, and 3 in the sorted list.
3. Next, look for 'n' preceding 'a'. We apply the LF-mapping to the range $[1, 3]$.
  - For the 'a' at BWT[1]='n', the new index would be $C['n'] + "Occ"('n', 1) = 5 + 0 = 5$.
  - For the 'a' at BWT[2]='n', the new index would be $C['n'] + "Occ"('n', 2) = 5 + 1 = 6$.
  - For the 'a' at BWT[3]='b', this does not match 'n', so we discard it.
  The new range for "na" would be $[5, 6]$.
4. The process continues with the next character 'a' and the new range $[5, 6]$.

=== Solution 3
The search is performed backward because of the way the LF-mapping works. The BWT gives us the character *preceding* a suffix in the original text. When we are at a certain range of suffixes (all starting with, say, string $S$), the BWT characters corresponding to this range tell us what characters precede $S$ in the text. This allows us to extend our match backward, for example to find suffixes starting with $c"S"$. A forward search would require a different, less efficient mapping.

#pagebreak()
