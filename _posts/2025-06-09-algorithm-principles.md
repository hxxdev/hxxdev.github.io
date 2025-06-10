---
title: Principles when designing an algorithm
date: 2025-06-09
categories: [dev, algorithm]
tags: [algorithm, principles]
---

1. Rule of thumb.
Calculate the O-metrics.  
If it is more than 100,000,000, the algorithm is likely to take more than a second.


2. Define a dataset that you have to DFS and what dataset you have.
Divde the dataset that you have to DFS to groups that can be parallelized.  

3. Define a problem and a subproblem.

Example: BOGGLE
In the Boggle game, the **_problem_** can be defined as:
"Given the current position (x, y) on the game board and a _word_, can the _word_ be found starting from this cell?"

To answer this we need to process 9 informations:
- Is there a first letter in the current position (x, y)?
- Starting from (x-1, y), can the remaining words be found?
- Starting from (x-1, y+1), can the remaining words be found?
- Starting from (x, y+1), can the remaining words be found?
- Starting from (x+1, y+1), can the remaining words be found?
- Starting from (x+1, y), can the remaining words be found?
- Starting from (x+1, y-1), can the remaining words be found?
- Starting from (x, y-1), can the remaining words be found?
- Starting from (x-1, y-1), can the remaining words be found?

2~9 has the same format with the original problem. We define this as **_subproblem_**.
