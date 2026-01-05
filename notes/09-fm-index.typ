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

#example_box(title: "Example")[
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

  The last column is `"annb$aa"`. This is the BWT.
]

== Key Components of the FM-Index

The *FM-index* consists of:
1. The $"BWT"$ of the text.
2. A *C-table* (Count table).
3. An *Occ* (Occurrence) data structure.

=== C-Table

The *C-table* for an alphabet $Sigma$ is an array where $C[c]$ stores the number of characters in the text that are lexicographically smaller than $c$.
- It can be computed by scanning the text once and doing prefix sums.
- It helps to map a character to the range of rows in the sorted matrix that start with that character.
- It requires $O(|Sigma|)$ space.

=== Occ Function

The $"Occ"(c, i)$ function returns the number of occurrences of character $c$ in the prefix of the $"BWT"$ string of length $i$, i.e., $"BWT"[0..i-1]$.
- A naive implementation would take $O(i |Sigma|)$ time and space.
- The *FM-index* uses a pre-computed data structure to answer $"Occ"$ queries much faster.

=== Efficient Occ Data Structure

To make $"Occ"$ queries efficient, a simple scan is not feasible. Two common approaches are checkpointing and wavelet trees.

==== Checkpointing
A simple method is to store the full occurrence counts at regular intervals (checkpoints) in the BWT string. For a query $"Occ"(c, i)$, you find the nearest checkpoint before `i`, retrieve the stored counts, and then scan the remaining part of the string to `i`. This balances space and time but is not the most efficient.

==== Block-based $O(1)$ Occ Structure

To achieve a constant $O(1)$ query time for $"Occ"(a, i)$, a multi-level data structure is built for *each character* $a$ in the alphabet $Sigma$.

1. *Conceptual Division:*
  The BWT string (length $n$) is conceptually divided into a hierarchy of blocks:
  - It is first split into $n / (log^2 n)$ large *blocks*, each of size $log^2 n$.
  - Each large block is then divided into $log n$ smaller *sub-blocks*, each of size $log n$.

2. *Pre-computed Count Tables:*
  For a specific character $a$, two tables are pre-calculated to handle counts at the block and sub-block level:
  - *$P$ table:* For each large block $i$, $P[i]$ stores the total count of character $a$ in the BWT string from the beginning up to the start of block $i$. This is the cumulative count across large blocks.
  - *$Q$ table:* For each large block $i$ and sub-block $j$ within it, $Q[i, j]$ stores the count of $a$ from the start of block $i$ up to the start of sub-block $j$.

3. *Rank within a sub-block:*
  To get the final count inside a sub-block without scanning, we use a pre-computed `rank` function.
  - A sub-block has size $log n$. We can represent the occurrences of $a$ within it using a bit-vector of length $log n$.
  - To perform a `rank` query on this bit-vector in $O(1)$, we can build a lookup table. Since a table for all possible $log n$-bit vectors would be too large ($2^(log n) = n$), the bit-vector is split into smaller chunks (e.g., two halves of length $(log n)/2$).
  - A pre-computed table then stores the rank for all possible bit-vectors of this smaller size. For any string of length $k = (log n)/2$ and any position $j < k$, the table stores the number of 1s in its $j$-prefix. This table is shared across all sub-blocks.

4. *Querying $"Occ"(a, i)$ in $O(1)$:*
  To answer $"Occ"(a, i)$, the index $i$ is decomposed to find the relevant block, sub-block, and offset:
  - Block index: $i_1 = floor(i / log^2 n)$
  - Sub-block index: $i_2 = floor((i mod log^2 n) / log n)$
  - Offset in sub-block: $i_3 = i mod log n$

  The final count is calculated by summing the pre-computed values and the rank in the final segment:
  $"Occ"(a, i) = P[i_1] + Q[i_1, i_2] + "rank"_a("at sub-block", i_3)$
  - $P[i_1]$ provides the count up to the boundary of the large block.
  - $Q[i_1, i_2]$ adds the count up to the boundary of the sub-block.
  - The `rank` function provides the final count within the last sub-block segment of length $i_3$.

This structure is built for each character, allowing constant-time queries for any of them. The total space complexity can be optimized to $O(n)$ for the entire alphabet, making it very efficient in theory, though often more complex to implement than Wavelet Trees.

==== Wavelet Trees\*
A more powerful and standard solution is to use a *wavelet tree*. A wavelet tree is a data structure built on the BWT string that can answer `rank` (Occ), `select`, and `access` queries in logarithmic time with respect to the alphabet size. This topic is not discussed in the lectures.

