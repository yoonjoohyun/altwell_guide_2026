<%@ Language=VBScript CodePage=65001 %>

<!--#include file="includes/asp_utf8.asp"-->

<html lang="ko">

<head>

<meta charset="utf-8"/>

<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<title>에셋 디자인 - ALTWELL SMART GUIDE</title>

<!--#include file="includes/fonts.asp"-->

<!--#include file="includes/main_css.asp"-->

<link rel="stylesheet" href="_css/icon_style.css"/>

<style>

.asset-preview{padding:40px 24px 60px;display:flex;flex-direction:column;gap:48px}

.asset-preview h2{font-size:14px;font-weight:700;color:#64748b;letter-spacing:.08em;margin-bottom:16px}

.lev_container,.badge_container,.sub_asset_container{display:flex;flex-wrap:wrap;gap:24px;align-items:center}

</style>

</head>

<body class="page-layout" style="overflow:scroll;">



<div class="asset-preview">

  <section>

    <h2>RANK MEDAL</h2>

    <!--#include file="includes/components/lev_container.asp"-->

  </section>

  <section>

    <h2>BADGE</h2>

    <!--#include file="includes/components/badge_container.asp"-->

  </section>

  <section>

    <h2>UNIT</h2>

    <!--#include file="includes/components/person_container.asp"-->

  </section>

  <section>

    <h2>SUB ASSET</h2>

    <!--#include file="includes/components/sub_asset_container.asp"-->
<!-- ==========================================================================
     [BLOCK A] HTML 마크업 모음 (includes/components/ 파일별 구조)
     ========================================================================== -->

<!-- 1. '3개월 구독' 달력 에셋 (includes/components/calendar_quarter_group.asp) -->
<div class="calendar_quarter_group" aria-label="3개월 정기 구독">
  <div class="calendar_quarter_cards">
    <div class="calendar_mini_card">
      <div class="calendar_mini_header">M1</div>
      <div class="calendar_mini_body">1개월</div>
    </div>
    <div class="calendar_mini_card">
      <div class="calendar_mini_header">M2</div>
      <div class="calendar_mini_body">2개월</div>
    </div>
    <div class="calendar_mini_card">
      <div class="calendar_mini_header">M3</div>
      <div class="calendar_mini_body">3개월</div>
    </div>
  </div>
  <div class="calendar_quarter_tag">3개월 정기 구독</div>
</div>

<!-- 2. '+' 추가 효과 에셋 (includes/components/effect_plus_icon.asp) -->
<div class="effect_plus_icon" role="img" aria-label="추가"></div>

<!-- 3. '할인 혜택' 뱃지 에셋 (includes/components/discount_benefit_badge.asp) -->
<!-- 펼침형 (_o) -->
<div class="discount_benefit_badge_o" aria-label="할인 혜택">
  <div class="discount_benefit_label">%</div>
  <div class="discount_benefit_text">할인 혜택</div>
</div>

<!-- 닫힘/축약형 (_c) -->
<div class="discount_benefit_badge_c" aria-label="할인 혜택">
  <div class="discount_benefit_label">%</div>
  <div class="discount_benefit_text">할인 혜택</div>
</div>


<!-- ==========================================================================
     [BLOCK B] CSS 스타일 모음 (_css/icon_style.css 추가용)
     ========================================================================== -->
<style>
/* 1. '3개월 구독' 달력 에셋 */
.calendar_quarter_group {
  --size: 200px;
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  width: var(--size);
  padding: calc(var(--size) * 8 / 200);
  gap: calc(var(--size) * 8 / 200);
  box-sizing: border-box;
  background-color: #f8fafc;
  border: calc(var(--size) * 2 / 200) solid #2c51ca;
  border-radius: calc(var(--size) * 12 / 200);
  box-shadow: 0 calc(var(--size) * 4 / 200) calc(var(--size) * 12 / 200) rgba(44, 81, 202, 0.12);
  font-family: var(--font-sans, 'MinSansVF', sans-serif);
  flex-shrink: 0;
}
.calendar_quarter_cards {
  display: flex;
  width: 100%;
  gap: calc(var(--size) * 6 / 200);
}
.calendar_mini_card {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-radius: calc(var(--size) * 6 / 200);
  border: calc(var(--size) * 1 / 200) solid #dce4f0;
  background-color: #ffffff;
  overflow: hidden;
}
.calendar_mini_header {
  height: calc(var(--size) * 18 / 200);
  background: linear-gradient(120deg, #2c51ca, #1034ac);
  color: #ffffff;
  font-size: calc(var(--size) * 9 / 200);
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}
.calendar_mini_body {
  height: calc(var(--size) * 32 / 200);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: calc(var(--size) * 11 / 200);
  font-weight: 700;
  color: #1e293b;
}
.calendar_quarter_tag {
  font-size: calc(var(--size) * 11 / 200);
  font-weight: 800;
  color: #1034ac;
  background-color: #eaf0fc;
  padding: calc(var(--size) * 4 / 200) calc(var(--size) * 10 / 200);
  border-radius: calc(var(--size) * 6 / 200);
  white-space: nowrap;
}

/* 2. '+' 추가 효과 에셋 */
.effect_plus_icon {
  --size: 28px;
  position: relative;
  display: inline-block;
  width: var(--size);
  height: var(--size);
  border-radius: 50%;
  background-color: #2c51ca;
  box-shadow: 0 calc(var(--size) * 2 / 28) calc(var(--size) * 6 / 28) rgba(44, 81, 202, 0.25);
  flex-shrink: 0;
}
.effect_plus_icon::before,
.effect_plus_icon::after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  background-color: #ffffff;
  border-radius: calc(var(--size) * 2 / 28);
  transform: translate(-50%, -50%);
}
.effect_plus_icon::before {
  width: calc(var(--size) * 14 / 28);
  height: calc(var(--size) * 3.5 / 28);
}
.effect_plus_icon::after {
  width: calc(var(--size) * 3.5 / 28);
  height: calc(var(--size) * 14 / 28);
}

/* 3. '할인 혜택' 뱃지 에셋 */
.discount_benefit_badge_o,
.discount_benefit_badge_c {
  --size: 36px;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  width: fit-content;
  height: var(--size);
  padding: calc(var(--size) * 5 / 36) calc(var(--size) * 7 / 36);
  gap: calc(var(--size) * 5 / 36);
  background: linear-gradient(120deg, #e65100, #f57c00, #ef6c00);
  box-shadow: inset 0 0 0 calc(var(--size) * 2 / 36) #b23c00;
  border-radius: calc(var(--size) * 10 / 36);
  font-family: var(--font-sans, 'MinSansVF', sans-serif);
  flex-shrink: 0;
}
.discount_benefit_badge_c .discount_benefit_text {
  display: none;
}
.discount_benefit_label {
  width: calc(var(--size) * 24 / 36);
  height: calc(var(--size) * 24 / 36);
  line-height: calc(var(--size) * 24 / 36);
  text-align: center;
  border-radius: 50%;
  background-color: #ffd180;
  color: #b23c00;
  font-weight: 900;
  font-size: calc(var(--size) * 14 / 36);
  flex-shrink: 0;
}
.discount_benefit_text {
  font-weight: 700;
  font-size: calc(var(--size) * 18 / 36);
  line-height: calc(var(--size) * 18 / 36);
  color: #ffffff;
  white-space: nowrap;
}
</style>
  </section>

  <section class="g01-anim-section">

    <h2>G01 ZONED ANIMATION</h2>

    <p class="g01-anim-intro">guide01_smartguide.asp에서 사용하는 7×7 존 에셋 Motion Component 미리보기 · <code>asset_animation_rull.md</code> 규칙 기반</p>

    <div class="g01-anim-card">

      <div class="g01-anim-stage-wrap">

        <div class="g01-anim-stage-outer">

          <div id="g01-anim-canvas" class="guide01-canvas g01-anim-stage" aria-label="G01 애니메이션 미리보기 캔버스"></div>

        </div>

        <p id="g01-anim-status" class="g01-anim-status">버튼을 눌러 Motion Component를 확인하세요.</p>

      </div>

      <div class="g01-anim-controls">

        <button type="button" class="g01-anim-btn" data-g01-anim="enterFade">Enter Fade<br><span>g01.zoned.enterFade</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="enterPop">Enter Pop<br><span>g01.zoned.enterPop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="enterDrop">Enter Drop<br><span>g01.zoned.enterDrop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="popScale">Pop Scale<br><span>g01.zoned.popScale</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="exit">Exit<br><span>g01.zoned.exit</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="idle">Idle Float<br><span>g01.zoned.idleStart/Stop</span></button>

        <button type="button" class="g01-anim-btn" data-g01-anim="move">Move Zone<br><span>g01.zoned.move</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-accent" data-g01-anim="sequence">Sequence<br><span>등장→idle→퇴장</span></button>

        <p class="g01-anim-group-label">Badge Fold · _c ↔ _o</p>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldAutoship">Unfold<br><span>오토십 구독</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldAutoship">Fold<br><span>오토십 구독</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldBase">Unfold<br><span>베이스 사업자</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldBase">Fold<br><span>베이스 사업자</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeUnfoldRecommend">Unfold<br><span>추천 보너스</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge" data-g01-anim="badgeFoldRecommend">Fold<br><span>추천 보너스</span></button>

        <button type="button" class="g01-anim-btn g01-anim-btn-badge g01-anim-btn-accent" data-g01-anim="badgeCycle">Cycle<br><span>펼침↔접힘 반복</span></button>

      </div>

    </div>

  </section>

</div>

<link rel="stylesheet" href="_css/guide01.css"/>

<style>
.g01-anim-section{margin-top:16px;padding-top:8px;border-top:2px solid #e2e8f0}
.g01-anim-intro{font-size:13px;color:#64748b;margin:-8px 0 20px;line-height:1.5}
.g01-anim-intro code{font-size:12px;background:#f1f5f9;padding:2px 6px;border-radius:4px}
.g01-anim-card{display:flex;flex-wrap:wrap;gap:28px;align-items:flex-start}
.g01-anim-stage-wrap{
  display:flex;
  flex-direction:column;
  gap:8px;
  flex:0 0 420px;
  width:420px;
  max-width:100%;
}
.g01-anim-stage-outer{
  flex-shrink:0;
  width:420px;
  height:315px;
  max-width:100%;
  box-sizing:border-box;
  padding:14px;
  border:1px solid #dbeafe;
  border-radius:12px;
  background:linear-gradient(160deg,#f8fafc 0%,#eef2ff 100%);
  box-shadow:0 4px 16px rgba(30,90,180,.08);
  overflow:visible;
}
.g01-anim-stage{
  width:100%;
  height:100%;
  position:relative;
  overflow:visible;
  box-sizing:border-box;
}
.g01-anim-stage .g01-zone-wrap{
  overflow:visible;
}
@media(max-width:480px){
  .g01-anim-stage-wrap{width:100%;flex-basis:100%}
  .g01-anim-stage-outer{width:100%;height:auto;aspect-ratio:4/3}
}
.g01-anim-status{font-size:12px;color:#64748b;min-height:18px;margin:0}
.g01-anim-controls{display:flex;flex-wrap:wrap;gap:10px;max-width:520px}
.g01-anim-btn{
  min-width:108px;
  padding:10px 12px;
  border:1px solid #cbd5e1;
  border-radius:10px;
  background:#fff;
  font-size:12px;
  font-weight:700;
  color:#1e293b;
  cursor:pointer;
  line-height:1.35;
  transition:background .15s,border-color .15s,transform .1s;
}
.g01-anim-btn span{display:block;font-size:10px;font-weight:500;color:#64748b;margin-top:4px;font-family:Consolas,monospace}
.g01-anim-btn:hover{background:#f8fafc;border-color:#93c5fd}
.g01-anim-btn:active{transform:scale(.97)}
.g01-anim-btn-accent{border-color:#3b82f6;background:#eff6ff}
.g01-anim-group-label{
  flex-basis:100%;
  margin:12px 0 0;
  padding-top:12px;
  border-top:1px dashed #cbd5e1;
  font-size:11px;
  font-weight:700;
  color:#64748b;
  letter-spacing:.06em;
}
.g01-anim-btn-badge{border-color:#c4b5fd;background:#faf5ff}
.g01-anim-btn-badge:hover{border-color:#8b5cf6;background:#f3e8ff}
</style>

<!--#include file="includes/components/guide01_templates.asp"-->
<!--#include file="includes/images.asp"-->
<!--#include file="includes/motion.js.asp"-->
<!--#include file="includes/motions/core/motionComponent.js.asp"-->
<!--#include file="includes/motions/g01/_load.asp"-->
<!--#include file="includes/motions/g01/preview.js.asp"-->

<script>G01AnimPreview.init();</script>

</body>

</html>

