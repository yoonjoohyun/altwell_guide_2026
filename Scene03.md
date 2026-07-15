# SCENE 03
## BASE사업자의 의미

---

# Scene Information

- Chapter : BASE사업자 이해하기
- Scene ID : base-scene-03
- Estimated Duration : 약 18~20초
- Goal : BASE사업자는 하나의 지위가 아니라 권리 소득을 받을 수 있는 자격이며, 소비자에서 사업자로 전환되는 첫 번째 단계임을 이해시킨다.

---

# Narration

BASE사업자는 하나의 직급이라기보다

권리 소득을 받을 수 있는 자격을 의미합니다.

즉,

단순히 제품을 사용하는 소비자에서

권리 소득을 만들어가는 사업자로 전환되는

첫 번째 단계라고 이해하시면 됩니다.

---

# Information Panel

## Fixed Chapter Title

BASE사업자 이해하기

---

## Scene Title

BASE사업자의 의미

---

## Description

- 하나의 지위가 아닌 권리 자격
- 권리 소득이 시작되는 첫 번째 전환점

---

# Objects

사용 Object

- BASE BUSINESS Badge

사용 HTML Object

- Qualification Title
- Consumer Business Text

---

# Timeline

## Intro

Motion Canvas 중앙에

BASE BUSINESS Badge 등장

Motion

- Fade In
- Scale Up
- Soft Glow

↓

등장 완료 후

미세한 Idle Motion 시작

---

## Qualification

나레이션

"권리 소득을 받을 수 있는 자격"

BASE BUSINESS Badge가

화면 중앙에서 좌측으로 부드럽게 이동한다.

↓

Badge 우측에 HTML div 표시

**= 권리 소득 자격**

- Bold
- 큰 폰트
- Slide Up

중요

Badge와 "= 권리 소득 자격" 전체를 하나의 그룹으로 간주하며

그룹 전체의 중심이 Motion Canvas 중앙에 위치하도록 배치한다.

---

## Consumer → Business

나레이션

"소비자에서"

↓

Qualification 그룹 아래

약간의 간격을 두고

HTML div 표시

소비자 → 사업자

스타일

- 소비자 : Semibold
- 사업자 : Bold
- 큰 폰트
- 화살표 : CSS 또는 SVG

Motion

- Fade In
- Slide Up

텍스트에는 Idle Motion을 적용하지 않는다.

---

## Highlight

나레이션

"사업자로 전환되는"

순차 강조

① BASE BUSINESS Badge

↓

② 권리 소득 자격

↓

③ 사업자

Motion

- Soft Highlight
- Glow Pulse

---

## Outro

Qualification Text Fade Out

↓

Consumer → Business Fade Out

↓

BASE BUSINESS Badge Fade Out

---

# End State

Visible

- Header
- Fixed Chapter Title
- Player Controls

Hidden

- BASE BUSINESS Badge
- Qualification Title
- Consumer Business Text
- Scene Title
- Description

---

# Scene Rules

- BASE BUSINESS Badge는 처음에는 Motion Canvas 중앙에 등장한다.
- 등장 후 좌측으로 이동하여 Qualification 그룹을 구성한다.
- Badge와 "= 권리 소득 자격"을 합친 전체 그룹의 중심이 Motion Canvas 중앙이 되도록 정렬한다.
- "= 권리 소득 자격"은 HTML div로 구현한다.
- "소비자 → 사업자"는 HTML div로 구현한다.
- 두 HTML Text 모두 Idle Motion을 적용하지 않는다.
- "소비자 → 사업자"는 Qualification 그룹 아래 일정한 간격을 유지한다.
- 화살표는 CSS 또는 SVG로 구현한다.
- 텍스트 크기는 Information Panel보다 크게 표시하여 핵심 메시지를 강조한다.

---

# Acceptance Criteria

- BASE BUSINESS Badge가 중앙에서 자연스럽게 등장한다.
- Badge가 좌측으로 이동하면서 Qualification 그룹이 완성된다.
- Badge와 "= 권리 소득 자격"을 합친 그룹이 화면 중앙에 정렬된다.
- "소비자 → 사업자"가 그룹 아래에 자연스럽게 표시된다.
- 권리 소득 자격과 소비자→사업자 전환 개념이 직관적으로 전달된다.
- Motion Canvas와 Information Panel이 나레이션과 자연스럽게 동기화된다.