# ALTWELL SMART GUIDE — 에셋 애니메이션 규칙

> guide01 씬1 제작 과정에서 확립된 **부드러운 존(7×7) 에셋 애니메이션** 규칙  
> 구현: `includes/series/guide01/guide01_common.js.asp` · `_css/guide01.css`  
> 좌표 배치: [MOTION_GRID_GUIDE.md](./MOTION_GRID_GUIDE.md)

---

## 1. 목적

모션그래픽 에셋이 **등장 · 이동 · 퇴장 · idle** 할 때 끊김·튐·크기 점프 없이 자연스럽게 보이도록 하는 규칙이다.

| 증상 | 원인 |
|------|------|
| 등장 후 “툭” 하고 크기가 바뀜 | pop/keyframe이 `scale(1)`에서 끝나는데 실제 `--g01-base-scale`은 0.72 등 |
| 중앙 정렬이 어긋남 | wrap의 `translate(-50%,-50%)`와 등장 `transform`이 같은 요소에 겹침 |
| 이동이 끊김 | `--zone-row/col` 변경 → `left/top` calc 레이아웃 재계산 |
| idle 시작 시 튐 | 전역 `motion-idle-float`가 inner `transform`을 덮어씀 |

---

## 2. DOM 구조 (필수)

7×7 그리드 에셋은 **2겹 래퍼**로 마운트한다.

```
.g01-zone-wrap          ← 위치(존) · 표시/숨김 · 이동
  └ .g01-float-inner    ← scale · 등장/퇴장/idle 애니메이션
       └ .guide01-asset ← 클론된 템플릿 (아이콘·카드 등)
```

| 레이어 | 역할 | transform 사용 |
|--------|------|----------------|
| **wrap** | `lo-zone-place` + `data-zone` + `--zone-row/col` 또는 이동 중 px 좌표 | `translate(-50%, -50%)` + `translate3d` **(이동만)** |
| **inner** | `--g01-base-scale`, 등장·퇴장·idle | `scale`, `translateY/3d` |
| **asset** | 시각 에셋 본체 | `transform: none` (guide01.css에서 고정) |

### 마운트 API

```javascript
// 템플릿 클론 + 존 배치 (일반)
Guide01.addZonedAsset(canvas, 'autoship_icon', 's01-autoship', 'd4', {
  scale: 1,              // --g01-base-scale + inner transform
  extraCls: 'g01-layer-front'  // z-index 보조 (선택)
});

// 커스텀 노드
Guide01.mountZonedNode(canvas, node, 's01-cycle', 'd4', { scale: 1.18 });
```

**규칙:** 새 존 에셋은 `canvas.appendChild(asset)` 직접 배치 금지. 반드시 `addZonedAsset` / `mountZonedNode` 사용.

---

## 3. Base Scale 시스템

에셋마다 **고유 표시 크기**를 CSS 변수로 보관한다.

| 변수 | 의미 | 설정 시점 |
|------|------|-----------|
| `--g01-base-scale` | 정착(scale) 크기 | 마운트 · `setZonedScale` · `moveZoned` 종료 |
| `--g01-from-scale` | 등장 시작 scale (`base × 배율`) | 등장 애니 직전 (`prepZonedAnimScales`) |
| `--g01-anim-dur` | 해당 등장 애니 길이 | `runZonedInnerAnim` |

```javascript
// 마운트 시 (mountZonedNode 내부)
inner.style.setProperty('--g01-base-scale', String(baseScale));
inner.style.transform = 'scale(' + baseScale + ')';
```

### 정착(settle)

애니메이션 종료 후 **반드시** base scale로 복원한다.

```javascript
settleZonedInner(inner);
// → transform: scale(base) translateZ(0)
// → --g01-from-scale 제거
```

**금지:** keyframe/to 값을 `scale(1)` 고정 — base scale이 1이 아닌 에셋은 반드시 튐.

---

## 4. 등장 (Enter)

### API: `fadeZoned(wrap, true, opts)`

| opts | 용도 | CSS 클래스 | 기본 배율(from) | 권장 duration |
|------|------|------------|-----------------|---------------|
| *(없음)* | 일반 fade-in | `g01-anim-enter` | base × 0.94 + translateY 4px | 420ms |
| `{ pop: true }` | 강조 등장 (오토십·BASE) | `g01-anim-pop` | base × 0.88 | ≥ 520ms |
| `{ coinDrop: true }` | 위→아래 드롭 (캐시백) | `g01-anim-drop` | base 유지 + translateY -22px | ≥ 520ms |

