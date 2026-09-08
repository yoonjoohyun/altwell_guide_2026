# ALTWELL SMART GUIDE — Project Rule

> Classic ASP 기반 교육용 인터랙티브 웹 플랫폼  
> Cursor AI / 개발자 작업 시 참고하는 단일 규칙 문서  
> **시나리오 작성:** [부록 A](#부록-a-시나리오-작성-양식) (문서 맨 아래)

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 이름 | ALTWELL SMART GUIDE |
| 목적 | 신규 디슈머가 앨트웰 비즈니스 구조를 영상형 웹 인포그래픽으로 학습하고, 시뮬레이터로 복습 |
| 현재 과제 | **영상 페이지 템플릿 정리** — `frame_layout.asp` 기준으로 신규 챕터 제작 |

**사용자 흐름**

```
index.asp → guide.asp → frame_layout.asp (템플릿·에셋 데모) / ○○_smartguide.asp (영상)
         → sim.asp    → (시뮬레이터 — 준비 중)
```

---

## 2. 기술 스택

| 사용 | 미사용 |
|------|--------|
| Classic ASP (SSI), HTML, CSS, Vanilla JavaScript | React, Vue, TypeScript, npm, bundler |

**인코딩**

- ASP 첫 줄: `<%@ Language=VBScript CodePage=65001 %>`
- 공통: `includes/asp_utf8.asp` include
- 소스·문서: UTF-8 저장
- JS 문자열: 한글 리터럴 사용 (`\uXXXX` 이스케이프 금지)

**SSI 경로 규칙**

- 영상 **진입 ASP(루트)** 에서 include: `includes/…` (루트 기준)
- `includes/player/` 내부 include: 같은 폴더 기준 (`video_controller_top.asp` 등)
- **중첩 SSI에서 `../` 사용 금지** — IIS Parent Paths 비활성 시 500 오류

---

## 3. 현재 작업 구조

### 3-1. 페이지 2종

| 종류 | 예 | CSS |
|------|-----|-----|
| **리스트** | `index.asp`, `guide.asp`, `sim.asp` | `_css/main.css` + 페이지별 (`index.css`, `guide.css`, `sim.css`) |
| **영상** | `frame_layout.asp`, `○○_smartguide.asp` | `_css/main.css` + `includes/styles.asp` + `_css/video_controller.css` |

### 3-2. 영상 페이지 6구역

새 영상은 **`frame_layout.asp` 복사 → `○○_smartguide.asp`** 로 시작한다.  
(에셋 쇼케이스 데모 블록 제거 후 RUNTIME·SCENES·INIT 추가)

| 구역 | 위치 | 내용 |
|------|------|------|
| **1. HEAD** | 진입 ASP `<head>` | title, fonts, main_css, styles.asp, 영상별 CSS |
| **2. LAYOUT** | `includes/player/video_layout.asp` | 상단·4:3 모션·텍스트 패널·하단 컨트롤러 (**수정 불필요**) |
| **4. RUNTIME** | `includes/video_runtime.asp` | defineScene + motion + components + SceneMedia + SceneRunner |
| **5. SCENES** | `includes/series/…/scenes/sceneNN.js.asp` | 씬별 motion + panel |
| **6. INIT** | series 등록 + `SeriesXXX.init()` | registerScene, 메타, UI 초기화 |

**템플릿·레퍼런스:** `frame_layout.asp` (레이아웃 + 에셋 컴포넌트 쇼케이스 데모)

### 3-3. 씬 1개 = 3요소

| # | 요소 | 영역 | 산출물 |
|---|------|------|--------|
| ① | **모션** | 좌 `#motion-canvas` | `sceneNN.js.asp` → `motion` / `play` 타임라인 |
| ② | **텍스트** | 우 `#lo-panel` | `sceneNN.js.asp` → `panel` / `setSceneTitle` 등 |
| ③ | **음성** | `#scene-media` (숨김) | `voice/{seriesId}/sceneNN.mp4` 파일만 추가 |

- `SceneRunner.registerScene()` **순서(0-based)** = voice `scene01`, `scene02` … 자동 매핑
- `SceneRunner.playScene()` — **모션 `play()` + 음성 재생** 동시 실행
- 고정 도트 배경: `#motion-stage-bg` (씬 reset 시에도 유지)
- 씬별 오브젝트: `#motion-canvas` 안에만 주입

### 3-4. 플레이어 HTML 셸 (`video_layout.asp`)

```
#layout-ov
├── ① video_controller_top.asp     (#lo-bar, 뒤로·타이틀·홈)
├── ② #lo-main
│   ├── .lo-motion-zone > .lo-stage-frame > #lo-canvas
│   │   ├── #motion-stage-bg        (도트·원형 — 고정)
│   │   └── #motion-canvas          (씬별 모션)
│   └── #lo-panel                     (씬별 텍스트)
├── ③ video_controller_bottom.asp   (재생·타임라인·리스트)
├── #scene-media                      (음성 mp4)
└── video_init.asp                    (#lo-back → closePlayer)
```

**씬에서 변경 가능:** `#motion-canvas` 내부, `#lo-panel` 콘텐츠  
**씬에서 변경 금지:** `#lo-bar`, `#lo-ctrl`, 4:3 프레임 구조, zone/panel 분리

### 3-5. 모션 4계층 (씬 내부 구현)

```
Object Library (styles.asp) → Motion Primitives (motion.js.asp)
  → Motion Components (motions/) → Scene Scripts (scenes/)
  → Scene Runner (sceneRunner.js.asp)
```

| 계층 | 위치 | 역할 |
|------|------|------|
| Object Library | `styles.asp` | DOM·CSS class·배치 기준 |
| Motion Primitives | `motion.js.asp` | `enterElement`, `wait`, `fadeCanvas` … |
| Motion Components | `includes/motions/` | 2씬+ 공통 움직임 시퀀스 |
| Object 팩토리 | `motions/core/objects/` | `MemberUnit`, `CanvasStage`, `BadgeObject` |
| Scene Scripts | `series/…/scenes/` | 타임라인·motion·panel·endState |
| Scene Runner | `sceneRunner.js.asp` | 등록·순차 재생·pause/seek·진행률 |

### 3-6. 폴더 구조

```
guide_page/
├── index.asp, guide.asp, sim.asp
├── frame_layout.asp                 # 영상 페이지 템플릿 + 에셋 쇼케이스 데모
├── _css/
│   ├── main.css                     # 전역·NAV·page shell
│   ├── index.css, guide.css, sim.css
│   ├── video_controller.css         # #lo-bar, #lo-ctrl
│   └── icon_style.css               # 에셋 컴포넌트 (rank, badge …)
├── voice/{seriesId}/scene01.mp4 …
├── images/
└── includes/
    ├── asp_utf8.asp, fonts.asp, images.asp, main_css.asp
    ├── styles.asp                   # 플레이어·모션·오브젝트 CSS
    ├── video_runtime.asp            # 재생 엔진 일괄 include
    ├── motion.js.asp, sceneMedia.js.asp, sceneRunner.js.asp
    ├── scenes/
    │   ├── defineScene.js.asp       # defineScene, SceneMotion, ScenePanel
    │   └── _scene.template.js.asp   # 씬 작성 템플릿
    ├── components/                  # 에셋 HTML + asset_showcase (frame_layout 데모)
    ├── player/
    │   ├── video_layout.asp         # 영상 HTML 셸
    │   ├── video_init.asp
    │   ├── video_controller_top.asp
    │   └── video_controller_bottom.asp  (playerControls 인라인)
    ├── motions/_load.asp + core/, canvas/, member/, badge/, …
    └── series/
        └── {seriesId}/
            ├── {seriesId}.asp       # registerScene + init
            └── scenes/sceneNN.js.asp
```

### 3-7. Include 체인 (신규 영상 — `○○_smartguide.asp`)

```
○○_smartguide.asp                    ← frame_layout.asp 복사 후 데모 제거
├── includes/player/video_layout.asp
│   ├── video_controller_top.asp   (#lo-scene-label = 영상 타이틀)
│   ├── video_controller_bottom.asp
│   └── video_init.asp
├── includes/video_runtime.asp
│   ├── scenes/defineScene.js.asp
│   ├── motion.js.asp
│   ├── motions/_load.asp
│   ├── sceneMedia.js.asp
│   └── sceneRunner.js.asp
├── includes/series/{seriesId}/scenes/sceneNN.js.asp …
├── includes/series/{seriesId}/{seriesId}.asp
└── SeriesXXX.init()
```

**`frame_layout.asp` (데모 전용)** — RUNTIME·SCENES 대신 `asset_showcase.js.asp` + `AssetShowcase.init()`

---

## 4. 페이지 역할

| 파일 | 역할 |
|------|------|
| `index.asp` | 메인 진입 |
| `guide.asp` | 교육영상 리스트 |
| `sim.asp` | 시뮬레이터 리스트 |
| `frame_layout.asp` | **영상 페이지 템플릿** + 에셋 컴포넌트 쇼케이스 데모 |
| `○○_smartguide.asp` | 챕터별 영상 진입 (얇은 shell) |
| `asset_design.asp` | 오브젝트·에셋 디자인 시안 (별도) |

---

## 5. 씬 작성 API

### 5-1. defineScene (권장 — 신규 씬)

```javascript
var BaseScene01 = defineScene({
  id: 'base-scene-01',
  title: '씬 제목',
  duration: 16000,           // voice mp4 길이 우선 (applyDurations)
  mediaStartDelay: 0,        // 선택: 음성 시작 지연(ms)

  motion: {
    mountCanvas: function(canvas){ /* #motion-canvas DOM */ },
    reset: function(){ CanvasStage.reset(SceneMotion.canvas()); },
    endState: function(){}
  },

  panel: {
    reset: function(){ ScenePanel.reset(); },
    endState: function(){}
  },

  play: async function(ctx){
    var T = createSceneTiming(ctx, this._baseAnimMs);
    setActiveSceneTiming(T);
    try {
      await T.padStart();
      setSceneTitle(this.title);
      showElement('#scene-title-main');
      await MotionBadgeHeroAcquire.run(ctx, { target: badge });
      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  }
});
```

템플릿: `includes/scenes/_scene.template.js.asp`

### 5-2. 레거시 씬 객체

```javascript
var MyScene01 = {
  id, title, duration, mediaStartDelay?,
  reset(), play(ctx), endState(), _mountCanvas()
};
```

신규 씬은 `defineScene` 사용.

### 5-3. 패널 DOM ID

| ID | 용도 |
|----|------|
| `#lo-scene-label` | 영상 타이틀 (상단 `#lo-bar`, series `meta.lessonTitle`) |
| `#scene-title-main` | 씬 제목 |
| `#panel-scene-desc` | 부연 1~2문장 |
| `#scene-bullets` | bullet 리스트 |

> `#panel-fixed-title`은 제거됨 — 영상 타이틀은 상단 `#lo-scene-label`만 사용.

### 5-4. Media (음성)

```
voice/{seriesId}/scene01.mp4 … sceneNN.mp4
```

- registerScene **순서** ↔ mp4 번호 **1:1**
- `SceneMedia.applyDurations()` — mp4 메타데이터로 `duration` 자동 반영
- 재생: Play → motion + voice / Pause → 둘 다 / Seek → 씬 단위

---

## 6. Motion Component

### 6-1. 원칙

- **2씬 이상** 동일 움직임 → `includes/motions/` 컴포넌트
- `.run(ctx, overrides)` — defaults 불변, 씬별 옵션만 병합
- 씬 파일에 50줄+ private 모션 메서드 금지

### 6-2. 등록된 Motion Component

| 컴포넌트 | 파일 | 용도 |
|----------|------|------|
| `MotionCanvasStandardStage` | `canvas/standardStage` | 씬 캔버스 기본 마운트 |
| `MotionCanvasFadeOut` | `canvas/fadeOut` | 캔버스 페이드·정리 |
| `MotionCanvasTransitionMount` | `canvas/transitionMount` | 씬 전환 + 재구성 |
| `MotionMemberEnter` | `member/enter` | 멤버 등장 |
| `MotionMemberReplaceImage` | `member/replaceImage` | 이미지 교체 |
| `MotionMemberPromoteHero` | `member/promoteHero` | 히어로 이동 |
| `MotionBadgeHeroAcquire` | `badge/heroAcquire` | 배지 등장 |
| `MotionBadgeFlyToAttach` | `badge/flyToAttach` | 배지 비행·부착 |
| `MotionBadgeChildAutoshipAcquire` | `badge/childAutoshipAcquire` | 하위 오토십 |
| `MotionConnectorDraw` | `connector/draw` | SVG 연결선 |
| `MotionPanelHideBullets` | `panel/hideBullets` | bullet 숨김 |
| `MotionPanelRevealBullets` | `panel/revealBullets` | bullet 순차 등장 |
| `MotionEffectPulseHighlight` | `effect/pulseHighlight` | 하이라이트 |
| `MotionObjectFloatEnter` | `effect/floatEnter` | 순차 플로팅 |

### 6-3. 신규 씬 워크플로

```
1. SceneXX 시나리오 작성 (§12 문법)
2. voice/…/sceneXX.mp4 배치
3. scenes/sceneXX.js.asp — defineScene + motion/panel/play
4. 진입 ASP에 scene include + registerScene
5. 단독·연속·seek·Media 검수
```

---

## 7. Motion Primitive API

`motion.js.asp` — 씬·컴포넌트 내부 호출.

```
wait, showElement, hideElement, enterElement, exitElement
setSceneTitle, setSceneBullets, slideUpElement, staggerFade
fadeCanvas, transitionCanvas
createSceneTiming, sceneWait, sceneDur, setActiveSceneTiming
resetMotion, resetMotionTree, resetScene
enterMember, setRank, setAutoship, setSEP, …
```

---

## 8. 파일별 책임

| 파일 | 해야 할 일 | 하지 말 것 |
|------|-----------|-----------|
| `frame_layout.asp` | 영상 템플릿·에셋 데모 | 씬·모션 로직 (데모 제외) |
| `○○_smartguide.asp` (루트) | HEAD + layout + runtime + scenes + init | 씬 타임라인 |
| `video_layout.asp` | 고정 HTML 셸 | 씬별 콘텐츠 |
| `video_runtime.asp` | 엔진 include 묶음 | — |
| `defineScene.js.asp` | 씬 3요소 헬퍼 | 씬별 내용 |
| `scenes/sceneXX.js.asp` | motion + panel + play | keyframe 중복 |
| `series/…/01_….asp` | registerScene, meta, init | 타임라인 |
| `sceneRunner.js.asp` | 재생·seek·UI 진행률 | 오브젝트 애니메이션 |
| `video_controller_bottom.asp` | UI + playerControls | 씬 로직 |
| `styles.asp` | 플레이어·오브젝트 CSS | 씬 문구 |
| `_css/main.css` | NAV·page shell | 플레이어 모션 |

---

## 9. Object Library

오브젝트 의미를 재해석·재디자인하지 않는다.

| Object | 의미 |
|--------|------|
| Main / Child Member | 본인·하위 디슈머/사업자 |
| Rank Medal | D~FC **지위** (BASE와 별개) |
| Autoship Badge | 오토십 이용 |
| BASE Badge | BASE사업자 **자격** |
| SEP Badge | SEP 실적 (HTML) |
| Bonus Plate | 추천·후원 보너스 (HTML) |

**핵심:** BASE Badge ↔ Rank Medal **독립** — 교체·자동 승급 금지.

---

## 10. BASE사업자 이해하기

guide.asp STEP 2 — **준비 중**.  
`frame_layout.asp`를 복사해 `02_base_business_smartguide.asp`(가칭)를 만들고, `includes/series/02_base_business/` 아래에 씬·음성을 추가한다.

| Scene | 제목 (기획) |
|-------|-------------|
| 01 | BASE사업자란? |
| 02 | 비즈니스 성장의 전환점 |
| 03 | BASE사업자의 의미 |
| 04 | BASE사업자가 되는 조건 |
| 05 | BASE사업자의 첫 번째 권리 |
| 06 | 권리 소득 시스템의 출발점 |
| 07 | 핵심 요약 |

---

## 11. Cursor AI 작업 지침

**작업 전:** 시나리오 작성 → [부록 A](#부록-a-시나리오-작성-양식) / 코드 변환 → §12·`motions/`·`defineScene` 확인  
**작업 후:** 수정 파일 / 재사용 컴포넌트 / DOM ID / 테스트 방법 보고

**금지**

- React·Vue·TS·npm 마이그레이션
- `includes/player/` 내부에서 `../` nested SSI
- keyframe·Component 중복 생성
- `#motion-stage-bg` 씬 reset 시 삭제
- UI 임의 재디자인 (명시 요청 없을 때)

---

## 12. 시나리오 문법 (개발 참고)

씬 기획·코드 변환용 상세 문법. **시나리오 작성은 [부록 A](#부록-a-시나리오-작성-양식)만 사용.**

| 블록 | 역할 |
|------|------|
| `--- script ---` | 강의·나레이션 원고 (음성 mp4) |
| `--- motion ---` | 좌 `#motion-canvas` — 에셋·멤버·애니메이션 |
| `--- panel ---` | 우 `#lo-panel` — title·desc·bullets |
| `--- end ---` | 씬 종료 후 다음 씬 seek 시 잔존 상태 |

**MOTION:** `mount standardStage` · `show asset.*` / `member.*` · `animate` · `hide` · `canvas.fadeOut` · `end motion`  
**PANEL:** `title` · `desc` · `bullets`(선택) · `show` / `hide`  
**타이밍:** `@0.2s` = 씬 시작 후 초 · `@END-0.8s` = 씬 끝 0.8초 전 (mp4 길이 기준)

---

## 부록 A. 시나리오 작성 양식

> **이 부록만 보고 작성.** 업로드 → 강의 영상 **초안** 제작 → 초안 보면서 수정·완성.

**가이드 영상의 목적**  
강의 **스크립트(음성)** + **좌측 모션그래픽** + **우측 텍스트 패널**이 함께 정보를 전달한다.

| 요소 | 역할 |
|------|------|
| **음성 (mp4)** | 강의·나레이션 — 전달의 중심 |
| **모션 (좌)** | 말하는 내용을 **보여 주는** 그래픽 (에셋·멤버·연결선·강조 등) |
| **패널 (우)** | 핵심 주제·부연·bullet — **읽으며 정리**하는 텍스트 |

씬은 **에셋 개수**가 아니라 **강의 주제가 바뀌는 단위**로 나눈다. 한 씬 안에 에셋·오브젝트가 여러 개 있어도 된다.

---

### A-1. 챕터 헤더 (문서 맨 위, 1회)

```text
# {챕터명}
@lessonTitle {상단 바에 보일 영상 제목}
@series {seriesId}
@smartguide {파일명}.asp
```

| 항목 | 예 |
|------|-----|
| `@lessonTitle` | BASE사업자 이해하기 |
| `@series` | `02_base_business` (voice 폴더명) |
| `@smartguide` | `02_base_business_smartguide.asp` |

---

### A-2. 씬 양식 (씬마다 복사)

**1씬 = 강의 주제 1단락** (스크립트 + 모션 + 패널 + 음성).  
`## Scene 01`, `## Scene 02` … 로 반복한다.

```text
## Scene NN

@scene NN
@title {이 씬의 핵심 주제 — 패널 제목}
@voice sceneNN.mp4
@duration auto

--- script ---
{이 씬 음성(mp4) 스크립트 — 말할 내용 전체}

--- motion ---
@0.0s  mount standardStage
@0.3s  show asset.base_business #sceneNN-base
@0.3s  animate asset.enter #sceneNN-base
{필요 시 추가 이벤트 — hide, show, member, connector, highlight …}
@END-0.8s animate canvas.fadeOut
@END-0.4s end motion

--- panel ---
@0.3s  title {핵심 주제 — script와 같은 맥락}
@0.3s  show title
@1.0s  desc {script를 보조하는 부연 1~2문장}
@1.0s  show desc
{필요 시 bullets}
@END-1.0s hide desc
@END-0.6s hide title

--- end ---
motion: {다음 씬 seek 시 캔버스 잔존 상태 — 보통 fadeOut 후 empty}
panel: title hidden, desc hidden
```

**블록별 작성 요령**

| 블록 | 작성 내용 |
|------|-----------|
| `--- script ---` | **먼저 작성.** mp4에 실릴 나레이션·강의 원고 |
| `--- motion ---` | script를 **시각화** — 등장·강조·교체·연결선 등 시간순 |
| `--- panel ---` | script의 **핵심만 텍스트로 정리** — title·desc·bullets |
| `--- end ---` | 씬 종료·다음 씬 연결 시 유지할 상태 |

**모션에 쓸 수 있는 것 (필요한 만큼 조합)**

| 구문 | 용도 |
|------|------|
| `show asset.{키} #id` | 지위·배지 에셋 ([A-3](#a-3-에셋-목록)) |
| `show member.main` / `member.child` | 멤버 유닛 |
| `animate asset.enter` / `member.enter` | 등장 |
| `animate effect.pulseHighlight` | 강조 |
| `draw connector left\|right` | 연결선 |
| `hide #id` | 교체·정리 전 숨김 |
| `idle float #id` | 가벼운 반복 움직임 (선택) |

**패널 bullets (선택)**

```text
@3.0s  bullets
  - 핵심 포인트 1
  - 핵심 포인트 2
@3.0s  show bullets
@END-1.0s hide bullets
```

**씬 나누는 기준**

- ✅ 주제·전개가 바뀔 때 (예: 「BASE란?」 → 「되는 조건」)
- ✅ 스크립트가 한 덩어리의 메시지를 끝낼 때
- ❌ 에셋 1개 = 씬 1개 (지위 12개라고 12씬 필수 **아님**)

---

### A-3. 에셋 목록

모션 `show asset.{에셋키}` 에 사용. **씬 개수와 무관** — script·모션 기획에 맞게 골라 쓴다.  
패널 `title` / `desc` 는 **script에 맞게** 작성 (아래 표는 기본 표기 참고).

**지위 (12단계)**

| 에셋키 | title | desc |
|--------|-------|------|
| `lev_d` | D 지위 | Disumer |
| `lev_p` | P 지위 | Pioneer |
| `lev_jp` | JP 지위 | Junior Pioneer |
| `lev_sp` | SP 지위 | Senior Pioneer |
| `lev_fc` | FC 지위 | First Class |
| `lev_gc` | GC 지위 | Gold Class |
| `lev_dc` | DC 지위 | Diamond Class |
| `lev_rf` | RF 지위 | Royal Family |
| `lev_crf` | CRF 지위 | Crown Royal Family |
| `lev_mrf` | MRF 지위 | Major Royal Family |
| `lev_srf` | SRF 지위 | Special Royal Family |
| `lev_irf` | IRF 지위 | Imperial Royal Family |

**자격·서비스·보너스 (3종)**

| 에셋키 | title | desc |
|--------|-------|------|
| `base_business` | 베이스 사업자 | BASE Business |
| `autoship` | 오토십 | 20% 할인 구독 서비스 |
| `recommend_bonus` | 추천 보너스 | 추천회원 한명당 1point 책정 |

> 지위(D~IRF)와 베이스 사업자 자격은 **별개 개념** — 혼동하지 않는다.

**신규 에셋 (자격·서비스·보너스 계열)**  
목록에 없는 배지형 에셋이 필요하면 **`base_business` · `autoship` · `recommend_bonus` 아이콘의 HTML·CSS 레이아웃을 참고**해 `includes/components/` + `_css/icon_style.css`에 추가한다.  
시나리오에는 `에셋키`, `title`, `desc`, 라벨 글자(1자), `aria-label`을 함께 적는다.

#### 배지형 에셋 — 공통 HTML 구조

3종 모두 **둥근 라벨(1글자) + 텍스트**를 가로로 나열한 **캡슐형 배지**다.

```html
<div class="{이름}_icon" aria-label="{접근성 설명}">
  <div class="{이름}_label">{1글자}</div>
  <div class="{이름}_text">{한글 표기}</div>
</div>
```

| 파일 | 예 |
|------|-----|
| 컴포넌트 | `includes/components/base_business_icon.asp` |
| CSS | `_css/icon_style.css` 해당 섹션 |
| 시나리오 키 | `show asset.base_business` → templateId `base_business_icon` |

**3종 HTML·라벨 매핑**

| 컴포넌트 | 루트 class | label class | text class | 라벨 글자 |
|----------|------------|-------------|------------|-----------|
| 베이스 사업자 | `.base_business_icon` | `.base_label` | `.base_text` | B |
| 오토십 | `.autoship_icon` | `.autoship_label` | `.autoship_text` | A |
| 추천 보너스 | `.recommend_bonus_icon` | `.recommend_bonus_label` | `.recommend_bonus_text` | R |

#### 배지형 에셋 — 공통 CSS 구조

**외곽 `{이름}_icon`** (3종 동일 골격, 색상만 다름)

| 속성 | 값 |
|------|-----|
| 레이아웃 | `inline-flex`, `align-items:center`, `height:36px`, `padding:5px 7px`, `gap:5px` |
| 배경 | `linear-gradient(120deg, …)` |
| 테두리 | `box-shadow: inset 0 0 0 2px {색}` |
| 모서리 | `border-radius:10px` |
| 폰트 | `font-family: var(--font-sans, 'MinSansVF', sans-serif)` |

**원형 라벨 `{이름}_label`**

| 속성 | 값 |
|------|-----|
| 크기 | `24×24px`, `border-radius:50%` |
| 글자 | `font-size:15px`, `font-weight:700~900`, 가운데 정렬 |
| 색 | 배경색·글자색은 에셋별 지정 |

**텍스트 `{이름}_text`**

| 속성 | 값 |
|------|-----|
| 글자 | `font-size:18px`, `font-weight:700`, `line-height:18px` |
| 줄바꿈 | `white-space:nowrap` |
| 색 | 에셋별 지정 (밝은 배경 → 진한 글자, 어두운 배경 → 흰 글자) |

**3종 색상 참고**

| 에셋 | 그라데이션·테두리 톤 | 라벨 원 | 텍스트 |
|------|----------------------|---------|--------|
| base_business | 녹색 `#118839` 계열 | `#54BE12` / 흰 글자 | `#fff` |
| autoship | 남색 `#2c51ca` 계열 | `#B3B1FF` / `#0B2A91` | `#fff` |
| recommend_bonus | 금색 `#ffd738` 계열 | `#C7A417` / `#FFEEA9` | `#665308` |

#### 신규 배지형 에셋 — 시나리오에 적을 항목

```text
@assetNew {에셋키}
@assetFile {이름}_icon.asp
@assetLabel {1글자}
@assetAria {aria-label 문구}
@title / @desc  ← A-2 패널과 동일
@colors {선택: 그라데이션·라벨·텍스트 hex 요약}
```

신규 에셋 씬에서 `show asset.{에셋키}` 로 사용. A-2 `--- script ---`·패널 문구와 함께 기재.

---

### A-4. 작성 규칙

1. **씬 번호** — 01부터 빠짐없이, `@voice sceneNN.mp4` 번호와 일치
2. **씬 분할** — **강의 주제·전개** 기준; 에셋 개수로 씬 수를 맞추지 않음
3. **작성 순서** — `--- script ---` → `--- motion ---` → `--- panel ---` (음성 중심, 모션·패널은 보조)
4. **영상 제목** — `@lessonTitle`은 A-1 헤더에만; 패널에 반복하지 않음
5. **패널** — `title` 필수; `desc`·`bullets`는 script 전달에 필요할 만큼
6. **모션·패널** — 같은 씬 안에서 **같은 메시지**를 다른 방식으로 전달 (모션=보여줌, 패널=글로 정리)
7. **초안 이후** — mp4 길이 확정 후 `@END-…` 시점·문구·모션 타이밍 조정

---

### A-5. 작업 흐름

```
1. A-1 챕터 헤더 작성
2. 씬마다 script(강의 원고) 작성
3. script에 맞춰 motion·panel 타임라인 작성
4. 업로드 → 강의 영상 초안 제작
5. 초안 시청 → 스크립트·타이밍·모션·패널 수정 → 완성
```

에셋·지위 **미리보기:** `frame_layout.asp` (컴포넌트 15종 데모, 시나리오 양식과 별개)

---

*문서 끝 — 시나리오 작성은 **부록 A***
