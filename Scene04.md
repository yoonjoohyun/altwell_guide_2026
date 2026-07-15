# SCENE 04
## BASE사업자가 되는 조건

---

# Scene Information

- Chapter : BASE사업자 이해하기
- Scene ID : base-scene-04
- Estimated Duration : 약 30~34초
- Goal : BASE사업자가 되기 위해 본인과 하위 디슈머 2명이 각각 오토십 이용과 SEP 30만 이상 조건을 유지해야 한다는 점을 이해시킨다.

---

# Narration

그렇다면 BASE사업자는 어떻게 될 수 있을까요?

먼저 본인이 오토십을 이용하면서  
SEP 30만 이상을 유지해야 합니다.

그리고 하위에 오토십을 이용하는 디슈머 두 명이 생기고,  
두 사람 모두 각각 SEP 30만 이상을 유지하면 됩니다.

여기서 꼭 기억해야 할 점이 있습니다.

본인을 포함한 세 사람 모두 조건을 계속 유지해야  
BASE사업자 자격도 함께 유지됩니다.

---

# Information Panel

## Fixed Chapter Title

BASE사업자 이해하기

(이전 Scene에서 이어서 유지)

---

## Scene Title

BASE사업자가 되는 법

---

## Description

### 본인

- 오토십 이용
- SEP 30만 이상

### 하위 디슈머 2명

- 각각 오토십 이용
- 각각 SEP 30만 이상

### Highlight Message

본인을 포함한 세 사람 모두 조건 유지

---

# Objects

## 사용 Object

- Main Member
- Child Member Left
- Child Member Right
- Current Rank Medal
- D Rank Medal ×2
- AUTOSHIP Badge ×3
- BASE BUSINESS Badge
- Status Check ×3

## 사용 HTML Object

- Main Member SEP Badge
- Child Member Left SEP Badge
- Child Member Right SEP Badge
- Highlight Message

## 사용하지 않음

- P Rank Medal 자동 전환
- Recommend Bonus Plate
- Support Bonus Plate
- Leader Crown
- Recommend Star

---

# Initial State

## Visible

- Header
- Motion Canvas
- Information Panel
- Fixed Chapter Title
- Player Controls

## Hidden

- Main Member
- Child Member Left
- Child Member Right
- 모든 Rank Medal
- 모든 AUTOSHIP Badge
- 모든 SEP Badge
- 모든 Status Check
- BASE BUSINESS Badge
- Scene Title
- Description
- Highlight Message

---

# Timeline

## Intro

나레이션:

> 그렇다면 BASE사업자는 어떻게 될 수 있을까요?

화면:

- Scene Title 표시
- Main Member가 중앙 상단에 등장
- Fade In + Scale Up

---

## Main Member Condition

나레이션:

> 먼저 본인이 오토십을 이용하면서  
> SEP 30만 이상을 유지해야 합니다.

화면 순서:

1. Main Member에 현재 Rank Medal 표시
2. Main Member에 AUTOSHIP Badge 표시
3. Main Member 좌측 상단에 SEP Badge 표시

SEP Badge 문구:

- SEP
- 30만 이상

모션:

- Rank Medal : Fade + Scale
- AUTOSHIP Badge : Acquire
- SEP Badge : Slide Up 또는 Acquire

---

## First Child Member

나레이션:

> 그리고 하위에 오토십을 이용하는 디슈머 두 명이 생기고,

화면 순서:

1. 좌측 하단에 일반 캐릭터 등장
2. 일반 캐릭터가 Child Member Left로 전환
3. D Rank Medal 표시
4. AUTOSHIP Badge 표시
5. SEP Badge 표시

SEP Badge 문구:

- SEP 30만 이상

---

## Second Child Member

나레이션:

> 두 사람 모두 각각 SEP 30만 이상을 유지하면 됩니다.

화면 순서:

1. 우측 하단에 일반 캐릭터 등장
2. 일반 캐릭터가 Child Member Right로 전환
3. D Rank Medal 표시
4. AUTOSHIP Badge 표시
5. SEP Badge 표시

SEP Badge 문구:

