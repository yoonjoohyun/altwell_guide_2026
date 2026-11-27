# ALTWELL SMART GUIDE — 통합 개발 문서

> Classic ASP + Vanilla JS 교육용 인터랙티브 가이드  
> **미리보기:** `asset_design.asp` · **guide01:** `guide01_smartguide.asp` · **guide02:** `guide02_smartguide.asp` · **guide03:** `guide03_smartguide.asp` · **guide04:** `guide04_smartguide.asp` · **guide05:** `guide05_smartguide.asp`  
> **Last updated:** 2026-11-27 (§12 Guide04·05 공통 제작 가이드 — 등장 방식·간격·반응·멤버 스타일)

---

## 목차

0. [Guide01 동결 · Guide02 작업 경계](#0-guide01-동결--guide02-작업-경계)
1. [아키텍처](#1-아키텍처)
2. [프로젝트 규칙](#2-프로젝트-규칙)
3. [에셋 디자인 시스템](#3-에셋-디자인-시스템)
4. [7×7 모션 그리드](#4-77-모션-그리드)
5. [존 애니메이션 규칙](#5-존-애니메이션-규칙) — [5-A 핵심 패턴](#5-a-핵심-구현-패턴-중앙정렬--간격--패널-flash)
6. [시나리오 작성 (부록 A)](#6-시나리오-작성-부록-a)
7. [guide01 씬 추가 가이드](#7-guide01-씬-추가-가이드)
8. [씬1~5 제작 프로세스 요약](#8-씬15-제작-프로세스-요약)
9. [Guide02 현행](#9-guide02-현행)
10. [Guide03 현행](#10-guide03-현행)
11. [씬 공통 작업 — 화면 맞춤 · 클로징 · 시뮬](#11-씬-공통-작업--화면-맞춤--클로징--시뮬)
12. [Guide04·05 현행 — 모션그래픽 공통 제작 가이드](#12-guide0405-현행--모션그래픽-공통-제작-가이드)

---

## 0. Guide01 동결 · Guide02 작업 경계

Guide01 씬 01~06은 완성본으로 취급한다. Guide01에는 이후 씬 07(핵심 요약)·씬 08(클로징)이 **추가 파일로** 붙어 있다. Guide02·Guide03는 각각 전용 시리즈 폴더·CSS·템플릿만 쓴다. Guide01을 공통화·리네임·파일 이동하는 정리는 하지 않는다. 그 작업은 모션, 패널 애니메이션, 에셋 디자인, 타이밍을 바꿀 수 있다.

**공통으로 재사용하는 것(가이드 간 공유 OK):** `GuideClosePanel`, `ReadLog`, `video_runtime` / `sceneRunner` / `sceneMedia`, `_css/guide_close.css`, `includes/site_nav.asp`. 시리즈별 모션·fit·패널 flash는 각 `guideNN_common`·씬 파일에 둔다.

### 0-1. 수정 금지 (Guide01 완성본)

| 영역 | 경로 |
|------|------|
| 페이지·등록 | `guide01_smartguide.asp` (프로젝트 루트), `includes/series/guide01/guide01.asp`. `series/season01/guide01_smartguide.asp`는 루트로 보내는 redirect만 둔다 |
| 씬 01~06 | `includes/series/guide01/scenes/scene01`~`scene06` `.constants` · `.setup` · `.js` |
| 가이드 런타임 | `includes/series/guide01/guide01_common.js.asp` (`Guide01.*`) |
| 모션 | `includes/motions/g01/` |
| 화면 스타일 | `_css/guide01.css` |
| 템플릿 | `includes/components/guide01_templates.asp` 및 거기에 등록된 `includes/components/*.asp` |
| 에셋 치수·색 | `_css/icon_style.css` 중 Guide01이 쓰는 규칙 |
| 음성 | `voice/guide_season01/guide01/` |

금지 범위는 클래스 이름, `T.main`, `panel.flashes`, `layout.gaps`, fold/idle/스택 배치, 패널 flash 클래스다. Scene 07을 Guide01에 넣을 때도 위 파일을 고치지 않고 **씬 07 파일만 추가**한 뒤 include·`registerScene`만 연결한다.

### 0-2. 공용 런타임 (include만, 동작 변경 금지)

Guide02 페이지가 그대로 include할 수 있다. 여기를 고치면 Guide01 재생도 바뀐다.

`includes/video_runtime.asp`, `sceneRunner.js.asp`, `sceneMedia.js.asp`, `sceneTransition.js.asp`, `scenes/defineScene.js.asp`, `player/video_layout.asp`, `player/video_controller_*.asp`, `_css/main.css`, `_css/video_controller.css`

`SceneMedia.setSeriesId`는 페이지마다 자기 id를 넘긴다. Guide01은 `'guide01'` 고정이다.

경로 접두만 예외다. 사이트 루트에서는 접두가 빈 문자열이라 주소가 예전과 같다. 하위 폴더에 올리면 `GuideAppRoot()`와 `window.GUIDE_ROOT`가 그 폴더를 붙인다. 모션 시간·배치 계산은 바꾸지 않는다.

### 0-3. Guide02가 새로 만들 경로

Guide01 파일 안에 씬이나 CSS 선택자를 추가하지 않는다.

| 역할 | 경로 |
|------|------|
| 페이지 | `guide02_smartguide.asp` (프로젝트 루트, `guide.asp`와 같은 폴더). `series/season01/guide02_smartguide.asp`는 redirect |
| 등록·공통 | `includes/series/guide02/guide02.asp`, `guide02_common.js.asp` |
| 씬 | `includes/series/guide02/scenes/sceneNN.constants.js.asp` · `.setup` · `.js` |
| 스타일 | `_css/guide02.css` (`guide01.css`를 링크하지 않음) |
| 템플릿 | `includes/components/guide02_templates.asp` |
| 음성 | `voice/guide_season01/guide02/` (mp4는 이미 있음) |

네이밍은 Guide01과 겹치지 않게 `Guide02`, `guide02-scene-NN`, `g02-sceneNN-canvas`, `g02-sceneNN-panel`, `#s02g-…` 를 쓴다. `scene01-panel` · `Scene01Config` · `Guide01Scene01` 을 재사용하지 않는다. 두 가이드는 서로 include하지 않는다.

Guide02의 레이아웃 헬퍼는 `guide02_common`에만 둔다. `Scene02Layout`~`Scene06Layout` 을 추출하거나 `Guide01`을 공용 이름으로 바꾸지 않는다.

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
index.asp → guide.asp → guide01_smartguide.asp   (오토십)
                    → guide02_smartguide.asp   (스타트팩)
                    → guide03_smartguide.asp   (BASE사업자)
                    → asset_design.asp (에셋 시안·G01 애니)
                    → frame_layout.asp (템플릿·AssetShowcase)
         → sim.asp  → guide01|02|03_simulator.asp
         → mypage.asp
```

리스트의 영상 링크는 같은 폴더 기준 상대 경로다. `/series/season01/…` 처럼 사이트 최상위로 고정하지 않는다.

로그인 체크는 `includes/asp_utf8.asp` 끝의 `<!--#include virtual="/smart_guide_login.asp"-->`로 진입 페이지에 공통 적용된다. 네비 로고 PNG는 `/`(사이트 루트), `SMART GUIDE` 텍스트는 `GuideAppRoot()/index.asp`다.

### 1-2. 페이지 2종

| 종류 | 예 | CSS |
|------|-----|-----|
| **리스트** | `index.asp`, `guide.asp`, `sim.asp` | `_css/main.css` + 페이지별 |
| **영상** | `guide01|02|03_smartguide.asp`, `frame_layout.asp` | `main.css` + `icon_style.css` + 가이드 CSS(`guide01|02|03.css`) + `styles.asp` + `video_controller.css` (+ 클로징 시 `guide_close.css`) |
| **시뮬** | `guide01|02|03_simulator.asp` | 영상과 동일 가이드 CSS + `guide_close.css` + `simulator_layout.asp` |

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
├── guide01_smartguide.asp · guide01_simulator.asp
├── guide02_smartguide.asp · guide02_simulator.asp
├── guide03_smartguide.asp · guide03_simulator.asp
├── mypage.asp                    # 시청·복습 기록 확인
├── asset_design.asp              # 에셋 시안 + G01 애니 미리보기
├── frame_layout.asp              # 영상 템플릿 + AssetShowcase
├── voice_stream.asp              # mp4 스트리밍
├── SMART_GUIDE_DOCS.md           # 본 문서
├── series/season01/              # 예전 주소 → 루트 페이지 redirect
├── _css/
│   ├── main.css, icon_style.css, guide01.css, guide02.css, guide03.css
│   ├── guide_close.css, video_controller.css
│   └── index.css, guide.css, sim.css
├── voice/guide_season01/guide01/ · guide02/ · guide03/
└── includes/
    ├── asp_utf8.asp              # GuideAppRoot() + smart_guide_login
    ├── site_nav.asp, readLog.js.asp
    ├── sceneRunner.js.asp, sceneMedia.js.asp, motion.js.asp
    ├── scenes/defineScene.js.asp
    ├── components/               # guide01|02|03_templates · guide_close_panel.js
    ├── player/video_layout.asp
    ├── motions/g01/              # zoned · badgeFold · preview
    └── series/
        ├── guide01/  scenes/scene01~08 (클로징 08)
        ├── guide02/  scenes/scene01~09 (클로징 09)
        └── guide03/  scenes/scene01~11 (클로징 11)
```

### 1-6. 영상 페이지 Include 체인

진입 ASP는 프로젝트 루트에 둔다. include는 자식 폴더 `file="includes/…"` 만 쓴다. `virtual="/includes/…"` 와 `../` include는 쓰지 않는다. 이 IIS는 상위 폴더 include가 꺼져 있다.

```
guide01|02|03_smartguide.asp
├── file includes/asp_utf8.asp          (GuideAppRoot · login)
├── file includes/player/video_layout.asp
├── file includes/components/guide0N_templates.asp
├── file includes/components/guide_close_panel.js.asp
├── file includes/video_runtime.asp     (defineScene · sceneMedia · sceneTransition · sceneRunner · ReadLog)
├── file includes/series/guide0N/guide0N_common.js.asp
├── scene01~07.constants · setup · js
├── file includes/series/guide0N/guide0N.asp
└── SeriesGuide0N.init()
```

`series/season01/guide0N_smartguide.asp`는 쿼리를 유지한 채 `../../guide0N_smartguide.asp`로 redirect한다. 페이지 본문은 없다.

### 1-7. 배포 (사이트 루트 · 하위 폴더)

`includes/asp_utf8.asp`의 `GuideAppRoot()`가 앱 폴더를 계산한다.

| 페이지 위치 | 앱 루트 |
|-------------|---------|
| `/guide02_smartguide.asp` | 빈 문자열 → `/_css/…`, `/voice_stream.asp` |
| `/폴더/guide02_smartguide.asp` | `/폴더` |
| `/폴더/series/season01/…` | `/폴더` (`/series/` 앞까지) |

- 리스트·홈 링크, CSS, 이미지, `voice_stream.asp`는 `GuideAppRoot()` 또는 `window.GUIDE_ROOT`를 붙인다.
- 사이트 최상위 `/series/season01/…`로 고정하면, 프로젝트를 하위 폴더에 올렸을 때 본사 사이트의 `series`를 찾아 404가 난다.
- 로컬(사이트 루트)과 하위 폴더 배포는 같은 진입 파일로 연다. 리스트에서 다시 들어간다. 예전에 열린 `/series/season01/…` 탭은 그 경로에 파일이 없으면 그대로 404다.

---

## 2. 프로젝트 규칙

### 2-1. 인코딩 · SSI

- ASP: `<%@ Language=VBScript CodePage=65001 %>` + `includes/asp_utf8.asp`
- UTF-8 저장, JS 한글 리터럴 (`\uXXXX` 금지)

| 위치 | include |
|------|---------|
| 프로젝트 루트 ASP (리스트·영상 진입) | `<!--#include file="includes/…"-->` |
| `includes/` 안의 nested SSI | 그 파일 기준 자식·형제 `file="…"` |
| 금지 | `virtual="/includes/…"`, `file="../../…"` (상위 경로) |

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
| `payment_batch_box` | 3개월분 일괄 결제 박스 (씬4·5) |
| `delivery_batch_box` | 3개월분 일괄 배송 박스 (씬4) |
| `installment_mini_badge` | 카드사 할부 가능 뱃지 (씬4) |
| `product_swap_box` | 상품 A~E 슬롯 (씬3·5) |
| `unavailable_stamp` | 변경 불가 스탬프 (씬3·5) |
| `reward_plan_basis_box` | 보상 플랜 기준 + 혜택 뱃지 row (씬2 collapse) |
| `quarter_renew_summary` | 3개월 단위 자동 갱신 요약 (시안) |
| `subscription_renew_payment_box` | 3개월분 자동 결제 (시안) |

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

### 5-A. 핵심 구현 패턴 (중앙정렬 · 간격 · 패널 flash)

> guide01 씬1~5 공통. 상세 씬별 변형은 [§8](#8-씬15-제작-프로세스-요약) 참고.

#### 5-A-1. 모션 중앙 정렬

**DOM 계층 (스택 씬 기본 — Scene 02~05)**

```
#g01-zone-wrap.sceneNN-stack-group     ← 앵커 존 1곳 (보통 d4)
  └── .sceneNN-group-inner             ← width/height:0, transform-origin:center
        └── .sceneNN-group-child × N   ← left:50%; top:50%; --offset-x/y
              └── .g01-float-inner     ← scale(--g01-base-scale), idle float
```

| 패턴 | 적용 씬 | 방식 |
|------|---------|------|
| **B — 세로 스택 중앙 정렬** | 02~05 (기본) | visible 자식 높이 합산 → 세로 중심을 inner (0,0)에 맞춤 |
| **B-1 — 복합 상대 배치** | 01 전용 | 멤버 앵커 기준 수동 `--offset-x/y` + `fitGroupScale` + `alignMemberHeadToZoneTop` |
| **A — 존 직접** | 단독 1~2개 | `addZonedAsset` / `addZonedBadge` — `@zone` 1개당 1 wrap |

**중앙 정렬 알고리즘 (`layoutVerticalChain` — Scene 02~05 공통)**

```javascript
// 1) visible 항목만 measureStackItem → chain[]
// 2) totalH = Σ(height) + Σ(gapAfterKey)
// 3) cursor = -totalH / 2
// 4) 각 wrap: setOffset(wrap, 0, cursor + h/2); cursor += h + gap
```

- 앵커 존 `placeAtZone(group, 'd4')` + inner 0×0 → **그룹 기준점 = 캔버스 작업 영역 정중앙**
- child는 `translate(calc(-50% + var(--offset-x)), calc(-50% + var(--offset-y)))` — **자체 중심**이 offset 위치에 옴
- 캔버스 넘침 시 `fitGroupScale` → `--group-scale` (Scene 01·04·05). Scene 04는 `syncStackContentWidth`로 pay-del row 폭 → 캘린더 폭 동기화

**에셋 등장 시 레이아웃 순서 (`sceneNNPrepStackSlot`)**

```javascript
wrap.style.opacity = '0';
showElement(wrap);                              // is-hidden 해제 → 측정 대상 포함
SceneNNLayout.scheduleLayout(!hasVisibleSibling); // 첫 자식: immediate, 이후: rAF
if(hasVisibleSibling) await wait(layoutTransition); // 480ms — offset 이동 대기
wrap.style.removeProperty('opacity');
// → enter 애니 → startIdleFloat → scheduleLayout(false)
```

#### 5-A-2. 에셋 간격 유지

**원칙:** 간격은 **constants `layout.gaps`** 에만 정의. JS·CSS에 px 하드코딩하지 않는다.

| 메커니즘 | 역할 |
|---------|------|
| `gapAfterKey(prevKey, gaps)` | 직전·다음 항목 사이 간격. 키별 override 가능 |
| `layout.gaps.stackGap` | 기본 세로 간격 (10~12px) |
| `scheduleLayout(immediate?)` | rAF coalesce — 연속 호출 1회로 합침 |
| `beginMeasurePass(group)` | 측정 중 group opacity:0 — 깜빡임 없이 실측 |
| `motion.layoutTransition` | CSS `transform` transition과 동기 (480ms) |
| `.sNN-layout-instant` | 첫 `applyLayout` 직후 transition 없음 — rAF에서 제거 |

**씬별 gap 키 (대표)**

| 씬 | 키 | 용도 |
|----|-----|------|
| 02 | `autoshipSummaryGap`, `autoshipSummaryOverlap`, `stackGap` | 오토십↔할인가 (overlap으로 겹침), 혜택 뱃지 간격 |
| 02 | `tightenAutoshipSummaryGap(px)` | fold 후 할인가와 오토십 간격 미세 조정 (runtime) |
| 03 | `memberProduct`, `memberProductAutoship` | 멤버↔상품열 (오토십 부착 시 gap 확대) |
| 04 | `stackGap`, pay-del cluster 내부 gap | 결제·배송·캘린더 스택 |
| 05 | `introPayEp`, `calendarRow`, `calendarTight`, `dualGroup`, `productGap` | EP·캘린더·듀얼 비교·상품열 |

**간격 재계산 트리거 (필수 호출 시점)**

- 에셋 `showElement` / `is-hidden` 해제 직후 (`prepStackSlot`)
- 뱃지 fold·unfold, 할인가 행 reveal, 박스 확장, 스탬프 등 **크기 변화**
- 하위 슬롯 prep (`scene03PrepProductSlot`, `scene04RevealDeliveryBox` 등) 후
- `window.resize` (`bindResize`)
- **금지:** 순차 연출 루프 **매 스텝**마다 `scheduleLayout` (크기 변화 시점만)

**측정 특수 케이스**

- 뱃지: `measureBadgeWrap` — fold(open/closed) 상태별 높이
- 할인가 카드: `measureSummaryWrap` — visible row만 or 전 row 일시 표시 후 복원
- Scene 02 혜택 collapse: `collapseBenefitsIntoBox` — 개별 뱃지를 `reward_plan_basis_box` row로 reparent (offset 레이아웃 → in-box flex)

#### 5-A-3. 패널 bullet flash (텍스트박스 점멸)

> guide01 씬1~5 **전부** `Guide01.panelBulletTimeline` 사용. `motion-slide-up` · `panelTitle`/`panelDesc` 순차 등장은 **guide01 미사용**.

**3단계 상태 클래스**

| 클래스 | 의미 | 시각 |
|--------|------|------|
| `.is-dim` | 비강조 bullet | 마커·텍스트 `#B8BDC5` |
| `.is-emphasis` | 현재 강조 bullet (flash 후 유지) | 마커 `#0d9488` + ring, 텍스트 `#222` bold |
| `.g01-flash` | flash **순간** 1회 (680ms) | dot scale pulse + text teal tint |

**타이밍 (constants만)**

```javascript
panel: {
  bullets: ['…', '…', '…'],
  flashes: [
    { atMain: 2000, index: 0 },   // main mp4 시작 + 2s
    { atMain: 12000, index: 1 }
  ]
}
// title+main 2단: sceneNNPanelFlashes(ctx) → at = titleMs + atMain
```

**JS 흐름**

```
panelBulletTimeline:
  tl.wait(0) → setSceneTitle → panelInitBullets (전부 is-dim)
  loop: tl.wait(f.at) → panelFlashBullet(index)
    → index만 is-emphasis, 나머지 is-dim, g01-flash 1회 부여
```

**CSS:** `#lo-panel.scene01-panel` ~ `.scene05-panel` 공통 블록 (`guide01.css`). 씬별 keyframe **추가 금지**.

**Scene 02 예외:** 3번째 bullet은 `.bullet-body`(text+sub)에 flash 1회 — subline 중복 애니 방지.

**금지 · Anti-patterns**

| ❌ | ✅ |
|----|-----|
| 씬별 bullet flash keyframe | `g01-panel-bullet-dot-flash` · `g01-panel-bullet-text-flash` 공통 |
| CSS `@keyframes`에 flash delay | `panel.flashes` + `panelBulletTimeline` |
| `motion-slide-up` bullet 등장 | `panelFlashBullet` + `g01-flash` |
| title `(~N초~)`를 `atMain`에 그대로 | `sceneNNPanelFlashes(ctx)` — titleMs offset |
| 씬 전용 패널 CSS 블록 신규 작성 | `#lo-panel.sceneNN-panel` 공통 selector에 `.scene06-panel`만 추가 |

### 5-5. guide01 Scene 01 ~ 05 (현행)

| 씬 | 레이아웃 패턴 | 핵심 에셋·연출 |
|----|-------------|--------------|
| **01** | B-1 그룹 상대 배치 | 멤버 2인 + 오토십·베이스·캐시백·추천, `Scene01Layout` |
| **02** | B 세로 스택 | 오토십 fold → 할인가 4행 → 혜택 뱃지(→ `reward_plan_basis_box` collapse), `Scene02Layout` |
| **03** | B + 하위 슬롯 | 멤버 + 상품 A~E 1열 + 변경불가 스탬프, `Scene03Layout` |
| **04** | B + 가로 클러스터 | 결제·배송 박스 + 캘린더 4개월 + 할부·자동결제, `Scene04Layout` |
| **05** | B 다단계 phase | 결제탭→EP분할→캘린더→멤버·상품→듀얼비교→요약, `Scene05Layout` |

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

> 중앙정렬·간격·패널 flash 상세: [§5-A](#5-a-핵심-구현-패턴-중앙정렬--간격--패널-flash). 씬별 변형: [§8](#8-씬15-제작-프로세스-요약).

### 5-6. Anti-patterns

| ❌ | ✅ |
|----|-----|
| wrap에 enter/exit 직접 | `fadeZoned` / `popScaleZoned` |
| keyframe `scale(1)` 고정 | `scale(var(--g01-base-scale))` |
| `--zone-row/col` rAF 보간 | `moveZoned` |
| idle `motion-idle-float` on inner | `g01-idle-float` |
| `motion-slide-up`으로 bullet 등장 | `panelBulletTimeline` + `g01-flash` ([§5-A-3](#5-a-3-패널-bullet-flash-텍스트박스-점멸)) |
| pop 직후 `setTimeout`으로 idle 시작 | `animationend` 후 soft idle 연결 ([§8-4](#8-4-부드러운-플로팅-애니메이션)) |
| 코인·배지 `display:none` 토글 | `visibility`/`opacity`로 공간 예약 ([§8-5](#8-5-레이아웃-안정화)) |
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
5. 패널 UX: guide01은 **bullet flash** (`panelBulletTimeline`) — [§5-A-3](#5-a-3-패널-bullet-flash-텍스트박스-점멸)

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
- [ ] 사용 에셋·존·패널 flash 시점 ([§5-A-3](#5-a-3-패널-bullet-flash-텍스트박스-점멸))

**파일**

- [ ] `sceneNN.constants.js.asp` — duration, media, panel, `T.*`, layout
- [ ] `sceneNN.setup.js.asp` — `setupSceneNNAssets(canvas)`
- [ ] `sceneNN.js.asp` — `Guide01SceneNN = defineScene({ … })`
- [ ] (스택 씬) `SceneNNLayout` + `sceneNNPrepStackSlot` — [§7-7 패턴 B](#패턴-b--그룹-중앙-정렬-스택-scene-0203-기본)

**배선**

- [ ] `guide01_smartguide.asp` — sceneNN 3파일 `#include`
- [ ] `guide01.asp` — `SceneRunner.registerScene(Guide01SceneNN)` (재생 순서대로)
- [ ] title 구간: `media.sequence`에 `{ part: 'title', … }` 추가 (`probeAllTitleMs` 자동, [§7-5](#7-5-음성-mp4))

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

실제 주소는 `(window.GUIDE_ROOT || '') + '/voice_stream.asp?series=' + id + '&scene=' + num` 이다. 사이트 루트에서는 `GUIDE_ROOT`가 빈 문자열이다.

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

**guide01.asp — title 프로브 (자동)**

`guide01.asp` init의 `probeAllTitleMs`가 등록된 **모든 씬**을 순회하며 `media.sequence[0].part === 'title'` 이면 mp4 길이를 프로브한다. 씬별 수동 추가 **불필요**.

- title 파일 없음 → `SceneMedia.filterSequence`가 title 제외, main만 재생
- flash·모션 절대 시각 = `sceneNNTitleMs(ctx) + T.main.*` / `sceneNNPanelFlashes(ctx)`

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

#### 패턴 B — 그룹 중앙 정렬 스택 (Scene 02~05 **기본**)

2개 이상 세로 스택 → [§5-A-1](#5-a-1-모션-중앙-정렬) · [§5-A-2](#5-a-2-에셋-간격-유지) 알고리즘 적용.

| 참조 | 파일 |
|------|------|
| Scene 02 | `Scene02Layout` · `scene02PrepStackSlot` · `collapseBenefitsIntoBox` |
| Scene 03 | `Scene03Layout` · `scene03PrepStackSlot` · `scene03PrepProductSlot` |
| Scene 04 | `Scene04Layout` · `syncStackContentWidth` · `mountPayDelCluster` |
| Scene 05 | `Scene05Layout` · phase별 mount (intro / calendar / memberProduct / dual / summary) |

**setup 필수:** `createGroup` → `reparentAsChild` → `applyLayout` → `bindResize` → rAF에서 `.sNN-layout-instant` 제거.

**js 필수:** `sceneNNPrepStackSlot` (enter **전** layout settle) — [§5-A-1](#5-a-1-모션-중앙-정렬) 코드 참고.

#### 패턴 B-1 — 복합 상대 배치 (Scene 01 전용)

멤버·추천 2인 + 혜택 row + 캘린더 lateral offset. `Scene01Layout` — `fitGroupScale` + `alignMemberHeadToZoneTop`.  
단순 스택 씬에는 **패턴 B**만 사용.

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

### 7-9. 패널 — bullet flash (guide01 표준)

guide01 씬1~5는 **전부** `Guide01.panelBulletTimeline` 사용. 상세: [§5-A-3](#5-a-3-패널-bullet-flash-텍스트박스-점멸).

**flashes 배열**

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

패널 DOM: [§2-3](#2-3-패널-dom-id) · CSS·Anti-patterns: [§5-A-3](#5-a-3-패널-bullet-flash-텍스트박스-점멸).

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
| `sceneNNWaitAnimEnd(el, name, fallbackMs)` | pop → soft idle 연결 (씬4·5, [§8-4](#8-4-부드러운-플로팅-애니메이션)) |

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
4. sceneNN.setup — setupSceneNNAssets (스택 씬: 패턴 B, [§5-A](#5-a-핵심-구현-패턴-중앙정렬--간격--패널-flash))
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
| 패널 | bullet flash | 동일 — `panelBulletTimeline` |
| 베이스 뱃지 | `BASE 사업자 기준` 예외 | 컴포넌트 기본 `베이스 사업자` |
| title 프로브 | `probeAllTitleMs` 자동 (§7-5) | 동일 |

씬별 상세: [§5-5](#5-5-guide01-scene-01--05-현행) · 공통 프로세스: [§8](#8-씬15-제작-프로세스-요약).

---

## 8. 씬1~5 제작 프로세스 요약

> Scene 01~05 작업에서 정리된 **실전 패턴**. 신규 씬은 §7 절차 + [§5-A](#5-a-핵심-구현-패턴-중앙정렬--간격--패널-flash) + 본 §8 체크리스트.

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

### 8-3. 그룹 중앙 정렬 · 간격 (패턴 B)

[§5-A-1](#5-a-1-모션-중앙-정렬) · [§5-A-2](#5-a-2-에셋-간격-유지)가 **단일 기준**. 씬별 추가:

| 씬 | 추가 로직 |
|----|-----------|
| 01 | `alignMemberHeadToZoneTop`, lateral calendar offset, `gridProportionalScale` |
| 02 | `measureBadgeWrap`(fold), `measureSummaryWrap`, `collapseBenefitsIntoBox`, `tightenAutoshipSummaryGap` |
| 04 | `syncStackContentWidth`, `mountPayDelCluster`, delivery `s04-delivery-pending` |
| 05 | phase별 `stackOrder` 전환, EP coin·info badge DOM 생성, `setScale(--s05-slot-scale)` |

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

**Scene 05**
- phase mount: intro(결제탭·EP) → calendar(3개월) → memberProduct → dual(EP vs Point) → summary
- `createEpCoin` — `point_token_icon` clone + EP 라벨
- EP fly·stack rise — WAAPI/transform 연출, layout settle 후 idle
- `quarter_renew_summary` · `subscription_renew_payment_box` — template 등록(시안), 씬5는 `payment_batch_box` 재사용

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

## 9. Guide02 현행

스타트팩 알아보기. 씬 01~09(마지막은 클로징). Guide01 씬 파일·`guide01.css`·`sceneTransition.js.asp`는 수정하지 않는다.

| 씬 | id | 제목 |
|----|-----|------|
| 01 | `guide02-scene-01` | 스타트팩이란? |
| 02 | `guide02-scene-02` | 누가, 언제 구매할 수 있나요? |
| 03 | `guide02-scene-03` | 스타트팩은 두 종류 입니다. |
| 04 | `guide02-scene-04` | 스타트팩의 가장 큰 혜택 |
| 05 | `guide02-scene-05` | 추천인에게는 어떤 혜택이 있나요? |
| 06 | `guide02-scene-06` | 스타트팩과 초기 승급 |
| 07 | `guide02-scene-07` | 왜 스타트팩을 운영할까요? |
| 08 | `guide02-scene-08` | 스타트팩 핵심 내용 |
| 09 | `guide02-scene-09` | 클로징 (`GuideClosePanel`) |

공통 헬퍼는 `Guide02` (`guide02_common.js.asp`)다. `timeline.wait(ms)`는 씬 시작 시각 기준의 절대 대기. `cloneTemplate`은 `#guide02-templates`만 복제한다. 존 배치는 `placeAtZone` → `G01ZonedAnim`. 맞춤 배율은 씬 setup의 `applyFit` → `Guide02.fitGroup(..., inset)`이 `--group-scale`에 넣는다. Guide01의 세로 체인 측정(`layoutVerticalChain`)을 가져오지 않는다.

### 9-1. 타이밍

시나리오에 **타이틀 음성**이 있으면 그 시각은 타이틀 mp4 시작이다. 없으면 본문 mp4 시작이다. 본문 시각은 재생 시 `titleMs`를 더한다.

`SeriesGuide02.init`이 타이틀 mp4 길이를 재서 `config.media.titleMs`와 `scene.mediaTitleMs`에 넣는다. 측정 전에는 `media.fallbackMs[0]` / `media.titleMs`를 쓴다. 패널 flash가 본문 기준이면 이 값을 더해 넘긴다 (`guide02Scene07PanelFlashes`와 같은 방식).

### 9-2. 등장 · 퇴장 · idle

| 클래스 | 동작 |
|--------|------|
| `g02-enter` | 420ms, 아래에서 나타남 |
| `g02-idle` | 3.2s, `translateY` 0 ↔ −3px. 무한 반복 |
| `g01-zone-wrap` | 씬 종료 시 패널과 같이 2초 fade. 스택 루트에 붙인다 |

`g02-idle`과 다른 transform 애니메이션은 한 요소에 동시에 두지 않는다. 떠 있는 동안의 idle은 바깥, 등장 transform은 안쪽에 둔다. `sceneTransition.js.asp`는 고치지 않는다. wrap이 없으면 패널이 먼저 사라지고 캔버스가 한 번 더 2초 fade된다.

### 9-3. Scene 07

앵커는 d4. 스택은 세로 flex. 시각은 본문 기준(뱃지 등장만 타이틀 0초).

| 본문 시각 | 연출 |
|-----------|------|
| 타이틀 0 | 스타트팩 뱃지 |
| 0 | 이름 트랙을 접은 뒤 뱃지가 사라짐. 너비를 48px로 순간 축소하지 않음 |
| 2초 | `높은 할인 혜택` 등장 후 1.5초 유지, 840ms에 두 바퀴 돌며 원형 `!`로 바뀜. `!`는 0.2초 뒤 투명도만으로 680ms에 사라짐. 높이로 눌러 찌그러뜨리지 않음 |
| 6 / 12 / 18초 | 원형 패널 3개. 가로 한 줄, 사이 라인은 `#333`이고 idle 없음 |
| 패널 6 / 14 / 20초 | 텍스트 박스 bullet flash |

원형 패널은 떠오르는 순간부터 idle. 다음 패널이 떠오를 때 이전 패널은 idle을 끄고 색을 반전한다(크림 배경, 버건디 글자). 반전·등장·왼쪽 이동은 680ms ease-in-out. 마지막 패널은 반전하지 않고 idle을 유지한다. 왼쪽 이동은 현재 화면 위치에서 이어 붙인다. idle을 끄자마자 좌표가 튀지 않게 한다.

혜택·`!` 배경은 `#3D8BFF` → `#1554E0`, 글자는 `#FFE566`.

### 9-4. fitInset (화면 점유)

기본 그룹은 `fitInset: 0.85`(캔버스의 약 85%). 단일 플로트(뱃지·카드만) 구간은 `fitInsetFloat: 0.4`로 줄인다. 씬 03·04 constants에 명시. 씬 07은 단독 히어로를 **50%**, 씬 08은 뱃지 단독을 **가로 42% / 세로 28%** 로 맞춘 뒤 그룹은 `0.88`. 상세는 [§11-1](#11-1-화면-구성--group-scale--fitinset).

---

## 10. Guide03 현행

BASE사업자 이해하기. 씬 01~11(마지막은 클로징). Guide01·02 파일을 수정하지 않고 `includes/series/guide03/` · `_css/guide03.css` · `guide03_templates.asp`만 쓴다.

| 씬 | 제목 |
|----|------|
| 01 | BASE사업자란? |
| 02 | BASE사업자의 기본 구성 |
| 03 | BASE사업자 본인 조건 |
| 04 | 파트너 2명의 조건 |
| 05 | 오토십으로 BASE사업자 만들기 |
| 06 | S.E.P실적으로 BASE사업자 만들기 |
| 07 | 파트너 실적에서 꼭 기억할 점 |
| 08 | BASE사업자 자격과 보상 |
| 09 | BASE사업자를 늘려야 하는 이유 |
| 10 | BASE 사업자 핵심 내용 |
| 11 | 클로징 (`GuideClosePanel`) |

공통 헬퍼는 `Guide03` (`guide03_common.js.asp`). `fitGroup`이 **그룹 80% / 뱃지 단독 40%** 를 기본으로 적용한다([§11-1](#11-1-화면-구성--group-scale--fitinset)). 패널 bullet flash·타이틀 음성 `titleMs` 패턴은 Guide02와 같다.

시뮬(`guide03_simulator.js.asp`)은 STEP1~3 퀴즈 후 판정·빌드 단계로 이어지며, 완료 시 `GuideClosePanel.showSimulatorEnd`를 쓴다.

---

## 11. 씬 공통 작업 — 화면 맞춤 · 클로징 · 시뮬

영상·시뮬레이션을 새로 만들거나 고칠 때 **가이드를 가리지 않고** 반복되는 작업이다. 시리즈별 CSS·템플릿은 분리하되, 아래 규칙·모듈은 공유한다.

### 11-1. 화면 구성 — `--group-scale` · fitInset

모션 그룹은 보통 앵커 존 `d4`에 `g01-zone-wrap` 스택을 두고, inner에 **`--group-scale`** 을 걸어 캔버스 안에 맞게 줄인다. 목표: **복합 오브젝트 그룹은 화면의 약 80%(가이드에 따라 85%)**, **뱃지·한 줄 텍스트 등 단일 오브젝트는 40~50%** 로 과대해지지 않게 한다.

#### 공식 (Guide02 / Guide03 공통 개념)

```
fit = min( (canvasW × ratio) / contentW , (canvasH × ratio) / contentH )
inner.style.setProperty('--group-scale', fit)
```

`ratio`가 화면 점유율이다. content가 작을수록 scale이 커지므로, **혼자 남은 뱃지에 그룹용 0.8을 쓰면 화면을 가득 채운다** → 단독 모드 ratio를 낮춘다.

| 모드 | 권장 ratio | 의미 |
|------|------------|------|
| **그룹** (멤버+파트너, 카드 2열, 요약판 등) | **0.80 ~ 0.88** | 작업 영역의 약 80~88%를 채움 |
| **단일 플로트** (접힌 뱃지, 짧은 카피, 단독 카드) | **0.40 ~ 0.50** | 40~50%로 읽기 좋은 크기 |
| **예외 축소** (매우 작은 뱃지 히어로) | 가로·세로 비대칭 또는 `badgeAloneScale` | 씬 특수 연출 |

#### Guide03 — 자동 전환 (`Guide03.fitGroup`)

```javascript
ratio = badgeAlone(stage, badge) ? 0.4 : (groupInset || 0.8);
// badgeAlone: stage에 보이는 자식이 badge 하나뿐일 때
// 옵션: stage._g03BadgeAloneScale (예: 씬10 layout.badgeAloneScale: 0.7)
// 옵션: layout.groupInset / fitGroup(..., groupInset) — 씬08은 0.7
```

- setup에서 `Guide03.fitGroup(canvas, inner, stage, badge)` 호출 + `ResizeObserver`로 크기 변화 시 재계산.
- 뱃지만 보일 때와 그룹이 펼쳐질 때 **같은 API**로 ratio가 바뀐다. 씬 JS에서 수동 %를 하드코딩하지 않는다.

#### Guide02 — constants + float 플래그

| 설정 | 기본 | 사용 |
|------|------|------|
| `layout.fitInset` | `0.85` | 그룹 맞춤 |
| `layout.fitInsetFloat` | `0.4` | 단일 플로트 구간 |
| `Layout.setFloatActive(true\|false)` | — | 씬 03·04: 플로트 켜질 때 inset 전환 |

씬별 변형:

| 씬 | 단독 | 그룹 |
|----|------|------|
| 03·04 | `fitInsetFloat` 0.4 | `fitInset` 0.85 |
| 07 | 뱃지/혜택 히어로 **0.5** | `fitGroup(..., 0.85)` |
| 08 | 뱃지 단독 **0.42 × 0.28** (가로·세로) | `0.88` |
| 그 외 | (대부분) `fitGroup` 기본 0.85 | 동일 |

#### Guide01

세로 스택은 `layoutVerticalChain` + 필요 시 `fitGroupScale` / `minFit`(약 0.42). 에셋 개별 크기는 `layout.scales`(대개 0.82~0.88). Guide02·03의 `fitInset` 숫자와 1:1 대응하지는 않지만, **그룹은 크게·단독은 과대하지 않게**라는 목적은 같다.

#### 제작 체크리스트 (화면 맞춤)

- [ ] 스택/스테이지를 `d4`(또는 시나리오 지정 존)에 `placeAtZone`
- [ ] inner에 `--group-scale`을 쓰는 fit 헬퍼 연결 (`Guide02.fitGroup` / `Guide03.fitGroup` / Guide01 `applyNotedFill`)
- [ ] 그룹 목표 점유 **~80%**(또는 시리즈 기본 0.85)
- [ ] 뱃지·짧은 텍스트만 남는 타이밍에 **40~50%** 모드(또는 `setFloatActive` / `badgeAlone`) 확인
- [ ] resize·자식 show/hide 후 `schedule()` / `fit` 재호출
- [ ] transform idle과 fit scale을 같은 노드에 충돌시키지 않음(idle은 float 안쪽)

---

### 11-2. 클로징 씬 — 공통 오브젝트 `GuideClosePanel`

세 가이드 모두 **마지막 씬**에서 같은 클로징 카드를 쓴다. 새 가이드를 만들 때도 이 모듈을 재사용한다.

| 가이드 | 클로징 씬 | 음성 | setup |
|--------|-----------|------|--------|
| Guide01 | Scene 08 | `guide01_scene_08_close.mp4` | `scene08.setup.js.asp` |
| Guide02 | Scene 09 | `guide02_scene_09_close.mp4` | `scene09.setup.js.asp` |
| Guide03 | Scene 11 | `guide03_scene_11_close.mp4` | `scene11.setup.js.asp` |

**모듈**

| 파일 | 역할 |
|------|------|
| `includes/components/guide_close_panel.js.asp` | `GuideClosePanel.mount` · `open` · `showSimulatorEnd` |
| `_css/guide_close.css` | 카드·버튼·시뮬 종료 스택 |

**영상 클로징 DOM (공통)**

```
.g-close (zone wrap 선택)
  └── .g-close-card
        ├── .g-close-slot[data-part=title] → 「{레슨명} 완료」
        ├── .g-close-slot[data-part=sim]   → 「Q 퀴즈 가이드로 복습하기」
        └── .g-close-slot[data-part=replay]→ 「가이드 영상 다시보기」(ghost)
```

- `mount(parent, { title, simulatorHref, hidden, titleOpen:false, zoneWrap:false })`
- 타임라인에서 `GuideClosePanel.open(slot, { ms:680, float:true })`로 슬롯을 순서대로 연다. 카드 높이와 슬롯 opacity/translateY를 **같은 시계**로 올린다.
- 퀴즈 버튼 기본 링크: `GUIDE_ROOT + '/sim.asp'` 또는 시리즈별 `guideNN_simulator.asp`.
- 다시보기: `SceneRunner.pauseLesson` → `restartLesson` → `playLesson`.

**패널 텍스트:** 우측 `#lo-panel`은 시리즈마다 「수강 완료」 카피를 constants에 둔다. 모션 카드 타이틀은 `GuideClosePanel`이 `title + ' 완료'`를 붙인다.

**하지 말 것:** 클로징 카드 HTML을 씬마다 새로 짜거나, 버튼 문구·순서를 가이드마다 다르게 만들기. 스타일만 `guide_close.css` / 시리즈 canvas 클래스로 조정한다.

---

### 11-3. 시뮬레이션 공통

| 항목 | 내용 |
|------|------|
| 레이아웃 | `includes/simulator_layout.asp` — 좌 모션 / 우 퀴즈 |
| 모션 | 해당 가이드 씬 `setup`+`run`을 **그대로** 재생 (`GuideNN.timeline` · fit 동일) |
| 완료 UI | `GuideClosePanel.showSimulatorEnd(canvas, { title, onRelearn, onWatch, onList })` |
| 완료 버튼 | 퀴즈 다시 풀기 · 교육 영상 다시 보기 · 리스트로 돌아가기 |
| 완료 fit | 카드를 캔버스의 **80%** 안에 맞춤 (`scale = min(0.8·W/w, 0.8·H/h)`) |
| 음성 | `SimVoice` · `voice/.../sim/guideNN_step_*.mp4`, 종료 `*_step_close.mp4` |
| 시청 확인 | `ReadLog.simulation(lessonId, section)` — [§11-5](#11-5-시청-확인-readlog) |

시뮬 종료 카드는 영상 클로징과 **같은 컴포넌트**이며 버튼 세트만 다르다.

---

### 11-4. 씬·시리즈 공통 제작 루틴

영상·시뮬에 새 씬을 넣을 때 반복되는 순서다.

1. **3파일:** `sceneNN.constants.js.asp` · `.setup.js.asp` · `.js.asp`
2. **constants:** `id`, `duration`, `canvasCls`/`panelCls`, `media.sequence`(title/main/close), `panel.bullets`+`flashes`, `T`(모션 시각), `layout.anchorZone`(보통 `d4`) + fit 옵션
3. **setup:** 템플릿 `cloneTemplate` → 스택 마운트 → Layout `bind`/`schedule` → assets 객체 반환
4. **js:** `defineScene` · `play`에서 `timeline.wait` 절대 시각 · `ctx.isCancelled()` · 패널 flash · fit 재호출
5. **등록:** `guideNN.asp`에 `registerScene` + smartguide/simulator 페이지 include
6. **음성:** `voice/guide_season01/guideNN/` · `voice_stream.asp` part 규칙(`title`/`main`/`close`/`sim`)
7. **CSS:** 시리즈 전용 `_css/guideNN.css`만 추가 (다른 가이드 CSS 링크 금지)
8. **시뮬 연결:** 해당 step에 config·RUN setup/run 매핑, 정답 시 `ReadLog.simulation`

**타이밍 공통**

- 타이틀 mp4가 있으면 본문 `T`·panel flash는 `titleMs`를 더한 절대 시각으로 맞춘다.
- 클로징은 `part: 'close'` 단일 파일이 흔하다.

**패널 공통**

- `setSceneTitle` / `setSceneBullets` + dim/emphasis flash 클래스(`g01-flash` / `g02-flash` / `g03-flash`).
- 가이드 common의 `panelBulletTimeline`을 우선 사용.

---

### 11-5. 시청 확인 (ReadLog)

| 파일 | 역할 |
|------|------|
| `includes/readLog.js.asp` | `ENDPOINT` → `read_ins.asp`에 Image GET |
| `includes/video_runtime.asp` | ReadLog include |
| `includes/sceneRunner.js.asp` | 씬 시작 시 `ReadLog.guideScene(lessonId, section)` |
| `guideNN_simulator.js.asp` | 단계 완료 시 `ReadLog.simulation(lessonId, section)` |

`div=m`(영상) / `div=s`(시뮬), `id_num`·`title`·`section` 쿼리. 동일 키는 세션 내 한 번만 전송.

---

### 11-6. 공통 모듈 빠른 표

| 관심사 | 모듈 | 비고 |
|--------|------|------|
| 화면 80% / 단독 40~50% | `Guide02.fitGroup` · `Guide03.fitGroup` · Guide01 fit | [§11-1](#11-1-화면-구성--group-scale--fitinset) |
| 클로징 카드 | `GuideClosePanel` | 영상 마지막 씬 + 시뮬 종료 |
| 존 배치 | `G01ZonedAnim.placeAtZone` | Guide02/03 `placeAtZone` 위임 |
| 씬 러너 | `sceneRunner.js.asp` | progress · ReadLog · 전환 |
| 음성 경로 | `sceneMedia.js.asp` · `voice_stream.asp` | seriesId별 파일명 |
| 로그인 | `asp_utf8.asp` → `/smart_guide_login.asp` | 진입 ASP 공통 |
| 네비 | `site_nav.asp` | 로고 `/` · SMART GUIDE → index |

---

## 12. Guide04·05 현행 — 모션그래픽 공통 제작 가이드

Guide04·05는 `G04Kit`(`includes/series/guide04/guide04_common.js.asp`)을 공용 도구로 쓰고, Guide05는 그 위에 `G05` 보조(`guide05_common.js.asp`)를 얹는다. 이 장은 **씬 하나에만 해당하는 내용이 아니라, 이후 모든 모션그래픽에 공통으로 적용하는 방식**만 적는다. 씬별 연출은 시나리오 문서에 둔다.

> Guide01의 §5-6·§8-5(“공간 예약”, `visibility`/`opacity`)는 **존(zone) 기반 Guide01 전용** 원칙이다. Guide04·05는 이 장의 방식(등장 시 주변이 밀리는 재배치)을 따른다.

### 12-1. 구조 · 타이밍

| 항목 | 규칙 |
|------|------|
| 파일 | 씬당 3파일: `sceneNN.constants.js.asp` · `.setup.js.asp` · `.js.asp` ([§11-4](#11-4-씬시리즈-공통-제작-루틴)) |
| 정의 | `guide04DefineScene(cfg, setup, run, layout)` — `run`은 async 함수 |
| 시각 기준 | constants의 `T`는 **본문(main) 음성 시작 기준 ms**. 타이틀 구간(`titleMs`)의 연출만 씬 시작 기준(`tl.wait`) |
| 대기 | `X = ms => guide04WaitMain(tl, C, ms, ctx)` 로 대기하고, 반환값이 true면 즉시 `return`(취소) |
| 패널 | `panel.bullets` + `flashes[{at, index}]` — 설명 문구 강조 시점은 음성 문장에 맞춘다 |
| 음성 | `voice/` 폴더의 mp4는 **수정하지 않는다.** 길이·문장 변경은 연출 시각(`T`)과 `duration`만 조정 |
| CSS | 시리즈 전용 `_css/guideNN.css`만 추가. 다른 가이드 CSS를 링크하지 않는다 |

시각은 눈대중으로 정하지 말고, 음성 문장 위치에 맞춘 뒤 **여러 시점을 캡처해 확인**한다(시점 사이를 건너뛰어도 이어지는지 확인).

### 12-2. 오브젝트 등장 방식

등장 방식은 아래 4가지로 구분해서 쓴다. **어떤 방식이든 오브젝트가 잘려 보이면 안 된다.**

| 방식 | 쓰는 경우 | 구현 |
|------|-----------|------|
| **자리 확보 팝업** (권장 기본) | 자리를 미리 잡아도 되는 오브젝트(뱃지·멤버·태그) | `opacity:0; transform:scale(.55)` → 클래스 추가로 `opacity:1; transform:none` (transition) |
| **밀림 등장** | 나타나면서 주변을 밀어야 하는 오브젝트 | 숨김 상태에서 음수 `margin`으로 자리를 없애고, 등장 시 `margin:0`으로 transition ([§12-3](#12-3-오브젝트-간격--재배치)) |
| **펼침 슬롯** (`K.grow` / `K.open`) | 높이·폭이 0→1로 열려야 하는 단순 텍스트 칩 등 | grid `0fr→1fr`. **내부에 `overflow:hidden`이 필요하므로 그림자·글로우·튀어나온 모서리가 잘린다. 뱃지·멤버·상품·에셋에는 쓰지 않는다** |
| **접힘 / 도킹** | 큰 에셋이 나타난 뒤 작아져 다른 오브젝트에 붙는 경우 | 등장(큰 크기) → 글자만 `max-width:0`으로 접기 + `transform`으로 목적 위치에 이동 (예: 오토십 → 'A') |

**잘림이 생기는 원인 두 가지**

1. **펼침 슬롯:** 자리를 0에서 열려면 내용을 감춰야 해서 `overflow:hidden`을 쓴다. 이 때문에 에셋 가장자리 효과가 모두 잘린다.
2. **SVG 기본값:** SVG는 자기 영역 밖에 그린 부분(퍼지는 링, 광선)을 기본으로 자른다. 감싸는 요소에 `overflow:visible`을 준다.

규칙:
- 에셋은 자리 확보 팝업 또는 밀림 등장을 기본으로 한다.
- 에셋이 닿는 부모에 `overflow:hidden`/`clip`을 두지 않는다.
- SVG 효과는 `overflow:visible`을 준다.
- 큰 크기로 나타났다 작아지는 연출은 확대된 모습이 이웃 오브젝트에 가리지 않도록 해당 칸의 `z-index`를 일시적으로 올린다.

**등장 후 상태 변화** (예: 일반인 → 신규 → Base 사업자): 요소를 교체하지 않고 **클래스 교체**(`g04-popin` 같은 짧은 팝 애니메이션 포함)로 변화시킨다. 변화 후 애니메이션 클래스는 제거해서 이후 재생에 영향이 없게 한다.

### 12-3. 오브젝트 간격 · 재배치

**원칙: 오브젝트는 자신의 최종 위치를 처음부터 차지하고 있으면 안 된다.** 새 오브젝트가 등장하면 기존 오브젝트가 서로 적절한 간격을 유지하며 밀려나고, 전체 그룹은 다시 중앙에 정렬되는 것이 기본 연출이다.

| 상황 | 구현 방식 |
|------|-----------|
| 같은 줄에 카드가 하나씩 늘어남 | 슬롯을 `is-hidden`(레이아웃에서 제외)으로 두고 `reveal` — 나타날 때마다 줄이 다시 중앙정렬됨 |
| 카드·그룹 **안**에서 오브젝트가 추가됨 (아래 붙기·아래 줄 등장) | 숨김 상태에서 음수 `margin`으로 자리를 비우고, 등장 시 `margin`을 0으로 (기존 오브젝트가 부드럽게 밀림) |
| 트리·표처럼 격자 구조 | `grid-template-columns/rows`를 단계별로 transition (예: 한 줄 → 두 줄 → 세 줄). 자리가 없는 줄은 `0px` |
| 한 칸에서 오브젝트를 **교체**함 (뱃지 → 다른 뱃지) | 두 요소를 같은 grid 칸(`grid-area:1/1`)에 겹쳐 두고 하나는 사라지고 하나는 나타남. 자리 이동이 없다 |

**주의**
- 음수 `margin` 값은 오브젝트 실제 높이와 맞아야 한다. 현재는 눈대중 값을 쓰고 있어 어긋나면 등장 순간 간격이 튄다. **실제 높이를 재서 margin을 계산하는 공통 함수를 만들어 쓰는 것을 권장한다(미구현).**
- 등장 중 연결선·이동 오브젝트의 위치는 전체 이동이 끝난 뒤에 계산한다(transition 중에 측정하면 어긋남). 연결선은 매 프레임 요소 위치를 다시 읽어 따라가므로, 이동이 끝나는 시각 뒤에 그리는 것이 가장 안전하다.
- 자리 확보형(투명도만 사용)은 간격이 처음부터 고정되므로, "밀려나는 연출"이 필요한 곳에는 쓰지 않는다.

**크기 변화(볼륨 확장)**

- 그룹이 커지면 화면 맞춤 배율이 줄어들어, 처음엔 크게 보이다가 오브젝트가 늘어나면 작아진다. 처음부터 완성본 크기에 맞춰 작게 보이지 않게 한다.
- 화면 맞춤은 `stage._g04GroupInset`(점유율, 기본 0.8)과 `stage._g04MaxScale`(최대 배율)로 조절한다. 오브젝트가 적을 때 너무 커지지 않도록 `MaxScale`을 둔다.
- 크기 변화는 `grid` 트랙·줄 높이 transition과 함께 쓴다(레이아웃이 변하는 프레임마다 맞춤 배율이 다시 계산된다).

### 12-4. 오브젝트 간 상호 반응

| 반응 | 도구 | 규칙 |
|------|------|------|
| **연결선** | `K.svgLayer` · `K.addPaths` · `K.drawLine` | 두 멤버 사이 점선. 선은 매 프레임 두 요소 위치를 따라가므로 이동·크기 변화를 따로 처리하지 않아도 된다. 대상이 **보이는 상태**가 된 뒤에 그린다 |
| **포인트 이동** | `K.fly(from, to, stage, {text})` | 코인이 한 오브젝트에서 다른 오브젝트로 날아감. 도착 시점에 받는 쪽 태그/뱃지를 등장·갱신 |
| **강조** | `g04-pulse`(맥동), 파란 강조 박스(`g05-key`) | 반응을 일으킨 오브젝트와 받는 오브젝트에 같은 시점에 준다 |
| **상태 전환** | 클래스 교체 | 같은 오브젝트가 역할이 바뀌는 연출(일반인 → 신규 → Base 사업자) |
| **부착** | 도킹 | 에셋이 멤버 우하단·좌하단에 겹쳐 붙음. 부착 위치는 한 화면 안에서 통일 |
| **비교 흐림** | `.is-dim` | 설명 대상이 아닌 오브젝트를 흐리게(opacity .32 + grayscale) |

규칙:
- 반응은 **원인 → 이동/연결 → 결과** 순서로 시각을 나눠서 보여준다(원인 오브젝트가 나타난 뒤 일정 시간 후 반응 시작).
- 결과가 나타나는 위치는 받는 오브젝트 위치와 일치해야 한다.
- 한 시점에 서로 다른 반응 여러 개가 겹치지 않게 시각을 분리한다.

### 12-5. 멤버 스타일 (`K.member`)

| 색 | 의미 | 코드 |
|----|------|------|
| **회색** | 일반인·고객 | `g04-nobase` (`#9aa3b2`) |
| **파랑** | 앨트웰 회원 | 기본 / `g04-up` |
| **주황** | 신규 회원(가입 월 포함 3개월 이내) | `g04-new` (`#e0802a`) |
| **짙은 초록 + Base 뱃지** | Base 사업자 본인 | `member_base_self` + Base 뱃지 |
| **옅은 초록** | 상위 Base 사업자의 하위 파트너 조건을 달성한 회원 | `member_base_partner` |

| 크기 | 변수 | 용도 |
|------|------|------|
| 기본 | `--g04-member:120px` | 단독 강조 |
| `is-sm` | `84px` | 일반 구조도 |
| `is-xs` | `64px` | 많은 멤버가 나오는 구조도 |
| `is-big` / `is-xl` | `90px` / `110px` | 카드 안 단독 멤버 (컨테이너별 CSS 변수로 지정) |

규칙:
- **Base 사업자 표시는 텍스트가 아니라 Base 뱃지 에셋**으로 한다. 멤버 하단에 5px 겹쳐 붙인다(`baseCap` / 멤버 `cap` 대체). 작은 구조도에서는 'B'만 보이는 접힌 형태를 멤버 좌하단에 붙일 수 있다.
- 멤버에 **'상위'·'하위' 같은 위치 글자를 쓰지 않는다.** 관계는 위치와 연결선으로만 보여준다.
- 새 오브젝트(신규 회원)는 등장할 때 **일반인(회색)** 으로 나온 뒤 신규(주황)로 바뀌게 한다.
- **신규 회원 아래에는 다른 회원이 있을 수 없다.** 구조도에서 신규 회원의 하위는 비워 둔다. 하위 구조가 필요하면 먼저 Base 사업자로 바꾼 뒤 하위를 붙인다.
- 한 화면에서 같은 의미의 멤버는 같은 색·같은 크기를 쓴다.
- 구조 설명은 **3명 구조에서 시작해 필요할 때 7명 구조로 확장**하는 식으로, 한 번에 완성된 구조를 보여주지 않는다.

### 12-6. 표기 · 강조 규칙

| 항목 | 규칙 |
|------|------|
| 용어 | 'Base 사업자'(띄어쓰기), '포인트'(영문 'Point' 사용 안 함) |
| 핵심 강조 | 금색 대신 **파란 강조 박스**(`g05-key`: 파란 그라디언트 + 흰 글자) |
| 정보 안내 | 붉은 뱃지(ⓘ) — 예: '본인 실적 제외' 같은 제외·주의 안내 |
| 제외 상태 | 해당 오브젝트를 **회색조**로 표현하고 스탬프로 표시 |
| 아이콘 | 의미가 정해진 아이콘(예: 지위 상승 화살표)은 그 의미에만 쓰고 다른 연출에 재사용하지 않는다 |
| 패널 문구 | 한 문장 안에서 강조할 부분만 `<em>`/`<b>`로 구분 |

### 12-7. 제작 · 검증 체크리스트

신규 모션그래픽을 만들 때 아래를 순서대로 확인한다.

1. **등장 방식:** 잘림이 생기는 방식(펼침 슬롯)을 에셋에 쓰지 않았는가? SVG에 `overflow:visible`을 줬는가?
2. **자리:** 오브젝트가 최종 위치를 미리 차지하고 있지 않은가? 새 오브젝트 등장 시 기존 것이 밀려나는가?
3. **크기:** 처음 구도가 너무 작거나 너무 크지 않은가? 확장 단계마다 맞춤 배율이 다시 계산되는가?
4. **간격:** 오브젝트 사이 간격이 단계마다 일정한가? 등장 직후 튀거나 겹치는 구간이 없는가?
5. **반응:** 원인 → 이동 → 결과 순서가 시각적으로 분리되어 있는가?
6. **멤버:** 색·크기·Base 뱃지 규칙을 지켰는가? 위치 글자가 없는가?
7. **표기:** 'Base 사업자'·'포인트' 표기, 파란 강조 박스 규칙을 지켰는가?
8. **타이밍:** 음성은 수정하지 않았는가? 전환 시점이 문장과 맞는가? 앞 장면을 충분히 보여준 뒤 다음 장면으로 넘어가는가?
9. **검증:** 시점별 캡처로 확인했는가(특히 등장 직후·전환 직후·마지막 장면)?

### 12-8. 금지 패턴

| ❌ | ✅ |
|----|-----|
| 뱃지·멤버·상품을 `K.grow`/`K.open`(펼침 슬롯)으로 등장 | 자리 확보 팝업 또는 밀림 등장 |
| 에셋의 부모에 `overflow:hidden` | `overflow:visible`, 필요한 곳은 `z-index`로 해결 |
| 닫힌 슬롯을 `is-hidden`만 붙여서 숨김 (grow 슬롯은 레이아웃에 남음) | 숨겨야 하면 `K.closeSlot` + `display:none` |
| 최종 구조를 처음부터 자리 잡아 두고 투명하게 표시 | 단계별로 줄·칸을 늘리며 재배치 |
| 연결선을 이동·크기 변화 도중에 그림 | 이동이 끝난 뒤 그림 |
| 'Base 사업자'를 글자 박스로 표시 | Base 뱃지 에셋 사용 |
| 멤버에 '상위/하위' 글자 | 위치·연결선으로 표현 |
| 금색 강조 | 파란 강조 박스 |
| 'Point' 표기 | '포인트' |
| 같은 의미의 멤버를 화면마다 다른 색·크기로 표기 | 12-5의 색·크기 규약 |
| 신규 회원 아래에 하위 회원 배치 | Base 사업자로 바꾼 뒤 하위 배치 |
| 음성 파일 수정 | 연출 시각(`T`)·`duration`만 조정 |

---

## 관련 파일 빠른 참조

| 파일 | 내용 |
|------|------|
| `asset_design.asp` | 6계열 시안 + G01 애니 |
| `includes/components/guide01_templates.asp` | guide01 clone template |
| `includes/components/guide02_templates.asp` | guide02 clone template |
| `includes/components/guide03_templates.asp` | guide03 clone template |
| `includes/components/guide_close_panel.js.asp` | 클로징·시뮬 종료 공통 UI |
| `includes/readLog.js.asp` | 시청·복습 확인 URL 호출 |
| `includes/motions/g01/preview.js.asp` | G01 미리보기 |
| `includes/series/guide01/scenes/sceneNN.*` | guide01 씬 |
| `includes/series/guide02/scenes/sceneNN.*` | guide02 씬 |
| `includes/series/guide03/scenes/sceneNN.*` | guide03 씬 |
| `includes/series/guide02/guide02_common.js.asp` | `Guide02` timeline · fitGroup · clone |
| `includes/series/guide03/guide03_common.js.asp` | `Guide03` timeline · fitGroup(80%/40%) |
| `includes/sceneTransition.js.asp` | 씬 간 1s hold + 2s opacity 퇴장. 수정하지 않음 |
| `includes/motions/g01/zonedCore.js.asp` | `g01-float-host`, idle float, resolveWrap |
| `includes/series/guide01/guide01.asp` | guide01 registerScene · init |
| `includes/series/guide02/guide02.asp` | guide02 registerScene · init |
| `includes/series/guide03/guide03.asp` | guide03 registerScene · init |
| `guide01_smartguide.asp` / `_simulator.asp` | guide01 진입 |
| `guide02_smartguide.asp` / `_simulator.asp` | guide02 진입 |
| `guide03_smartguide.asp` / `_simulator.asp` | guide03 진입 |
| `includes/asp_utf8.asp` | `GuideAppRoot()` + 로그인 include |
| `includes/site_nav.asp` | 공통 네비 |
| `voice/guide_season01/guide01/` · `guide02/` · `guide03/` | 음성 mp4 |
| `_css/icon_style.css` | 전 에셋 CSS |
| `_css/guide01.css` · `guide02.css` · `guide03.css` | 시리즈 전용 |
| `_css/guide_close.css` | 클로징·시뮬 종료 |

---

*통합 문서 — ARCHITECTURE · PROJECT_RULE · ASSET_DESIGN_SYSTEM · MOTION_GRID_GUIDE · asset_animation_rull 대체*
