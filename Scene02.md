# SCENE 02
## 비즈니스 성장의 전환점

---

# Scene Information

- Chapter : BASE사업자 이해하기
- Scene ID : base-scene-02
- Estimated Duration : 약 28초
- Goal : 디슈머가 오토십 이용자 2명을 확보하면서 BASE사업자 자격을 획득하는 과정을 이해시킨다.

---

# Reference

Scene 구현 전 아래 파일을 반드시 확인한다.

- PROJECT_RULE.md
- video_start.asp

video_start.asp는 이번 Scene의 레이아웃 및 Object Library 기준 페이지이다.

다음 요소를 참고하여 동일한 스타일과 비율을 유지한다.

- Motion Canvas의 레이아웃
- Information Panel의 구조
- Member 캐릭터의 크기와 위치
- D Rank Medal 위치
- AUTOSHIP Badge 위치
- BASE BUSINESS Badge의 Qualification 위치
- Object Layer 순서
- 기존 DOM ID
- 기존 CSS Class
- 기존 Motion API

Scene 구현 시 새로운 레이아웃을 만들지 않는다.

---

# Narration

앨트웰을 처음 시작하면 누구나 디슈머가 됩니다.

디슈머는 앨트웰의 좋은 제품을 할인받아 이용하는
똑똑한 소비자입니다.

그리고 내가 누리고 있는 혜택을 다른 사람에게 소개하고,

그 사람들도 나처럼 오토십을 이용하게 되면

비즈니스 성장의 중요한 전환점을 맞이하게 됩니다.

바로 BASE사업자가 되는 순간입니다.

---

# Information Panel

## Fixed Chapter Title

BASE사업자 이해하기

(Scene01에서 이어져 계속 유지)

---

## Scene Title

비즈니스 성장의 전환점

---

## Description

? 디슈머 = 똑똑한 소비자

? 내가 누리는 혜택을 다른 사람과 공유

? 오토십 이용자 2명 확보

? BASE사업자 자격 획득

---

# Objects

이번 Scene에서 사용하는 Object

- Main Member
- Child Member ×2
- D Rank Medal
- AUTOSHIP Badge
- BASE BUSINESS Badge

이번 Scene에서는 사용하지 않음

- P Rank Medal
- SEP Badge
- Recommend Bonus Plate
- Support Bonus Plate
- Leader Crown
- Recommend Star
- Connector Line

---

# Timeline

## 0.0s

Scene02 초기화

Scene01의 End State에서 자연스럽게 이어진다.

고정 타이틀은 유지한다.

---

## 0.5s

화면 중앙

일반 캐릭터 등장

Motion

Fade In

---

## 1.5s

일반 캐릭터 →

Member 캐릭터 전환

Motion

Replace

---

## 2.3s

Member에

D Rank Medal 부착

Motion

Acquire

Glow

---

## 3.0s

Member에

AUTOSHIP Badge 부착

Motion

Acquire

Glow

---

## 5.0s

좌측 하단

Member 1명 등장

Motion

Fade + Scale

---

## 5.8s

우측 하단

Member 1명 등장

Motion

Fade + Scale

---

## 7.0s

좌측 하단 Member

AUTOSHIP Badge 부착

Motion

Acquire

---

## 8.0s

우측 하단 Member

AUTOSHIP Badge 부착

Motion

Acquire

---

## 10.0s

화면 중앙

BASE BUSINESS Badge 크게 등장

Motion

Fade In

Scale Up

Glow

---

## 11.5s

BASE BUSINESS Badge

Main Member의 Qualification 위치로 이동

Motion

Move

Scale Down

Attach

---

## 12.5s

하위 Member 두 명은

약간 축소하거나

Opacity를 낮춰

Main Member를 강조

---

## 13.0s ~ 24.0s

최종 상태 유지

Main Member

- D Rank 유지
- AUTOSHIP 유지
- BASE BUSINESS 자격 추가

Child Member

- AUTOSHIP 유지

---

## 24.0s

Information Panel

Description 마지막 항목

"BASE사업자 자격 획득"

Highlight Pulse

1회

---

## 26.0s

Scene 종료

순서

Description Fade Out

↓

Scene Title Fade Out

↓

Object 유지

(Scene03에서 이어서 사용)

---

## 28.0s

Scene Complete

---

# Initial State

Visible

- Header
- Motion Canvas
- Information Panel
- Fixed Chapter Title
- Player Controls

Hidden

- Main Member
- Child Member
- D Rank Medal
- AUTOSHIP Badge
- BASE BUSINESS Badge

---

# End State

Visible

- Main Member
- Child Member ×2
- D Rank Medal
- AUTOSHIP Badge ×3
- BASE BUSINESS Badge
- Fixed Chapter Title

Hidden

- Scene Title
- Description

---

# Scene Rules

- BASE BUSINESS Badge는 Rank Medal이 아니다.
- D Rank Medal을 교체하지 않는다.
- D Rank Medal과 BASE BUSINESS Badge는 동시에 표시한다.
- BASE BUSINESS Badge는 Qualification 영역에 부착한다.
- BASE사업자 자격과 지위는 서로 독립적으로 표현한다.
- Object Library를 새로 생성하지 않는다.
- Motion Library를 새로 생성하지 않는다.
- 기존 DOM과 Motion API를 재사용한다.
- 실제 나레이션 음원은 없으므로 예상 발화 시간을 기준으로 애니메이션을 구성한다.

---

# Acceptance Criteria

- 약 28초 내외로 재생된다.
- 일반 캐릭터가 Member로 자연스럽게 전환된다.
- D Rank Medal과 AUTOSHIP Badge가 순차적으로 획득된다.
- 하위 Member 2명이 등장한다.
- BASE BUSINESS Badge가 Qualification 위치에 부착된다.
- D Rank Medal은 유지된다.
- BASE사업자 자격과 지위가 독립적으로 표현된다.
- Scene03에서 그대로 이어질 수 있는 상태로 종료된다.