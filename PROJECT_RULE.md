# ALTWELL SMART GUIDE ? Project Rule

> Classic ASP 기반 교육용 인터랙티브 웹 플랫폼  
> Cursor AI / 개발자가 작업 전·중에 빠르게 참고하는 단일 규칙 문서

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|------|------|
| 이름 | ALTWELL SMART GUIDE |
| 목적 | 신규 디슈머가 앨트웰 비즈니스 구조를 영상형 웹 인포그래픽으로 학습하고, 시뮬레이터로 복습 |
| 현재 우선 과제 | **BASE사업자 이해하기** 챕터를 씬 단위로 제작 → 하나의 연속 영상으로 연결 |

**사용자 흐름**

```
메인(index.asp) → 가이드 리스트(guide.asp) → 영상 재생
              → 시뮬레이터 리스트(sim.asp) → 복습
```

---

## 2. 기술 스택

**사용**
- Classic ASP, SSI, HTML, CSS, Vanilla JavaScript
- **문자 인코딩: UTF-8** (`CodePage=65001`, `<meta charset="utf-8">`)

**인코딩 규칙 (`guide_page` 전용, 상위 폴더 미변경)**
- 진입 ASP 첫 줄: `<%@ Language=VBScript CodePage=65001 %>`
- 공통 응답: `includes/asp_utf8.asp` include (`Response.CodePage` / `Response.Charset`)
- 소스·문서 파일 저장: UTF-8
- 씬·러너 JS 문자열: **한글 리터럴** 사용 (`\uXXXX` 이스케이프 사용 안 함)

**사용하지 않음**
- React, Vue, TypeScript, npm, bundler, framework state

---

## 3. 폴더 구조 (현재)

```
guide_page/
├── index.asp                      # 메인
├── guide.asp                      # 교육영상 리스트
├── sim.asp                        # 시뮬레이터 리스트
├── video_start.asp                # 레이아웃·Object Library 참고용 (정적)
├── video_base.asp                 # 공통 플레이어 템플릿
├── 01_base_business_running.asp   # BASE 챕터 영상 페이지
├── voice/
│   └── 01_base_business_running/
│       ├── scene01.mp4 … scene07.mp4
├── images/
└── includes/
    ├── images.asp                 # 이미지 경로 상수
    ├── asp_utf8.asp               # UTF-8 Response.CodePage / Charset
    ├── styles.asp                 # 전역 CSS·키프레임
    ├── motion.js.asp              # Object·Motion Library
    ├── sceneMedia.js.asp          # 씬별 mp4 재생 (voice_stream.asp 경유)
    ├── sceneRunner.js.asp         # 씬 순차 재생 엔진
    ├── playerControls.js.asp      # Play/Pause/Progress UI
    ├── player.js.asp              # 레거시 (참고용)
    ├── voice_stream.asp           # mp4 스트리밍 (IIS 정적 mp4 404 우회)
    └── series/
        └── 01_base_business_running/
            ├── 01_base_business_running.asp   # 씬 등록·초기화
            └── scenes/
                ├── scene01.js.asp
                ├── scene02.js.asp
                └── … scene07.js.asp
```

**아키텍처 흐름**

```
Object Library → Motion Library → Scene Scripts → Scene Runner → Lesson Player
```

---

## 4. 페이지 역할

| 파일 | 역할 |
|------|------|
| `index.asp` | 메인 진입 |
| `guide.asp` | 교육영상 카드 리스트 → 영상 페이지 진입 |
| `sim.asp` | 시뮬레이터 리스트 |
| `video_start.asp` | **레이아웃·오브젝트 배치·CSS class 참고 기준** (씬 미연결) |
| `01_base_business_running.asp` | **BASE 챕터 실제 재생** (`guide.asp` 진입, `#layout-ov`) |
| `video_base.asp` | 공통 플레이어 템플릿 (레거시·참고) |

> `video_start.asp`는 복사·iframe 삽입하지 않는다. DOM·비율만 참고한다.

---

## 5. 애니메이션 시스템

### 현재 표준 (사용)

