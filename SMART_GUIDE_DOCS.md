# ALTWELL SMART GUIDE — 통합 개발 문서

> Classic ASP + Vanilla JS 교육용 인터랙티브 가이드  
> **미리보기:** `asset_design.asp` · **guide01:** `series/season01/guide01_smartguide.asp`  
> **Last updated:** 2026-09-21 (§6 시나리오 필수 항목 · §7 씬 추가)

---

## 목차

1. [아키텍처](#1-아키텍처)
2. [프로젝트 규칙](#2-프로젝트-규칙)
3. [에셋 디자인 시스템](#3-에셋-디자인-시스템)
4. [7×7 모션 그리드](#4-77-모션-그리드)
5. [존 애니메이션 규칙](#5-존-애니메이션-규칙)
6. [시나리오 작성 (부록 A)](#6-시나리오-작성-부록-a)
7. [guide01 씬 추가 가이드](#7-guide01-씬-추가-가이드)

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
            ├── scene01.constants.js.asp
            ├── scene01.setup.js.asp
            └── scene01.js.asp
```

### 1-6. guide01 Include 체인

```
guide01_smartguide.asp
├── virtual /includes/player/video_layout.asp
├── virtual /includes/components/guide01_templates.asp
├── virtual /includes/video_runtime.asp
├── virtual /includes/series/guide01/guide01_common.js.asp
├── scene01.constants · setup · js
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

### 5-5. guide01 Scene 01 · 02 (현행)

**Scene 01**

| 파일 | 역할 |
|------|------|
| `scene01.constants.js.asp` | media sequence (title→main), `T.main.*`, panel flashes |
| `scene01.setup.js.asp` | 멤버 그룹(d4), 상대 레이아웃, 모바일 grid scale |
| `scene01.js.asp` | title(멤버) → main(오토십~베이스) 순차 등장 |

- 그룹 앵커 `d4`, 멤버 머리 → `c4` 상단 라인 · 혜택 row 캐시백 중심

**Scene 02**

| 파일 | 역할 |
|------|------|
| `scene02.constants.js.asp` | title→main, `T.main.*`, panel 4 bullet flash |
| `scene02.setup.js.asp` | d4 세로 스택 (`Scene02Layout`) |
| `scene02.js.asp` | title(오토십) → fold → 할인가 4행 → BASE·캐시백·추천 |

**Scene 02 `T.main` (ms)**

| 시점 | 에셋 |
|------|------|
| title+0 | 오토십 unfold |
| main+3s | 오토십 fold + 할인가 빈 패널 |
| main+8~14s | 할인가 4행 순차 (+2s 간격) |
| main+21s | BASE 사업자 기준 |
| main+24s | 캐시백 |
| main+27s | 추천 보너스 |

### 5-6. Anti-patterns

| ❌ | ✅ |
|----|-----|
| wrap에 enter/exit 직접 | `fadeZoned` / `popScaleZoned` |
| keyframe `scale(1)` 고정 | `scale(var(--g01-base-scale))` |
| `--zone-row/col` rAF 보간 | `moveZoned` |
| idle `motion-idle-float` on inner | `g01-idle-float` |

### 5-7. 신규 씬 체크리스트 (모션)

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

#### 패턴 B — 그룹 상대 배치 (씬1 전용급)

여러 에셋을 **한 앵커(d4) 기준 상대 좌표**로 묶을 때. 겹침·모바일 간격 조정이 필요한 복잡 레이아웃.

- 참조: `scene01.setup.js.asp` · `Scene01Layout`
- `reparentZonedWrap` + `--offset-x/y` + `gridProportionalScale` + `mobileGaps`
- **단순 씬에 무리하게 도입하지 말 것** — 패턴 A로 충분하면 A 사용

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
  /* layout.apply / bindResize — 패턴 B일 때만 */
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
| `startIdleFloat` / `stopIdleFloat` | idle float |

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
| 레이아웃 | 그룹 상대 배치 (패턴 B) | 존 직접 (패턴 A) 권장 |
| 음성 | title → main 순차 | 단일 mp4 또는 동일 패턴 |
| 패널 | bullet flash 4줄 | 씬 주제에 맞게 §7-9 선택 |
| 베이스 뱃지 | `BASE 사업자 기준` 예외 | 컴포넌트 기본 `베이스 사업자` |
| init | title 프로브 index 0 | title 씬마다 index 맞춰 추가 |

씬1 상세 타이밍·레이아웃: [§5-5](#5-5-guide01-scene-01-현행).

---

## 관련 파일 빠른 참조

| 파일 | 내용 |
|------|------|
| `asset_design.asp` | 6계열 시안 + G01 애니 |
| `includes/components/guide01_templates.asp` | clone template |
| `includes/motions/g01/preview.js.asp` | G01 미리보기 |
| `includes/series/guide01/scenes/sceneNN.*` | 씬별 constants · setup · js |
| `includes/series/guide01/guide01.asp` | registerScene · init |
| `series/season01/guide01_smartguide.asp` | 씬 include · 페이지 진입 |
| `voice/guide_season01/guide01/` | guide01 음성 mp4 |
| `_css/icon_style.css` | 전 에셋 CSS |
| `_css/guide01.css` | 존·fold·씬별 panel |

---

*통합 문서 — ARCHITECTURE · PROJECT_RULE · ASSET_DESIGN_SYSTEM · MOTION_GRID_GUIDE · asset_animation_rull 대체*
