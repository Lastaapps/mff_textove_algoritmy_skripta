#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

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
  For $T = "banana"$, append a special end-of-string character "\$" which is lexicographically smaller than any other character. $T = "banana\$"$.

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

  The last column is `"annb$aa"`. This is the BWT. The first column is `"$$aaabnn"`.
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
- The *FM-index* uses a pre-computed data structure (often using checkpoints and bit-vectors) to answer $"Occ"$ queries in $O(1)$ time.

== LF-Mapping (Last-to-First Mapping)

The core of the FM-index search is the LF-mapping property. For the `$i$`-th character of the BWT (which is $T["SA"[i]-1]$), its corresponding character in the first column is at index `$j = "C"["BWT"[i]] + "Occ"("BWT"[i], i)$`. This allows us to move from a character in the last column to its corresponding position in the first column.

== Pattern Search

To find a pattern $P$, the *FM-index* performs a backward search:
1. Start with the last character of $P$. Find the range of rows in the sorted matrix that start with this character using the *C-table*.
2. For the second to last character, update the range by using the *LF-mapping* on the previous range.
3. Repeat this process for all characters in $P$, from right to left.
4. If at any point the range becomes empty, the pattern does not exist.
5. If the final range is not empty, it corresponds to all occurrences of the pattern in the text.

== Tasks

1. What is the purpose of the *Burrows-Wheeler Transform* in the context of the *FM-Index*?
2. Given the $"BWT"$ string `"annb$aa"` and a *C-table*, explain how you would start a search for the pattern `"ana"`.
3. Why is the search in the *FM-index* performed backward (from the last character of the pattern to the first)?

#pagebreak()

== Solutions

=== Task 1: Purpose of BWT

The *Burrows-Wheeler Transform* groups identical characters together in the $"BWT"$ string. For example, all 'a's in the original text tend to be clustered in the $"BWT"$. This property is crucial for compression. In the context of the *FM-index*, the $"BWT"$ enables the *LF-mapping* property, which is the core mechanism for the efficient backward search algorithm. It allows us to find the occurrences of a pattern by iteratively refining a range in the suffix array without explicitly storing the suffix array itself.

=== Task 2: Starting a search for "ana"

Given BWT = `"annb$aa"`.
Let's assume a simplified C-table for the alphabet `{$, a, b, n}`:
- `$C[$] = 0$`
- `$C[a] = 1$` (one '\$')
- `$C[b] = 4$` (one '\$' + three 'a's)
- `$C[n] = 5$` (one '\$' + three 'a's + one 'b')

Search for "ana":
1. Start with the last character, 'a'.
2. From the C-table, the range for 'a' is `[C[a], C[b]-1] = [1, 3]`. So, the suffixes starting with 'a' are at indices 1, 2, and 3 in the sorted list.
3. Next, look for 'n' preceding 'a'. We apply the LF-mapping to the range `[1, 3]`.
  - For the 'a' at BWT[1]='n', the new index would be `$C['n'] + Occ('n', 1) = 5 + 0 = 5$`.
  - For the 'a' at BWT[2]='n', the new index would be `$C['n'] + Occ('n', 2) = 5 + 1 = 6$`.
  - For the 'a' at BWT[3]='b', this does not match 'n', so we discard it.
  The new range for "na" would be `[5, 6]`.
4. The process continues with the next character 'a' and the new range `[5, 6]`.

=== Task 3: Backward Search

The search is performed backward because of the way the LF-mapping works. The BWT gives us the character *preceding* a suffix in the original text. When we are at a certain range of suffixes (all starting with, say, string $S$), the BWT characters corresponding to this range tell us what characters precede $S$ in the text. This allows us to extend our match backward, for example to find suffixes starting with $c"S"$. A forward search would require a different, less efficient mapping.
