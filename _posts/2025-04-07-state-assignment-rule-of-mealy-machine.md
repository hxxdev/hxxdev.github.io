---
title: State assignment rule of mealy machine
date: 2025-04-07
categories: [circuit, digital]
tags: [digital, mealy machine]
---
State assignment란, sequential machine의 state에 binary값을 할당하는 작업이다.

아무값이나 할당해도 되지만 값을 어떻게 할당하냐에 따라 좀 더 optimal한 회로가 설계된다.

[##_Image|kage@bxsLl7/btsFiuIeSn3/7YazSyUgqFkwFpuoWkCibk/img.png|CDM|1.3|{"originWidth":2492,"originHeight":1427,"style":"alignCenter","width":642,"height":368,"caption":"Mealy Machine"}_##]

위 그림은 밀리 머신이다.

State assignment를 어떻게 하냐에 따라 combinational network이 더 복잡할 수도 있고 간단해질 수 있다.

Optimal한 state assignment를 하기 위한 3가지 룰을 소개한다.

---

**Rule 1.** **특정 input(X) condition 에 대해 next state이 같은 state는 인접한 state로 할당해라.**

Next state에 대한 combinational logic을 만들 때 Karnaugh map을 그린다고 상상을 해보자.

Karnaugh map에서 최대한 1이 많이 뭉쳐있어야 combinational logic이 간단해질 것이다.

이를 위해 next state이 같은 state은 인접하도록 assign하자.

---

**Rule 2. 특정 state의 next states들은 adjacent code를 부여하자.**

예를 들어, state S0에서 X=0이면 S1, X=1이면 S2가 next state가 된다고 하자.

이 경우, S1과 S2에 인접한 코드를 부여하는 것이 좋다.

---

**Rule 3. **특정 input(X) condition 에 대해 output이 같은 state는 인접한 state로 할당해라.****

예를 들어, state S0에서 X=0이면 S1, X=1이면 S2가 next state가 된다고 하자.

이 경우, S1과 S2에 인접한 코드를 부여하는 것이 좋다.

---

## **Rule 적용해보기**![](https://blog.kakaocdn.net/dn/JRpuN/btsFoJwRKzk/0h2nTG5E6g2aqhtdr0V5KK/img.png)

Rule 1에 따라 (S3, S4), (S5, S6), (S1, S2)는 K-map에서 인접해야 한다.

Rule 2에 따라 (S1, S2), (S3, S4), (S5, S6)는 K-map에서 인접해야 한다.

Rule 3에 따라 (S0, S1, S4, S6), (S2, S3, S5), (S0, S1, S4)는 K-map에서 인접해야 한다.

따라서 다음과 같이 state encoding을 하는 것이 효과적이다.

[##_Image|kage@6mOGd/btsFmfp6AVb/1Bb9KUJ9D3exMRzWFkzkq0/img.png|CDM|1.3|{"originWidth":599,"originHeight":381,"style":"alignCenter"}_##]

end.