```javascript
await Guide01.fadeZoned(autoshipMain, true, { pop: true, duration: 320 });
await Guide01.fadeZoned(product, true, { duration: 280 });
await Guide01.fadeZoned(coin, true, { coinDrop: true, duration: 320 });
```

### API: `popScaleZoned(wrap, opts)`

할인 태그·체크 등 **짧은 pop** — 내부적으로 `g01-anim-pop` + `settleZonedInner`.

```javascript
await Guide01.popScaleZoned(discount, { duration: 360 });
```

### 등장 규칙

1. **wrap에는 `enterElement` / `is-entering` 사용 금지** — wrap transform과 충돌.
2. 등장 애니는 **inner에만** `g01-anim-*` 클래스 부여.
3. `animationend` 후 클래스 제거 + `settleZonedInner` 호출 (자동).
4. 이징: `cubic-bezier(.22, 1, .36, 1)`.
5. idle 시작 전 등장 애니 **완료(await) 후** `startIdleFloat` 호출.

---

## 5. 퇴장 (Exit)

### API: `fadeZoned(wrap, false, opts)`

inner에 opacity + scale( base × 0.94 ) transition 후 wrap `is-hidden`.

```javascript
await Guide01.fadeZoned(autoshipMain, false, { duration: 280 });
await fadeMany([cycleWrap, calB2, calB6, calF4], false);  // 병렬 퇴장
```

### 퇴장 규칙

1. 퇴장 시 inner의 `g01-anim-*`, `g01-idle-float` **먼저 제거**.
2. wrap에 `exitElement` 직접 사용 금지 (inner가 있을 때).
3. transition 이징: `cubic-bezier(.22, 1, .36, 1)`.

---

## 6. 이동 (Move)

### API: `moveZoned(wrap, zone, durationOrOpts)`

```javascript
// 제품 F4 → D4, scale 0.72 → 0.96 동시 보간
await Guide01.moveZoned(product, 'd4', { duration: 720, toScale: 0.96 });

// 포인트 B4 → D2
await Guide01.moveZoned(pointToken, 'd2', { duration: 900 });
```

| 항목 | 규칙 |
|------|------|
| 위치 보간 | wrap: `translate3d(dx, dy, 0)` (GPU 합성) |
| scale 보간 | inner: `fromScale → toScale` rAF 보간 |
| 이징 | `easeOutCubic` |
| 이동 중 | `is-zone-moving` + `will-change: transform` |
| 종료 | px 스타일 제거 → `placeAtZone` → `--g01-base-scale` 갱신 |

### 이동 금지 사항

- `--zone-row` / `--zone-col`을 rAF로 보간 ❌ (layout thrashing)
- 이동 중 wrap에 CSS `transition` ❌
- 이동 종료 후 scale을 별도 `setZonedScale`로 한 번 더 바꾸기 ❌ → `toScale` 옵션 사용

---

## 7. Idle Float

### API

```javascript
Guide01.startIdleFloat(autoshipMain);  // 등장 완료 후
Guide01.stopIdleFloat(autoshipMain);   // 퇴장·구간 전환 전
```

| 항목 | 규칙 |
|------|------|
| 클래스 | `g01-idle-float` (guide01 전용) |
| 금지 | `motion-idle-float` on `.g01-float-inner` — transform 덮어씀 |
| keyframe | `scale(var(--g01-base-scale))` + translateY ±3px |
| 시작 전 | `settleZonedInner` 호출로 base scale 확정 |

---

## 8. 타임라인 (시나리오 ~초 엄수)

### 벽시계 기준 `Guide01.timeline(ctx)`

```javascript
var tl = Guide01.timeline(ctx);
await tl.wait(7000);  // 씬 시작 후 정확히 7.000초
```

- `tl.wait(ms)`는 **씬 시작 origin + ms** 시각까지 대기 (중간 await 애니 길이와 무관).
- 패널 bullet: `panelBulletTimeline` — flash 시각은 **절대 ms** (`flashes[i].at`).

