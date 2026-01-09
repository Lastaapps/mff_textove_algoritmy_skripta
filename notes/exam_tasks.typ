#import "../definitions.typ": *

/* The source generation prompt
  Read all the lecture notes files (not the slides). After that, generate the exam tasks section.
  First, on the first page, summarize what is the approach of the teacher to the exam, what can a student expect. Than, solve each task on a single page as a section. Use the notation used in lecture notes, no
  term that is not already defined can be used. Stick strictly to the lecture notes. Before starting, real all the notes in context first!!!

  There are the questions from exams. Always, first state the problem, then solve it (on the same page) in English.

  - Nalézt opakující se podslovo slova x v suffixovém stromě.
  - Kódovat slovo pomocí suffixového pole
  - Konstrukce DAWG / CDAWG na slovo cocoa (jak se konstruují, jaká je prostorová složitost, porovnání se suffix stromem)
  - Problém nejdelší společné podposloupnosti - najít rozumný algoritmus
  - Problém palindromu
  - Normální forma - jak jde nalézt normální formu, časová a prostorová složitost.
  - LCF vs LCS - porovnejte časové složitosti a vysvětlete.
  - Popište nějakou metodu na matchování ? a * symbolů.
  - Prostorová složitost suffixového stromu a suffixové trie.
  - Nalezení všech dvojic i, j takových že existuje k>=0 t.ž. [i..i+k]=[j..j+k].
  - Sestrojit automat pro regulární výraz ((ab)|(c)) nad abecedou {a,b,c}.
  - Popište efektivní algoritmus na sestavení sufixového pole. Odvoďte jeho časovou složitost. (slide 23-42)
  - Popište algoritmus na vytváření NFA z regulárního výrazu. Popište jeho časovou a prostorovou složitost. (slide 8-18)
  - Určování vzdálenosti mezi slovy pomocí dynamického programování. Rekurentní vztah a časová + prostorová složitost.
  - Sufixový strom: efektivní konstrukce
  - Bitový paralelismus: vybrat si problém a vyřešit ho pomocí bitových operací + pseudokód
  - Konečná množina vzorků - časová složitost
  - Rekurentní vztah u algoritmu pro vzdálenost dvou slov
  - Aho-Corasick, napsat definici Fail funkce, popsat, k čemu slouží, napsat algoritmus pro efektivní konstrukci a jak dlouho bude trvat
  - využití sufixového pole pro pattern matching - popsat pomocí pseudokódu
  - Ukkonen-Meyers - hlavní myšlenka
  - Asymptotickou složitost časovou a prostorovou pro nalezení všech výskytů vzoru v textu.
  - Jak se využívá suffix array pro nalezení všech výskytů vzoru v textu?
  - prostorová složitost (včetně odůvodnění) - sufixový trie, strom, pole, CDAWG (+ FM index)
  - myšlenka Longest Common Subsequence (LCS)
*/

= Exam Tasks

#info_box(title: "Disclaimer")[
  This chapter was generated using AI and was not yet human reviewed.
  Expect *more errors/mistakes/differences* than in the rest of the text
  until someone finds some time to human review this.

  For the original questions, see `./exam_task_raw.md`.
  The tasks are usually quite easy and repetitive, so this chapter may not be needed at all.
]

This chapter contains a selection of tasks that have appeared in exams for the Text Algorithms course. Each task includes a problem statement, a proposed solution, and notes on what the examiner might focus on.

#pagebreak()

== Task: Suffix Trie and Suffix Tree Space Complexity

*Problem Statement*

Explain and justify the space complexity of a Suffix Trie and a Suffix Tree for a string of length $n$.

*Solution*

#info_box(title: "Suffix Trie")[
  A Suffix Trie is a trie containing all suffixes of a string.

  - *Space Complexity:* $O(n^2)$ in the worst case.

  - *Justification:*
    In a suffix trie, each edge represents a single character. A new node is created for each character of each suffix that does not already exist as a path.
    Consider the worst-case string, such as $"a^n"$ or $"abc...xyz"$.
    For the string $"a^n"$, the suffixes are $"a^n", "a^(n-1)", ..., "a"$. The trie will have a linear chain of $n$ nodes for the first suffix. The second suffix will share the first $n-1$ nodes, and so on. The total number of nodes will be $1+2+...+n = O(n^2)$.
    For a string with all unique characters like $"abc"$, the suffixes are $"abc", "bc", "c"$. The trie will have separate paths for each, leading to $O(n^2)$ nodes.
]

#info_box(title: "Suffix Tree")[
  A Suffix Tree is a compressed suffix trie, where chains of single-child nodes are compressed into a single edge labeled with a substring.

  - *Space Complexity:* $O(n)$ in the worst case.

  - *Justification:*
    The linear space complexity is achieved through two key properties:
    1. *Number of Nodes:* A suffix tree for a string of length $n$ (with a unique terminator) has at most $2n+1$ nodes. This is because it has $n+1$ leaves (one for each suffix), and in a tree where every internal node has at least two children, the number of internal nodes is at most one less than the number of leaves. Total nodes approx $n + (n+1) = 2n+1$.
    2. *Edge Label Representation:* The labels on the edges are not stored explicitly. Instead, they are represented by a pair of indices `(start, end)` pointing to a substring in the original text. This means each edge label requires only $O(1)$ space (assuming indices fit in a machine word).

    Therefore, the total space is the sum of space for nodes and edges, which is proportional to $n$. This is a significant improvement over the quadratic complexity of the suffix trie.
]

