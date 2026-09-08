# ALTWELL SMART GUIDE — Asset Design System

> `asset_design.asp` 기준 에셋·아이콘 디자인 시스템  
> **목적:** 다른 AI 모델이 이 문서를 학습해 **HTML + CSS만**으로 서브 아이콘·보조 컴포넌트를 제작  
> **소스:** `_css/icon_style.css` · `includes/components/*.asp`  
> **미리보기:** `asset_design.asp`

---

## 1. 개요

### 1-1. 에셋 3계열

| 계열 | 영문명 | 용도 | CSS 파일 |
|------|--------|------|----------|
| **RANK MEDAL** | 지위 메달 | D~IRF 12단계 지위 표시 | `icon_style.css` |
| **BADGE** | 자격·서비스 배지 | BASE사업자·오토십·추천보너스 | `icon_style.css` |
| **UNIT** | 인물 실루엣 | 일반·멤버 캐릭터 | `icon_style.css` |

### 1-2. 기술 제약 (신규 아이콘 제작 시 필수)

- **HTML + CSS만** 사용 (PNG·SVG 파일·외부 이미지 금지)
- **Vanilla CSS** — React/Vue/Tailwind 금지
- 폰트: `var(--font-sans, 'MinSansVF', sans-serif)` (MinSansVF)
- 모든 치수는 **`--size` CSS 변수** 기준으로 `calc()` 비율 유지
- 클래스명: **snake_case** (예: `lev_d`, `autoship_icon_o`, `person_icon`)
- 접근성: 루트에 `aria-label` 또는 `role="img"` + `aria-label`
- UTF-8 저장, 한글 리터럴 그대로 사용

### 1-3. 파일 배치 규칙

```
guide_page/
├── asset_design.asp              ← 시안 미리보기 페이지
├── ASSET_DESIGN_SYSTEM.md        ← 본 문서
├── _css/icon_style.css           ← 모든 아이콘 CSS (단일 파일)
└── includes/components/
    ├── lev_d.asp … lev_irf.asp   ← 지위 메달 HTML
    ├── base_business_icon.asp    ← 배지 HTML (_o / _c)
    ├── autoship_icon.asp
    ├── recommend_bonus_icon.asp
    ├── person_icon.asp
    ├── member_icon.asp
    ├── lev_container.asp         ← 시안용 묶음
    ├── badge_container.asp
    ├── person_container.asp
    ├── point_token_icon.asp      ← SUB ASSET (씬 서브 에셋)
    ├── status_check_icon.asp
    ├── status_cross_icon.asp
    ├── calendar_month_card.asp
    ├── product_silhouette_card.asp
    ├── delivery_box_icon.asp
    ├── payment_card_icon.asp
    ├── select_counter_badge.asp
    ├── ep_split_card.asp
    ├── cashback_card.asp
    ├── price_step_card.asp
    └── sub_asset_container.asp
```

**신규 아이콘 추가 절차**

1. `includes/components/{name}.asp` — HTML 마크업
2. `_css/icon_style.css` — 스타일 추가 (기존 패턴·비율 준수)
3. 해당 `*_container.asp`에 include (시안 확인용)

---

## 2. 공통 디자인 토큰

### 2-1. 크기 (`--size`)

모든 아이콘은 루트 요소에 `--size`를 정의하고, 내부 px는 **기본값 대비 비율**로 `calc()` 처리.

```css
/* 사용 예 */
.my_icon { --size: 48px; }           /* CSS에서 */
<div class="my_icon" style="--size:80px">  /* 인라인에서 */
```

| 계열 | 기본 `--size` | 의미 |
|------|---------------|------|
| Simple Rank (D~DC) | `60px` | 외곽 약 60×60 (내용 40 + padding 10×2) |
| Complex Rank (RF~IRF) | `34px` | 컨테이너 한 변 |
| Badge | `36px` | 배지 **높이** |
| Unit (person/member) | `160px` | 실루엣 한 변 |

**비율 공식 (Simple Rank, base=60)**

| 속성 | px (기본) | calc |
|------|-----------|------|
| content width/height | 40 | `calc(var(--size) * 40 / 60)` |
| padding | 10 | `calc(var(--size) * 10 / 60)` |
| font-size | 18 | `calc(var(--size) * 18 / 60)` |
| box-shadow | 1 2 7 | `calc(var(--size) * N / 60)` |
| text-shadow Y/blur | 1 | `calc(var(--size) * 1 / 60)` |

