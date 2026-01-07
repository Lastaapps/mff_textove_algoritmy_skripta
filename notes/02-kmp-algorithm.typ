#import "../definitions.typ": *

= The Knuth-Morris-Pratt (KMP) Algorithm

The Knuth-Morris-Pratt (KMP) algorithm is a fast way to find a pattern (a "needle") in a text (a "haystack").

== The Problem with the Simple Way

The simple, or "brute-force," way to find a pattern is to check every possible position in the text. This can be very slow, taking up to $O(n m)$ steps (text length $dot$ pattern length).

#example_box(title: "Example: The Simple Way")[

  Let's find the pattern `ABCD` in the text `ABCABCD`.
  - Check at index 0: `ABCABCD` vs `ABCD`. Mismatch.
  - Check at index 1: `BCABCD` vs `ABCD`. Mismatch.
  - Check at index 2: `CABCD` vs `ABCD`. Mismatch.
  - Check at index 3: `ABCD` vs `ABCD`. Match found!
]


== The KMP Idea: Be Smart About Mismatches

The KMP algorithm is faster because it cleverly uses information from mismatches. Instead of re-checking every character, it uses a pre-computed table about the *pattern* to skip ahead.

== The Border Array (or Failure Function)

#info_box(
  title: "The Border Array",
)[
  The core of KMP is a _border array_ (or _failure function_), let's call it `b`.

  - *Definition*:
    $b[0] = -1$,
    For each position $j$ in the pattern, $b[j]$ is the length of the longest _proper prefix_ of $P[0...j]$ that is also a _suffix_ of $P[0...j]$.
  - *Proper Prefix*:
    A proper prefix is not the whole string.
]

#example_box(title: "Example")[
  For pattern `ababaca`, the border array is ${-1, 0, 0, 1, 2, 3, 0, 1}$.
  - `aba`:
    The longest proper prefix that is also a suffix is `"a"`. Length is 1. $b[3] = 1$.
  - `abab`:
    The longest is `"ab"`. Length is 2. $b[4] = 2$.
  - `ababa`:
    The longest is `"aba"`. Length is 3. $b[5] = 3$.
]


== How the KMP Algorithm Works

#info_box(
  title: "The KMP Algorithm",
)[
  The algorithm has two main steps:
  - *Preprocessing*:
    Build the border array for the pattern.
  - *Searching*:
    Scan the text from left to right.
    - If characters match, advance both pointers.
    - If there is a mismatch, use the border array to determine how far to slide the pattern forward *without moving the text pointer backward*. This is the key to its speed.
]

#code_box([
  #smallcaps([KMP-Search]) ($P$, $T$, $b$)
  ```
  j = 0  // Length of current match
  for i from 0 to n-1:
    while j > 0 and T[i] != P[j]:
      j = b[j]  // Fall back using border array

    if T[i] == P[j]:
      j = j + 1

    if j == m:
      report match at i - m + 1
      j = b[j] // Continue searching for more matches
  ```
])

=== The `while` loop
A common question is why the algorithm uses a `while` loop to handle mismatches, rather than a simple `if` statement.
- When a mismatch occurs at `T[i]` and `P[j]`, we shift the pattern by setting `j = b[j-1]`.
- An `if` statement would perform this shift once and then proceed to the next character in the text.
- However, the new prefix of the pattern (of length `b[j-1]`) might *still* not match the character `T[i]`.
- The `while` loop is necessary to handle this. It repeatedly applies the border array logic, effectively trying all possible shorter prefixes of the pattern that are also suffixes, until it finds one that can be extended by `T[i]`, or until the pattern is fully reset (`j=0`).


== How Fast is KMP?

#info_box(
  title: "KMP Complexity",
)[
  - *Time Complexity*:
    $O(n + m)$, where $n$ is text length and $m$ is pattern length.
  - *Space Complexity*:
    $O(m)$ to store the border array for the pattern.
  - *Use case*:
    Searching a single needle in multiple haystacks.
]

== Linear Time Complexity

The linear time complexity of the KMP search phase is not immediately obvious because of the `while` loop inside the main `for` loop. A simple analysis would suggest a complexity higher than $O(n)$. However, an amortized analysis shows that the algorithm is indeed linear.

#info_box(
  title: "Proof of Linear Time Complexity",
)[
  - The `for` loop runs $n$ times (the length of the text). The pointer `i` is always incremented.
  - The `while` loop body (where `j` is updated to `b[j]`) can execute multiple times for a single `i`. Each execution corresponds to a "shift" of the pattern.
  - The key insight is that the total number of these "shifts" (executions of `j = b[j]`) across the entire run of the algorithm is limited. The pointer `j` is incremented at most $n$ times (once for each character of the text in case of a match). Each time the `while` loop body executes, `j` is decreased. Since `j` can only be decreased as many times as it has been increased, the total number of `j = b[j]` executions cannot exceed the total number of increments.
  - Therefore, the total number of comparisons and operations is bounded by $2n$, which gives a time complexity of $O(n)$ for the search phase.
]

