#import "../definitions.typ": info_box

= The Knuth-Morris-Pratt (KMP) Algorithm

The Knuth-Morris-Pratt (KMP) algorithm is a fast way to find a pattern (a "needle") in a text (a "haystack").

== The Problem with the Simple Way

The simple, or "brute-force," way to find a pattern is to check every possible position in the text. This can be very slow, taking up to $n \cdot m$ steps (text length \* pattern length).

#info_box(
  title: "Example: The Simple Way",
)[
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
  title: "Key Concept: The Border Array",
)[
  The core of KMP is a _border array_ (or _failure function_), let's call it `b`.

  - *Definition*:
    For each position $j$ in the pattern, $b[j]$ is the length of the longest _proper prefix_ of $P[0...j]$ that is also a _suffix_ of $P[0...j]$.
  - *Proper Prefix*:
    A proper prefix is not the whole string.

  *Example*: For pattern `ababaca`, the border array is ${0, 0, 1, 2, 3, 0, 1}$.
  - `aba`:
    The longest proper prefix that is also a suffix is `"a"`. Length is 1. $b[2] = 1$.
  - `abab`:
    The longest is `"ab"`. Length is 2. $b[3] = 2$.
  - `ababa`:
    The longest is `"aba"`. Length is 3. $b[4] = 3$.
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


Because of its efficiency, KMP is a very important algorithm for pattern matching.

#pagebreak(weak: true)

== Tasks

1. *Task:* For the pattern `abacaba`, construct its border array (failure function) step-by-step. Explain the reasoning for each value.

2. *Task:* Given the text `ABABDABACDABABCABAB` and the pattern `ABABCABAB`,
  explain how the KMP algorithm would process a mismatch if the mismatch occurs at
  the 6th character of the pattern (`C` in `ABABCABAB`) while comparing against
  the text. Assume the KMP algorithm has already matched `ABAB` successfully.

3. *Task:* Compare the time complexity of the naive string matching algorithm with the KMP algorithm. Under what conditions does KMP offer a significant advantage?

#pagebreak(weak: true)

== Solutions

1. *Solution:* For the pattern `abacaba`:
  - `P[0] = 'a'`: No proper prefix. `b[0] = 0`.
  - `P[0...1] = "ab"`: No proper prefix that is also a suffix. `b[1] = 0`.
  - `P[0...2] = "aba"`: Longest proper prefix "a" is also a suffix. Length 1. `b[2] = 1`.
  - `P[0...3] = "abac"`: No proper prefix that is also a suffix. `b[3] = 0`.
  - `P[0...4] = "abaca"`: Longest proper prefix "a" is also a suffix. Length 1. `b[4] = 1`.
  - `P[0...5] = "abacab"`: Longest proper prefix "ab" is also a suffix. Length 2. `b[5] = 2`.
  - `P[0...6] = "abacaba"`: Longest proper prefix "aba" is also a suffix. Length 3. `b[6] = 3`.

  The border array for `abacaba` is `{0, 0, 1, 0, 1, 2, 3}`.

2. *Solution:*
  - *Text:* `ABABDABACDABABCABAB`
  - *Pattern:* `ABABCABAB`
  - *Border Array (for `ABABCABAB`):* `{0, 0, 1, 2, 0, 1, 2, 3, 4}`
  - Assume `ABABA` has matched. The pattern pointer $j$ is at index 5 (pointing to 'C').
  - A mismatch occurs at the 6th character of the pattern (index 5, which is 'C').
  - The current matched prefix length is 5 (`ABABA`).
  - We look up $b[j-1] = b[5-1] = b[4]$. $b[4]$ corresponds to the prefix `ABABC`. The value $b[4]$ is 0.
  - This means the pattern will slide forward by $j - b[j-1] = 5 - 0 = 5$ positions. More accurately, the pattern pointer $j$ resets to $b[4] = 0$. The text pointer remains unchanged.
  - The comparison then restarts from the current text position with the pattern pointer at index 0.

3. *Solution:*
  - *Naive Algorithm Time Complexity:* $O(n \cdot m)$, where $n$ is text length and $m$ is pattern length.
  - *KMP Algorithm Time Complexity:* $O(n + m)$.
  - *Significant Advantage:* KMP offers a significant advantage when:
    - The text is very long ($n$ is large).
    - The pattern is relatively short ($m$ is small).
    - The pattern contains many repeating sub-patterns (e.g., `AAAAA`, `ABABAB`), which allows the border array to maximize skips on mismatches.
    - Multiple searches with the same pattern are performed on different texts, as the preprocessing for the border array is done only once.

#pagebreak(weak: true)