**비율 공식 (Badge, base=36)**

| 속성 | px (기본) | calc |
|------|-----------|------|
| height | 36 | `var(--size)` |
| padding | 5 7 | `5/36` · `7/36` |
| gap | 5 | `5/36` |
| border-radius | 10 | `10/36` |
| inset border | 2 | `2/36` |
| label circle | 24 | `24/36` |
| label font | 15 | `15/36` |
| text font | 18 | `18/36` |

### 2-2. 그림자

```css
/* Simple Rank — drop shadow */
box-shadow: calc(var(--size) * 1 / 60) calc(var(--size) * 2 / 60) calc(var(--size) * 7 / 60) 0 rgba(0, 0, 0, 0.20);

/* Simple Rank — text shadow */
text-shadow: 0 calc(var(--size) * 1 / 60) calc(var(--size) * 1 / 60) rgba(0, 0, 0, 0.20);

/* Badge — inset ring (외곽선 느낌) */
box-shadow: inset 0 0 0 calc(var(--size) * 2 / 36) #{border-color};
```

### 2-3. 브rand 악센트 색

| 토큰 | HEX | 용도 |
|------|-----|------|
| Gold | `#FDD503` | RF~IRF 배경·테두리, FC~DC border |
| Gold dark | `#C7A417` | 추천보너스 테두리 |

---

## 3. RANK MEDAL (지위 메달)

### 3-1. 타입 분류

| 타입 | 클래스 | 형태 | HTML 구조 |
|------|--------|------|-----------|
| **Simple** | `lev_d` … `lev_sp` | 원형 | 텍스트만 (1 div) |
| **Rounded** | `lev_fc` … `lev_dc` | 둥근 사각 (border-radius 30%) | 텍스트만 + gold border 2px |
| **Star RF** | `lev_rf` | 별형 2겹 | bg01, bg02, text (3 layer) |
| **Cross CRF~IRF** | `lev_crf` … `lev_irf` | 십자형 4겹 | bg01~04, text (5 layer) |

### 3-2. Simple Rank — 색상표

| 클래스 | 지위 | 배경 | 글자색 | border |
|--------|------|------|--------|--------|
| `lev_d` | D | `#FCF1C0` | `#CF9000` | — |
| `lev_p` | P | `#FE7902` | `#D02C00` | — |
| `lev_jp` | JP | `#FDDB03` | `#C98C00` | — |
| `lev_sp` | SP | `#03793F` | `#FDDB03` | — |
| `lev_fc` | FC | `#03793F` | `#FDDB03` | `2px #fdd503` |
| `lev_gc` | GC | `#1B2E63` | `#FDDB03` | `2px #fdd503` |
| `lev_dc` | DC | `#B81C2C` | `#FDDB03` | `2px #fdd503` |

**HTML 템플릿 (Simple)**

```html
<div class="lev_d" aria-label="D 지위">D</div>
```

**CSS 골격 (Simple — lev_d 기준, 색만 교체)**

```css
.lev_d {
  --size: 60px;
  display: flex;
  width: calc(var(--size) * 40 / 60);
  height: calc(var(--size) * 40 / 60);
  padding: calc(var(--size) * 10 / 60);
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border-radius: 50%;              /* FC~DC는 30% */
  background: #FCF1C0;
  box-shadow: calc(var(--size) * 1 / 60) calc(var(--size) * 2 / 60) calc(var(--size) * 7 / 60) 0 rgba(0,0,0,.2);
  font-size: calc(var(--size) * 18 / 60);
  font-weight: 700;
  color: #CF9000;
  text-shadow: 0 calc(var(--size) * 1 / 60) calc(var(--size) * 1 / 60) rgba(0,0,0,.2);
  font-family: var(--font-sans, 'MinSansVF', sans-serif);
}
```

### 3-3. Complex Rank — RF (별형)

**HTML**

```html
<div class="lev_rf" aria-label="RF 지위">
  <div class="rf_bg01"></div>
  <div class="rf_bg02"></div>
  <div class="lev_t_rf">RF</div>
</div>
```

**레이어 (DOM 순서 = z-index 아래→위)**

1. `rf_bg01` — 금색 사각, `rotate(67.5deg)`, border-radius 10%
2. `rf_bg02` — 금색 사각, `rotate(22.5deg)`
3. `lev_t_rf` — 빨간 원 `#D8030A`, 글자 `#FDD503`, z-index 최상단

**컨테이너**

