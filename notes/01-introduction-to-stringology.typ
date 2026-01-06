#import "../definitions.typ": *

= Introduction to Stringology

== Basic Concepts

#info_box(title: "Fundamental Definitions")[
  - *Alphabet* ($Sigma$): A finite, non-empty set of symbols called characters or letters.
    - An alphabet is *ordered* if its elements have a defined linear order (e.g., a < b < c).
    - An alphabet is *indexed* if it is mapped to a range of integers, e.g., $Sigma = {0, 1, ..., |Sigma|-1}$.
  - *String* (or *Word*): A finite sequence of characters from an alphabet $Sigma$.
  - *Empty String* ($epsilon$): The unique string of length zero.
  - *Length* ($|alpha|$): The number of characters in a string $alpha$.
  - $Sigma^*$: The set of all possible strings over the alphabet $Sigma$, including the empty string.
  - $Sigma^+$: The set of all non-empty strings, i.e., $Sigma^* backslash {epsilon}$.
]

#example_box(title: "Examples of Alphabets")[
  - *Binary*: $Sigma = {0, 1}$
  - *DNA*: $Sigma = {C, G, A, T}$ (Cytosine, Guanine, Adenine, Thymine)
  - *Natural Language*: $Sigma = {A, B, ..., Z, a, b, ..., z, ., ;, ...}$
]

== String Representation and Ordering

#info_box(title: "Notation")[
  A string $alpha$ of length $n$ can be treated as a 0-indexed array:
  - $alpha = alpha[0] alpha[1] ... alpha[n-1]$
  - A substring can be denoted as $alpha[i..j] = alpha[i]alpha[i+1]...alpha[j]$.

  We also use Python-like slice notation:
  - $alpha[i:j] = alpha[i..j-1]$
  - $alpha[:k] = alpha[0..k-1]$ (a prefix of length $k$)
  - $alpha[k:] = alpha[k..n-1]$ (a suffix starting at index $k$)
  - $alpha[-k:] = alpha[n-k..n-1]$ (a suffix of length $k$)
]

#info_box(title: "Lexicographical Order")[
  Two strings $alpha$ and $beta$ are *equal* ($alpha = beta$) if they have the same length and identical characters at every position.

  For an ordered alphabet, the lexicographical order ($alpha < beta$) is defined if:
  - $alpha$ is a proper prefix of $beta$ (e.g., `"ada" < "adam"`), or
  - For some index $k$, the prefixes up to $k-1$ are identical, but $alpha[k] < beta[k]$ (e.g., `"adam" < "alan"` because `'d' < 'l'`).
]

== Substructures of Strings

#info_box(title: "Concatenation, Substring, Prefix, and Suffix")[
  - *Concatenation*: Joining two strings $alpha$ and $beta$ to form a new string $alpha beta$.
  - *Substring*: $beta$ is a substring of $alpha$ if $alpha = gamma beta delta$ for some strings $gamma, delta$. We say $beta$ occurs at position $|gamma|$. A non-empty substring is also called a *factor*.
  - *Prefix*: $beta$ is a prefix of $alpha$ if $alpha = beta gamma$ for some string $gamma$.
  - *Suffix*: $beta$ is a suffix of $alpha$ if $alpha = gamma beta$ for some string $gamma$.
  - A *proper* prefix, suffix, or substring is one that is not equal to the original string.
]

#example_box(title: "Example: Prefixes and Suffixes")[
  The string `abaaba` has:
  - Prefixes: $epsilon$, `a`, `ab`, `aba`, `abaa`, `abaab`, `abaaba`.
  - Suffixes: $epsilon$, `a`, `ba`, `aba`, `aaba`, `baaba`, `abaaba`.
]

== Borders and Periodicity

#info_box(title: "String Border")[
  A *border* of a non-empty string $alpha$ is any proper prefix of $alpha$ that is also a suffix of $alpha$.
]

#example_box(title: "Example: Borders of 'abaabaab'")[
  - `ab`: `ab`aaba`ab`
  - `abaab`: `abaab`a`abaab`
  The longest border is `abaab`.
]