#pagebreak()

== Task: Finding a Repeating Substring in a Suffix Tree

*Problem Statement*

Describe how to find a repeating substring in a word $x$ using a suffix tree. How would you find the *longest* repeating substring?

*Solution*

#info_box(title: "Finding Repeating Substrings")[
  A suffix tree for a string $x$ contains all suffixes of $x$. A substring of $x$ is a prefix of some suffix of $x$.

  - Any substring that is repeated in $x$ will be represented by an *internal node* in the suffix tree.
  - An internal node, by definition, has more than one child. This means the path from the root to this node is a prefix of at least two different suffixes. If a string is a prefix of two different suffixes, it must occur at least twice in the original string.
  - The leaves in the subtree of an internal node tell you the starting positions of the occurrences of the substring represented by that internal node.

  Therefore, to find all repeating substrings, one can traverse the suffix tree and report the string path for every internal node.
]

#info_box(title: "Finding the Longest Repeating Substring")[
  The longest repeating substring corresponds to the *deepest* internal node in the suffix tree. The "depth" of a node here refers to its *string-depth*, which is the length of the string path from the root to that node.

  *Algorithm:*
  1. Construct the suffix tree for the string $x$.
  2. Perform a traversal (like DFS) of the suffix tree.
  3. For each internal node visited, calculate its string-depth.
  4. Keep track of the internal node with the maximum string-depth found so far.
  5. After the traversal is complete, the path from the root to the deepest internal node found spells out the longest repeating substring.

  The time complexity of this process is dominated by the construction of the suffix tree, which is $O(n)$. The traversal is also $O(n)$.
]

#pagebreak()

== Task: Efficient Suffix Array Construction

*Problem Statement*

Describe an efficient algorithm for constructing a suffix array and derive its time complexity.

*Solution*

An efficient method for suffix array construction is the *DC3 (Difference Cover) algorithm*, also known as the Kärkkäinen-Sanders algorithm. It achieves linear time complexity.

#info_box(title: "DC3 Algorithm Overview")[
  The algorithm uses a divide-and-conquer strategy based on the indices of the suffixes modulo 3.

  *Step 1: Sort Suffixes at Indices $i mod 3 != 0$*
  1. Group suffixes starting at indices $i$ where $i mod 3 = 1$ and $i mod 3 = 2$.
  2. For each such suffix, form a triplet of characters $(T[i], T[i+1], T[i+2])$.
  3. Sort these triplets using a linear-time sorting algorithm like Radix Sort.
  4. If all triplets are unique, this gives the relative order of these suffixes. If not, a recursive step is needed. A new string is formed from the ranks of the triplets, and the DC3 algorithm is called recursively on this new string (which is $2/3$ the original size).
  5. From the sorted ranks, the Suffix Array ($"SA"_12$) and Inverse Suffix Array ($"ISA"_12$) for these suffixes are constructed.

  *Step 2: Sort Suffixes at Indices $i mod 3 = 0$*
  1. The suffixes starting at indices $i$ where $i mod 3 = 0$ are sorted based on a pair of values: $(T[i], "ISA"[i+1])$.
  2. The rank of the suffix at $i+1$ (i.e., $"ISA"[i+1]$) is already known from Step 1, since $(i+1) mod 3 = 1$.
  3. These pairs are sorted using Radix Sort. This gives the Suffix Array ($"SA"_0$) for these suffixes.

  *Step 3: Merge*
  1. The two sorted suffix arrays, $"SA"_12$ and $"SA"_0$, are merged into the final suffix array $"SA"$.
  2. The merge step compares a suffix from $"SA"_0$ with a suffix from $"SA"_12$. This comparison can be done in $O(1)$ time by using the pre-computed rank information from the $"ISA"_12$ array.

  *Time Complexity:*
  The recurrence relation for the algorithm is $T(n) = T(2n/3) + O(n)$. The $O(n)$ term comes from the radix sorts and the merge step, which are all linear. This recurrence solves to $T(n) = O(n)$.
]

#pagebreak()

== Task: Pattern Matching with a Suffix Array

*Problem Statement*

Describe how a suffix array can be used to find all occurrences of a pattern $P$ in a text $T$. Provide pseudocode for a simple version of the search.

*Solution*

A suffix array `SA` for a text `T` stores the starting indices of all suffixes of `T` in lexicographical order. This property allows for efficient pattern matching using binary search. All occurrences of a pattern `P` will form a contiguous block in the suffix array.

