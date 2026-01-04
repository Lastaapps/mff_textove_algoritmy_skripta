#import "../definitions.typ": *

= Suffix Array Construction

== Introduction

Constructing a suffix array naively by sorting all suffixes of a text $T$ of length $n$ can be slow, with a complexity of $O(n^2 log n)$ or $O(n log^2 n)$ using standard comparison-based sorting. More advanced algorithms can achieve $O(n log n)$ or even $O(n)$ time.

One of the most famous linear time algorithms is the *DC3 (Difference Cover) algorithm*, also known as the *Kärkkäinen-Sanders algorithm*, introduced in 2003. This algorithm uses a divide and conquer approach.

== DC3 (Kärkkäinen-Sanders / Skew) Algorithm

DC3 is discussed in Data Structures lecture recording by #link("https://mj.ucw.cz/vyuka/2324/ds1/")[Martin Mareš, 20th December 2023, 45:00].

The algorithm consists of three main steps:

=== Step 1: Sort Suffixes for $i mod 3 != 0$

1. Consider suffixes starting at indices $i$ where $i mod 3 = 1$ or $i mod 3 = 2$.
2. For each such suffix, create a triplet of characters $(T[i], T[i+1], T[i+2])$.
3. Sort these triplets using a stable sorting algorithm like radix sort. This gives a relative order of these suffixes.
4. If all triplets are unique, this gives the final sorted order of these suffixes. If there are duplicates, a recursive call is needed.
5. A new string is formed from the ranks of the triplets, and the algorithm is called recursively on this new string to sort the suffixes.

=== Step 2: Sort Suffixes for $i mod 3 = 0$

1. The suffixes starting at indices $i$ where $i mod 3 = 0$ are sorted based on the first character $T[i]$ and the rank of the suffix starting at $i+1$.
2. The rank of the suffix starting at $i+1$ is already known from Step 1, as $(i+1) mod 3 = 1$.
3. A stable sort (like radix sort) on these pairs $(T[i], "ISA"[i+1])$ gives the sorted order of the suffixes at $i mod 3 = 0$.

=== Step 3: Merge the Two Sorted Lists

1. The two sorted lists of suffixes (from Step 1 and Step 2) are merged into a single sorted list.
2. The merge operation compares suffixes from each list. To compare a suffix $T_i$ from the $i mod 3 = 0$ group and $T_j$ from the $i mod 3 != 0$ group, we use the ranks already computed.
3. The comparison can be done in constant time by looking up pre-computed ranks.

The overall time complexity of the DC3 algorithm is $O(n)$.

== Tasks

=== Task 1
For the text $T = "yabbadabbado"$, what are the suffixes at positions $i mod 3 != 0$?

=== Task 2
In the DC3 algorithm, how are the suffixes at positions $i mod 3 = 0$ sorted?

=== Task 3
Why is the recursive call in the DC3 algorithm on a string of length $2n/3$?

#pagebreak()

== Solutions

=== Solution 1
For $T = "yabbadabbado"$, length $n=12$.
The positions $i$ where $i mod 3 != 0$ are 1, 2, 4, 5, 7, 8, 10, 11.
The suffixes are:
- $i=1$: $"abbadabbado"$
- $i=2$: $"bbadabbado"$
- $i=4$: $"adabbado"$
- $i=5$: $"dabbado"$
- $i=7$: $"abbado"$
- $i=8$: $"bbado"$
- $i=10$: $"do"$
- $i=11$: $"o"$

=== Solution 2
The suffixes at positions $i mod 3 = 0$ are sorted based on pairs of values: $(T[i], "ISA"[i+1])$.
- $T[i]$ is the first character of the suffix.
- $"ISA"[i+1]$ is the lexicographical rank of the suffix starting at $i+1$. Since $(i+1) mod 3 = 1$, this rank is known from the first step of the algorithm (the sorting of suffixes at positions not divisible by 3).
A stable sorting algorithm, such as radix sort, is used to sort these pairs, which gives the sorted order of the $i mod 3 = 0$ suffixes.

=== Solution 3
The recursive call in the DC3 algorithm is made on a string that represents the ranks of the suffixes at positions $i mod 3 != 0$.
- The number of such suffixes is approximately $2/3$ of the total number of suffixes, so the length of this new string is $2n/3$.
- The algorithm's recurrence relation is $T(n) = T(2n/3) + O(n)$, which solves to $T(n) = O(n)$. This is why the algorithm achieves linear time complexity.

#pagebreak()
