---
title: C++ compile-time programming
date: 2025-08-29
categories: [dev, cpp]
tags: [cpp]
layout: single
permalink: /notes/2025/08/cpp-constexpr/
author_profile: true
read_time: true
comments: true
share: true
related: true
---

It is good practice to write a lot of compile-time evaluatable expressions
rather than resorting to as-if optimization of the compiler.

The more expressions we can evaluate at compile-time, the more performance gain is given.

- Constexpr variables (discussed in upcoming lesson 5.6 -- Constexpr variables).
- Constexpr functions (discussed in upcoming lesson F.1 -- Constexpr functions).
- Templates (introduced in lesson 11.6 -- Function templates).
- static_assert (discussed in lesson 9.6 -- Assert and static_assert).