#info_box(title: "Algorithm using Binary Search")[
  The goal is to find the range $[L, R]$ in the suffix array such that for all $i$ in $[L, R]$, the suffix $T["SA"[i]:]$ starts with the pattern $P$.

  1. *Find Left Boundary:* Perform a binary search on the suffix array to find the first (leftmost) suffix that starts with or is greater than $P$.
  2. *Find Right Boundary:* Perform another binary search to find the last (rightmost) suffix that starts with $P$.
  3. *Report Occurrences:* All indices in the suffix array between the left and right boundaries correspond to occurrences of the pattern. The starting positions in the text are given by $"SA"[i]$ for $i$ in the found range.

  The comparison in each step of the binary search takes $O(m)$ time, where $m$ is the pattern length. This leads to an overall complexity of $O(m log n)$. With LCP array optimizations, this can be improved to $O(m + log n)$.
]

#code_box[
  #smallcaps([SA-Find-First]) ($P$, $T$, $"SA"$)
  ```
  low = 0, high = n-1
  first_occurrence = -1

  while low <= high:
    mid = floor((low + high) / 2)
    suffix_start = SA[mid]

    // Compare P with the suffix T[suffix_start : suffix_start + m]
    comparison = compare(P, T[suffix_start : suffix_start + m])

    if comparison == 0: // Match
      first_occurrence = mid
      high = mid - 1 // Try to find an earlier one
    elif comparison < 0: // P is smaller
      high = mid - 1
    else: // P is larger
      low = mid + 1

  return first_occurrence
  ```
  A similar function `SA-Find-Last` would be used to find the right boundary, by continuing the search in the other direction (`low = mid + 1`) upon finding a match.
]

#pagebreak()

== Task: Encoding a Word with a Suffix Array (BWT)

*Problem Statement*

Explain how to "encode" a word using a suffix array.

*Solution*

This task usually refers to computing the *Burrows-Wheeler Transform (BWT)*, a reversible permutation of a string that is fundamental to the FM-Index and compression algorithms like `bzip2`. The suffix array is key to this process.

#info_box(title: "Burrows-Wheeler Transform (BWT)")[
  The BWT of a string $T$ is constructed as follows:
  1. Append a unique end-of-string character, `$`, which is lexicographically smaller than any other character in $T$.
  2. Generate the suffix array `SA` for this new string $T\$$.
    3. The BWT string is constructed by taking the character *preceding* each suffix in the sorted order.
    The formula for the BWT string `L` is:$L[i] = (T\$)["SA"[i] - 1]$ If $"SA"[i] = 0$, the preceding character is the last character of the string, which is `$`.
]

#example_box(title: "Example: BWT of 'banana'")[
  Let $T = "banana"$. With the terminator, $T' = "banana\$"$.

  1. *Sorted Suffixes and SA:*
    - `$` (from index 6) -> SA[0]=6
    - `a$` (from index 5) -> SA[1]=5
      - `ana$` (from index 3) -> SA[2]=3
    - `anana$` (from index 1) -> SA[3]=1
      - `banana$` (from index 0) -> SA[4]=0
    - `na$` (from index 4) -> SA[5]=4
      - `nana$` (from index 2) -> SA[6]=2
    So, `SA = (6, 5, 3, 1, 0, 4, 2)`.
    2. *Construct BWT string L:*
    - $L[0] = T'["SA"[0]-1] = T'[5] = 'a'$
    - $L[1] = T'["SA"[1]-1] = T'[4] = 'n'$
    - $L[2] = T'["SA"[2]-1] = T'[2] = 'n'$
    - $L[3] = T'["SA"[3]-1] = T'[0] = 'b'$
    - $L[4] = T'["SA"[4]-1] = T'[ -1 -> 6] = '\$'$
    - $L[5] = T'["SA"[5]-1] = T'[3] = 'a'$
    - $L[6] = T'["SA"[6]-1] = T'[1] = 'a'$

  The BWT of "banana" is `"annb$aa"`.
]
This transformed string has the property that characters that occur in similar contexts in the original string are grouped together, making it highly compressible.

#pagebreak()

== Task: NFA from a Regular Expression

*Problem Statement*

Describe an algorithm to create a Nondeterministic Finite Automaton (NFA) from a regular expression. What is its time and space complexity?

*Solution*

*Thompson's Construction* is a classic algorithm for converting a regular expression into an equivalent NFA. The algorithm is compositional, building the NFA for a complex expression from the NFAs of its subexpressions.

#info_box(title: "Thompson's Construction Rules")[
  The construction defines how to create an NFA for each type of regular expression operator:
  - *Base Case (character `a`):* An NFA with a start state and a final state, connected by a single transition on character `a`.
  - *Concatenation ($v_1 v_2$):* The NFA for $v_1$ is connected to the NFA for $v_2$. The final state of NFA($v_1$) becomes non-final and is connected via an $epsilon$-transition to the start state of NFA($v_2$). The new automaton's start state is the start of NFA($v_1$) and its final state is the final state of NFA($v_2$).
  - *Union ($v_1 | v_2$):* A new start state is created with $epsilon$-transitions to the start states of both NFA($v_1$) and NFA($v_2$). A new final state is created, and the final states of NFA($v_1$) and NFA($v_2$) are connected to it via $epsilon$-transitions.
  - *Kleene Star ($v^*$):* A new start state (which is also a final state to accept the empty string) has an $epsilon$-transition to the start state of NFA($v$). The final state of NFA($v$) has $epsilon$-transitions back to its own start state (for repetitions) and to the new final state.

  The resulting NFA has exactly one start state and one final state.
]