```javascript
Guide01.panelBulletTimeline(tl, '오토십이란?', BULLETS, [
  { at: 2000, index: 0 },
  { at: 7000, index: 1 },
  { at: 12000, index: 2 },
  { at: 23000, index: 3 }
]);
```

### 씬 작성 패턴

```javascript
var T = { t0: 0, t2: 2000, t6: 6000, t7: 7000, t29: 29000 };
var FADE = { duration: 280 };
var POP  = { pop: true, duration: 320 };

await tl.wait(T.t6);
// 6~7초 구간 애니는 병렬 처리해 7초 키프레임을 맞춤
await Promise.all([
  fadeMany([cycleWrap, calB2], false),
  Guide01.moveZoned(product, 'd4', { duration: 720, toScale: 0.96 })
]);
await tl.wait(T.t7);
await Guide01.popScaleZoned(discount, { duration: 360 });
```

**규칙:** 구간 전환은 `await tl.wait(키프레임)` **먼저**, 구간 내 애니는 다음 키프레임 전에 끝나도록 duration·병렬 조정.

---

## 9. z-index 레이어 (선택)

| 클래스 | z-index | 용도 |
|--------|---------|------|
| `g01-layer-back` | 10 | 순환 링 등 배경 |
| *(기본 wrap)* | 12 | 일반 에셋 |
| `g01-layer-front` | 14 | 오토십·BASE 등 중앙 강조 |
| `g01-connector-svg` | 8 | 연결선 (에셋 아래) |

---

## 10. CSS Keyframe · 클래스 요약

**파일:** `_css/guide01.css`

| Keyframe | from → to |
|----------|-----------|
| `g01-pop-scale` | `--g01-from-scale` → `--g01-base-scale` |
| `g01-zone-enter` | from-scale + translateY 4px → base |
| `g01-coin-drop` | base + translateY -22px → base |
| `g01-idle-float` | base + Y(0) ↔ Y(-3px) |

| inner 클래스 | 용도 |
|--------------|------|
| `g01-anim-pop` | pop 등장 |
| `g01-anim-enter` | fade 등장 |
| `g01-anim-drop` | coin drop |
| `g01-idle-float` | 미세 상하 float |

| wrap 클래스 | 용도 |
|-------------|------|
| `is-zone-moving` | rAF 이동 중 |
| `is-hidden` | 비표시 |
| `lo-zone-place` | 7×7 존 calc 배치 |

**GPU 보조:** inner/wrap에 `backface-visibility: hidden`, 이동·등장 시 `translateZ(0)`.

---

## 11. Guide01 API 빠른 참조

| 함수 | 설명 |
|------|------|
| `addZonedAsset(canvas, templateId, id, zone, opts)` | 템플릿 클론 + 존 마운트 |
| `addZonedBadge(canvas, templateId, id, zone, opts)` | 뱃지 `_c` 템플릿 + 존 마운트 |
| `enterZonedBadge(wrap, opts)` | 접힌 상태 등장(pop/fade) → `unfold` |
| `unfoldZonedBadge(wrap, opts)` | 펼침만 (`unfoldDuration`) |
| `mountZonedNode(canvas, node, id, zone, opts)` | 커스텀 노드 마운트 |
| `fadeZoned(wrap, show, opts)` | 등장/퇴장 (§4·§5) |
| `popScaleZoned(wrap, opts)` | pop 등장 단축 |
| `moveZoned(wrap, zone, { duration, toScale })` | 부드러운 존 이동 |
| `setZonedScale(wrap, scale)` | base scale 변경 |
| `getZonedScale(wrap)` | 현재 base scale |
| `startIdleFloat(wrap)` / `stopIdleFloat(wrap)` | idle on/off |
| `placeAtZone(wrap, zone)` | 존 문자열로 위치 리셋 |
| `timeline(ctx)` | 벽시계 타임라인 |
| `panelBulletTimeline(tl, title, items, flashes)` | 패널 bullet 점멸 |

---

## 12. 금지 · 주의 (Anti-patterns)