| 계층 | 파일 | 역할 |
|------|------|------|
| 스타일 | `styles.asp` | 레이아웃, Object, keyframe, 상태 클래스 |
| 모션 API | `motion.js.asp` | 재사용 모션·오브젝트 상태 함수 |
| 씬 | `scenes/sceneXX.js.asp` | 씬별 타임라인·패널 텍스트·endState |
| 러너 | `sceneRunner.js.asp` | 씬 등록, 순차 재생, pause/resume/seek, 진행률 |
| 미디어 | `sceneMedia.js.asp` | 씬별 mp4 재생·duration 프로브 |
| 컨트롤 | `playerControls.js.asp` | 버튼·시크바 UI 연결 |

### 레거시 (참고만, 삭제 금지)

- `includes/player.js.asp` ? EVS + `requestAnimationFrame` 기반 구 플레이어
- `index.asp.bak` ? 구조 참고

---

## 6. Motion API

```
wait, showElement, hideElement, activateElement, deactivateElement
enterElement, exitElement, acquireElement, softAcquireElement, enterMember
setRank, replaceRank, setAutoship, setSEP, completeCondition
setRecommendBonus, setSupportBonus
setSceneTitle, setSceneBullets, slideUpElement, staggerFade
fadeCanvas, transitionCanvas
resetMotion, resetMotionTree, resetScene
softAcquireElement (옵션: hero, glow)
```

**Keyframe / 클래스:** `kf-enter`, `kf-soft-enter`, `kf-soft-acquire`, `kf-acquire`, `kf-glow-once`, `kf-badge-hero-enter`, `kf-rank-out`, `kf-rank-in`, `kf-slide-up`, `kf-check-pop`, `kf-stagger-item`, `kf-idle-float`, `kf-highlight-pulse`

> 새 Keyframe·Motion API는 **필요 시에만** `motion.js.asp` / `styles.asp`에 **한 곳** 추가한다. 씬 파일에 중복 정의하지 않는다.

---

## 7. 파일별 책임 (Do / Don't)

| 파일 | 해야 할 일 | 하지 말 것 |
|------|-----------|-----------|
| `images.asp` | 이미지 경로 상수 | 애니메이션·씬 로직 |
| `styles.asp` | 레이아웃, Object, keyframe, 반응형 | 씬 시간·문구 하드코딩 |
| `motion.js.asp` | 공통 모션·상태 함수 | 특정 씬 타임라인·플레이어 시간 관리 |
| `sceneXX.js.asp` | 씬 초기/종료 상태, 타임라인, 패널 텍스트 | CSS keyframe 신규 작성, 공통 함수 중복 |
| `sceneRunner.js.asp` | 씬 순서·전체 재생·진행률 | 오브젝트 애니메이션·콘텐츠 |
| `playerControls.js.asp` | UI → SceneRunner 연결 | 애니메이션·씬 콘텐츠 |
| `01_base_business_running.asp` (series) | `registerScene`, 메타·제목 설정 | 씬 타임라인 직접 작성 |

---

## 8. Object Library 의미

오브젝트 의미를 재해석하거나 재디자인하지 않는다.

| Object | 의미 | 비고 |
|--------|------|------|
| Main Member | 설명 중심 본인 디슈머/사업자 | |
| Child Member | 하위·관계 디슈머 | |
| Rank Medal | D, P, JP, SP, FC **지위** | BASE 자격과 **별개** |
| Autoship Badge | 오토십 이용 상태 | |
| BASE Badge | BASE사업자 **자격** | Rank가 아님. P와 자동 동일 아님 |
| SEP Badge | SEP 실적 | **HTML div** (이미지 X) |
| Recommend/Support Bonus Plate | 추천·후원 보너스 | **HTML div** (이미지 X) |
| Leader Crown | 중심 인물 Marker | Rank 아님 |
| Recommend Star | 직접 추천 Member 표시 | 조직선과 다름 |

**핵심:** BASE Badge와 Rank Medal은 **독립** ? 교체·자동 승급 처리 금지.

---

## 9. Scene 구현 규칙

> **모든 Scene은 아래 규칙을 따른다.**

### 9-1. 참고 파일·레이아웃

**구현 전 반드시 확인 (순서)**

1. `PROJECT_RULE.md` (본 문서)
2. `SceneXX.md` (해당 씬 시나리오)
3. `video_start.asp` (레이아웃·Object Library·DOM ID·class 기준)
4. 실제 Media (`voice/…/sceneXX.mp4`)

`video_start.asp`는 **복사·iframe 삽입하지 않는다.** DOM·비율·Object 배치만 참고한다. 새 레이아웃을 임의 생성하지 않는다.