#info_box(title: "Complexity Analysis")[
  Let the size of the regular expression be $m$ (number of characters and operators).

  - *Time Complexity:* $O(m)$.
    The algorithm processes each character and operator of the parsed regular expression exactly once. Each step (creating states and transitions) takes constant time. Therefore, the construction is linear in the size of the expression.

  - *Space Complexity:* $O(m)$.
    The number of states and transitions in the resulting NFA is proportional to the size of the regular expression. Specifically, for a regex of size $m$, Thompson's construction creates at most $2m$ states and $4m$ transitions.
]

#pagebreak()

== Task: Construct an NFA for `((ab)|(c))`

*Problem Statement*

Construct the NFA for the regular expression `((ab)|(c))` over the alphabet {a, b, c} using Thompson's construction.

*Solution*

We build the NFA step-by-step:

1. *NFA for `a` and `b`:* Create two simple NFAs, one for `a` and one for `b`.
  - NFA(a): (s1) --a--> (f1)
  - NFA(b): (s2) --b--> (f2)

2. *NFA for `ab` (Concatenation):* Connect NFA(a) and NFA(b).
  - The final state `f1` is connected to the start state `s2` with an $epsilon$-transition.
  - The resulting NFA has start state `s1` and final state `f2`.
  - (s1) --a--> (f1) --$epsilon$--> (s2) --b--> (f2)

3. *NFA for `c`:* Create a simple NFA for `c`.
  - NFA(c): (s3) --c--> (f3)

4. *NFA for `(ab)|(c)` (Union):* Combine NFA(ab) and NFA(c).
  - Create a new start state `S_start` and a new final state `F_final`.
  - Add $epsilon$-transitions from `S_start` to the start states of NFA(ab) (i.e., `s1`) and NFA(c) (i.e., `s3`).
  - Add $epsilon$-transitions from the final states of NFA(ab) (`f2`) and NFA(c) (`f3`) to the new final state `F_final`.

The final structure would look like this (textually):

```
          /--eps--> (s1) --a--> (f1) --eps--> (s2) --b--> (f2) --eps--\
(S_start)                                                              (F_final)
          \--eps--> (s3) --c--> (f3) ---------------------------------/
```
This NFA correctly accepts either the sequence "ab" or the character "c".

#pagebreak()

== Task: Aho-Corasick Algorithm

*Problem Statement*

For the Aho-Corasick algorithm, define the *Fail Function*, describe its purpose, and outline the algorithm for its efficient construction and its time complexity. This algorithm is used for finding all occurrences of a finite set of patterns.

*Solution*

#info_box(title: "Aho-Corasick Algorithm")[
  The Aho-Corasick algorithm is used for finding all occurrences of a set of patterns (a dictionary) in a text. Its time complexity is linear in the length of the text plus the total number of matches, after a preprocessing step that is linear in the total length of all patterns.

  - *Preprocessing Time:* $O(M)$, where $M$ is the total length of all patterns.
  - *Search Time:* $O(N + z)$, where $N$ is the text length and $z$ is the number of matches.
]

#info_box(title: "The Fail Function (f)")[
  - *Definition:* The Aho-Corasick automaton is built on a trie of all patterns. For each state `u` in the trie, the fail function `f(u)` points to another state `w`. This state `w` represents the longest proper suffix of the string corresponding to state `u` that is also a prefix of some pattern in the dictionary.

  - *Purpose:* The fail function is the key to the algorithm's efficiency. When a mismatch occurs during the text scan (i.e., from the current state `u`, there is no transition for the current text character `c`), the automaton does not backtrack in the text. Instead, it follows the fail link from `u` to `f(u)` and attempts the transition on `c` from there. This is repeated until a transition is found or the root is reached. This process is analogous to the failure function in the KMP algorithm, but generalized for a set of patterns.
]

#info_box(title: "Efficient Construction of Fail Links")[
  The fail links are computed efficiently using a Breadth-First Search (BFS) on the states of the pattern trie.

  *Algorithm:*
  1. Initialize a queue for the BFS and add the root node to it. The fail link of the root points to itself or a special nil node.
  2. While the queue is not empty, dequeue a state `u`.
  3. For each character `c` that has a transition from `u` to a child state `v`:
    a.  Let `w = f(u)` (the fail state of the parent).
    b.  *Traverse fail links:* While `w` has no transition on character `c` (and `w` is not the root), update `w = f(w)`.
    c.  If `w` now has a transition on `c` to a state `w'`, set `f(v) = w'`.
    d.  If `w` has no transition on `c` (meaning we reached the root and it also has no `c` transition), set `f(v)` to the root.
    e.  Enqueue the child state `v`.

  *Time Complexity:* This BFS-based construction processes each state and edge once. The total work done in the inner `while` loop (traversing fail links) is amortized to be linear over the whole construction. Therefore, the time complexity for computing all fail links is $O(M)$, where $M$ is the total length of all patterns in the trie.
]

#pagebreak()

== Task: Edit Distance and the Wagner-Fischer Algorithm

*Problem Statement*

Explain how to determine the distance between two words using dynamic programming. Provide the recurrence relation and analyze the time and space complexity.