```css
.lev_rf {
  --size: 34px;
  width: var(--size);
  height: var(--size);
  position: relative;
  top: calc(var(--size) * 2 / 34);
}
```

**텍스트 레이어**

```css
.lev_t_rf {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 100%; height: 100%;
  color: #FDD503;
  font-size: calc(var(--size) * 18 / 34);
  font-weight: 700;
  text-align: center;
  line-height: var(--size);
  border-radius: 50%;
  background-color: #D8030A;
}
```

**배경 팔각형 공통 (rf_bg01, rf_bg02)**

```css
.rf_bg01 {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: #FDD503;
  border-radius: 10%;
  transform: rotate(67.5deg);   /* bg02는 22.5deg */
  box-shadow: calc(var(--size)*1/34) calc(var(--size)*2/34) calc(var(--size)*7/34) 0 rgba(0,0,0,.2);
}
```

### 3-4. Complex Rank — CRF~IRF (십자형)

**HTML (CRF 예)**

```html
<div class="lev_crf" aria-label="CRF 지위">
  <div class="crf_bg01"></div>
  <div class="crf_bg02"></div>
  <div class="crf_bg03"></div>
  <div class="crf_bg04"></div>
  <div class="lev_t_crf">CRF</div>
</div>
```

**레이어**

| 레이어 | 역할 | 공통 스타일 |
|--------|------|-------------|
| `{prefix}_bg01` | 금색 십자 | rotate(45deg), border-radius 10% |
| `{prefix}_bg02` | 금색 십자 | rotate(0deg) |
| `{prefix}_bg03` | 중앙 원 | 50% translate, border-radius 50% |
| `{prefix}_bg04` | 가로 날개 | width 160%, height 60%, 좌우 gold border |
| `lev_t_{prefix}` | 지위 텍스트 | absolute center, line-height: var(--size) |

**CRF~IRF 색상 차이**

| 클래스 | bg03 (원) | bg04 (날개) | 텍스트 |
|--------|-----------|-------------|--------|
| `lev_crf` | `#006A3A` | `#BAE9D4` | `#006A3A` |
| `lev_mrf` | `#083D95` | `#CEDEF9` | `#083D95` |
| `lev_srf` | `#521F81` | `#E3D8EE` | `#521F81` |
| `lev_irf` | `#231815` | `#FCF1C0` | `#231815` |

**bg04 공통**

```css
.crf_bg04 {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 160%;
  height: 60%;
  border-left: calc(var(--size) * 2 / 34) solid #FDD503;
  border-right: calc(var(--size) * 2 / 34) solid #FDD503;
}
```

### 3-5. 신규 Simple Rank 추가 체크리스트

- [ ] 클래스명 `lev_{code}` (소문자)
- [ ] `--size: 60px` + calc 비율 유지
- [ ] `aria-label="{지위명} 지위"`
- [ ] 배경·글자색만 변경, 구조·비율 동일
- [ ] FC 이상이면 `border-radius: 30%` + `border: calc(var(--size)*2/60) solid #fdd503`

---

## 4. BADGE (자격·서비스 배지)

### 4-1. 공통 구조

모든 배지는 **2-part pill** 구조:

```
[ 라벨 원 (1글자) ] [ 텍스트 (한글명) ]
```

| Part | 클래스 패턴 | 역할 |
|------|-------------|------|
| Root | `{name}_icon_o` / `{name}_icon_c` | flex container |
| Label | `{prefix}_label` | 원형 1글자 약자 |
| Text | `{prefix}_text` | 서비스명 |

### 4-2. 펼침 / 닫힘 모드

| 접미사 | 클래스 예 | 텍스트 | 용도 |
|--------|-----------|--------|------|
| `_o` | `autoship_icon_o` | **표시** | 영상 등장·설명 |
| `_c` | `autoship_icon_c` | `display:none` | 멤버 아이콘 부착용 축약 |

**닫힘 모드 CSS (텍스트만 숨김, padding은 펼침과 동일)**

```css
.autoship_icon_c .autoship_text {
  display: none;
}
```

**HTML — 펼침**

```html
<div class="autoship_icon_o" aria-label="오토십 구독">
  <div class="autoship_label">A</div>
  <div class="autoship_text">오토십 구독</div>
</div>
```

**HTML — 닫힘** (텍스트 DOM은 유지, CSS로 숨김)

```html
<div class="autoship_icon_c" aria-label="오토십 구독">
  <div class="autoship_label">A</div>
  <div class="autoship_text">오토십 구독</div>
</div>
```