**공통 플레이어**

| 파일 | 역할 |
|------|------|
| `01_base_business_running.asp` | BASE 챕터 **실제 재생** (`#layout-ov`) |
| `video_base.asp` | 공통 플레이어 템플릿 (레거시·참고) |

**씬에서 변경 가능**

- Motion Canvas (`#motion-canvas`)
- Information Panel (`#lo-panel` 내부 콘텐츠)

**씬에서 변경 금지**

- Header (`#lo-bar`)
- Player Controls (`#lo-ctrl`, `#btn-play`, Progress Bar `#lo-tl`)
- 플레이어 전체 레이아웃 (`#layout-ov` 구조·비율)

1. 씬별 크기·위치는 **씬 전용 ID** (`#scene01-base-badge` 등)로 override한다.
2. Header·Controls·패널 레이아웃은 씬 전환 시 유지한다.

**핵심 DOM ID** (플레이어 ? 씬이 건드리지 않음)

| 영역 | ID | 비고 |
|------|-----|------|
| 루트 | `#layout-ov` | `body.page-layout` |
| 헤더 | `#lo-bar`, `#lo-back`, `#lo-breadcrumb`, `#lo-scene-label` | |
| 메인 | `#lo-main`, `#lo-canvas`, `#motion-canvas` | 씬 오브젝트 주입 대상 |
| 패널 | `#lo-panel`, `#panel-fixed-title`, `#scene-title-main`, `#panel-scene-desc`, `#scene-bullets` | |
| 컨트롤 | `#lo-ctrl`, `#btn-play`, `#lo-tl`, `#lo-tlf`, `#time-current`, `#time-total`, `#scene-number` | |

**씬 시나리오 문서:** 프로젝트 루트 `Scene01.md` … `Scene07.md`

**참고용 Object DOM** (`video_start.asp` ? 씬에서 동적 생성 시 동일 ID·class 사용)

`#member-unit-main`, `#member-unit-left`, `#member-unit-right`, `#rank-medal-main`, `#autoship-emblem-main`, `#base-business-badge-main`, `.member-emblem-group`, `.scene-canvas-badge`, `#lo-connectors`

### 9-2. Object / Motion Library

**Object Library**

- Member, Badge, Medal 등 **기존 Object만 재사용**한다. 임의 신규 Object·재디자인 금지.
- 크기·비율·배치는 `video_start.asp` + `styles.asp` 기준. 의미는 §8 표 준수.

**Motion Library**

- 모든 애니메이션은 `motion.js.asp` API + `styles.asp` keyframe 조합으로 구현한다.
- 동일 keyframe·모션 함수를 씬 파일에 **중복 생성하지 않는다.**

**HTML Object (설명 UI)**

권리·조건·비율 설명, 화살표, 연결선 등 **설명용 UI는 이미지로 만들지 않는다.**

- SEP Badge, Bonus Plate → **HTML div**
- 관계선 → **SVG** (`#lo-connectors`)
- 텍스트·수치 → **HTML** (`span`, `strong` 등)

### 9-3. Information Panel / Motion Canvas

**Information Panel** ? 구조 고정, **내용만** 씬마다 변경

| 요소 | ID | 비고 |
|------|-----|------|
| Fixed Chapter Title | `#panel-fixed-title` | 챕터명. 이전 씬 endState에서 이어질 수 있음 |
| Scene Title | `#scene-title-main` | 씬 제목 |
| Description | `#panel-scene-desc` 또는 `#scene-bullets` | 설명·불릿 |

**Motion Canvas**

- Object Library로 **해당 씬 내용만** 표현한다.
- 배경 레이어(`scene-canvas-bg`)는 오브젝트 **아래**, 씬 오브젝트는 **위** (z-index 규칙 § `styles.asp`).
- Scene 종료 시 `SceneXX.md` **End State**를 `endState()`로 유지한다 (다음 씬 연결용).

### 9-4. 씬 스크립트 표준

각 `sceneXX.js.asp`는 아래 API를 노출한다.

```javascript
var BaseScene01 = {
  id: 'base-scene-01',
  title: '씬 제목',
  duration: 14000,        // Media 실제 길이 우선, md Estimated는 참고용

  reset: function() { /* 해당 씬 오브젝트·패널만 */ },
  play: async function(ctx) { /* ctx.canvas, reportProgress, isCancelled */ },
  endState: function() { /* 다음 씬에 넘길 상태 */ }
};
```