| ❌ 금지 | ✅ 대신 |
|---------|---------|
| wrap에 `enterElement` / `exitElement` | `fadeZoned` |
| pop keyframe `to { scale(1) }` 고정 | `--g01-base-scale` 사용 |
| inner에 `motion-idle-float` | `g01-idle-float` |
| `--zone-row/col` rAF 보간 | `moveZoned` (translate3d) |
| 등장 중 wrap `transform` 변경 | inner만 애니 |
| idle을 pop await 전에 시작 | pop 완료 후 `startIdleFloat` |
| panel flash `tl.wait(at - elapsed)` | `tl.wait(at)` 절대 시각 |
| 이동 후 scale 별도 점프 | `moveZoned` `toScale` |

---

## 13. Badge Fold (오토십·베이스·추천보너스)

| 단계 | 접힘 | 펼침 |
|------|------|------|
| 1 | track clip 수축 (overflow) | track 확장 |
| 2 | 텍스트 fade-out | 텍스트 fade-in (확장과 겹침) |

- 코어: `G01BadgeFold` (`includes/motions/g01/badgeFoldCore.js.asp`)
- 본작업 등장: `Guide01.enterZonedBadge(wrap, opts)` — `_c` → zone 등장 → unfold
- 펼침 기본 620ms · 접힘 744ms (20% 느림) — `badgeFoldCore.js.asp` `DEFAULT_*`
- 미리보기: `asset_design.asp` Badge Fold 버튼 (`MotionG01BadgeUnfold/Fold`)
- **씬 타임라인과 분리:** `Scene01Config.motion.BADGE.unfoldDuration` = 등장 시 펼침 속도만

---

## 14. 씬1 재작업 구조

| 파일 | 수정 대상 |
|------|-----------|
| `scene01.constants.js.asp` | `T.*` 시각, 패널 bullet, `motion.*` duration |
| `scene01.setup.js.asp` | 에셋 templateId · zone · scale · element id |
| `scene01.js.asp` | `runScene01Motion` 블록 (등장/퇴장/이동 순서) |

헬퍼: `scene01Motion('FADE'|'POP')`, `scene01BadgeEnter({ pop: true })`

| 시각 | 동작 | API |
|------|------|-----|
| 0s | 오토십 접힘→펼침 + 제품 | `enterZonedBadge` + `fadeZoned` |
| 2~4.7s | 달력 순차 | `fadeZoned` |
| 6s | 링·달력 out + 제품 D4 | `fadeMany` + `moveZoned` |
| 13s | 추천 관계 + 오토십 링크 | `enterZonedBadge` |
| 20s | 추천 보너스 | `enterZonedBadge` |
| 22s | BASE | `enterZonedBadge` POP |
| 29s | 종료 | `finishSceneHold` |

테스트(멤버 부착): `scene01_test.js.asp` → `0909test.asp` (본작업과 별도)

---

## 15. 관련 파일

| 파일 | 내용 |
|------|------|
| `includes/series/guide01/guide01_common.js.asp` | 존·뱃지·타임라인 JS |
| `includes/motions/g01/badgeFoldCore.js.asp` | Badge fold/unfold |
| `_css/guide01.css` | g01 keyframe · zone · badge fold |
| `includes/components/guide01_templates.asp` | clone 템플릿 |
| `includes/series/guide01/scenes/scene01.constants.js.asp` | 씬1 상수 |
| `includes/series/guide01/scenes/scene01.setup.js.asp` | 씬1 에셋 마운트 |
| `includes/series/guide01/scenes/scene01.js.asp` | 씬1 타임라인 |
| `MOTION_GRID_GUIDE.md` | 7×7 존 좌표 |
| `PROJECT_RULE.md` | 프로젝트 전체 규칙 |

---

## 16. 신규 씬 체크리스트

- [ ] 에셋을 `addZonedAsset` / `mountZonedNode`로 마운트했는가
- [ ] `scale` opts로 `--g01-base-scale`이 설정되었는가
- [ ] 등장/퇴장에 `fadeZoned` / `popScaleZoned`만 사용했는가
- [ ] 이동에 `moveZoned` (+ 필요 시 `toScale`)를 사용했는가
- [ ] idle은 `g01-idle-float` + 등장 완료 후 시작인가
- [ ] 키프레임은 `tl.wait(절대ms)`로 맞췄는가
- [ ] wrap에 직접 transform 애니를 걸지 않았는가
- [ ] 뱃지는 `addZonedBadge` + `enterZonedBadge`로 등장했는가

---

*Last updated: guide01 Scene 01 재작업 구조 분리 기준*