### 4-3. 등록 배지 3종 — 디자인 스펙

#### 베이스 사업자 (`base_business_icon`)

| 항목 | 값 |
|------|-----|
| 라벨 글자 | B |
| 텍스트 | 베이스 사업자 |
| 배경 gradient | `120deg, #118839, #09794D, #107474` |
| inset border | `#05653F` |
| label bg | `#54BE12` |
| label color | `#fff` |
| text color | `#fff` |

#### 오토십 (`autoship_icon`)

| 항목 | 값 |
|------|-----|
| 라벨 글자 | A |
| 텍스트 | 오토십 구독 |
| 배경 gradient | `120deg, #2c51ca, #1034AC, #462db3` |
| inset border | `#0B2A91` |
| label bg | `#B3B1FF` |
| label color | `#0B2A91` |
| text color | `#fff` |

#### 추천 보너스 (`recommend_bonus_icon`)

| 항목 | 값 |
|------|-----|
| 라벨 글자 | R |
| 텍스트 | 추천 보너스 |
| 배경 gradient | `120deg, #ffd738, #ffeca0, #FFE373, #e6c92a, #ffd738` |
| inset border | `#C7A417` |
| label bg | `#C7A417` |
| label color | `#FFEEA9` |
| text color | `#665308` |

### 4-4. Badge CSS 골격 (신규 배지 제작용)

```css
.my_service_icon_o,
.my_service_icon_c {
  --size: 36px;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  width: fit-content;
  height: var(--size);
  padding: calc(var(--size) * 5 / 36) calc(var(--size) * 7 / 36);
  gap: calc(var(--size) * 5 / 36);
  background: linear-gradient(120deg, #color1, #color2, #color3);
  box-shadow: inset 0 0 0 calc(var(--size) * 2 / 36) #borderColor;
  border-radius: calc(var(--size) * 10 / 36);
  font-family: var(--font-sans, 'MinSansVF', sans-serif);
}
.my_service_icon_c .my_service_text { display: none; }

.my_service_label {
  width: calc(var(--size) * 24 / 36);
  height: calc(var(--size) * 24 / 36);
  line-height: calc(var(--size) * 24 / 36);
  text-align: center;
  border-radius: 50%;
  font-weight: 700;        /* 또는 900 */
  font-size: calc(var(--size) * 15 / 36);
  flex-shrink: 0;
}
.my_service_text {
  font-weight: 700;
  font-size: calc(var(--size) * 18 / 36);
  line-height: calc(var(--size) * 18 / 36);
  white-space: nowrap;
}
```

### 4-5. 신규 Badge 추가 체크리스트

- [ ] `_o` / `_c` HTML 각 1파일 (또는 동일 HTML + 클래스만 교체)
- [ ] 라벨 1글자 + 한글 텍스트
- [ ] gradient 120deg, inset box-shadow 테두리
- [ ] `_c`는 텍스트 `display:none`만 — **padding 변경 금지**
- [ ] `--size` 비율 calc 유지

---

## 5. UNIT (인물 실루엣)

### 5-1. person vs member

동일 구조, **`--color`만 다름**.

| 클래스 | aria-label | `--color` (기본) | 용도 |
|--------|------------|------------------|------|
| `person_icon` | 일반 | `#b1c1da` | 일반 사용자 |
| `member_icon` | 멤버 | `#73a5f0` | 회원·추천 관계 |

### 5-2. HTML

```html
<div class="person_icon" role="img" aria-label="일반"></div>
<div class="member_icon" role="img" aria-label="멤버"></div>
```

### 5-3. CSS (pseudo-element 실루엣)

```css
.person_icon {
  --size: 160px;
  --color: #b1c1da;
  position: relative;
  display: inline-block;
  width: var(--size);
  height: var(--size);
  flex-shrink: 0;
}

/* 머리 */
.person_icon::before {
  content: "";
  position: absolute;
  top: 20%;
  left: 50%;
  width: 34%;
  height: 34%;
  border-radius: 50%;
  background-color: var(--color);
  transform: translateX(-50%);
}

/* 어깨·몸통 */
.person_icon::after {
  content: "";
  position: absolute;
  bottom: 8%;
  left: 50%;
  width: 72%;
  height: 42%;
  border-radius: 50% 50% 8% 8% / 75% 75% 15% 15%;
  background-color: var(--color);
  transform: translateX(-50%);
}
```