**오브젝트 조작:** REUSE · SHOW · HIDE · MOVE · UPDATE · REPLACE · ANIMATE  
**CREATE**는 재사용 컴포넌트가 없을 때만.

**reset 범위:** 해당 씬 canvas·패널만. `panel-fixed-title` 등 이전 씬에서 유지할 항목은 건드리지 않는다.

**씬 전환**

- 각 씬은 **단독 실행·reset** 가능해야 한다.
- Scene01 → 02 → … 순차 재생 시 endState·`transitionCanvas` 등으로 **자연스럽게 연결**한다.

### 9-5. Scene Media·동기화

**미디어 위치**

```
voice/
└── 01_base_business_running/
    ├── scene01.mp4 … scene07.mp4
```

| 대응 | 예 |
|------|-----|
| Scene 01 | scene01.mp4 |
| Scene 02 | scene02.mp4 |

- Scene 번호 ↔ Media 파일 **1:1**. 경로는 `SceneMedia` / `voice_stream.asp` 경유 (IIS 정적 mp4 404 우회).
- `duration`은 **실제 Media 길이 우선**. `SceneXX.md` Estimated Duration은 기획·`wait()` 임시값 참고용.

**재생·동기화 흐름 (목표)**

```
Play    → Media Play    → Animation Play
Pause   → Media Pause   → Animation Pause
Restart → Media Reset   → Scene Reset → Play
```

- 애니메이션은 최종적으로 Media **`currentTime` 기준** 동기화한다.
- `SceneXX.md` Timeline은 **나레이션 흐름·currentTime** 우선. 단순 `wait()` 숫자만 맞추지 않는다.

**구현 참고 순서:** `SceneXX.md` → 실제 Media → `video_start.asp` → Object/Motion Library

#### 현재 구현 상태 vs 목표

| 항목 | 목표 | 현재 (2026-07) |
|------|------|----------------|
| Media 재생 | 씬 시작 시 mp4 | ? `sceneMedia.js.asp` + `voice_stream.asp` |
| duration | Media 실제 길이 | ? `applyDurations()` (Scene01·02 등록 씬) |
| Pause | Media ↔ 애니메이션 | ? SceneRunner `playToken` + Media pause |
| Seek | Progress Bar 이동 | ? 씬 시작 지점 이동 (씬 내 초 단위는 후속) |
| 타임라인 | Media `currentTime` 동기화 | ? Scene01·02는 `wait()` 병렬 (전환 예정) |

> Media `currentTime` 전환 시 `sceneXX.js.asp`의 `play()`를 Media 이벤트(`timeupdate` 등) 기준으로 리팩터링한다.

### 9-6. Include 체인 (BASE 챕터)

```
01_base_business_running.asp          ← guide.asp 진입 페이지
├── includes/images.asp
├── includes/styles.asp
├── includes/motion.js.asp
├── includes/sceneMedia.js.asp
├── includes/sceneRunner.js.asp
├── includes/playerControls.js.asp
├── includes/series/01_base_business_running/scenes/scene01.js.asp
├── includes/series/01_base_business_running/scenes/scene02.js.asp
│   … scene07.js.asp (추가 시 동일 경로)
├── includes/series/01_base_business_running/01_base_business_running.asp
└── Series01BaseBusinessRunning.init()
```

**신규 씬 추가 절차**

1. `SceneXX.md` 작성·확인
2. `voice/…/sceneXX.mp4` 배치·길이 확인
3. `scenes/sceneXX.js.asp` 생성 (`BaseSceneXX`)
4. `01_base_business_running.asp`(루트)에 scene include 한 줄 추가
5. `01_base_business_running.asp`(series)에 `SceneRunner.registerScene(BaseSceneXX)` 추가

### 9-7. 진행 현황 (BASE 챕터)

| Scene | 시나리오 | scene JS | register | Media |
|-------|----------|----------|----------|-------|
| 01 | `Scene01.md` | ? | ? | ? wait 병렬 |
| 02 | `Scene02.md` | ? | ? | ? wait 병렬 |
| 03~07 | 미작성 | ? | ? | ? |