*Solution*

The distance between two words, commonly the *Levenshtein distance* or *Edit Distance*, can be calculated using the Wagner-Fischer algorithm, which is a dynamic programming approach. The distance is defined as the minimum number of single-character edits (insertions, deletions, or substitutions) required to change one word into the other.

#info_box(title: "Wagner-Fischer Algorithm")[
  The algorithm constructs a matrix `D` of size $(|A|+1) x (|B|+1)$, where `A` and `B` are the two strings. The cell `D[i, j]` stores the edit distance between the prefix `A[1..i]` and `B[1..j]`.

  *Initialization:*
  - The first row is initialized with the cost of transforming an empty string into a prefix of `B`, which requires `j` insertions: `D[0, j] = j`.
  - The first column is initialized with the cost of transforming a prefix of `A` into an empty string, which requires `i` deletions: `D[i, 0] = i`.

  *Recurrence Relation:*
  For `i > 0` and `j > 0`, the value of `D[i, j]` is computed based on the three possible operations that could lead to this state:
  1. *Deletion:* Delete character `A[i]`. The cost is `D[i-1, j] + 1`.
  2. *Insertion:* Insert character `B[j]`. The cost is `D[i, j-1] + 1`.
  3. *Substitution:* Substitute `A[i]` with `B[j]`. The cost is `D[i-1, j-1] + cost_sub`, where `cost_sub` is 0 if `A[i] == B[j]` (a match) and 1 otherwise (a substitution).

  The recurrence relation is the minimum of these three values:
  $
    D[i, j] = min(D[i-1, j] + 1, D[i, j-1] + 1, D[i-1, j-1] + (A[i] == B[j] ? 0 : 1))
  $

  The final edit distance between `A` and `B` is the value in the bottom-right cell, `D[|A|, |B|]`.
]

#info_box(title: "Complexity Analysis")[
  Let $|A| = n$ and $|B| = m$.
  - *Time Complexity:* $O(n * m)$.
    The algorithm fills an $(n+1) x (m+1)$ matrix. Each cell is computed in constant time based on the values of its neighbors.

  - *Space Complexity:* $O(n * m)$.
    The straightforward implementation requires storing the entire matrix in memory. However, this can be optimized. Notice that to compute row `i`, you only need the values from the previous row `i-1`. Therefore, the space can be reduced to $O(min(n, m))$ by only storing the current and previous rows.
]

#pagebreak()

== Task: Ukkonen-Myers Algorithm

*Problem Statement*

What is the main idea behind the Ukkonen-Myers algorithm for approximate string matching?

*Solution*

The Ukkonen-Myers algorithm (often referred to as Ukkonen's algorithm for k-differences) is an optimization of the standard dynamic programming approach for edit distance. Its main idea is to avoid filling the entire $O(n * m)$ DP matrix by recognizing that the interesting values lie close to the main diagonal.

#info_box(title: "Main Idea: Bounded Search and Prospective Diagonals")[
  The key insight is the *Diagonal Property*: for any cell `D[i, j]` on an optimal path in the DP matrix, the edit distance `D[i, j]` is at least as large as the cell's distance from the main diagonal, i.e., `D[i, j] >= |i - j|`.

  This implies that if we are searching for a match with at most `k` errors, we only need to compute the cells within a band of width `2k+1` around the main diagonal. The Ukkonen-Myers algorithm formalizes this by only computing values in these "prospective diagonals".

  *The Algorithm:*
  1. The algorithm doesn't compute the entire matrix. Instead, it works in phases, where phase `d` computes all possible edit distances of `d`.
  2. It iteratively increases a "trial" distance `D` (e.g., $D = 0, 1, 2, ...$) and computes only the necessary parts of the DP matrix for that `D`.
  3. For a given `D`, it only calculates values in a limited band of diagonals around the main diagonal.
  4. The algorithm stops when it successfully computes the value for the final cell `D[n, m]` within the current trial distance `D`. This `D` is then the true edit distance.

  *Benefit:*
  Instead of an $O(n * m)$ complexity, the Ukkonen-Myers algorithm achieves a time complexity of $O(d * n)$, where `d` is the actual edit distance. This is a significant improvement when the strings are similar and the distance `d` is much smaller than `m`.
]

#pagebreak()

== Task: DAWG and CDAWG Construction and Complexity

*Problem Statement*

Explain how a DAWG (Directed Acyclic Word Graph) is constructed for a word like "cocoa". Discuss its space complexity and compare it to a Suffix Tree.

*Solution*

