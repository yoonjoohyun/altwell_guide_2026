# SCENE 01
## BASE사업자란 무엇일까요?

---

# Scene Information

- Chapter : BASE사업자 이해하기
- Scene ID : base-scene-01
- Estimated Duration : 약 14초
- Goal : BASE사업자는 직급이 아닌 '권리 소득이 시작되는 첫 번째 전환점'이라는 개념을 소개한다.

---

# Reference

Scene 구현 전 아래 파일을 반드시 확인한다.

- PROJECT_RULE.md
- video_start.asp

video_start.asp는 이번 Scene의 **레이아웃 및 Object Library 기준 페이지**이다.

다음 요소를 참고하여 동일한 스타일과 비율을 유지한다.

- Motion Canvas의 좌우 레이아웃
- Information Panel의 구조
- BASE BUSINESS 앰블럼의 크기
- BASE BUSINESS 앰블럼의 중앙 정렬 위치
- 배경 Decoration
- Object Layer 순서
- 기존 CSS Class
- 기존 DOM ID
- 기존 Motion API

Scene 구현 시 새로운 레이아웃을 만들지 않는다.

video_start.asp에 있는 Object Library와 Motion Library를 그대로 재사용한다.

---

# Narration

여러분은 'BASE사업자'가 무엇이라고 생각하시나요?

많은 분들이 하나의 직급이라고 생각하실 수 있지만,
사실은 조금 다릅니다.

이번 가이드 영상을 통해
BASE사업자가 무엇인지,
그리고 왜 중요한지 함께 알아보겠습니다.

---

# Information Panel

## Fixed Chapter Title

BASE사업자 이해하기

(Scene 종료 후 유지)

---

## Scene Title

'BASE사업자'란?

---

## Description

권리 소득이 시작되는 첫 번째 전환점

---

# Objects

이번 Scene에서 사용하는 Object

- BASE BUSINESS Badge

이번 Scene에서는 사용하지 않음

- Main Member
- Child Member
- Rank Medal
- Autoship Badge
- BASE Badge(캐릭터 부착형)
- SEP Badge
- Recommend Bonus Plate
- Support Bonus Plate
- Leader Crown
- Recommend Star
- Connector Line

---

# Timeline

## 0.0s

Scene 초기화

- Scene01에서 사용하는 Object만 Reset

---

## 0.2s

BASE BUSINESS Badge 등장

Motion

- Fade In
- Scale Up
- Soft Glow

위치는 Motion Canvas 중앙.

크기와 비율은
video_start.asp의 BASE BUSINESS Badge를 기준으로 한다.

---

## 0.2s

Scene Title 등장

'BASE사업자'란?

Motion

Slide Up

---

## 0.8s

Description 등장

권리 소득이 시작되는
첫 번째 전환점

Motion

Fade In

---

## 1.2s ~ 11.3s

BASE BUSINESS Badge

Idle Motion

- 아주 미세한 상하 움직임
- 회전 금지
- Bounce 금지

---

## 약 8초

Description Highlight

"권리 소득이 시작되는 첫 번째 전환점"

Highlight Pulse

1회

---

## 11.3s

Scene 종료

순서

1.

Description Fade Out

↓

2.

Scene Title Fade Out

↓

3.

BASE BUSINESS Badge Fade Out

---

## 12.5s

Information Panel 좌측 상단

Fixed Chapter Title 표시

BASE사업자 이해하기

이후 Scene에서도 유지

---

## 14.0s

Scene Complete

---

# Initial State

Visible

- Header
- Motion Canvas
- Information Panel
- Player Controls

Hidden

- BASE BUSINESS Badge
- Scene Title
- Description
- Fixed Chapter Title

---

# End State

Visible

- Header
- Player Controls
- Fixed Chapter Title

Hidden

- BASE BUSINESS Badge
- Scene Title
- Description

---

# Scene Rules

- video_start.asp의 레이아웃과 Object 배치를 기준으로 구현한다.
- Object Library를 새로 생성하지 않는다.
- Motion Library를 새로 생성하지 않는다.
- 기존 DOM과 CSS를 우선 재사용한다.
- 기존 Motion API를 우선 사용한다.
- Scene01 전용 CSS를 최소화한다.
- Scene01은 독립 실행, 반복 재생, Reset이 가능해야 한다.
- 실제 나레이션 음원은 없으므로 예상 발화 시간을 기준으로 애니메이션을 구성한다.

---

# Acceptance Criteria

- 약 14초 내외로 재생된다.
- video_start.asp와 동일한 레이아웃 감성을 유지한다.
- BASE BUSINESS Badge가 Motion Canvas 중앙에 자연스럽게 등장한다.
- Information Panel의 제목과 설명이 내레이션 흐름에 맞춰 나타난다.
- Scene 종료 후 Fixed Chapter Title만 유지된다.
- 반복 재생 시 Motion이 중복되지 않는다.
- 공통 Player Layout은 변경되지 않는다.