**인프라 완료:** `#layout-ov`, SceneRunner, SceneMedia, playerControls, seek, series 구조, `guide.asp` 링크

### 9-8. 품질·체크리스트

모든 Scene은 아래를 만족한다.

- [ ] Object·Motion Library 재사용 (중복 keyframe·API 금지)
- [ ] 단독 실행·반복 재생·reset 가능
- [ ] Play / Pause / Seek(씬 단위) / Progress / 시간 표시
- [ ] Media 재생 연동 (해당 mp4 존재 시)
- [ ] 씬 간 시각적 점프 없음 (`transitionCanvas`, `enterMember` 등)
- [ ] End State 유지 (다음 씬 연결)
- [ ] Console Error 없음
- [ ] `animationend` 누락 시 Promise fallback timeout
- [ ] `prefers-reduced-motion`에서도 씬 완료
- [ ] 한 씬에 핵심 메시지 하나 ? 조건·보너스 동시 몰아넣기 금지

---

## 10. BASE사업자 이해하기 레슨

| Scene | 제목 | Media |
|-------|------|-------|
| 01 | BASE사업자란 무엇일까요? | scene01.mp4 |
| 02 | 비즈니스 성장의 전환점 | scene02.mp4 |
| 03 | BASE사업자의 의미 | scene03.mp4 |
| 04 | BASE사업자가 되는 조건 | scene04.mp4 |
| 05 | BASE사업자의 첫 번째 권리 | scene05.mp4 |
| 06 | 권리 소득 시스템의 출발점 | scene06.mp4 |
| 07 | 핵심 요약 | scene07.mp4 |

**목표 길이:** 약 2분 50초 · **제작 순서:** Scene 01 단독 완성 → 검수 → 02 → … → 07 → 전체 연결

---

## 11. 씬 제작 워크플로

```
1. SceneXX.md 시나리오 확정
2. voice/…/sceneXX.mp4 배치·duration 확인
3. video_start.asp·Object/Motion Library 확인
4. sceneXX.js.asp 독립 구현
5. 단독 재생·reset·endState·Media 검수
6. registerScene 및 include 추가
7. 이전 씬과 연속 재생·전환·seek 검수
8. 전체 Play/Pause/Progress/시간 표시 검수
```

---

## 12. 레거시 마이그레이션

| 단계 | 내용 |
|------|------|
| 1 | 레거시 플레이어 유지 (참고) |
| 2 | Object + Motion + Scene Runner로 신규 레슨 구축 |
| 3 | 동작 비교 |
| 4 | `guide.asp` 링크를 신규 페이지로 전환 |
| 5 | 안정화 후 레거시 아카이브 (즉시 삭제 금지) |

---

## 13. 완료 기준 (BASE 챕터)

1. Scene 01~07 독립 모듈, 단독·reset 가능  
2. 동일 Object·Motion Library 재사용  
3. 순차 재생 시 레이아웃 점프·DOM 중복 없음  
4. Play / Pause / Replay / Progress / 시간 표시 정상  
5. Fixed Chapter Title 일관 유지  
6. BASE Badge ↔ Rank Medal 의미 독립 유지  
7. SEP·Bonus는 HTML div 유지  
8. 데스크톱·태블릿·모바일 반응형  
9. JP/SP/FC 등 다른 챕터·시뮬레이터로 확장 가능한 구조  

---

## 14. Cursor AI 작업 지침

**작업 전 (필수)**

1. `PROJECT_RULE.md` → `SceneXX.md` → `video_start.asp` 순으로 읽는다.
2. 현재 프로젝트 구조·DOM ID·include 체인·기존 Object/Motion Library를 분석한다.
3. 실제 파일명·함수명 확인 (추측·**동일 기능 중복 구현 금지**).
4. Classic ASP SSI·`images.asp` 경로·반응형 유지.

**작업 후 보고**

- 수정·생성 파일 / 재사용·추가 함수 / 변경 DOM ID / 테스트 방법 / 알려진 제한

**금지**

- React·Vue·TypeScript·npm·Vite 마이그레이션
- UI 임의 재디자인 (명시적 요청 없을 때)
- 새 레이아웃·Object·Keyframe·Motion API 중복 생성
- 모놀리식 단일 플레이어 파일 확장
- 씬 정의·모션 primitive·타임라인을 한 파일에 혼합

---

*문서 끝*