#info_box(title: "Periodicity from Borders")[
  *Observation:* If a string $alpha$ of length $n$ has a border of length $b > 0$, then it has a *period* $p = n - b$.
  This means that for all $i$ from $0$ to $n-p-1$, we have $alpha[i] = alpha[i+p]$.
]

This observation is fundamental and is sometimes called the *Periodicity Lemma*. It connects the concept of borders to the repetitive nature of a string.

#info_box(title: "Powers and Generators")[
  - *Factorization*: A string $alpha$ can be decomposed into factors, e.g., $alpha = beta_1 beta_2 ... beta_k$. If all factors are the same ($beta$), we write $alpha = beta^k$.
  - *Extended Power Notation*: If a string $alpha$ has a period $p$, its shortest generator is $gamma = alpha[:p]$ and its exponent is $r = n/p$. We can write $alpha = gamma^r$. For example, $"abaabaa" = ("aba")("aba")a = ("aba")^2 a = ("aba")^(2 + 1/3) = ("aba")^(7/3)$.
  - *Period, Generator, Exponent*:
    - *Period*: A number $p$ such that $alpha[i] = alpha[i+p]$ for all valid $i$.
    - *Generator*: A string $gamma$ such that $alpha$ is a power of $gamma$.
    - *Exponent*: The number $r$ such that $alpha = gamma^r$.
  - *Normal Form*: The decomposition $alpha = gamma^(r^\*)$ where $p^*$ is the *minimum* period of $alpha$, $gamma = alpha[:p^*]$, and $r^* = n/p^*$.
]

#info_box(title: "String Classification")[
  Based on the normal form exponent $r^*$:
  - *Primitive*: $r^* = 1$. The string is not a repetition of a smaller string.
  - *Periodic*: $r^* > 1$.
    - *Weakly Periodic*: $1 < r^* < 2$.
    - *Strongly Periodic*: $r^* >= 2$.
  - *Repetition*: $r^* >= 2$ and is an integer.
]

#example_box(title: "Examples of Classification")[
  - `aaabaabab`: Primitive ($r^*=1$)
  - `abaabaab`: Weakly periodic ($p^*=3$, $gamma=$`aba`, $r^*=8/3$)
  - `abababab`: A repetition ($p^*=2$, $gamma=$`ab`, $r^*=4$)
]


#pagebreak()
== Border Array

The *border array* $b$ for a string $alpha$ of length $n$ is an array of size $n+1$ that stores the length of the longest border for each prefix of $alpha$.

#info_box(title: "Border Array Definition")[
  - $b[0] = -1$ (a sentinel value for convenience in algorithms).
  - For $i > 0$, $b[i]$ = the length of the longest border of the prefix $alpha[:i]$ (i.e., $alpha[0..i-1]$).
]

#example_box(title: "Example: Border Array for 'abaabaab'")[
  #table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
    align: center,
    [*i*], [0], [1], [2], [3], [4], [5], [6], [7], [8],
    [*$alpha[i-1]$*], [], [a], [b], [a], [a], [b], [a], [a], [b],
    [*$b[i]$*], [-1], [0], [0], [1], [1], [2], [3], [2], [3],
  )
  The prefix $alpha[:6]$ is `abaaba`, its longest border is `aba` (length 3), so $b[6]=3$.
]

=== Computing the Border Array

A trivial algorithm that re-scans prefixes to find borders for each position takes quadratic time. A linear-time algorithm, `Algorithm BA`, can be constructed using the properties of borders.

#info_box(title: "Key Lemma for Border Array Construction")[
  1. If $gamma$ is a border of $beta$, and $beta$ is a border of $alpha$, then $gamma$ is a border of $alpha$.
  2. This implies that all borders of a prefix can be found by following the chain of longest borders. The second-longest border of $alpha[:i]$ is the longest border of the longest border of $alpha[:i]$, i.e., $b[b[i]]$.
]

The algorithm computes $b[i+1]$ based on the already computed values $b[0...i]$. It tries to extend the longest border of the previous prefix, $alpha[:i]$.

