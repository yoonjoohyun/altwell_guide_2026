# SCENE 05
## BASE사업자의 첫 번째 권리

---

# Scene Information

- Chapter : BASE사업자 이해하기
- Scene ID : base-scene-05
- Estimated Duration : 약 40초
- Goal : BASE사업자가 되면 가장 먼저 발생하는 권리인 '추천 보너스'의 발생 조건과 지급 구조를 이해시킨다.

---

# Narration

BASE사업자가 되면 가장 먼저
권리 소득이 시작됩니다.

그 첫 번째 권리가 바로 추천 보너스입니다.

BASE사업자는 본인이 직접 추천한 오토십 이용자 한 명당
매월 10,000원의 추천 보너스를 받을 수 있습니다.

추천 보너스는 반드시 내 하위 그룹에서만 발생하는 것이 아닙니다.

앨트웰 비즈니스 어디에서든
내가 직접 추천한 사업자가 오토십 이용과
SEP 30만 이상 조건을 유지하고 있다면
추천 보너스가 발생합니다.

물론 나 역시 BASE사업자 조건을
계속 유지해야 한다는 점을 기억해야 합니다.

---

# Information Panel

## Fixed Chapter Title

BASE사업자 이해하기

---

## Scene Title

BASE사업자의 권리

---

## Description

### 권리 소득의 시작

### 추천 보너스

- 직접 추천한 조건 충족 사업자 1명당 월 10,000원
- 기본 조건 : 오토십 이용 + SEP 30만 이상
- 소속 그룹과 관계없이 직접 추천한 사업자에게 적용
- 본인도 BASE사업자 조건 유지 필요

---

# Objects

## 사용 Object

- Main Member
- Member Group × 2~3
- Child Member
- Current Rank Medal
- AUTOSHIP Badge
- BASE BUSINESS Badge
- Recommend Star
- Leader Crown
- Bonus Flow
- referral_bonus_icon.png

## 사용 HTML Object

- SEP Badge
- Bonus Counter
- BASE Status Plate

---

# Timeline

## Intro

Main Member 등장

↓

Leader Crown 표시

↓

BASE BUSINESS Badge 유지

↓

AUTOSHIP Badge 유지

↓

현재 Rank Medal 유지

↓

SEP Badge 표시

---

## 추천 보너스 소개

나레이션

"그 첫 번째 권리가 바로 추천 보너스입니다."

Main Member 하단

referral_bonus_icon.png 등장

Fade In

↓

Glow

↓

Bounce 1회

↓

HTML Counter 등장

1명당 월 10,000원

---

## 추천 Member 등장

2~3개의 그룹이

순차적으로 등장

각 추천 Member

- Recommend Star
- AUTOSHIP Badge
- SEP Badge

순차적으로 획득

---

## Bonus Flow

추천 Member에서

Main Member 방향으로

Bonus Flow 실행

조직선이 없는 추천 Member도

Bonus Flow만으로 관계를 표현한다.

---

## Bonus Count Up

나레이션

"직접 추천한 오토십 이용자 한 명당"

추천 Member가 조건을 만족할 때마다

Bonus Flow

↓

Counter 증가

10,000원 × 1

↓

10,000원 × 2

↓

10,000원 × 3

각 숫자가 변경될 때

- Pop Scale
- Glow
- Coin Tick 느낌의 Bounce

적용

Counter는 HTML Text로 구현한다.

---

## 추천 보너스 설명

나레이션

"앨트웰 비즈니스 어디에서든..."

Bonus Flow가

다른 그룹에서도

Main Member로 이동

↓

Counter 유지

↓

추천 관계는

Recommend Star로 표현

조직선은 사용하지 않는다.

---

## BASE 유지

나레이션

"물론 나 역시..."

Main Member 하단

BASE Status Plate 등장

문구

BASE사업자 자격 유지 중

↓

BASE BUSINESS Badge

Glow Pulse

↓

Main Member 강조

---

## Outro

Bonus Flow 종료

↓

Counter Fade Out

↓

Status Plate Fade Out

↓

Description Fade Out

↓

Scene Title Fade Out

---

# End State

Visible

- Header
- Fixed Chapter Title
- Player Controls
- Main Member
- Recommend Groups

Hidden

- Bonus Counter
- Bonus Flow
- BASE Status Plate
- Scene Title
- Description

---

# Scene Rules

- referral_bonus_icon.png는 Bonus Flow 애니메이션에서만 사용한다.
- Main Member에는 추천 보너스 아이콘을 항상 표시하지 않는다.
- 추천 보너스 정보는 Recommend Bonus Plate(HTML div)로 표시한다.
- Bonus Flow 종료 후 아이콘은 제거하고 Bonus Plate의 카운터만 갱신한다.
- Recommend Bonus Plate는 "추천 보너스"와 "10,000원 × n"을 표시한다.
- Bonus Counter는 Count Up 애니메이션을 적용한다.

---

# Acceptance Criteria

- referral_bonus_icon.png가 추천 보너스를 대표한다.
- Bonus Counter가 10,000원 ×1 → ×2 → ×3으로 자연스럽게 증가한다.
- 추천 Member가 증가할 때마다 Bonus Flow와 Counter가 함께 동작한다.
- 추천 관계와 조직 관계가 명확히 구분된다.
- Motion Canvas와 Information Panel이 나레이션과 자연스럽게 동기화된다.
- Play / Pause / Restart 시 Counter 상태가 정상적으로 초기화된다.