**비율은 % 기반** — `--size`만 바꿔도 실루엣 비율 유지.

### 5-4. 신규 Unit 변형

- 클래스명 `{role}_icon`
- `--color`로 역할 구분
- ::before / ::after 비율 변경 금지 (디자인 훼손)

---

## 6. 네이밍 규칙

| 대상 | 규칙 | 예 |
|------|------|-----|
| 지위 Simple | `lev_{code}` | `lev_d`, `lev_sp` |
| 지위 Complex root | `lev_{code}` | `lev_crf` |
| 지위 Complex bg | `{code}_bg01` … | `crf_bg04` |
| 지위 Complex text | `lev_t_{code}` | `lev_t_mrf` |
| Badge root | `{service}_icon_o` / `_c` | `autoship_icon_o` |
| Badge label | `{prefix}_label` | `autoship_label` |
| Badge text | `{prefix}_text` | `autoship_text` |
| Unit | `{role}_icon` | `member_icon` |

**금지**

- `person-icon` (하이픈) — 프로젝트는 `person_icon` (underscore)
- PNG·img 태그로 배지·지위 대체
- `--size` 없이 고정 px만 사용 (확대 시 비율 깨짐)

---

## 7. AI 출력 형식 (신규 서브 아이콘 요청 시)

새 아이콘을 만들 때 아래 **2블록**으로 출력:

### Block A — HTML (`includes/components/{name}.asp`)

```html
<div class="my_sub_icon" aria-label="설명">
  <!-- 자식 요소 -->
</div>
```

### Block B — CSS (`_css/icon_style.css`에 추가)

```css
.my_sub_icon {
  --size: ??px;
  /* calc 비율 포함 전체 규칙 */
}
```

### 필수 확인

1. 기본 `--size`에서 `asset_design.asp` 시각적 크기가 기존 계열과 어울리는가
2. `--size` 2배 시 모든 요소가 2배로 커지는가
3. `_c` 배지는 텍스트만 숨기고 padding·label 크기 유지하는가
4. Complex Rank는 bg 레이어 DOM 순서·rotate 각도 준수하는가
5. `aria-label` 한글 설명 포함하는가

---

## 8. 보조 오브젝트 (영상 씬용 — 참고)

영상 `#motion-canvas` 안 **보조 UI** (달력·카드·타임라인 등)는 `icon_style.css` **밖** `_css/guide01.css`의 `.g01-*` 클래스로 별도 제작.

| 구분 | icon_style.css | guide01.css 등 |
|------|----------------|----------------|
| 대상 | **재사용 에셋** (지위·배지·유닛) | 씬별 일회성 보조 도형 |
| 이미지 | 없음 (CSS only) | 없음 |
| `--size` | 필수 | 선택 |

**신규 재사용 에셋** → `icon_style.css` + `components/`  
**씬 전용 카드·도식** → 시리즈 CSS, 에셋 HTML 복제 금지

---

## 9. 전체 컴포넌트 목록 (현행)

### RANK MEDAL (12)

`lev_d` · `lev_p` · `lev_jp` · `lev_sp` · `lev_fc` · `lev_gc` · `lev_dc` · `lev_rf` · `lev_crf` · `lev_mrf` · `lev_srf` · `lev_irf`

### BADGE (3 × 2모드)

| 서비스 | 펼침 `_o` | 닫힘 `_c` |
|--------|-----------|-----------|
| 베이스 사업자 | `base_business_icon_o` | `base_business_icon_c` |
| 오토십 | `autoship_icon_o` | `autoship_icon_c` |
| 추천 보너스 | `recommend_bonus_icon_o` | `recommend_bonus_icon_c` |

### UNIT (2)

`person_icon` · `member_icon`

### SUB ASSET (11)

`point_token_icon` · `status_check_icon` · `status_cross_icon` · `calendar_month_card` · `product_silhouette_card` · `delivery_box_icon` · `payment_card_icon` · `select_counter_badge` · `ep_split_card` · `cashback_card` · `price_step_card`

---

## 10. 미리보기

브라우저에서 `asset_design.asp` 열기:

- **RANK MEDAL** — 12지위 한 줄 배치
- **BADGE** — 펼침 3 + 닫힘 3
- **UNIT** — person + member
- **SUB ASSET** — 씬 서브 에셋 11종

CSS 수정 후 새로고침으로 즉시 확인.

---

*문서 버전: asset_design.asp · icon_style.css 기준 (2026-03)*
