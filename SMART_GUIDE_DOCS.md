# ALTWELL SMART GUIDE — 통합 개발 문서

> Classic ASP + Vanilla JS 교육용 인터랙티브 가이드  
> **미리보기:** `asset_design.asp` · **guide01:** `series/season01/guide01_smartguide.asp`  
> **Last updated:** 2026-09-23 (§5-8 씬1~4 제작 프로세스 · Scene 03/04 반영)

---

## 목차

1. [아키텍처](#1-아키텍처)
2. [프로젝트 규칙](#2-프로젝트-규칙)
3. [에셋 디자인 시스템](#3-에셋-디자인-시스템)
4. [7×7 모션 그리드](#4-77-모션-그리드)
5. [존 애니메이션 규칙](#5-존-애니메이션-규칙)
6. [시나리오 작성 (부록 A)](#6-시나리오-작성-부록-a)
7. [guide01 씬 추가 가이드](#7-guide01-씬-추가-가이드)
8. [씬1~4 제작 프로세스 요약](#8-씬14-제작-프로세스-요약)

---

## 1. 아키텍처

### 1-1. 개요

| 항목 | 내용 |
|------|------|
| 스택 | Classic ASP (SSI), HTML, CSS, Vanilla JavaScript |
| 미사용 | React, Vue, TypeScript, npm, bundler |
| 목적 | 영상형 웹 인포그래픽 + 시뮬레이터로 비즈니스 구조 학습 |

**사용자 흐름**

```
index.asp → guide.asp → series/season01/guide01_smartguide.asp
                    → asset_design.asp (에셋 시안·G01 애니)
                    → frame_layout.asp (템플릿·AssetShowcase)
         → sim.asp
```

### 1-2. 페이지 2종

| 종류 | 예 | CSS |
|------|-----|-----|
| **리스트** | `index.asp`, `guide.asp`, `sim.asp` | `_css/main.css` + 페이지별 |
| **영상** | `guide01_smartguide.asp`, `frame_layout.asp` | `main.css` + `icon_style.css` + `guide01.css` + `styles.asp` + `video_controller.css` |

### 1-3. 영상 페이지 셸

```
#layout-ov
├── video_controller_top.asp
├── #lo-main
│   ├── .lo-motion-zone > .lo-stage-frame > #lo-canvas
│   │   ├── #motion-stage-bg      (고정 배경)
│   │   ├── #motion-canvas        (씬별 모션)
│   │   └── #motion-zone-grid     (7×7 라벨)
│   └── #lo-panel                 (씬별 텍스트)
├── video_controller_bottom.asp
├── #scene-media                  (음성 mp4)
└── video_init.asp
```

**씬 1개 = 3요소**

| # | 요소 | 영역 | 산출물 |
|---|------|------|--------|
| ① | 모션 | `#motion-canvas` | `sceneNN.js.asp` 타임라인 |
| ② | 텍스트 | `#lo-panel` | panel title / bullets |
| ③ | 음성 | `#scene-media` | `voice/{series}/sceneNN*.mp4` |

### 1-4. 모션 4계층

```
Object Library (styles.asp)
  → Motion Primitives (motion.js.asp)
    → Motion Components (includes/motions/)
      → Scene Scripts (series/…/scenes/)
        → Scene Runner (sceneRunner.js.asp)
```

### 1-5. 폴더 구조 (현행)

```
guide_page/
├── index.asp, guide.asp, sim.asp
├── asset_design.asp              # 에셋 시안 + G01 애니 미리보기
├── frame_layout.asp              # 영상 템플릿 + AssetShowcase
├── voice_stream.asp              # mp4 스트리밍
├── SMART_GUIDE_DOCS.md           # 본 문서
├── series/season01/
│   ├── guide01_smartguide.asp
│   └── 0909test.asp
├── _css/
│   ├── main.css, icon_style.css, guide01.css, video_controller.css
│   └── index.css, guide.css, sim.css
├── voice/guide_season01/guide01/
└── includes/
    ├── sceneRunner.js.asp, sceneMedia.js.asp, motion.js.asp
    ├── scenes/defineScene.js.asp
    ├── components/               # *.asp + *_container.asp + guide01_templates.asp
    ├── player/video_layout.asp
    ├── motions/g01/              # zoned · badgeFold · preview
    └── series/guide01/
        ├── guide01.asp, guide01_common.js.asp
        └── scenes/
            ├── scene01.constants.js.asp · setup · js
            ├── scene02.constants.js.asp · setup · js
            ├── scene03.constants.js.asp · setup · js
            └── scene04.constants.js.asp · setup · js
```

### 1-6. guide01 Include 체인

```
guide01_smartguide.asp
├── virtual /includes/player/video_layout.asp
├── virtual /includes/components/guide01_templates.asp
├── virtual /includes/video_runtime.asp
├── virtual /includes/series/guide01/guide01_common.js.asp
├── scene01~04.constants · setup · js (씬별)
├── virtual /includes/sceneTransition.js.asp
├── virtual /includes/series/guide01/guide01.asp
└── SeriesGuide01.init()
```

### 1-7. 배포 참고 (서브폴더)

- `index.asp`, `guide.asp` — 상대 경로 `_css/…` → 서브폴더 배포 OK
- `guide01_smartguide.asp` — `virtual="/includes/…"`, `/_css/…` → **사이트 루트** 또는 IIS 가상 디렉터리 필요
- 서브폴더만 업로드 시 `/index.asp`(본사 루트) 404와 guide01 리소스 404는 **별개** — 접속 URL·경로 매핑 확인

---

## 2. 프로젝트 규칙

### 2-1. 인코딩 · SSI

- ASP: `<%@ Language=VBScript CodePage=65001 %>` + `includes/asp_utf8.asp`
- UTF-8 저장, JS 한글 리터럴 (`\uXXXX` 금지)

| 위치 | include |
|------|---------|
| 루트 ASP | `<!--#include file="includes/…"-->` |
| `series/…/*.asp` | `<!--#include virtual="/includes/…"-->` |
| nested SSI | `../` **금지** |

### 2-2. 씬 작성 API (`defineScene`)

```javascript
var MyScene = defineScene({
  id: 'guide01-scene-01',
  title: '씬 제목',
  duration: 30000,
  motion: { mountCanvas, reset, endState },
  panel: { reset, endState },
  play: async function(ctx){ /* 타임라인 */ }
});
SceneRunner.registerScene(MyScene);
```

**guide01 씬 권장 3파일**

| 파일 | 역할 |
|------|------|
| `sceneNN.constants.js.asp` | duration, `T.*`, panel, media |
| `sceneNN.setup.js.asp` | `setupSceneNNAssets(canvas)` |
| `sceneNN.js.asp` | `defineScene` + `runSceneNNMotion` |

### 2-3. 패널 DOM ID

| ID | 용도 |
|----|------|
| `#lo-scene-label` | 상단 바 영상 제목 |
| `#scene-title-main` | 씬 제목 |
| `#panel-scene-desc` | 부연 |
| `#scene-bullets` | bullet 리스트 |

### 2-4. 시나리오 → 코드 변환 (요약)

| 블록 | 역할 |
|------|------|
| `--- script ---` | 음성 원고 |
| `--- motion ---` | `#motion-canvas` 타임라인 |
| `--- panel ---` | `#lo-panel` |
| `--- end ---` | 씬 종료 잔존 상태 |

타이밍: `@0.2s` = 씬 시작 후 · `@END-0.8s` = mp4 끝 기준

### 2-5. Cursor AI 금지

- React/Vue/TS/npm 마이그레이션
- `#motion-stage-bg` 씬 reset 시 삭제
- keyframe·Component 무분별 중복
- UI 임의 재디자인 (명시 요청 없을 때)

---

## 3. 에셋 디자인 시스템

> 소스: `_css/icon_style.css` · `includes/components/*.asp` · `asset_design.asp`

### 3-1. 계열 (6종)

| 계열 | 용도 | container |
|------|------|-----------|
| **RANK MEDAL** | D~IRF 12지위 | `lev_container.asp` |
| **BADGE** | BASE·오토십·추천·할인·캐시백 (fold `_o`/`_c`) | `badge_container.asp` |
| **UNIT** | person · member | `person_container.asp` |
| **SUB ASSET** | 달력·카드·상태·`+` 등 | `sub_asset_container.asp` |
| **MORE BADGE** | guide01 문구 교체형 정보 뱃지 | `more_badge_container.asp` |
| **MORE SUB ASSET** | guide01 신규 카드·아이콘 | `more_asset_container.asp` |

### 3-2. 기술 제약

- **HTML + CSS만** (PNG/SVG/img 금지)
- **`--size`** + `calc()` 비율 스케일
- 클래스: **snake_case**
- `aria-label` 또는 `role="img"` + `aria-label`

### 3-3. 신규 에셋 추가 절차

1. `includes/components/{name}.asp`
2. `_css/icon_style.css` 해당 섹션
3. `*_container.asp` include (시안)
4. guide01 씬 사용 시 `guide01_templates.asp`에 `data-template` 등록

### 3-4. BADGE (fold `_o` / `_c`)

| 서비스 | templateId | 라벨 |
|--------|------------|------|
| 베이스 사업자 | `base_business_icon` | B |
| 오토십 | `autoship_icon` | A |
| 추천 보너스 | `recommend_bonus_icon` | R |
| 할인 혜택 | `discount_benefit_icon` | % |
| 캐시백 | `cashback_icon` | CB |

> 씬1 베이스만 문구 **`BASE 사업자 기준`** — `scene01SetBaseBadgeLabel()` (컴포넌트 기본값은 `베이스 사업자`)

**배지 HTML 골격**

```html
<div class="{name}_icon_o" aria-label="…">
  <div class="{name}_label">X</div>
  <div class="{name}_text">한글</div>
</div>
```

`G01BadgeFold` 대상: `base_business_icon`, `autoship_icon`, `recommend_bonus_icon`, `discount_benefit_icon`, `cashback_icon`

### 3-5. SUB ASSET (11종)

`effect_plus_icon` · `point_token_icon` · `status_check_icon` · `status_cross_icon` · `calendar_month_card` · `product_silhouette_card` · `delivery_box_icon` · `payment_card_icon` · `select_counter_badge` · `ep_split_card` · `price_step_card`

### 3-6. MORE BADGE

| templateId | 용도 |
|------------|------|
| `guide_info_badge` | 문구 교체형 (기본 파랑) |
| (시안) `guide_info_badge_green.asp` | `.is_green` 변형 |
| (시안) `guide_info_badge_red.asp` | `.is_red` 변형 |
| `auto_renewal_icon` | 3개월 자동 갱신 |

색상 modifier: `.is_green` · `.is_orange` · `.is_red`

### 3-7. MORE SUB ASSET (11종)

| templateId | 용도 |
|------------|------|
| `autoship_discount_summary_card` | 오토십 할인가 4행 정리 (씬2) |
| `subscription_flow_card` | 3개월 구독 → 4개월 자동 연장 |
| `member_basis_card` | 회원 1인 기준 |
| `group_bracket` | 여러 상품 그룹 |
| `product_swap_icon` | 상품 변경 불가 |
| `cancel_request_card` | 해지 신청 |
| `payment_stop_icon` | 자동결제 중단 |
| `business_flow_card` | 제품→추천→비즈니스 |
| `subscription_system_frame` | 정기 구독 시스템 프레임 |
| `cursor_click_icon` | 클릭 커서 |
| `payment_batch_box` | 3개월분 일괄 결제 박스 (씬4) |
| `delivery_batch_box` | 3개월분 일괄 배송 박스 (씬4) |
| `installment_mini_badge` | 카드사 할부 가능 뱃지 (씬4) |
| `product_swap_box` | 상품 A~E 슬롯 (씬3) |
| `unavailable_stamp` | 변경 불가 스탬프 (씬3) |

### 3-8. guide01 clone (`guide01_templates.asp`)

```javascript
Guide01.addZonedAsset(canvas, 'subscription_flow_card', 's01-flow', 'd4', { scale: 0.88 });
Guide01.addZonedBadge(canvas, 'cashback_icon', 's01-cashback', 'd4', { scale: 0.88 });
```

CSS 역할 분리:

| 파일 | 대상 |
|------|------|
| `icon_style.css` | 재사용 에셋 `--size` |
| `guide01.css` | 7×7 존 배치 · wrap/inner 애니 · badge fold |

---

## 4. 7×7 모션 그리드

> DOM: `#motion-canvas` · `#motion-zone-grid` · 비율 **4:3**

### 4-1. 안전 여백

| 환경 | 여백 |
|------|------|
| 웹 (`min-width: 901px`) | **10px** |
| 모바일 (`max-width: 900px`) | **5px** |

### 4-2. 존 이름

`{행 a~g}{열 1~7}` — 예: `d4` = **작업 영역 정중앙**

```text
     1    2    3    4    5    6    7
a   a1   a2   a3   a4   a5   a6   a7
b   …                        …
c   …    …    …   c4   …    …    …
d   …    …    …   d4   …    …    …   ← d4 = 50%, 50%
…
g   g1   …    …   g4   …    …   g7
```

### 4-3. CSS 배치

```css
.lo-zone-place {
  left: calc(10px + (var(--zone-col) - 0.5) / 7 * (100% - 20px));
  top:  calc(10px + (var(--zone-row) - 0.5) / 7 * (100% - 20px));
  transform: translate(-50%, -50%);
}
```

JS: `G01ZonedAnim.parseZone` · `placeAtZone` · `zoneCenterPx` — `includes/motions/g01/zonedCore.js.asp`

### 4-4. 시나리오 표기

```text
@0.3s  show asset.autoship #s01-autoship
       @zone d4
```

### 4-5. 배치 패턴

| 패턴 | 존 예 |
|------|-------|
| 히어로 | `d4` |
| 좌우 대칭 | `c2` · `c6` |
| 상단 라벨 + 중앙 | `a4` + `d4` |
| 3개 가로 | `e2` `e4` `e6` |

### 4-6. 주요 존 중심 (%)

| 존 | 가로 | 세로 | 용도 |
|----|------|------|------|
| `a4` | 50 | 7.1 | 상단 중앙 |
| `c4` | 50 | 35.7 | 상단·머리 정렬 (scene01) |
| `d4` | 50 | 50 | **핵심** |
| `g4` | 50 | 92.9 | 하단 중앙 |

전체 49존표는 구현 코드 `zoneCenterPx` ( `includes/motions/g01/zonedCore.js.asp` ) 와 동일 (행·열 0.5/7 간격).

---

## 5. 존 애니메이션 규칙

> 구현: `guide01_common.js.asp` · `includes/motions/g01/` · `_css/guide01.css`

### 5-1. DOM 2겹

```
.g01-zone-wrap          ← 위치(존) · 이동
  └ .g01-float-inner    ← scale · 등장/퇴장/idle
       └ .guide01-asset
```

| 레이어 | transform |
|--------|-----------|
| wrap | `translate(-50%,-50%)` + `translate3d` (이동) |
| inner | `scale`, `translateY` (등장·idle) |

**마운트 API**

```javascript
Guide01.addZonedAsset(canvas, templateId, elId, zone, { scale: 0.88 });
Guide01.addZonedBadge(canvas, templateId, elId, zone, { scale: 0.88 });
```

`canvas.appendChild` 직접 배치 **금지**.

### 5-2. Base Scale

| 변수 | 의미 |
|------|------|
| `--g01-base-scale` | 정착 크기 |
| `--g01-from-scale` | 등장 시작 scale |
| `--g01-anim-dur` | 등장 길이 |

### 5-3. Motion Component (`g01.zoned.*`)

| Component | 용도 |
|-----------|------|
| `g01.zoned.enterFade` | 페이드 등장 |
| `g01.zoned.enterPop` | pop 등장 |
| `g01.zoned.enterDrop` | drop 등장 |
| `g01.zoned.exit` | 퇴장 |
| `g01.zoned.move` | 존 이동 |
| `g01.zoned.idleStart/Stop` | idle float |
| `g01.badge.unfold/fold` | 뱃지 펼침/접힘 |

미리보기: `asset_design.asp` → **G01 ZONED ANIMATION**

### 5-4. Badge Fold

- 접힘: track clip → 텍스트 fade-out
- 펼침: track 확장 → 텍스트 fade-in (15% overlap)
- 등장: `Guide01.enterZonedBadge` — `_c` → zone 등장 → unfold

### 5-5. guide01 Scene 01 ~ 04 (현행)

| 씬 | 레이아웃 패턴 | 핵심 에셋·연출 |
|----|-------------|--------------|
| **01** | B-1 그룹 상대 배치 | 멤버 2인 + 오토십·베이스·캐시백·추천 존 배치, `Scene01Layout` grid scale |
| **02** | B 중앙 정렬 스택 | 오토십 fold → 할인가 4행 → BASE·캐시백·추천, `Scene02Layout` |
| **03** | B + 하위 슬롯 | 멤버 승격 + 상품 A~E 1열 + 변경불가 스탬프, `Scene03Layout` |
| **04** | B + 가로 클러스터 | 결제·배송 박스 + 캘린더 4개월 + 할부·자동결제, `Scene04Layout` |

**공통 3파일**

| 파일 | 역할 |
|------|------|
| `sceneNN.constants.js.asp` | `T.main`, panel flashes, `layout`, `motion` 프리셋 |
| `sceneNN.setup.js.asp` | DOM 마운트, `SceneNNLayout` IIFE, `setupSceneNNAssets` |
| `sceneNN.js.asp` | `defineScene`, 타임라인, `sceneNNPrepStackSlot`, 연출 함수 |

**Scene 02 `T.main` (ms) — 참고**

| 시점 | 에셋 |
|------|------|
| title+0 | 오토십 unfold |
| main+3s | 오토십 fold + 할인가 빈 패널 |
| main+8~14s | 할인가 4행 순차 (+2s 간격) |
| main+21s | BASE 사업자 기준 |
| main+24s | 캐시백 |
| main+27s | 추천 보너스 |

**Scene 04 `T.main` (ms) — 참고**

| 시점 | 에셋 |
|------|------|
| main+0s | 오토십 |
| main+1s | 결제 박스 (pay-del 클러스터) |
| main+3s | 카드 탭 연출 |
| main+5s | 배송 박스 확장 + 제품 루프 |
| main+8s | 할부 가능 뱃지 |
| main+13s | 캘린더 1~4개월 순차 점프 |
| main+18s | 3→4 자동 연장 |
| main+23s | 전체 idle float 홀드 |

> 씬1~4에서 쌓인 **에셋 조합·플로팅·중앙정렬·레이아웃 안정화** 절차는 [§8 씬1~4 제작 프로세스 요약](#8-씬14-제작-프로세스-요약) 참고.

### 5-6. Anti-patterns

| ❌ | ✅ |
|----|-----|
| wrap에 enter/exit 직접 | `fadeZoned` / `popScaleZoned` |
| keyframe `scale(1)` 고정 | `scale(var(--g01-base-scale))` |
| `--zone-row/col` rAF 보간 | `moveZoned` |
| idle `motion-idle-float` on inner | `g01-idle-float` |
| pop 직후 `setTimeout`으로 idle 시작 | `animationend` 후 soft idle 연결 ([§8-3](#8-3-부드러운-플로팅-애니메이션)) |
| 코인·배지 `display:none` 토글 | `visibility`/`opacity`로 공간 예약 ([§8-4](#8-4-레이아웃-안정화)) |
| 캘린더 스텝마다 `scheduleLayout` | 연출 루프 밖·크기 변화 1회만 호출 |
| 존재하지 않는 keyframe 이름 | `@keyframes` 정의 후 class에 연결 (`s04-installment-pop` 등) |

### 5-7. 씬 간 전환 (`sceneTransition.js.asp`)

| 단계 | 시간 | 동작 |
|------|------|------|
| hold | 1s | 현재 씬 잔존 |
| fade | 2s | canvas **직계** `.g01-zone-wrap` + 패널 **opacity** 퇴장 |
| gap | 3s | SceneRunner가 다음 씬 시작까지 대기 |

- 중첩 `g01-zone-wrap`(스택 자식)은 **개별 퇴장하지 않음** — 스택 그룹 1개만 fade
- scale/transform 퇴장 제거 → 다음 씬 중앙정렬이 깨지지 않음
- `#motion-zone-grid`는 `video_layout.asp`에서 항상 유지 (씬1 grid fallback과 연동)

### 5-8. 신규 씬 체크리스트 (모션)

- [ ] `addZonedAsset` / `addZonedBadge` 마운트
- [ ] `--g01-base-scale` 설정
- [ ] 등장/퇴장 zoned API만 사용
- [ ] `tl.wait(절대ms)` 타이밍
- [ ] wrap에 transform 애니 금지

> 등록·음성·패널·배선 등 **씬 추가 전체 절차**는 [§7 guide01 씬 추가 가이드](#7-guide01-씬-추가-가이드) 참고.

---

## 6. 시나리오 작성 (부록 A)

> **워크플로:** 기획문(음성·모션 단계·텍스트박스) → **본 §6 양식으로 변환** → mp4 제작 → 코드(`sceneNN.*`) 반영 → 타이밍 미세 조정.  
> 코드 제작 절차: [§7 guide01 씬 추가 가이드](#7-guide01-씬-추가-가이드)

### A-1. 챕터 헤더

```text
# {챕터명}
@lessonTitle {영상 제목}
@series {seriesId}
@smartguide {파일명}.asp
```

### A-2. 시나리오 필수 항목 체크리스트

기획문만으로는 구현·수정 시 추측이 필요하다. **제작용 시나리오**에는 아래를 반드시 포함한다.

**씬 메타**

- [ ] `@scene NN` · `@title` (패널 H2 — 「~무엇인가요?」 질문형과 구분)
- [ ] `@voice` mp4 파일명 (`guide01_scene_NN.mp4`)
- [ ] `@voiceTitle` — title mp4 분리 여부 (`guide01_scene_NN_title.mp4`, 없으면 생략)
- [ ] `@mediaBase` — 모션·패널 타이밍 기준 (`title` | `main`, [A-3](#a-3-타이밍-표기-규칙))

**음성 (`--- script ---`)**

- [ ] 낭독 원고 전문
- [ ] 구간 마커 `(~N초)` — **어느 mp4 기준인지** 주석 (`main 기준`, `title 기준`)

**모션 (`--- motion ---`)** — 단계마다

- [ ] 시점 (`@main+3s` 등, [A-3](#a-3-타이밍-표기-규칙))
- [ ] 에셋키 또는 `templateId` ([A-4](#a-4-에셋-키--templateid))
- [ ] DOM id (`#sNN-…`)
- [ ] `@zone` (예: `d4`) — 그룹 배치 시 앵커 존 + offset 메모
- [ ] 등장 방식: `fade` · `pop` · `badge.enter+unfold` · `badge.fold` · `reveal col N` 등
- [ ] 배치 관계: 겹침·세로 스택·fold 후 등장 순서
- [ ] `@END-*` 또는 씬 종료 시 퇴장 여부

**패널 (`--- panel ---`)**

- [ ] `@title` 문구
- [ ] bullet 전체 목록 (index 0부터)
- [ ] **flash 시점** — 음성 구간과 1:1 (`@main+4000 flash bullet 0`)
- [ ] 4번째 줄 등 **부제/subline** vs bullet 구분

**신규 에셋 (`--- assets-new ---`, 해당 시)**

- [ ] 가칭 `templateId` · 계열 (MORE SUB 등)
- [ ] 본문 카피 (`<br>` 위치 포함)
- [ ] 색·크기·열 순차 reveal 시점
- [ ] 기존 에셋 임시 대체안 (`price_step_card` 등)

**종료 (`--- end ---`)**

- [ ] motion 잔존 (hold / fadeOut / empty)
- [ ] panel 잔존 (title·bullet 강조 index)

### A-3. 타이밍 표기 규칙

| 표기 | 의미 | 코드 매핑 |
|------|------|-----------|
| `@title+0s` | title mp4 시작 | `tl.wait(0)` (title 구간) |
| `@title+2.1s` | title 시작 후 2.1초 | title 전용 모션 |
| `@main+0s` | main mp4 시작 | `T.main.*` · `sceneNNAtMain(0, ctx)` |
| `@main+3s` | main 시작 후 3초 | `T.main.xxx: 3000` |
| `@END-0.8s` | **해당 mp4** 끝 0.8초 전 | 퇴장·패널 hide |
| `(~N초)` (script) | 낭독 구간 힌트 | → `@main+N*1000` flash로 변환 |

**규칙**

1. **모션·패널 flash는 동일 기준** (`@main+` 또는 `@title+` 하나로 통일)
2. title+main 2단 음성: title 구간 모션은 `@title+`, 본문은 `@main+`
3. script의 `(~N초)`만 두고 motion/panel에 시점을 안 적지 **않는다** ( drift 발생 — 씬1도 시나리오 14초 vs 코드 11.5초 사례 )

### A-4. 에셋 키 → templateId

| 에셋키 | templateId |
|--------|------------|
| `base_business` | `base_business_icon` |
| `autoship` | `autoship_icon` |
| `recommend_bonus` | `recommend_bonus_icon` |
| `discount_benefit` | `discount_benefit_icon` |
| `cashback` | `cashback_icon` |
| `calendar_month` | `calendar_month_card` |
| `effect_plus` | `effect_plus_icon` |
| `member` | `member_icon` |
| `price_step` | `price_step_card` |
| `subscription_flow` | `subscription_flow_card` |
| `discount_summary` | `autoship_discount_summary_card` |

전체: [§3 에셋 디자인 시스템](#3-에셋-디자인-시스템)

**모션 행 필드 (한 단계)**

```text
@main+3s  show badge.autoship #s02-autoship @zone d4 scale 0.88
          animate badge.enter+unfold
```

| 필드 | 필수 | 예 |
|------|------|-----|
| 시점 | ✅ | `@main+3s` |
| 동작 | ✅ | `show` · `hide` · `animate` · `reveal` |
| 종류.에셋키 | ✅ | `badge.autoship` |
| `#id` | ✅ | `#s02-autoship` |
| `@zone` | ✅ (그룹 제외) | `@zone d4` |
| `scale` | 권장 | `scale 0.88` |
| `animate` | ✅ | `badge.fold` · `fade.in` · `reveal col 2` |

### A-5. guide01 제작용 씬 양식 (확장)

```text
## Scene NN
@scene NN
@title {패널 H2 제목}
@voice guide01_scene_NN.mp4
@voiceTitle guide01_scene_NN_title.mp4    ← 단일 mp4면 생략
@mediaBase main                           ← motion·panel 타이밍 기준 (title | main)
@duration auto

--- script ---
{음성 원고 — 구간 (~N초) 에 main/title 기준 주석}

--- motion ---
@title+0s  mount standardStage
@title+0s  show unit.member #sNN-member @zone d4
           animate pop.in
           note title 구간에만 등장 (main 시작 전 유지 또는 fade)

@main+0s   show badge.autoship #sNN-autoship @zone d4 scale 0.88
           animate badge.enter+unfold
@main+3s   animate badge.autoship fold
@main+3s   show asset.discount_summary #sNN-summary @zone d4
           layout stack-below #sNN-autoship overlap 12px
           state empty
@main+6s   reveal asset.discount_summary col 1
@main+7s   reveal col 2
@main+8s   reveal col 3
@main+9s   reveal col 4
@main+12s  show badge.base_business #sNN-base @zone d4 layout below #sNN-summary
           label "BASE 사업자 기준"
           animate badge.enter+unfold
@main+15s  show badge.cashback #sNN-cashback …
@main+18s  show badge.recommend_bonus #sNN-recommend …

--- panel ---
@main+0s   title {패널 H2}
@main+0s   bullets init
           - bullet 0 텍스트
           - bullet 1 텍스트
           - bullet 2 텍스트
           - (선택) subline 또는 bullet 3
@main+4000  flash bullet 0
@main+19000 flash bullet 1
@main+33000 flash bullet 2

--- assets-new ---
discount_summary:
  kind: MORE SUB ASSET
  templateId: autoship_discount_summary_card   ← 가칭, asset_design.asp 시안 후 확정
  copy:
    col1: -25% 회원가
    col2: + 20% 추가 할인
    col3: = 오토십 할인가
    col4: = 제품 경험 & 추천 활동
  style: autoship_icon 동일 톤 박스, 4열 세로 또는 가로
  reveal: @main+6s col1 → +1s 간격

--- end ---
motion: 세로 스택 유지 (fadeOut 없음)
panel: title visible, bullet 2 emphasized
```

### A-6. 기획문 → 제작용 변환 (예: Scene 02)

**기획문 (입력)** — 음성 + 번호 모션 + 텍스트박스 3블록.

**변환 시 체크**

| 기획문 | 제작용에 추가 |
|--------|----------------|
| 「타이틀 음성 0초~」 | `@voiceTitle` 유무 · `@title+0s` vs `@main+0s` 확정 |
| 「(3초~)」 | `@main+3s` (기준선 `@mediaBase` 와 일치) |
| 「오토십 할인가 정리 에셋」 | `--- assets-new ---` + templateId · 4열 카피 · reveal 시점 |
| 「접혀지고 겹쳐서」 | `animate badge.fold` + `layout overlap Npx` |
| 「1,2,3열 순 표시」 | `reveal col 1` `@main+6s` … 각 열 시점 |
| 텍스트박스 bullet | `bullets init` + `@main+N flash bullet index` |
| 「캐시백 & …」 한 줄 | bullet 3 vs subline — 기획에서 확정 |

### A-7. 작성 규칙

1. 씬 분할 = **강의 주제** 기준 (에셋 개수 X)
2. 작성 순서: **script → motion → panel → assets-new → end**
3. mp4 확정 후 `@main+*` · `@END-*` · flash를 constants `T.main` · `panel.flashes`에 반영 ([§7-6](#7-6-constants-설계))
4. 기획문과 제작용 시나리오 **둘 다 보관** — 기획문은 의도, 제작용은 구현 계약
5. 패널 UX: bullet flash(씬1) vs title+desc+순차 reveal — [§7-9](#7-9-패널-패턴-선택) 에서 씬별 1개 선택

### A-8. 간단 양식 (단일 mp4 · 존 1~2개)

```text
## Scene NN
@scene NN
@title {패널 제목}
@voice guide01_scene_NN.mp4
@mediaBase main
@duration auto

--- script ---
{음성 원고}

--- motion ---
@main+0s  mount standardStage
@main+0s  show badge.autoship #sNN-autoship @zone d4
          animate badge.enter+unfold
@END-0.8s animate canvas.fadeOut

--- panel ---
@main+0s  title {핵심 주제}
@main+0s  bullets init · …
@main+3000 flash bullet 0

--- end ---
motion: fadeOut 후 empty
panel: title hidden
```

---

## 7. guide01 씬 추가 가이드

> guide01 시리즈에 **Scene 02, 03 …** 을 순차 추가할 때 따르는 표준 절차.  
> **참조 구현:** `includes/series/guide01/scenes/scene01.*`

### 7-1. 핵심 개념

| 용어 | 의미 |
|------|------|
| **Scene NN** | 파일·음성 이름의 2자리 번호 (`01`, `02` …) |
| **scene index** | `SceneRunner` 등록 순서의 0-based 인덱스 (Scene 02 → index `1`) |
| **씬 3요소** | ① `#motion-canvas` 모션 ② `#lo-panel` 텍스트 ③ `#scene-media` 음성 |
| **씬 3파일** | `constants` · `setup` · `js` (권장, 씬1과 동일) |

**원칙**

1. 시나리오(§6) → 음성 mp4 → constants 타이밍 → setup → js 순으로 제작
2. 존 에셋은 `Guide01.addZonedAsset` / `addZonedBadge`로만 마운트 ([§5](#5-존-애니메이션-규칙))
3. `canvas.appendChild` 직접 배치 금지 (그룹 레이아웃 예외는 setup 모듈 내부에서만)
4. 신규 HTML 에셋은 [§3-3](#3-3-신규-에셋-추가-절차) + `guide01_templates.asp` 등록

### 7-2. 추가 체크리스트 (전체)

**기획**

- [ ] §6 형식 시나리오 초안 (script → motion → panel → end)
- [ ] 사용 에셋·존·패널 UX 패턴 결정 ([§7-8](#7-8-패널-패턴-선택))

**파일**

- [ ] `sceneNN.constants.js.asp` — duration, media, panel, `T.*`, layout
- [ ] `sceneNN.setup.js.asp` — `setupSceneNNAssets(canvas)`
- [ ] `sceneNN.js.asp` — `Guide01SceneNN = defineScene({ … })`
- [ ] (스택 씬) `SceneNNLayout` + `sceneNNPrepStackSlot` — [§7-7 패턴 B](#패턴-b--그룹-중앙-정렬-스택-scene-0203-기본)

**배선**

- [ ] `guide01_smartguide.asp` — sceneNN 3파일 `#include`
- [ ] `guide01.asp` — `SceneRunner.registerScene(Guide01SceneNN)` (재생 순서대로)
- [ ] title 구간이 있으면 `guide01.asp` init에 title 길이 프로브 추가 ([§7-5](#7-5-음성-mp4))

**음성**

- [ ] `voice/guide_season01/guide01/` 에 mp4 배치 ([§7-4](#7-4-음성-파일))
- [ ] constants `media.fallbackMs` · `duration` 초기값 설정

**에셋**

- [ ] 기존 templateId 재사용 또는 [§3-3](#3-3-신규-에셋-추가-절차) 신규 등록
- [ ] `asset_design.asp`에서 시안 확인

**스타일**

- [ ] `#motion-canvas.sceneNN-canvas` 전용 규칙 필요 시 `_css/guide01.css` (공통 존·fold) 또는 `includes/styles.asp` (레거시 MemberUnit 등)

**검증**

- [ ] 데스크톱·모바일(900px 이하) 레이아웃
- [ ] 재생·일시정지·씬 시크·씬 경계
- [ ] bullet flash / desc 전환 타이밍이 음성과 맞는지

### 7-3. 파일·네이밍 규칙

```
includes/series/guide01/scenes/
├── sceneNN.constants.js.asp   → SceneNNConfig
├── sceneNN.setup.js.asp       → setupSceneNNAssets(canvas)
└── sceneNN.js.asp             → Guide01SceneNN (defineScene)
```

| 심볼 | 규칙 | 예 (Scene 02) |
|------|------|----------------|
| Config 객체 | `SceneNNConfig` | `Scene02Config` |
| defineScene | `Guide01SceneNN` | `Guide01Scene02` |
| setup 함수 | `setupSceneNNAssets` | `setupScene02Assets` |
| canvas 클래스 | `sceneNN-canvas` | `scene02-canvas` |
| wrap/에셋 id | `sNN-…` | `s02-autoship` |
| defineScene id | `guide01-scene-NN` | `guide01-scene-02` |

### 7-4. 페이지·런타임 배선

**① `series/season01/guide01_smartguide.asp`**

씬 파일 include를 **constants → setup → js** 순으로 추가한다. `guide01.asp`보다 **앞**에 둔다.

```html
<!--#include virtual="/includes/series/guide01/scenes/scene02.constants.js.asp"-->
<!--#include virtual="/includes/series/guide01/scenes/scene02.setup.js.asp"-->
<!--#include virtual="/includes/series/guide01/scenes/scene02.js.asp"-->
```

**② `includes/series/guide01/guide01.asp`**

등록 순서 = 재생 순서 = 음성 scene index.

```javascript
SceneRunner.registerScene(Guide01Scene01);
SceneRunner.registerScene(Guide01Scene02);
// …
```

**③ init 흐름**

```
SeriesGuide01.init()
  → SceneRunner.registerScene(…)
  → SceneMedia.setSeriesId('guide01')
  → (선택) title 구간 프로브 — §7-5
  → SceneMedia.applyDurations(scenes)   /* 모든 씬 duration 자동 측정 */
  → SceneRunner.init()
```

`applyDurations`는 등록된 **모든 씬**의 mp4 길이를 합산해 `scene.duration`을 갱신한다. 타임라인 마커·총 재생 시간도 자동 반영된다.

### 7-5. 음성 (mp4)

**저장 위치**

```
voice/guide_season01/guide01/
├── guide01_scene_01_title.mp4   /* part=title (선택) */
├── guide01_scene_01.mp4         /* part=main 또는 단일 */
├── guide01_scene_02_title.mp4
├── guide01_scene_02.mp4
└── …
```

**스트리밍 URL** (`SceneMedia.getMediaPath`)

| 씬 | index | main | title |
|----|-------|------|-------|
| Scene 01 | `0` | `…&scene=01` | `…&scene=01&part=title` |
| Scene 02 | `1` | `…&scene=02` | `…&scene=02&part=title` |

**constants — 단일 mp4 (일반)**

```javascript
var Scene02Config = {
  duration: 28000,
  media: {
    /* mediaSequence 생략 → scene index 기준 단일 mp4 */
    fallbackMs: [28000]  /* applyDurations용, 씬별 배열 아님 — scene.duration 직접 설정 */
  }
};
```

`defineScene`에 `mediaSequence` 없이 `duration`만 두면 `SceneMedia.play(index)`로 단일 파일 재생.

**constants — title → main 순차 (씬1 패턴)**

```javascript
media: {
  sequence: [
    { part: 'title', file: 'guide01_scene_02_title.mp4' },
    { part: 'main',  file: 'guide01_scene_02.mp4' }
  ],
  fallbackMs: [2000, 26000],
  titleMs: 0   /* 런타임 프로브로 채움 */
}
```

`defineScene`:

```javascript
mediaSequence: Scene02Config.media.sequence,
mediaFallbackMs: Scene02Config.media.fallbackMs,
```

**타이밍 기준**

| 구간 | 모션 `tl.wait` 기준 | 패널 flash 기준 |
|------|---------------------|-----------------|
| title만 | `0` ~ `titleMs` | `at: 0` … `titleMs` |
| main 본문 | `titleMs + T.main.*` | `atMain` + `sceneNNTitleMs(ctx)` |

헬퍼 패턴 (씬1과 동일):

```javascript
function scene02TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  return Scene02Config.media.titleMs || Scene02Config.media.fallbackMs[0] || 0;
}
function scene02AtMain(mainMs, ctx){
  return scene02TitleMs(ctx) + mainMs;
}
```

**guide01.asp — title 프로브 (title 구간 씬마다)**

씬1 init은 index `0` 전용이다. 씬2+에 title 구간이 있으면 **해당 index**에 대해 동일 프로브를 추가한다.

```javascript
function probeTitleMs(sceneIndex, config, sceneObj, done){
  if(!SceneMedia.probeDurationPath) return done();
  SceneMedia.probeDurationPath(
    SceneMedia.getMediaPath(sceneIndex, 'title'),
    config.media.fallbackMs[0]
  ).then(function(ms){
    if(ms > 0){
      config.media.titleMs = ms;
      if(sceneObj) sceneObj.mediaTitleMs = ms;
    }
    done();
  });
}
```

title 파일이 없으면 `SceneMedia.filterSequence`가 title 파트를 제외하고 main만 재생한다.

### 7-6. constants 설계

```javascript
var SceneNNConfig = {
  id: 'guide01-scene-NN',
  title: '패널·플레이어에 표시할 씬 제목',
  duration: 30000,           /* mp4 프로브 전 fallback */
  canvasCls: 'sceneNN-canvas',

  media: { /* §7-5 */ },

  panel: {
    title: '…',
    bullets: ['…', '…'],     /* 또는 desc 기반 패널은 js에서 직접 */
    flashes: [               /* panelBulletTimeline용 */
      { atMain: 2000, index: 0 },
      { atMain: 8000, index: 1 }
    ]
  },

  T: {
    main: {                  /* main 음성 시작(= titleMs) 기준 ms */
      hero: 0,
      stepB: 3500
    }
  },

  layout: {                  /* setup 전용 — 존·gap·scale */
    anchorZone: 'd4',
    scales: { hero: 0.88 }
  },

  motion: {
    FADE: { duration: 420 },
    POP:  { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 }
  }
};
```

**타이밍 잡는 순서:** 음성 mp4 확정 → `@END-*` / 낭독 시점 메모 → `T.main.*` · `panel.flashes` 입력 → 브라우저에서 미세 조정.

### 7-7. setup — 에셋 마운트 패턴

`setupSceneNNAssets(canvas)`는 **에셋 DOM만** 만들고, 등장 애니메이션은 `sceneNN.js`에서 실행한다.

#### 패턴 A — 존 직접 배치 (기본·권장)

대부분의 신규 씬에 적합. 에셋마다 `@zone` 하나.

```javascript
function setupScene02Assets(canvas){
  return {
    autoship: Guide01.addZonedBadge(canvas, 'autoship_icon', 's02-autoship', 'd4', { scale: 0.88 }),
    flow:     Guide01.addZonedAsset(canvas, 'subscription_flow_card', 's02-flow', 'c4', { scale: 0.85 })
  };
}
```

#### 패턴 B — 그룹 중앙 정렬 스택 (Scene 02/03+ **기본**)

**한 앵커 존(d4 등)에 세로로 쌓이는 에셋**이 2개 이상일 때는 이 패턴을 **기본**으로 사용한다.  
에셋이 하나씩 등장할 때마다 **현재 보이는 전체 스택의 세로 중심이 inner (0,0)에 맞춰지도록** `--offset-y`를 재계산한다 (씬2와 동일).

| 참조 | 파일 |
|------|------|
| Scene 02 | `scene02.setup.js.asp` · `Scene02Layout` · `scene02PrepStackSlot` |
| Scene 03 | `scene03.setup.js.asp` · `Scene03Layout` · `scene03PrepStackSlot` · `scene03PrepProductSlot` |
| Scene 04 | `scene04.setup.js.asp` · `Scene04Layout` · `scene04PrepStackSlot` · `syncStackContentWidth` |

**setup (`SceneNNLayout` IIFE) 필수 요소**

1. `createGroup(canvas, anchorZone)` — `#sNN-stack-group` + `.sceneNN-group-inner` (width/height 0)
2. `reparentAsChild(wrap, inner)` — 존 절대좌표 제거 → `.sceneNN-group-child` + `--offset-x/y`
3. `applyLayout` — visible 항목만 측정 → `totalH` → `cursor = -totalH / 2` → 각 wrap에 `setOffset(0, cursor + h/2)`
4. `scheduleLayout(immediate)` — rAF coalesce; `bindResize` → `window.resize`
5. setup 마지막: `applyLayout` 1회 + rAF에서 `.sNN-layout-instant` 제거 (첫 배치는 transition 없음)

**js — 에셋 등장 시 (필수)**

```javascript
async function sceneNNPrepStackSlot(wrap){
  wrap.style.opacity = '0';
  showElement(wrap);                              // is-hidden 해제 → 측정 대상 포함
  SceneNNLayout.scheduleLayout(!hasVisibleSibling); // 첫 자식: immediate, 이후: rAF
  if(hasVisibleSibling) await wait(sceneNNLayoutSettleMs()); // motion.layoutTransition
  wrap.style.removeProperty('opacity');
}

async function sceneNNEnterAsset(wrap, opts){
  await sceneNNPrepStackSlot(wrap);   // ★ enter 애니 **전** 레이아웃
  await Guide01.fadeZoned(wrap, true, opts);
  Guide01.startIdleFloat(wrap);
  SceneNNLayout.scheduleLayout(false); // enter **후** 한 번 더
}
```

**크기가 바뀌는 경우** (뱃지 부착·fold·행 추가·스탬프·체크 등)에도 `scheduleLayout(false)` 호출.

**스택 자식 안의 하위 에셋** (예: Scene 03 제품 A~E)은 그룹 child가 아니라 **부모 wrap 크기만 키운다**.  
→ 하위 슬롯 prep(`scene03PrepProductSlot` 등) 후 **동일하게** `SceneNNLayout.scheduleLayout` 호출.

**CSS (`guide01.css`)**

```css
.guide01-canvas.sceneNN-canvas .sceneNN-group-child{
  position:absolute; left:50%; top:50%;
  transform:translate(calc(-50% + var(--offset-x,0px)), calc(-50% + var(--offset-y,0px)));
  transition:transform 480ms cubic-bezier(.22,1,.36,1); /* motion.layoutTransition 과 동기 */
}
.sceneNN-group-child.sNN-layout-instant { transition:none; }
```

**constants**

```javascript
layout: { anchorZone: 'd4', gaps: { stackGap: 10, /* 키별 gap */ } },
motion: { layoutTransition: 480 }
```

#### 패턴 B-1 — 그룹 상대 배치 (씬1 전용급)

멤버·추천인 **2인 배치** + canvas fit-scale 등 **비대칭·복합** 레이아웃.

- 참조: `scene01.setup.js.asp` · `Scene01Layout`
- `reparentZonedWrap` + `--offset-x/y` + `gridProportionalScale` + `mobileGaps`
- **단순 스택 씬에는 패턴 B(중앙 정렬) 사용** — 씬1급 복잡도일 때만 B-1

#### 패턴 C — 멤버·추천 (레거시)

`MemberUnit` 기반. `styles.asp`의 `.scene02-canvas` 등과 연동.

| API | 용도 |
|-----|------|
| `Guide01.mountMemberAtZone(canvas, id, zone)` | 존 멤버 + attach 슬롯 |
| `Guide01.prepareMemberAttach` / `runMemberAttachSequence` | 뱃지 부착 연출 |
| `Guide01.mountReferral` / `showReferralPair` | 나·추천인 2인 |
| `MotionMemberPromoteHero` | 메인 멤버 위치 이동 |

신규 씬은 **패턴 A(zoned template)** 를 우선하고, C는 기존 MemberUnit CSS가 꼭 필요할 때만.

#### setup 공통

```javascript
function setupSceneNNAssets(canvas){
  var assets = { /* … */ };
  /* 패턴 B: applyLayout + bindResize + rAF에서 layout-instant 제거 */
  return assets;   /* js play에서 참조 */
}
```

### 7-8. js — defineScene · play

**골격**

```javascript
var Guide01SceneNN = defineScene({
  id: SceneNNConfig.id,
  title: SceneNNConfig.title,
  duration: SceneNNConfig.duration,
  mediaSequence: SceneNNConfig.media.sequence,      /* 선택 */
  mediaFallbackMs: SceneNNConfig.media.fallbackMs,  /* 선택 */

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('sceneNN-panel');
    /* 패턴 B: Layout.unbindResize() */
    Guide01.resetScene(SceneNNConfig.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('sceneNN-panel');

    var tl = Guide01.timeline(ctx);
    Guide01.resetScene(SceneNNConfig.canvasCls);
    Guide01.mountStage(canvas, SceneNNConfig.canvasCls);

    var assets = setupSceneNNAssets(canvas);

    await Promise.all([
      runSceneNNMotion(tl, assets, ctx),
      /* 패널 — §7-9 중 택1 */
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide01.finishSceneHold(tl, ctx.sceneDuration || SceneNNConfig.duration);
  }
});
```

**`ctx` (SceneRunner가 주입)**

| 필드 | 설명 |
|------|------|
| `canvas` | `#motion-canvas` |
| `sceneIndex` | 0-based 씬 index |
| `sceneDuration` | 프로브 반영 후 ms |
| `mediaTitleMs` | title 구간 길이 (프로브) |
| `isFollowUp` | `sceneIndex > 0` |
| `isCancelled()` | 재생 중단·씬 전환 시 true |
| `reportProgress(ms)` | 플레이어 진행바 갱신 |

**모션 타임라인**

```javascript
async function runSceneNNMotion(tl, assets, ctx){
  var T = SceneNNConfig.T.main;
  var at = function(ms){ return sceneNNAtMain(ms, ctx); };

  await tl.wait(at(T.hero));
  if(ctx.isCancelled()) return;
  await Guide01.enterZonedBadge(assets.autoship, { pop: true, duration: 520 });
  Guide01.startIdleFloat(assets.autoship);
  /* … */
}
```

**취소 처리:** `await`마다 `if(ctx.isCancelled()) return;` — 장시간 연출 필수.

**씬 종료**

| 방식 | API | 용도 |
|------|-----|------|
| hold | `Guide01.finishSceneHold(tl, duration)` | 음성 끝까지 유지 (씬1·일반) |
| fade out | `Guide01.endScene(ctx, canvas, tl)` | 패널·캔버스 페이드 후 종료 |

### 7-9. 패널 패턴 선택

| 패턴 | API | 적합한 씬 |
|------|-----|-----------|
| **Bullet flash** | `Guide01.panelBulletTimeline(tl, title, bullets, flashes)` | bullet 3~5개, 음성 구간마다 **한 줄 강조** (씬1) |
| **Title + Desc + Bullets** | `panelTitle` → `panelDesc` → `panelBullets` | 제목·부연·리스트 순차 등장 |
| **Desc 교체** | `panelSwapDesc` | 같은 씬에서 설명 문단 전환 |
| **Bullet 추가** | `panelAddBullet` | 점진적으로 항목 늘리기 |

**Bullet flash flashes 배열**

```javascript
function sceneNNPanelFlashes(ctx){
  var off = sceneNNTitleMs(ctx);
  return SceneNNConfig.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

// play 내부
Guide01.panelBulletTimeline(
  tl,
  SceneNNConfig.panel.title,
  SceneNNConfig.panel.bullets,
  sceneNNPanelFlashes(ctx)
);
```

패널 DOM: [§2-3](#2-3-패널-dom-id) · bullet 강조 CSS: `_css/guide01.css` (`.is-emphasis`, `.g01-flash`).

### 7-10. Guide01 API 빠른 참조 (씬 제작)

**존·에셋**

| API | 설명 |
|-----|------|
| `addZonedAsset(canvas, templateId, elId, zone, opts)` | SUB/MORE 카드·아이콘 |
| `addZonedBadge(canvas, templateId, elId, zone, opts)` | fold 뱃지 (`_c` 시작) |
| `addZonedCalendar(canvas, elId, zone, label)` | 3개월 달력 row |
| `enterZonedBadge(wrap, opts)` | 등장 + unfold |
| `fadeZoned` / `popScaleZoned` | 등장·퇴장 |
| `moveZoned(wrap, toZone, opts)` | 존 이동 |
| `startIdleFloat` / `stopIdleFloat` | idle float (`g01-idle-float` on inner) |
| `sceneNNWaitAnimEnd(el, name, fallbackMs)` | pop → soft idle 연결 (씬4 패턴, [§8-4](#8-4-부드러운-플로팅-애니메이션)) |

**연결·부가**

| API | 설명 |
|-----|------|
| `mountConnectorSvg` / `linkZones` / `revealConnector` | 존 간 연결선 |
| `addCard` / `showCard` | 텍스트 카드 |
| `disclaimer(canvas, text)` | 하단 각주 |

**타임라인**

| API | 설명 |
|-----|------|
| `Guide01.timeline(ctx)` | `{ wait(ms), finish() }` — **절대 ms** |
| `finishSceneHold(tl, duration)` | duration까지 hold 후 finish |

templateId 전체: [§3](#3-에셋-디자인-시스템) · G01 애니 미리보기: `asset_design.asp`.

### 7-11. CSS · canvas 클래스

| 범위 | 파일 |
|------|------|
| 존 wrap/inner · badge fold · bullet flash | `_css/guide01.css` |
| 에셋 `--size` · 색 | `_css/icon_style.css` |
| 씬 전용 오버라이드 (MemberUnit 등) | `includes/styles.asp` 또는 `guide01.css` 하단 |

```javascript
Guide01.mountStage(canvas, 'sceneNN-canvas');
// → #motion-canvas.guide01-canvas.sceneNN-canvas
```

씬 전용 선택자 예: `#motion-canvas.sceneNN-canvas .sNN-hero { … }`

### 7-12. 제작 워크플로 (권장 순서)

```
1. §6 시나리오 초안
2. script 녹음 → mp4 (title/main 분리 여부 결정)
3. sceneNN.constants — panel, T.main, media
4. sceneNN.setup — setupSceneNNAssets (패턴 A부터)
5. sceneNN.js — defineScene + runSceneNNMotion
6. guide01_smartguide.asp include + guide01.asp registerScene
7. 브라우저: 재생·모바일·시크·타이밍 미세 조정
8. (필요 시) guide01.css / styles.asp
```

### 7-13. Scene 01 ↔ 신규 씬 차이

| 항목 | Scene 01 | Scene 02+ (일반) |
|------|----------|------------------|
| 레이아웃 | 그룹 상대 배치 (패턴 B-1) | 단일 존: 패턴 A · **앵커 스택: 패턴 B (중앙 정렬)** |
| 음성 | title → main 순차 | 단일 mp4 또는 동일 패턴 |
| 패널 | bullet flash 4줄 | 씬 주제에 맞게 §7-9 선택 |
| 베이스 뱃지 | `BASE 사업자 기준` 예외 | 컴포넌트 기본 `베이스 사업자` |
| init | title 프로브 index 0 | title 씬마다 index 맞춰 추가 |

씬1~4 상세·공통 프로세스: [§5-5](#5-5-guide01-scene-01--04-현행) · [§8](#8-씬14-제작-프로세스-요약).

---

## 8. 씬1~4 제작 프로세스 요약

> Scene 01~04 작업에서 정리된 **실전 패턴**. 신규 씬(Scene 05+)은 §7 절차 + 본 §8 체크리스트를 함께 따른다.

### 8-1. 3파일 역할 분담

```
constants  →  “언제·얼마나”  (T.main, panel.flashes, layout.gaps, motion 프리셋)
setup      →  “어디에·무엇을”  (DOM 마운트, SceneNNLayout, template clone)
js         →  “어떻게 움직일지”  (타임라인, prepStackSlot, 연출 함수)
```

**원칙:** setup은 **DOM만** 만든다. 등장·플로팅·순차 연출은 js에서 실행한다.

### 8-2. 에셋 활용 2경로

#### 경로 A — 존 직접 배치 (`Guide01.addZoned*`)

단독 에셋 1개 = 존 1개. 씬1 멤버·뱃지, 씬2 첫 오토십 등.

```javascript
Guide01.addZonedBadge(canvas, 'autoship_icon', 's02-autoship', 'd4', { scale: 0.88 });
Guide01.addZonedAsset(canvas, 'subscription_flow_card', 's04-flow', 'd4', { scale: 1 });
```

#### 경로 B — template clone + 스택 조합 (`SceneNNLayout.cloneFromTemplate`)

**여러 컴포넌트를 한 덩어리로 조립**할 때 (씬3 상품 슬롯, 씬4 결제·배송 박스).

```javascript
var payment = Scene04Layout.cloneFromTemplate('payment_batch_box');
var delivery = Scene04Layout.cloneFromTemplate('delivery_batch_box');
/* row / cluster / host 슬롯에 append → mountFloatChild / mountPayDelCluster */
```

| 구분 | addZoned* | cloneFromTemplate |
|------|-----------|-------------------|
| wrap | `g01-zone-wrap` 자동 | 직접 `g01-float-inner` 또는 `.guide01-asset` |
| 존 좌표 | `--zone-row/col` | 스택 `--offset-x/y` 로 대체 |
| CSS `--size` | `icon_style.css` + scale | 씬 CSS에서 `--size:min(220px,42vw)` 등 박스별 지정 |

**신규 박스형 에셋 추가 순서:** `components/*.asp` → `icon_style.css` → `guide01_templates.asp` `data-template` → setup에서 clone.

### 8-3. 그룹 중앙 정렬 스택 (패턴 B — 씬2~4 기본)

```
#g01-zone-wrap.sceneNN-stack-group          ← 앵커 존(d4) 1곳
  └── .sceneNN-group-inner                  ← width/height:0, transform-origin:center
        └── .sceneNN-group-child × N        ← position:absolute; left:50%; top:50%
              └── .g01-float-inner          ← scale(--g01-base-scale), idle float 대상
                    └── .guide01-asset
```

**레이아웃 알고리즘 (`applyLayout`)**

1. visible `.sceneNN-group-child`만 측정 (height 합산)
2. `cursor = -totalH / 2` 에서 시작 → 각 wrap 중심에 `--offset-y` 부여
3. (씬4) `fitGroupScale` + `syncStackContentWidth` — 캔버스 넘침 시 `--group-scale`, 캘린더 폭 동기화
4. `scheduleLayout(false)` — rAF coalesce (연속 호출 1회로 합침)

**에셋 등장 필수 순서 (`sceneNNPrepStackSlot`)**

```javascript
wrap.style.opacity = '0';
showElement(wrap);                                    // is-hidden 해제 → 측정 포함
SceneNNLayout.scheduleLayout(!hasVisibleSibling);     // 첫 자식: immediate
if(hasVisibleSibling) await wait(layoutTransition); // 480ms — offset 이동 대기
wrap.style.removeProperty('opacity');
await Guide01.fadeZoned(wrap, true, opts);            // 또는 enterZonedBadge
Guide01.startIdleFloat(wrap);
SceneNNLayout.scheduleLayout(false);
```

**CSS 동기화**

```css
.sceneNN-group-child {
  transform: translate(calc(-50% + var(--offset-x)), calc(-50% + var(--offset-y)));
  transition: transform 480ms cubic-bezier(.22,1,.36,1);  /* motion.layoutTransition */
}
.sceneNN-group-child.sNN-layout-instant { transition: none; }  /* 첫 applyLayout 직후 제거 */
```

**씬1 예외 (패턴 B-1):** 2인 비대칭 배치 + `gridProportionalScale` — 단순 세로 스택에는 B만 사용.

### 8-4. 부드러운 플로팅 애니메이션

#### 계층 1 — 클러스터 idle float (`Guide01.startIdleFloat`)

- 대상: `.g01-float-inner` (wrap의 `_float` 또는 querySelector)
- class: `g01-idle-float` — 3s, ±3px, `scale(var(--g01-base-scale))` 포함
- API: `startIdleFloat(wrap)` / `stopIdleFloat(wrap)` — 연출 전후 토글

#### 계층 2 — 씬4 soft idle (`s04-soft-idle-float`)

- 키프레임: ±2px, 4s — **pop 직후** 하위 요소에 적용
- 대상 예: 결제 코인 inner, 할부 뱃지+카드(`.pbb_card-slot`), pay-del·캘린더 클러스터 override
- **23s 홀드**에서 클러스터 `g01-idle-float`로 전환 시 하위 soft idle **제거** 후 통합

#### pop → idle 연결 (끊김 방지)

```javascript
el.classList.add('s04-installment-pop');
await scene04WaitAnimEnd(el, 's04-installment-pop', popDur + 80);
el.classList.remove('s04-installment-pop');
el.classList.add('s04-soft-idle-float');   // 또는 부모 슬롯에 float
```

- `animationend` + fallback timeout 병행
- pop class **제거 후** idle class 추가 (both fill 충돌 방지)

#### `g01-float-host` (opt-in)

`g01-zone-wrap`이 아닌 클러스터 wrap에 idle float를 걸 때 `zonedCore.js` `resolveWrap`이 인식하도록 클래스 추가.

```html
<div class="s04-pay-del-cluster scene04-group-child g01-float-host">
  <div class="g01-float-inner">…</div>
</div>
```

### 8-5. 레이아웃 안정화

| 상황 | ❌ 피할 것 | ✅ 권장 |
|------|-----------|--------|
| 숨김 토글 | `display:none` (슬롯 높이 변동) | `visibility:hidden` + inner `opacity:0` (코인 슬롯 `min-height` 예약) |
| 박스 확장 | pending class 즉시 제거 | `is-hidden` 해제 → rAF → pending 제거 → `layoutTransition` 대기 (배송 박스) |
| 폭 동기화 | 매 프레임 `--s04-stack-content-width` 갱신 | 2px 미만 변화 무시 + `width` CSS transition |
| 순차 연출 중 | 스텝마다 `scheduleLayout` | 루프 **밖**에서 1회, 또는 크기 변화 시점만 |
| 할부 뱃지 | card-slot flow 삽입 (타이틀 밀림) | `position:absolute; bottom:100%` — 카드 위 오버레이 |
| 할부 float | 배지만 float | `.pbb_card-slot`에 soft idle → **카드+배지 동시** |

**전역 `is-hidden`:** `opacity:0; pointer-events:none` (display 아님).  
**예외:** `.scene04-group-child.is-hidden { display:none!important }` — 스택 자식만 DOM에서 제외.

### 8-6. 하위 슬롯 prep (스택 child 내부)

스택 **child**가 아닌 **child 안의 요소**가 늘어날 때:

| 씬 | 함수 | 예 |
|----|------|-----|
| 03 | `scene03PrepProductSlot` | 상품 A~E wrap — row 너비만 키움 |
| 04 | `scene04RevealDeliveryBox` | 배송 pending 해제 + layout settle |
| 04 | `wrapFlowMonthSlots` | 월별 slot + 결제/자동결제 코인 DOM 생성 |

공통: prep 시 `opacity:0` → show → `scheduleLayout` → settle 대기 → opacity 복원.

### 8-7. Web Animations API (미세 연출)

캘린더 월 점프 등 **transform 충돌**이 잦을 때 CSS infinite 대신 WAAPI 1회 재생:

```javascript
target.animate([…], { duration, easing, fill: 'none' }).finished.then(function(){
  target.style.transform = '';
});
```

- idle float와 **동시에 같은 요소**에 걸지 않음
- 점프 중 `stopIdleFloat(calendarWrap)` → 스텝 종료 후 재시작 또는 홀드에서 통합

### 8-8. 씬별 특기 사항

**Scene 01**
- `Scene01Layout` — 멤버·혜택 **상대 offset**, canvas `--group-scale`
- `#motion-zone-grid` 유지 — grid 비율 fallback

**Scene 02**
- `mountInGroup` — addZoned 후 즉시 `reparentZonedWrap`
- fold·할인가 행 추가마다 `scheduleLayout`

**Scene 03**
- `MemberUnit` + `g01-member-stack` idle (멤버·뱃지 연동)
- `scene03PrepProductSlot` — product row 내부 순차 등장
- unavailable 스탬프 — host 내부 `g01-float-inner` 별도 float

**Scene 04**
- `mountPayDelCluster` — 결제+배송 가로 row, 배송 `s04-delivery-pending` (width:0 → transition)
- `syncStackContentWidth` — pay-del row 실측 → `--s04-stack-content-width` → 캘린더 박스 폭
- 1·4개월 코인: `결제` / `자동 결제` (`s04-flow-payment-coin-auto` 캡슐형)
- 배송 제품 `deliveryLoop.totalCycles: 2` — fade in → idle float → slide out ×2
- 캘린더 스텝: WAAPI jump + `scene04RevealPaymentCoin` (pop → soft idle)

### 8-9. 신규 씬 적용 체크리스트

- [ ] constants: `T.main`, `motion.layoutTransition`, panel flashes
- [ ] setup: `createGroup` + `SceneNNLayout` + `setupSceneNNAssets`
- [ ] js: `sceneNNPrepStackSlot` + `sceneNNLayoutSettleMs()`
- [ ] CSS: `.guide01-canvas.sceneNN-canvas` 스코프, `--size`·gap·transition
- [ ] template 등록 (`guide01_templates.asp`) — clone 사용 시
- [ ] pop/keyframe 이름 실제 `@keyframes`와 일치
- [ ] 등장 시 layout 예약 · 연출 루프 내 layout 최소화
- [ ] idle float 계층 정리 (하위 soft → 클러스터 g01-idle)
- [ ] `reset`에서 `Layout.unbindResize()` + panel class 제거
- [ ] `ctx.isCancelled()` await마다 확인

---

## 관련 파일 빠른 참조

| 파일 | 내용 |
|------|------|
| `asset_design.asp` | 6계열 시안 + G01 애니 |
| `includes/components/guide01_templates.asp` | clone template |
| `includes/motions/g01/preview.js.asp` | G01 미리보기 |
| `includes/series/guide01/scenes/sceneNN.*` | 씬별 constants · setup · js |
| `includes/sceneTransition.js.asp` | 씬 간 1s hold + 2s opacity 퇴장 |
| `includes/motions/g01/zonedCore.js.asp` | `g01-float-host`, idle float, resolveWrap |
| `includes/series/guide01/guide01.asp` | registerScene · init |
| `series/season01/guide01_smartguide.asp` | 씬 include · 페이지 진입 |
| `voice/guide_season01/guide01/` | guide01 음성 mp4 |
| `_css/icon_style.css` | 전 에셋 CSS |
| `_css/guide01.css` | 존·fold·씬별 panel |

---

*통합 문서 — ARCHITECTURE · PROJECT_RULE · ASSET_DESIGN_SYSTEM · MOTION_GRID_GUIDE · asset_animation_rull 대체*
