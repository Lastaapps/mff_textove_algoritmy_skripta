
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set heading(numbering: "1.1")

= Rabin-Karp Algorithm

== Introduction

The *Rabin-Karp algorithm* is a string-searching algorithm that uses hashing to find occurrences of a pattern in a text. It was created by Michael O. Rabin and Richard M. Karp in 1987. Instead of comparing the pattern with every substring of the text, it compares the hash value of the pattern with the hash value of each substring.

== Hashing and Signatures

The core idea is to compute a "signature" or hash value for the pattern and for each substring of the text of the same length.
- If the hash values are different, the strings are definitely different.
- If the hash values are the same, it is likely that the strings are the same. This is called a "spurious hit" or collision, and a full character-by-character comparison is needed to confirm the match.

== Rolling Hash

To be efficient, the algorithm needs a way to compute the hash of the next substring in constant time, rather than re-calculating it from scratch. This is achieved using a *rolling hash*.

A common rolling hash function treats a string as a number in a base-`b` system, where `b` is the size of the alphabet. The hash of a string `$S$` of length `$m$` is:
`$h(S) = (S[0] * b^(m-1) + S[1] * b^(m-2) + ... + S[m-1] * b^0) mod q$`
where `$q$` is a large prime number to keep the values manageable.

To compute the hash of the next substring, we can subtract the term for the first character and add the term for the new last character in `$O(1)$` time.
If `$h_i$` is the hash of `$T[i..i+m-1]$`, then `$h_(i+1)$` can be computed as:
`$h_(i+1) = ((h_i - T[i] * b^(m-1)) * b + T[i+m]) mod q$`

== The Algorithm

1. *Initialization:*
  - Choose a suitable base `$b$` (e.g., the alphabet size) and a prime `$q$`.
  - Pre-calculate `$b^(m-1) mod q$`.
  - Compute the hash of the pattern `$P$` and the first `$m` characters of the text `$T$`.

2. *Searching:*
  - Slide a window of size `$m$` over the text.
  - For each window, compare the hash of the window with the hash of the pattern.
  - If the hashes match, perform a full comparison of the window and the pattern.
  - If they match, report an occurrence.
  - Compute the hash for the next window using the rolling hash formula.

== Complexity

- *Time Complexity:*
  - *Worst case:* `$O(m * (n-m+1))$`. This happens if the hash values match for every substring, leading to a full comparison at every step (e.g., a text of all 'a's and a pattern of 'a's).
  - *Average case:* `$O(n+m)$`. With a good hash function, collisions are rare.

- *Space Complexity:* `$O(1)` (excluding the storage for text and pattern).

== Tasks

1. If you are searching for a pattern of length 3 in a text, and the hash of `$T[0..2]$` is `H`. How do you compute the hash of `$T[1..3]$` in `$O(1)$` time?
2. What is a "spurious hit" in the context of the Rabin-Karp algorithm?
3. Why is the choice of the prime number `$q$` important?

#pagebreak()

== Solutions

=== Task 1: Computing the Next Hash

Let the hash of `$T[0..2]$` be `$H = (T[0]*b^2 + T[1]*b^1 + T[2]*b^0) mod q$`.
To compute the hash of `$T[1..3]$`, we first remove the contribution of `$T[0]$`:
`$H' = H - T[0]*b^2$`
Then, we shift the remaining part to the left (multiply by `$b$`) and add the new character `$T[3]$`:
`$H_new = (H' * b + T[3]) mod q = ((H - T[0]*b^2) * b + T[3]) mod q$`
The term `$b^2$` can be pre-calculated. This update step takes `$O(1)$` time.

=== Task 2: Spurious Hit

A "spurious hit" (or hash collision) occurs when the hash value of a text substring matches the hash value of the pattern, but the substring itself is different from the pattern.
`$hash(substring) = hash(pattern)$` but `$substring != pattern$`.
Because hash functions map a large space of strings to a smaller space of numbers, collisions are possible. To handle this, the Rabin-Karp algorithm must perform a character-by-character comparison whenever the hash values match to confirm a true occurrence.

=== Task 3: Importance of the Prime `q`

The choice of the prime number `$q$` is important for two reasons:
1. *Minimizing Collisions*: A larger `$q$` reduces the probability of hash collisions. If `$q$` is too small, many different strings will map to the same hash value, leading to frequent spurious hits and degrading the algorithm's performance towards the worst-case scenario.
2. *Avoiding Overflow*: The value of `$q$` should be chosen such that intermediate calculations (like `$T[i] * b^(m-1)$`) do not overflow the standard integer types of the programming language. Often, `$q$` is chosen to be a large prime that fits within a machine word.
