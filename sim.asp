<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>시뮬레이터 - ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/sim.css"/>
</head>
<body class="d2 page-list">
<nav id="nav">
  <!--<button class="nav-back" onclick="location.href='index.asp'">&#8592;</button>-->
  <button type="button" class="nav-logo" onclick="location.href='index.asp'" aria-label="홈으로">ALTWELL<span> SMART GUIDE</span></button>
  <span id="nav-page-title">시뮬레이터</span>
  <div class="nav-spacer"></div>
</nav>
<div class="list-page" id="sim-page">
  <div class="list-wrap">
    <div class="lp-head">
      <div class="lp-title">시뮬레이터</div>
      <div class="lp-desc">인터랙티브 애니메이션으로 비즈니스 구조를 직접 체험하세요.</div>
    </div>
    <div class="sim-grid">
      <div class="sc-card" onclick="location.href='01_base_business_simulator.asp'">
        <div class="sc-thumb t1">
          <div class="sc-thumb-glow"></div>
          <div class="sc-thumb-icon">?</div>
          <div class="sc-badge">NEW</div>
        </div>
        <div class="sc-body">
          <div class="sc-label">인터랙티브 시뮬레이터</div>
          <div class="sc-title">BASE사업자 이해하기</div>
          <div class="sc-desc">Scene 1~3 핵심 내용을 질문과 선택으로 직접 학습하세요. 3단계 · 인터랙티브 복습</div>
          <div class="sc-footer">
            <span class="sc-meta">3단계 · 질문형 학습</span>
            <button class="sc-go">▶ 시작하기</button>
          </div>
        </div>
      </div>
      <div class="sc-card disabled">
        <div class="sc-thumb t2">
          <div class="sc-thumb-glow" style="background:radial-gradient(circle,rgba(124,58,237,.28),transparent 70%)"></div>
          <div class="sc-thumb-icon">?</div>
        </div>
        <div class="sc-body">
          <div class="sc-label">성장 시뮬레이터</div>
          <div class="sc-title">SEP 성장 계산기</div>
          <div class="sc-desc">나의 추천 현황과 SEP를 입력하면 예상 보너스와 다음 목표 레벨을 계산해드립니다.</div>
          <div class="sc-footer">
            <span class="sc-meta">곧 출시 예정</span>
            <button class="sc-go off">준비 중</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>