#info_box(title: "Wavelet Tree for Occ")[
  A *wavelet tree* provides a very efficient way to calculate `Occ` values. It's a single, compact data structure built from the BWT string.

  - It's a binary (search, "decision") tree, where each node corresponds to a part of the alphabet. The root represents the whole alphabet.
  - Each node contains a *bit-vector*. This bit-vector is the key to counting characters. It's size corresponds to the number of alphabet letters in the node.
  - The counts are not stored directly. Instead, they are calculated very quickly from the bit-vectors at each node.
  - At a node, the alphabet is split in half. The bit-vector at that node stores a `0` for each character that belongs to the first half of the node's alphabet, and a `1` for characters in the second half.
  - By counting the 0s and 1s in a prefix of a bit-vector (using an operation called `rank`), we can determine how many characters from each half of the alphabet appeared up to a certain position.
]
#example_box[
  - Let BWT string be `"annb$aa"` and the alphabet be `{"$", "a", "b", "n"}`.
  - The root's alphabet is `{"$", "a", "b", "n"}`. Let's split it into `{"$", "a"}` (left, bit `0`) and `{"b", "n"}` (right, bit `1`).
  - The bit-vector at the root will be created by looking at each character of `"annb$aa"`:
    - 'a': in `{"$", "a"}` #sym.arrow 0
    - 'n': in `{"b", "n"}` #sym.arrow 1
    - 'n': in `{"b", "n"}` #sym.arrow 1
    - 'b': in `{"b", "n"}` #sym.arrow 1
    - '\$': in `{"$", "a"}` #sym.arrow 0
    - 'a': in `{"$", "a"}` #sym.arrow 0
    - 'a': in `{"$", "a"}` #sym.arrow 0
  - So, the root's bit-vector is `0111000`.
  - The characters for the left child (for alphabet `{"$", "a"}`) are `a$aa` (the ones that got a 0, in order). The characters for the right child (for `{"b", "n"}`) are `nnb`. The tree construction continues recursively on these sequences.
]
#info_box(title: [Query in a wavelet tree])[
  To find $"Occ"(c, i)$, you traverse the tree from the root to the leaf for character $c$:
  - At each node, you check if $c$ belongs to the left (0) or right (1) part of the alphabet.
  - You use the `rank` operation on the node's bit-vector to count how many characters from that part appeared before position $i$. This gives you the new, smaller position for the query in the child node.
  - When you reach the leaf for $c$, the final position you calculated is the $"Occ"$ value.

  With this structure, $"Occ"$ queries take $O(log|Sigma|)$ time (where $|Sigma|$ is the alphabet size), which is extremely fast. The space required is $O(n log|Sigma|)$.
]

== LF-Mapping (Last-to-First Mapping)

The core of the FM-index search is the LF-mapping property. For the $i$-th character of the BWT (which is $T["SA"[i]-1]$), its corresponding character (same character in a string one cyclic rotation away) in the first column is at index $j = C["BWT"[i]] + "Occ"("BWT"[i], i)$ (number of string's characters smaller than $"BWT"[i]$ + occurrences of the same character in $"BWT"$ before $i$). This allows us to move from a character in the last column to its corresponding position in the first column.

#example_box(title: "LF-Mapping Example")[
  Let's use our example where $T = "banana$"$ and BWT = "annb\$aa". The C-table is `C = ('$': 0, 'a': 1, 'b': 4, 'n': 5)`.

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

== FM-Index in Bioinformatics: DNA Search

One of the most significant applications of the FM-index is in bioinformatics, especially for searching in large genomes. The structure of DNA, with its small alphabet $Sigma = {A, C, G, T}$, makes the FM-index exceptionally space-efficient.

#info_box(title: "Space Advantage for DNA")[
  Consider a human genome with approximately $n = 3 dot 10^9$ base pairs.

  - A traditional suffix array would require $n dot log n$ bits of space. For $n=3 dot 10^9$, this is roughly $3 dot 10^9 dot log_2(3 dot 10^9) approx 3 dot 10^9 dot 31.5$ bits, which is about *11.7 gigabytes*. This is only for the suffix array itself, not the full text.

  - The *FM-index*, however, can be much smaller. For the DNA alphabet, the space complexity is dominated by the BWT and the Occ structure.
    - The BWT can be compressed very effectively. Since there are only 4 characters, we only need 2 bits per character, so the BWT string takes $2n$ bits.
    - The C-table is tiny, requiring space for only 4 characters: $O(|Sigma| log n) = O(log n)$.
    - The Occ data structure, which is often the largest part, can be implemented in $O(n)$ bits.
]

The total space for an FM-index on a human genome can be less than *3 gigabytes*, a reduction of *4x or more* compared to a standard suffix array. This makes it possible to hold the entire index for a human genome in the RAM of a typical desktop computer, enabling extremely fast queries. This is why tools like Bowtie and BWA, which are standards in genomics, are built on the FM-index.

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
Let's assume a simplified C-table for the alphabet `{"$", "a", "b", "n"}`:
- $C["$"] = 0$
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
