
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

= Approximate String Matching II

== Introduction

This chapter continues the exploration of approximate string matching, focusing on more advanced and practical algorithms that build upon the concepts of dynamic programming and bit parallelism. A key algorithm in this area is the *Wu-Manber algorithm*.

== The k-Differences Problem

The goal is to find all substrings of a text `$T$` that have an edit distance of at most `$k$` from a pattern `$P$`. This is also known as the *k-differences problem*.

== Wu-Manber Algorithm

The Wu-Manber algorithm, developed by Sun Wu and Udi Manber in 1992, provides an efficient solution to the k-differences problem. It is the basis for the popular `agrep` tool on Unix-like systems.

The algorithm cleverly combines the dynamic programming approach with the bit parallelism of the Shift-Or algorithm.
- *Idea:* Use bit vectors to represent the columns (or diagonals) of the dynamic programming matrix. This allows the computation of a new column from the previous one using a few bitwise operations, which is much faster than cell-by-cell computation.

=== Bit Vector Representation

Instead of storing the entire DP matrix, the algorithm maintains a set of bit vectors. For each number of errors `$q$` from 0 to `$k$`, a bit vector `s[q]` is used.
- `s[q][j] = 0` if the edit distance between `$P[1..j]$` and the current text window is less than or equal to `$q$`.
- In other words, the `j`-th bit of `s[q]` tells us if the `j`-th prefix of the pattern can be matched with at most `q` errors.

=== Update Step

The update of these vectors for each new character in the text is done using bitwise operations (AND, OR, shift). The recurrence relation from the DP matrix is translated into a set of operations on these vectors.

For the edit distance (insert, delete, substitute), the update for `s_i[q]` (the state at text position `i` with `q` errors) depends on:
- `s_(i-1)[q-1]`: A match with one fewer error, extended by a match or substitution.
- `s_i[q-1]`: A match with one fewer error, extended by a deletion.
- `s_(i-1)[q-1]`: A match with one fewer error, extended by an insertion.

This leads to a complex-looking but efficient bitwise formula to update all `k+1` state vectors in parallel.

=== Complexity

- *Time:* `$O(k * ceil(m/w) * n)`, where `$k$` is the number of allowed errors, `$m$` is the pattern length, `$n$` is the text length, and `$w$` is the machine word size. This is very fast in practice, especially for small `$k$`.
- *Space:* `$O((alpha + k) * ceil(m/w))`, for the precomputed masks and the state vectors.

== Extensions

The Wu-Manber algorithm is flexible and can be extended to handle:
- *Regular expressions*: Certain classes of regular expressions can be converted into a form that the bit-parallel approach can handle.
- *Multiple patterns*: By modifying the precomputed mask table, the algorithm can search for a set of patterns simultaneously.
- *Wildcards*: Characters in the pattern that match any character in the text can be incorporated.

== Tasks

1. What is the main innovation of the Wu-Manber algorithm compared to the standard dynamic programming approach?
2. In the Wu-Manber algorithm, what does the bit vector `s[q]` represent?
3. Why is the Wu-Manber algorithm particularly well-suited for bioinformatics applications like DNA sequence searching?

#pagebreak()

== Solutions

=== Task 1: Wu-Manber Innovation

The main innovation of the Wu-Manber algorithm is the application of *bit parallelism* to the dynamic programming solution for approximate string matching. Instead of calculating each cell of the DP matrix one by one, which costs `$O(m*n)$`, it represents entire columns or diagonals of the matrix as bit vectors. It then computes the next set of vectors from the previous ones using a constant number of fast, word-level bitwise operations (shifts, ANDs, ORs). This effectively parallelizes the computation and reduces the complexity, making it significantly faster in practice, especially when the pattern length `m` is smaller than the machine word size `w`.

=== Task 2: Bit Vector `s[q]`

In the Wu-Manber algorithm, the bit vector `s[q]` (for `$q` from 0 to `$k$`) is a state vector that encodes information about matches with up to `$q$` errors. Specifically, the `$j$`-th bit of `s[q]` being 0 indicates that the prefix of the pattern of length `$j$`, i.e., `$P[1..j]`, can be matched with a substring of the text ending at the current position with an edit distance of *at most* `$q$`. A 1 indicates that the distance is greater than `$q$`. When the last bit, `s[k][m]`, becomes 0, it means the entire pattern has been matched with at most `$k$` errors.

=== Task 3: Suitability for Bioinformatics

The Wu-Manber algorithm is well-suited for bioinformatics for several reasons:
1. *Small Alphabet*: DNA and protein sequences have small alphabets (4 for DNA, ~20 for proteins). This keeps the size of the precomputed mask tables manageable.
2. *Short to Medium Patterns*: Many applications involve searching for relatively short patterns (e.g., motifs, primers), which fit well within the bit-parallel model where performance is best when the pattern length `$m$` is close to the machine word size `$w$`.
3. *Error Tolerance*: Biological sequences often have variations (mutations). The algorithm's native support for the k-differences problem (allowing for insertions, deletions, and substitutions) is exactly what is needed for finding similar, but not necessarily identical, sequences.
4. *Speed*: The algorithm is extremely fast in practice, which is critical when searching through massive genomic databases that can be gigabytes in size.
