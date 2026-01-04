#import "../definitions.typ": *

= Shift-Or Algorithm

== Introduction

The *Shift-Or* algorithm is an exact string matching algorithm that uses bit parallelism to make comparisons faster. It was introduced by Baeza-Yates and Gonnet in 1992. Instead of reducing the number of comparisons like Boyer-Moore or KMP, Shift-Or optimizes the comparison process itself. It is particularly efficient for small patterns and alphabets.

The time complexity is $O(ceil(m/w) dot n)$, where $m$ is the pattern length, $n$ is the text length, and $w$ is the machine word size (e.g., 64 bits).

== Bit Parallelism

The core idea is to use bitwise operations (like shift and OR) to simulate the behavior of a non-deterministic finite automaton (NFA) for pattern matching. A bit vector is used to keep track of all current matches of prefixes of the pattern.

== The Bit Vector $s$

A bit vector $s$ of length $m$ is maintained. The $j$-th bit of $s$ is 0 if the prefix of the pattern of length $j$ (i.e., $P[1..j]$) is a suffix of the text scanned so far.
- $s[j] = 0$ means $T[i-j+1 dots i] == P[1..j]$.
- $s[j] = 1$ otherwise.

#figure(
  image("../figures/shift-or.png", width: 80%) 
)

An occurrence of the full pattern is found at position $i$ if $s[m] = 0$.

== Update Step

As we scan the text character by character, the bit vector $s$ is updated. Let $s_i$ be the bit vector after reading the $i$-th character of the text, $T[i]$. The new vector $s_{i+1}$ is computed from $s_i$ and $T[i+1]$.

The update involves two main operations:
1. A right shift of the old vector $s_i$. This corresponds to extending all previous prefix matches by one character.
2. An OR operation with a precomputed mask for the current text character $T[i+1]$. This mask indicates which prefixes of the pattern end with this character.

The formula is: $s_{i+1} = (s_i >> 1) | "mask"[T[i+1]]$

== Precomputed Masks

For each character $c$ in the alphabet, a bitmask of length $m$ is precomputed.
- $"mask"[c][j] = 0$ if $P[j] == c$.
- $"mask"[c][j] = 1$ if $P[j] != c$.

This table can be precomputed in $O(alpha m)$ time, where $alpha$ is the size of the alphabet.

== The Algorithm

1. *Initialization:*
  - Precompute the `mask` table for the pattern $P$.
  - Initialize the state vector $s$ to all 1s.

2. *Searching:*
  - For each character $T[i]$ of the text:
    - Update the state vector: $s = (s >> 1) | "mask"[T[i]]$.
    - If $s[m] == 0$ (or after the update, the $m$-th bit is 0), an occurrence of the pattern has been found.

== Tasks

=== Task 1
For the pattern $P = "aba"$ and alphabet {"a", "b"}, what would the precomputed masks be?

=== Task 2
Using the Shift-Or algorithm, trace the state vector $s$ while searching for $P = "aba"$ in the text $T = "ababa"$.

=== Task 3
When is the Shift-Or algorithm not recommended?

#pagebreak()

== Solutions

=== Solution 1
Pattern $P = "aba"$, length $m=3$. Alphabet {"a", "b"}.
The masks are bit vectors of length 3.

- For 'a': The pattern has 'a' at positions 1 and 3. The mask should have 0s at these positions.
  `mask['a'] = 010`
- For 'b': The pattern has 'b' at position 2.
  `mask['b'] = 101`
- For any other character $c$, there are no matches.
  `mask[c] = 111`

=== Solution 2
Pattern $P = "aba"$, Text $T = "ababa"$.
Initial state: $s = 111$.
`mask['a'] = 010`, `mask['b'] = 101`.

1. Read $T[0] = 'a'$:
  $s = (111 >> 1) | "mask"[T[0]] = 011 | 010 = 011$. $s[0]$ is 0.

2. Read $T[1] = 'b'$:
  $s = (011 >> 1) | "mask"[T[1]] = 001 | 101 = 101$. $s[1]$ is 0.

3. Read $T[2] = 'a'$:
  $s = (101 >> 1) | "mask"[T[2]] = 010 | 010 = 010$. $s[2]$ is 0. Match found at position 2.

4. Read $T[3] = 'b'$:
  $s = (010 >> 1) | "mask"[T[3]] = 001 | 101 = 101$. $s[1]$ is 0.

5. Read $T[4] = 'a'$:
  $s = (101 >> 1) | "mask"[T[4]] = 010 | 010 = 010$. $s[2]$ is 0. Match found at position 4.

The algorithm correctly finds matches ending at positions 2 and 4.

=== Solution 3
The Shift-Or algorithm's performance depends on the pattern length $m$ relative to the machine word size $w$.
- If $m > w$, the algorithm requires multiple words to store the state vector, and the complexity becomes $O(ceil(m/w) dot n)$. For very long patterns, this can be slower than other algorithms like Boyer-Moore.
- It is also not recommended for very large alphabets because the space for the precomputed mask table ($O(alpha m)$) can become very large.

Therefore, for large patterns or large alphabets, other algorithms might be more suitable.

#pagebreak()