== Improved Border Array

The standard KMP algorithm can be optimized to avoid some redundant comparisons.

- When a mismatch occurs between `P[j]` and `T[i]`, the algorithm sets `j = b[j-1]`.
- It then compares `P[j]` with `T[i]` again.
- However, if `P[j]` (the new `j`) is the same as `P[b[j-1]]` (the old `j`), this comparison is guaranteed to fail if the original mismatch was with a character different from `P[j]`.

#info_box(
  title: "The Solution: Improved Border Array (b')",
)[
  We can define an improved border array, `b'`, that skips these useless comparisons. `b'` is defined as follows:
  - `b'[j] = b[j]` if `P[b[j]] != P[j]`
  - `b'[j] = b'[b[j]]` if `P[b[j]] == P[j]` (recursive definition)

  This means that after a shift, the new character to be compared, `P[b'[j]]`, is guaranteed to be different from the character `P[j]` that caused the mismatch. This avoids the redundant comparison.

  The improved border array can be computed in $O(m)$ time. One way is to first compute the standard border array `b`, and then compute `b'` from it.

  #code_box([
    #smallcaps([Compute-Improved-Border-Array]) ($P$, $b$)
    ```
    m = length(P)
    b_prime = array of size m
    b_prime[0] = b[0]
    for j from 1 to m-1:
      if P[b[j]] != P[j]:
        b_prime[j] = b[j]
      else:
        b_prime[j] = b_prime[b[j]]
    return b_prime
    ```
  ])

  The search algorithm remains the same, just using `b'` instead of `b`. This optimization reduces the total number of comparisons to a maximum of $2n - m$.
]


Because of its efficiency, KMP is a very important algorithm for pattern matching.

== Tasks

=== Task 1
For the pattern `abacaba`, construct its border array (failure function) step-by-step. Explain the reasoning for each value.

=== Task 2
Given the text `ABABABC` and the pattern `ABABC`,
explain how the KMP algorithm would process its first mismatch at
the 5th character of the pattern (`C` in `ABABC`) against the 5th character of the text (`D`).
Assume the KMP algorithm has already matched `ABAB` successfully, and that the algorithm does not use the improved border array.

=== Task 3
Compare the time complexity of the naive string matching algorithm with the KMP algorithm. Under what conditions does KMP offer a significant advantage?

#pagebreak()

== Solutions

=== Solution 1
For the pattern `abacaba`:
- `P[0] = 'a'`: No proper prefix. `b[1] = 0`.
- `P[0...1] = "ab"`: No proper prefix that is also a suffix. `b[2] = 0`.
- `P[0...2] = "aba"`: Longest proper prefix "a" is also a suffix. Length 1. `b[3] = 1`.
- `P[0...3] = "abac"`: No proper prefix that is also a suffix. `b[4] = 0`.
- `P[0...4] = "abaca"`: Longest proper prefix "a" is also a suffix. Length 1. `b[5] = 1`.
- `P[0...5] = "abacab"`: Longest proper prefix "ab" is also a suffix. Length 2. `b[6] = 2`.
- `P[0...6] = "abacaba"`: Longest proper prefix "aba" is also a suffix. Length 3. `b[7] = 3`.

The border array for `abacaba` is `{-1, 0, 0, 1, 0, 1, 2, 3}`.

=== Solution 2
- *Text:* `ABABABC`
- *Pattern:* `ABABC`
- *Border Array (for `ABABC`):* `{-1, 0, 0, 1, 2, 0}`
- Assume `ABAB` has matched. The text pointer $i$ is at index 4 (pointing to 'A').
- The pattern pointer $j$ is at index 4 (pointing to 'C').
- We look up $b[j] = b[4]$. $b[4]$ corresponds to the border length of `ABAB`. The value $b[4]$ is 2.
- This means the pattern will slide forward by $j - b[j] = 4 - 2 = 2$ positions.
- In the next iteration of the while loop $i=4, j=2$, the algorithm will successfully match the 3rd character of the pattern to the 5th character of the text (`A`).

=== Solution 3
- *Naive Algorithm Time Complexity:* $O(n dot m)$, where $n$ is text length and $m$ is pattern length.
- *KMP Algorithm Time Complexity:* $O(n + m)$.
- *Significant Advantage:* KMP offers a significant advantage when:
  - The text is very long ($n$ is large).
  - The pattern is relatively short ($m$ is small).
  - The pattern contains many repeating sub-patterns (e.g., `AAAAA`, `ABABAB`), which allows the border array to maximize skips on mismatches.
  - Multiple searches with the same pattern are performed on different texts, as the preprocessing for the border array is done only once.

#pagebreak()
