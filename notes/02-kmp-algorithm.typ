#import "../definitions.typ": info_box

= The Knuth-Morris-Pratt (KMP) Algorithm

The Knuth-Morris-Pratt (KMP) algorithm is a fast way to find a pattern (a "needle") in a text (a "haystack").

== The Problem with the Simple Way

The simple, or "brute-force," way to find a pattern is to check every possible position in the text. This can be very slow, taking up to $n \cdot m$ steps (text length \* pattern length).

#info_box(
  title: "Example: The Simple Way")[
    Let's find the pattern `ABCD` in the text `ABCABCD`.
    1. Check at index 0: `ABCABCD` vs `ABCD`. Mismatch.
    2. Check at index 1: `BCABCD` vs `ABCD`. Mismatch.
    3. Check at index 2: `CABCD` vs `ABCD`. Mismatch.
    4. Check at index 3: `ABCD` vs `ABCD`. Match found!
  ]


== The KMP Idea: Be Smart About Mismatches

The KMP algorithm is faster because it cleverly uses information from mismatches. Instead of re-checking every character, it uses a pre-computed table about the *pattern* to skip ahead.

== The Border Array (or Failure Function)

#info_box(
  title: "Key Concept: The Border Array")[
    The core of KMP is a *border array* (or *failure function*), let's call it `b`.

    - *Definition*: For each position `j` in the pattern, `b[j]` is the length of the longest *proper prefix* of `P[0...j]` that is also a *suffix* of `P[0...j]`.
    - A *proper prefix* is not the whole string.

    *Example*: For pattern `ababaca`, the border array is `{0, 0, 1, 2, 3, 0, 1}`.
    - `aba`: The longest proper prefix that is also a suffix is `"a"`. Length is 1. `b[2] = 1`.
    - `abab`: The longest is `"ab"`. Length is 2. `b[3] = 2`.
    - `ababa`: The longest is `"aba"`. Length is 3. `b[4] = 3`.
  ]


== How the KMP Algorithm Works

#info_box(
  title: "The KMP Algorithm")[
    The algorithm has two main steps:
    1.  *Preprocessing*: Build the border array for the pattern.
    2.  *Searching*: Scan the text from left to right.
        - If characters match, advance both pointers.
        - If there is a mismatch, use the border array to determine how far to slide the pattern forward *without moving the text pointer backward*. This is the key to its speed.
  ]


== How Fast is KMP?

#info_box(
  title: "KMP Complexity")[
    - *Time Complexity*: $O(n + m)$, where $n$ is text length and $m$ is pattern length. This is a linear time complexity, which is very efficient.
    - *Space Complexity*: `O(m)` to store the border array for the pattern.
  ]


Because of its efficiency, KMP is a very important algorithm for pattern matching.