#info_box(title: "DAWG Construction from Equivalence Classes")[
  A DAWG is the minimal automaton that accepts all suffixes of a string. Its states correspond to equivalence classes of substrings based on their end-positions. Two substrings are equivalent if the set of their ending positions in the text is identical.

  *Construction for "cocoa":*
  Let the string be $S = "cocoa"$. We identify substrings and their end-position sets (`endpos`):
  - `endpos("a")` = {4}
  - `endpos("oa")` = {4}
  - `endpos("coa")` = {4}
  - `endpos("ocoa")` = {4}
  - `endpos("cocoa")` = {4} -> All these are in one class: *[a]*
  - `endpos("o")` = {1, 3}
  - `endpos("co")` = {1, 3} -> These are in one class: *[o]*
  - `endpos("c")` = {0, 2} -> Class *[c]*
  - `endpos("oc")` = {2} -> Class *[oc]*
  - `endpos("")` = {0, 1, 2, 3, 4} -> Class *[#sym.epsilon]* (the root)

  The states of the DAWG are {[#sym.epsilon], [c], [o], [oc], [a]}. Transitions are added based on character extensions (e.g., from [#sym.epsilon] a 'c' transition leads to [c]). The DAWG is formed by connecting these states. A Suffix Link in a DAWG connects a state for class `[ca]` to the state for class `[a]`.
]

#info_box(title: "CDAWG (Compacted DAWG)")[
  A CDAWG is created by compressing paths in the DAWG, similar to how a Suffix Tree compresses a Suffix Trie. Any state with a single incoming and single outgoing edge can be removed, and the edge labels are concatenated. For "cocoa", the DAWG is already quite small and may not have many compressible paths.
]

#info_box(title: "Space Complexity and Comparison")[
  - *DAWG:* For a string of length $n$, a DAWG has at most $2n-1$ states and $3n-4$ transitions. Its space complexity is $O(n)$.
  - *CDAWG:* Has at most $n+1$ states and $2n-2$ transitions. Space complexity is $O(n)$.
  - *Suffix Tree:* Has at most $2n+1$ states and $2n$ edges. Space complexity is $O(n)$.

  *Comparison:*
  - All three data structures (DAWG, CDAWG, Suffix Tree) have a linear space complexity, making them far more efficient than a Suffix Trie ($O(n^2)$).
  - The CDAWG is the most compact of the three in terms of the number of states and edges.
  - While Suffix Trees explicitly represent all suffixes as paths to leaves, DAWGs represent all substrings. In a DAWG, multiple substrings can map to the same state.
  - In practice, Suffix Trees are often more commonly used due to slightly simpler construction algorithms (like Ukkonen's) and direct application to problems involving suffixes (like LCP).
]

#pagebreak()

== Task: Space Complexity of String Data Structures

*Problem Statement*

Provide and justify the space complexity for the following data structures for a string of length $n$: Suffix Trie, Suffix Tree, Suffix Array, CDAWG, and FM-Index.

*Solution*

#info_box(title: "Summary of Space Complexities")[
  - *Suffix Trie:* $O(n^2)$. Has $O(n^2)$ nodes in the worst case (e.g., for string "ab...z").
  - *Suffix Tree:* $O(n)$. Achieves linear space by compressing nodes and using `(start, end)` pointer pairs for edge labels, which take $O(1)$ space each. The number of nodes is also linear ($<= 2n+1$).
  - *Suffix Array:* $O(n)$. It's an array of $n$ integers. If an LCP array is also stored, it's an additional $O(n)$ space, but the total remains linear.
  - *CDAWG:* $O(n)$. The most compact of the suffix structures, with at most $n+1$ states.
  - *FM-Index:* $O(n log|Sigma|)$ bits, or just $O(n)$ if the alphabet is considered constant. The main components are the BWT string and the Occ data structure, both of which are proportional to $n$. This is often the most space-efficient index in practice.
]

#pagebreak()

== Task: Bit Parallelism (Shift-Or)

*Problem Statement*

Choose a suitable problem and describe how to solve it using bitwise operations (bit parallelism). Provide pseudocode.

*Solution*

The *Shift-Or* algorithm for exact string matching is a classic example of bit parallelism. It's efficient for patterns shorter than the machine word size (e.g., 64 bits).

#info_box(title: "Problem: Exact String Matching")[
  Find all occurrences of a pattern `P` of length `m` in a text `T` of length `n`.

  *Core Idea:*
  The algorithm simulates a Non-deterministic Finite Automaton (NFA) where there is a state for each prefix of the pattern. The state of the simulation is held in a single bitmask `S` of length `m`. The `j`-th bit of `S` is 0 if the prefix `P[1..j]` is a suffix of the text scanned so far. The logic is inverted (0 for a match, 1 for a mismatch) to make the OR operation work for setting mismatches.
]

#info_box(title: "Algorithm and Pseudocode")[
  1. *Preprocessing:*
    For each character `c` in the alphabet, create a bitmask `mask[c]` of length `m`. The `j`-th bit of `mask[c]` is 0 if `P[j] == c`, and 1 otherwise. This takes $O(|#sym.Sigma| m)$ time.

  2. *Searching:*
    Initialize the state `S` to all 1s. Then, for each character `T[i]` in the text, update the state using bitwise operations.

  #code_box([
    #smallcaps([Shift-Or-Search]) ($P$, $T$)
    ```
    // Preprocessing
    m = length(P)
    mask = precompute_masks(P)

    // Searching
    S = bitmask_of_all_ones(m)
    for i from 0 to n-1:
      // 1. Shift: Extends all previous partial matches.
      // 2. Or: Records mismatches for the current character.
      S = (S << 1) | mask[T[i]]

      // Check for a full match
      if (m-th bit of S is 0):
        report match ending at i
    ```
    Note: The pseudocode uses `<<` (left shift) assuming bit 0 is the MSB. If bit 0 is LSB, a right shift `>>` would be used. The logic remains the same.
  ])

  *Complexity:*
  - Preprocessing: $O(|#sym.Sigma| m)$.
  - Searching: $O(n)$ if $m <= w$ (word size). If $m > w$, the complexity is $O(ceil(m/w) * n)$.
  This is extremely fast for short patterns.
]