#code_box([
  #smallcaps([Algorithm BA (Border Array)]) ($alpha$, $n$)
  ```
  b = array of size n+1
  b[0] = -1
  for i from 0 to n-1:
    border_len = b[i]
    while border_len >= 0 and alpha[i] != alpha[border_len]:
      border_len = b[border_len]
    b[i+1] = border_len + 1
  return b
  ```
])

#info_box(title: "Complexity of Algorithm BA")[
  The algorithm runs in *$O(n)$ time* and *$O(n)$ space*.

  *Proof of Time Complexity:* The `for` loop runs $n$ times. The work is in the `while` loop. Let's count the total number of `while` loop iterations. The $"border_len"$ variable is decreased inside the `while` loop ($"border_len" = b["border_len"]$). It is only ever increased by 1 in the `for` loop ($b[i+1] = "border_len" + 1$). Since it starts at -1 and can't go below that, the total number of decrements (while loop executions) cannot exceed the total number of increments, which is at most $n$. Therefore, the total time complexity is linear.
]

#pagebreak()

== Tasks

=== Task 1
What is the result of $(("ab")^(3/2))^2$?

=== Task 2
We have shown that if a non-empty string $alpha$ of length $n$ has a border of length $b$, then it has a period $p = n - b$. Can this statement be reversed? (i.e., If $alpha$ has a period $p$, does it necessarily have a border of length $b=n-p$?)

=== Task 3
Prove or disprove: Every border of a palindrome is itself a palindrome.

#pagebreak()
== Solutions

=== Solution 1
- $("ab")^{3/2}$: The generator is `ab` (length 2). The exponent is 3/2. Length is $2 dot 3/2 = 3$. This is the generator `ab` plus its first character `a`. Result: `aba`.
- $("aba")^2$: The generator is `aba`. The exponent is 2. Result: `abaaba`.
- So, $(("ab")^(3/2))^2 = ("aba")^2 = "abaaba"$.

=== Solution 2
Yes, the implication can be reversed for $p < n$.

*Proof:*
If a string $alpha$ of length $n$ has a period $p$, it means $alpha[i] = alpha[i+p]$ for all $i$ from $0$ to $n-p-1$.
We want to show it has a border of length $b = n-p$. A border is a prefix of length $b$ that equals a suffix of length $b$.
- The prefix of length $b$ is $alpha[0..b-1]$.
- The suffix of length $b$ is $alpha[n-b..n-1]$. Since $p=n-b$, the suffix is $alpha[p..n-1]$.

We need to show that $alpha[i] = alpha[i+p]$ for all $i \in [0, b-1]$.
The definition of periodicity states this is true for $i \in [0, n-p-1]$.
Since $b = n-p$, the required range $[0, b-1]$ is identical to the range $[0, n-p-1]$.
Therefore, the prefix of length $b$ equals the suffix of length $b$, and it is a border.

=== Solution 3
The statement is true.

*Proof:*
Let $alpha$ be a palindrome and let $beta$ be a border of $alpha$.
1. Since $beta$ is a prefix of $alpha$, $alpha = beta delta$ for some string $delta$.
2. Since $beta$ is a suffix of $alpha$, $alpha = gamma beta$ for some string $gamma$.
3. Since $alpha$ is a palindrome, $alpha = alpha^R$, where `R` is the reversal operation.
4. From (1), $alpha^R = delta^R beta^R$.
5. From (2), $alpha = gamma beta$.
6. So, $gamma beta = delta^R beta^R$. This implies that $gamma = delta^R$.
7. Now let's use the prefix property again: $alpha = beta delta$. $alpha^R = delta^R beta^R$.
8. Since $alpha$ is a palindrome, $alpha = alpha^R$, so $beta delta = delta^R beta^R$.
9. Also, since $beta$ is a suffix of $alpha$, $beta = gamma^R$.
10. The prefix of $alpha$ of length $|beta|$ is $beta$. The suffix of $alpha$ of length $|beta|$ is $beta^R$ because $alpha$ is a palindrome.
11. Since $beta$ is a border, this prefix must equal this suffix. So, $beta = beta^R$.
12. A string that equals its own reversal is, by definition, a palindrome.

Therefore, $beta$ is a palindrome.