- SEP 30만 이상

---

## Condition Complete

세 Member의 조건을 순서대로 강조한다.

순서:

1. Main Member의 AUTOSHIP과 SEP 강조
2. Child Member Left의 AUTOSHIP과 SEP 강조
3. Child Member Right의 AUTOSHIP과 SEP 강조
4. 각 Member에 Status Check 표시

모션:

- Highlight Pulse
- Check Pop

---

## BASE Qualification Acquired

세 Member의 조건 충족 후  
Main Member에 BASE BUSINESS Badge 표시

모션:

- Fade In
- Scale Up
- Soft Glow
- Qualification 위치에 부착

중요:

- 기존 Rank Medal은 유지
- Rank Medal과 BASE BUSINESS Badge를 동시에 표시
- D Rank Medal을 P Rank Medal로 자동 교체하지 않음

---

## Condition Maintenance Highlight

나레이션:

> 여기서 꼭 기억해야 할 점이 있습니다.

화면:

- Information Panel의 Highlight Message 표시

문구:

본인을 포함한 세 사람 모두 조건 유지

모션:

- Slide Up
- Highlight Pulse

---

## Final Explanation

나레이션:

> 본인을 포함한 세 사람 모두 조건을 계속 유지해야  
> BASE사업자 자격도 함께 유지됩니다.

화면:

- 세 Member의 AUTOSHIP Badge와 SEP Badge를 동시에 강조
- BASE BUSINESS Badge는 활성 상태 유지
- 세 Status Check 유지
- 조건 유지 구조를 충분히 인지할 수 있도록 최종 상태 유지

---

## Outro

Scene 종료 순서:

1. Highlight Message Fade Out
2. Description Fade Out
3. Scene Title Fade Out
4. Status Check Fade Out
5. Scene 전용 강조 효과 제거

Scene 종료 시 Member 구조를 다음 Scene에서 재사용할지  
다음 Scene 명세의 Initial State를 기준으로 결정한다.

---

# End State

## Visible

- Header
- Fixed Chapter Title
- Player Controls
- Main Member
- Child Member Left
- Child Member Right
- Rank Medal ×3
- AUTOSHIP Badge ×3
- SEP Badge ×3
- Main Member의 BASE BUSINESS Badge

## Hidden

- Scene Title
- Description
- Highlight Message
- Status Check 또는 임시 강조 효과

---

# Scene Rules

- BASE사업자 조건과 Rank 승급은 독립적으로 처리한다.
- BASE사업자 조건 충족만으로 D Rank를 P Rank로 자동 변경하지 않는다.
- P Rank는 별도의 승급 조건이 충족된 경우에만 표시한다.
- BASE BUSINESS Badge는 Rank Medal을 대체하지 않는다.
- SEP Badge는 이미지가 아닌 HTML div로 구현한다.
- 세 Member의 SEP Badge는 각각 독립된 DOM 요소로 구성한다.
- 각 Member의 AUTOSHIP, SEP, Rank 상태는 개별적으로 제어한다.
- 조건 충족은 색상만이 아니라 Check와 강조 효과로 함께 표현한다.
- Highlight Message는 HTML 텍스트로 구현한다.
- Main Member와 Child Member의 크기와 배치는 기존 레이아웃 기준을 따른다.

---

# Acceptance Criteria

- 본인과 하위 디슈머 2명의 조건이 순차적으로 이해된다.
- 세 Member 모두 AUTOSHIP과 SEP 조건을 개별적으로 표시한다.
- 각 SEP Badge가 독립적인 HTML div로 구현된다.
- 세 Member의 조건 충족 후 각각 Check가 표시된다.
- Main Member에 BASE BUSINESS Badge가 자격으로 추가된다.
- 기존 Rank Medal은 유지된다.
- D Rank가 P Rank로 자동 변경되지 않는다.
- 조건 유지의 중요성이 Information Panel과 Motion Canvas에서 동시에 강조된다.
- Scene Media와 애니메이션이 자연스럽게 동기화된다.
- Play, Pause, Restart, 반복 재생 시 상태가 깨지지 않는다.