#pagebreak()

== Task: Wildcard Matching

*Problem Statement*

Describe a method for matching patterns that contain wildcard characters like `?` (matches any single character) and `*` (matches any sequence of zero or more characters).

*Solution*

Matching wildcards requires algorithms that can handle ambiguity.

#info_box(title: "Matching '?' (Single Character Wildcard)")[
  This is the simpler case. Algorithms can be adapted easily:
  - *Dynamic Programming:* In the edit distance matrix, when comparing a `?` in the pattern, the substitution cost is always 0, regardless of the text character.
  - *Bit Parallelism (Shift-Or):* During preprocessing, for the position `j` where `P[j] = '?'`, the `j`-th bit in *every* character's mask `mask[c]` is set to 0. This ensures it always matches.
]

#info_box(title: "Matching '*' (Zero-or-More Wildcard)")[
  The `*` wildcard is more complex as it can match a sequence of any length.

  *Method 1: Using Regular Expressions*
  The most natural way to handle `*` is to treat the pattern as a regular expression.
  1. Convert the pattern with wildcards into a standard regular expression (e.g., `p*a?t` becomes `p.*a.t`).
  2. Build an NFA from the regular expression using Thompson's construction.
  3. Simulate the NFA on the text. The simulation naturally handles the ambiguity of `*` via $epsilon$-transitions.
  - *Complexity:* $O(m n)$ for NFA simulation.

  *Method 2: Splitting the Pattern*
  1. The `*` wildcard splits the pattern into sub-patterns. For example, `P1*P2*P3`.
  2. Search for the sub-patterns `P1`, `P2`, `P3` in order in the text.
  3. Find an occurrence of `P1` ending at position `i`. Then, search for an occurrence of `P2` starting at some position `j > i`. Then search for `P3` starting at `k > j`.
  4. This can be done efficiently by finding all occurrences of all sub-patterns first (e.g., with Aho-Corasick) and then combining the results.
]

#pagebreak()

== Task: Longest Common Subsequence (LCS)

*Problem Statement*

Describe a reasonable algorithm to find the length of the Longest Common Subsequence (LCS) of two strings.

*Solution*

The length of the LCS can be found efficiently using dynamic programming.

#info_box(title: "LCS Algorithm")[
  Let the two strings be `A` of length `n` and `B` of length `m`. We construct a matrix `L` of size `(n+1) x (m+1)`, where `L[i, j]` will store the length of the LCS of the prefixes `A[1..i]` and `B[1..j]`.

  *Initialization:*
  - The first row and first column of the matrix are initialized to 0, as the LCS of any string with an empty string is 0. `L[i, 0] = 0` and `L[0, j] = 0`.

  *Recurrence Relation:*
  We fill the matrix using the following recurrence for `i > 0` and `j > 0`:
  - If the characters match (`A[i] == B[j]`):
    The LCS is one character longer than the LCS of the prefixes before these characters.
    $ L[i, j] = 1 + L[i-1, j-1] $
  - If the characters do not match (`A[i] != B[j]`):
    The LCS is the same as the longest of the two possible smaller problems: LCS of `A[1..i-1]` and `B[1..j]`, or LCS of `A[1..i]` and `B[1..j-1]`.
    $ L[i, j] = max(L[i-1, j], L[i, j-1]) $

  The length of the LCS of the full strings `A` and `B` is the value in the bottom-right cell, `L[n, m]`.

  *Complexity:*
  - *Time:* $O(n * m)$ because each of the `(n+1)(m+1)` cells is computed in constant time.
  - *Space:* $O(n * m)$ to store the matrix. This can be optimized to $O(min(n, m))$ as each row only depends on the previous one.
]

#pagebreak()

== Task: LCF vs. LCS

*Problem Statement*

Compare the Longest Common Factor (LCF) and the Longest Common Subsequence (LCS). Explain the difference and compare their time complexities.

*Solution*

#info_box(title: "Definitions")[
  - *Longest Common Factor (LCF) / Substring:* The longest string that is a *contiguous* substring of both string `A` and string `B`.
  - *Longest Common Subsequence (LCS):* The longest sequence of characters that appears in both `A` and `B` in the same order, but *not necessarily contiguously*.

  *Example:* For `A = "banana"` and `B = "atana"`,
  - The *LCF* is `"ana"`.
  - The *LCS* is `"aana"`.
]

