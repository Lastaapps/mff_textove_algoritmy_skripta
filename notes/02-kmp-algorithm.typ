= The Knuth-Morris-Pratt (KMP) Algorithm

The Knuth-Morris-Pratt (KMP) algorithm is a fast way to find a pattern (a "needle") in a text (a "haystack"). It was created by Donald Knuth, James H. Morris, and Vaughan Pratt in 1977.

== The Problem with the Simple Way

The simple, or "brute-force," way to find a pattern is to check every possible position in the text.

For example, let's say our text is `ABCABCD` and our pattern is `ABCD`.
1. We check if `ABCABCD` starts with `ABCD`. No.
2. We check if `BCABCD` starts with `ABCD`. No.
3. We check if `CABCD` starts with `ABCD`. No.
4. We check if `ABCD` starts with `ABCD`. Yes! We found a match.

This works, but it can be very slow if the text and pattern are long. The computer has to do a lot of comparisons that are not necessary. If the text has `n` characters and the pattern has `m` characters, the simple way can take up to `n * m` steps.

== The KMP Idea: Be Smart About Mismatches

The KMP algorithm is faster because it's smarter. When there is a mismatch (the characters don't match), KMP uses information it already learned about the *pattern* to skip ahead. It doesn't need to re-check characters that it knows will not match.

Imagine we are matching the pattern `ababa` against a text. If we match `abab` and the next character is a mismatch, we don't have to start over. We know that the part we just matched (`abab`) starts with `ab`. The KMP algorithm uses this to slide the pattern forward in an intelligent way.

== The Border Array (or Failure Function)

The "magic" of KMP comes from a special table that we create from the pattern. This table is often called a *border array* or a *failure function*. Let's call it `b`.

For each position `j` in our pattern, `b[j]` tells us the length of the longest proper prefix of the pattern `P[0...j]` that is also a suffix of `P[0...j]`.

- A *prefix* is the beginning part of a string.
- A *suffix* is the ending part of a string.
- A *proper* prefix is not the whole string.

Let's look at the pattern `ababaca`.

- `a`: No proper prefix. `b[0] = 0`.
- `ab`: Prefixes: `a`. Suffixes: `b`. No match. `b[1] = 0`.
- `aba`: Prefixes: `a`, `ab`. Suffixes: `a`, `ba`. Match: `a`. Length is 1. `b[2] = 1`.
- `abab`: Prefixes: `a`, `ab`, `aba`. Suffixes: `b`, `ab`, `bab`. Match: `ab`. Length is 2. `b[3] = 2`.
- `ababa`: Prefixes: `a`, `ab`, `aba`, `abab`. Suffixes: `a`, `ba`, `aba`, `baba`. Match: `aba`. Length is 3. `b[4] = 3`.
- `ababac`: No match. `b[5] = 0`.
- `ababaca`: Match: `a`. Length is 1. `b[6] = 1`.

So, for the pattern `ababaca`, the border array would be `{0, 0, 1, 2, 3, 0, 1}`.

== How the KMP Algorithm Works

The KMP algorithm has two main steps:

1.  *Preprocessing:* First, we build the border array for our pattern. This step only looks at the pattern, not the text. It takes about `m` steps, where `m` is the length of the pattern.

2.  *Searching:* Then, we search for the pattern in the text, using the border array to help us.
    - We compare characters of the pattern and the text one by one.
    - If the characters match, we move to the next character in both the pattern and the text.
    - If the characters *do not* match, we look at the border array. The array tells us how many characters to slide the pattern forward. We don't have to move the text pointer back. This is what makes KMP fast.

== How Fast is KMP?

- *Time:* The total time for the KMP algorithm is about `n + m` steps, where `n` is the length of the text and `m` is the length of the pattern. This is much faster than the `n * m` steps of the simple way.
- *Space:* The KMP algorithm needs extra memory to store the border array. The size of the array is the same as the length of the pattern (`m`).

Because of its speed, the KMP algorithm is a very important and widely used method in computer science for finding patterns in strings.
