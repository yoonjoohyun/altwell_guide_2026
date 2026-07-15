<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<!--#include file="includes/images.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>BASE사업자 이해하기 - ALTWELL SMART GUIDE</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
<style>
<!--#include file="includes/styles.asp"-->
</style>
</head>
<body class="page-layout">
<div id="layout-ov">

  <!-- ① 헤더 (64px, 블랙) -->
  <div id="lo-bar">
    <div id="lo-bar-left">
      <button id="lo-back" onclick="location.href='guide.asp'">&#8592;</button>
      <span id="lo-breadcrumb">가이드 영상</span>
      <span class="lo-hd-sep"> &rsaquo; </span>
      <span id="lo-scene-label">BASE사업자 이해하기</span>
    </div>
    <div id="lo-bar-right">
      <span id="lo-brand">ALTWELL SMART GUIDE</span>
      <span id="lo-brand-dot"></span>
    </div>
  </div>

  <!-- ② 메인 콘텐츠 -->
  <div id="lo-main">

    <!-- 모션 캔버스 (65%) -->
    <section id="lo-canvas">
      <div class="scene-bg-circle" id="bg-circle-1"></div>
      <div class="scene-bg-circle" id="bg-circle-2"></div>
      <div class="scene-bg-circle" id="bg-circle-3"></div>
      <div id="dot-pattern"></div>

      <!-- SVG 관계 연결선 -->
      <svg id="lo-connectors" viewBox="0 0 100 100" preserveAspectRatio="none">
        <line id="connector-left"  x1="50" y1="48" x2="22" y2="68"/>
        <line id="connector-right" x1="50" y1="48" x2="78" y2="68"/>
      </svg>

      <!-- ─── 메인 멤버: BASE사업자 (Design Bible §7) ─── -->
      <div class="member-unit" id="member-unit-main">
        <div class="member-visual" id="member-visual-main">
          <img class="member-image" id="member-image-main" src="<%=memberImg%>" alt="BASE사업자"/>
          <div class="member-emblems" id="member-emblems-main">
            <div class="member-emblem-group">
              <div class="condition-emblem autoship-emblem" id="autoship-emblem-main">
                <img src="<%=autoshipImg%>" alt="오토십 이용"/>
              </div>
              <div class="qualification-badge base-business" id="base-business-badge-main">
                <img src="<%=basebizImg%>" alt="BASE사업자 자격"/>
              </div>
              <div class="rank-medal" id="rank-medal-main">
                <img src="<%=lev01Img%>" alt="D 지위"/>
              </div>
            </div>
          </div>
        </div>
        <div class="member-income bonus-stack" id="bonus-stack-main">
          <div class="bonus-plate support-bonus" id="support-bonus-main">
            <span class="bonus-indicator"></span>
            <span class="bonus-label">후원 보너스</span>
            <strong class="bonus-value">3%</strong>
          </div>
          <div class="bonus-plate recommend-bonus" id="recommend-bonus-main">
            <span class="bonus-indicator"></span>
            <span class="bonus-label">추천 보너스</span>
            <strong class="bonus-value">10,000원 &times; 2</strong>
          </div>
        </div>
      </div>

      <!-- ─── 왼쪽 자식 멤버: SEP 회원 (Design Bible §7) ─── -->
      <div class="member-unit member-child" id="member-unit-left">
        <div class="member-visual" id="member-visual-left">
          <img class="member-image" id="member-image-left" src="<%=peopleImg%>" alt="SEP 회원 좌"/>
          <div class="member-emblems" id="member-emblems-left">
            <div class="condition-emblem autoship-emblem" id="autoship-emblem-left">
              <img src="<%=autoshipImg%>" alt="오토십 이용"/>
            </div>
          </div>
          <div class="member-metrics" id="member-metrics-left">
            <div class="metric-badge sep-badge" id="sep-badge-left">
              <span class="sep-badge-text">S.E.P<br>30만↑</span>
            </div>
          </div>
        </div>
      </div>

      <!-- ─── 오른쪽 자식 멤버: SEP 회원 (Design Bible §7) ─── -->
      <div class="member-unit member-child" id="member-unit-right">
        <div class="member-visual" id="member-visual-right">
          <img class="member-image" id="member-image-right" src="<%=peopleImg%>" alt="SEP 회원 우"/>
          <div class="member-emblems" id="member-emblems-right">
            <div class="condition-emblem autoship-emblem" id="autoship-emblem-right">
              <img src="<%=autoshipImg%>" alt="오토십 이용"/>
            </div>
          </div>
          <div class="member-metrics" id="member-metrics-right">
            <div class="metric-badge sep-badge" id="sep-badge-right">
              <span class="sep-badge-text">S.E.P<br>30만↑</span>
            </div>
          </div>
        </div>
      </div>

    </section>

    <!-- 정보 패널 (35%, 화이트) -->
    <aside id="lo-panel">
      <p id="panel-fixed-title">BASE사업자 이해하기</p>
      <h2 class="scene-title" id="scene-title-main">BASE사업자가 되면 무엇이 달라질까요?</h2>
      <ul class="scene-bullet-list" id="scene-bullets">
        <li class="bullet-item" id="bullet-1">
          <span class="bullet-dot"></span>
          <span class="bullet-text">권리 소득의 출발점</span>
        </li>
        <li class="bullet-item" id="bullet-2">
          <span class="bullet-dot"></span>
          <span class="bullet-text">추천 보너스 지급</span>
        </li>
      </ul>
    </aside>

  </div><!-- /lo-main -->

  <!-- ③ 컨트롤러 (블랙) -->
  <div id="lo-ctrl">
    <div id="lo-progress-wrap">
      <div id="lo-tl">
        <div id="lo-tlf"></div>
        <div id="lo-tlt"></div>
      </div>
    </div>
    <div id="lo-cr">
      <button id="btn-play">&#9654;</button>
      <span id="time-current">0:02</span>
      <span class="lo-time-sep">/</span>
      <span id="time-total">3:00</span>
      <span id="scene-number">· Scene 05</span>
      <button id="btn-help">HELP</button>
    </div>
  </div>

</div>
<!--#include file="includes/motion.js.asp"-->
</body>
</html>