#info_box(title: "Algorithmic Complexity")[
  - *LCS:*
    - *Algorithm:* Dynamic Programming.
    - *Time Complexity:* $O(n * m)$.
    - *Explanation:* Requires filling an $n times m$ matrix. Faster algorithms exist for special cases but this is the general complexity.

  - *LCF:*
    - *Algorithm:* Using a Generalized Suffix Tree or a Generalized Suffix Array.
    - *Time Complexity:* $O(n + m)$.
    - *Explanation:*
      1. Build a Generalized Suffix Tree for strings `A` and `B` ($O(n+m)$).
      2. Mark each internal node based on whether its subtree contains suffixes from `A`, `B`, or both.
      3. The deepest internal node marked as containing suffixes from both `A` and `B` represents the LCF. Finding this node is a linear-time traversal of the tree.
      The overall complexity is dominated by the linear-time construction of the suffix tree.
]

*Conclusion:* Finding the LCF is asymptotically faster ($O(n+m)$) than finding the LCS ($O(n*m)$) because it can leverage specialized string data structures like suffix trees that are built for finding substrings.

#pagebreak()

== Task: Finding Palindromes

*Problem Statement*

Describe an efficient algorithm to find the longest palindromic substring within a given string `S`.

*Solution*

A highly efficient method to find the longest palindromic substring is to use a suffix tree combined with LCP (Longest Common Prefix) queries.

#info_box(title: "Algorithm using Suffix Tree and LCP")[
  A string is a palindrome if it reads the same forwards and backwards ($P = P^R$). The key idea is to find the longest substring `U` starting at some position `i` in `S` whose reverse also appears in `S`. This reverse will be a substring in the reversed string `S^R`.

  *Algorithm:*
  1. *Preprocessing:*
    a. Create the reverse of the string, $S^R$.
    b. Build a Generalized Suffix Tree for `S` and `S^R` together. This takes $O(n)$ time.
    c. Preprocess the suffix tree to answer LCP (Longest Common Prefix) queries in $O(1)$ time. This also takes $O(n)$.

  2. *Searching:*
    Iterate through each position `i` from 0 to `n-1` in the string `S`. Each position can be the center of a palindrome.
    - *Odd-Length Palindromes (centered at `i`):*
      The palindrome is centered around the character `S[i]`. We need to find the longest common prefix between the suffix of `S` starting at `i` ($S[i..]$) and the suffix of $S^R$ starting at the corresponding position ($n-1-i$).
      `len = LCP(S[i..], S^R[n-1-i..])`
      The palindrome found is `S[i-len+1 .. i+len-1]`.
    - *Even-Length Palindromes (centered between `i-1` and `i`):*
      `len = LCP(S[i..], S^R[n-i..])`
      The palindrome found is `S[i-len .. i+len-1]`.

  3. *Result:* Keep track of the maximum length found during the iteration.

  *Time Complexity:* The preprocessing takes $O(n)$. The search loop runs $n$ times, and each LCP query takes $O(1)$. Therefore, the total time complexity is $O(n)$.
]

A simpler, but less optimal, $O(n^2)$ algorithm called "Expand from Center" also exists. It iterates through each character as a potential center and expands outwards, which is easier to implement but slower.

#pagebreak()

== Task: String Normal Form

*Problem Statement*

How can the "Normal Form" of a string be found? What is its time and space complexity?

*Solution*

The normal form of a string $alpha$ is its most compact representation in the form $gamma^r$, where $gamma$ is the shortest possible generator (a primitive string) and $r$ is the exponent.

#info_box(title: "Finding the Normal Form")[
  The normal form is directly related to the string's *shortest period*. The shortest period, in turn, is related to the length of the string's *longest border*. A border is a proper prefix that is also a suffix.

  *Algorithm:*
  1. Let the string be $alpha$ of length $n$.
  2. Compute the *Border Array* (or KMP failure function) for $alpha$. This takes $O(n)$ time.
  3. The length of the longest border of the entire string $alpha$ is given by `b[n]`.
  4. A candidate for the shortest period is $p = n - b[n]$.
  5. *Check for Periodicity:*
    If `b[n] > 0` and `n` is divisible by `p` (i.e., `n % p == 0`), then `p` is indeed the shortest period of $alpha$.
    - The generator is $gamma = alpha[0..p-1]$.
    - The exponent is $r = n / p$.
    - The normal form is $gamma^r$.
  6. *Primitive String:*
    If the condition in step 5 is not met (e.g., `b[n] = 0` or `n` is not divisible by `p`), the string is primitive.
    - The generator is $gamma = alpha$.
    - The exponent is $r = 1$.
    - The normal form is $alpha^1$.
]

#info_box(title: "Complexity Analysis")[
  - *Time Complexity:* $O(n)$.
    The dominant step is the computation of the border array, which is a classic linear-time algorithm. The rest of the steps are arithmetic operations that take constant time.

  - *Space Complexity:* $O(n)$.
    The space is required to store the border array of length $n+1$.
]

#example_box(title: "Example: 'ababab'")[
  - $alpha = "ababab"$, $n=6$.
  - The longest border is "abab", with length 4. So, `b[6] = 4`.
  - The candidate period is $p = 6 - 4 = 2$.
  - Check: `6 > 0` and `6 % 2 == 0`. The condition holds.
  - The shortest period is 2.
  - The generator is $gamma = alpha[0..1] = "ab"$.
  - The exponent is $r = 6 / 2 = 3$.
  - The normal form is $("ab")^3$.
]
#pagebreak()
