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
<%
NavSubTitle = "실습 콘텐츠"
NavShowMypage = False
%>
<!--#include file="includes/site_nav.asp"-->
<div class="list-page" id="sim-page">
  <div class="list-wrap">
    <div class="lp-head">
      <div class="lp-title">실습 콘텐츠</div>
      <div class="lp-desc">인터랙티브 학습 자료를 통해 가이드 영상의 내용을 복습해보세요.</div>
    </div>
    <div class="sim-grid">
      <div class="sc-card" onclick="location.href='guide01_simulator.asp'">
        <div class="sc-thumb t1">
          <div class="sc-thumb-glow" style="background:radial-gradient(circle,rgba(44,81,202,.35),transparent 70%)"></div>
          <div class="sc-thumb-icon">SMART<br>AUTOSHIP<br>QUIZ</div>
          <div class="sc-badge">NEW</div>
        </div>
        <div class="sc-body">
          <div class="sc-label">Interactive Content</div>
          <div class="sc-title">스마트 오토십 알아보기</div>
          <div class="sc-desc">스마트 오토십의 핵심 내용을 질문으로 복습하는 실습 콘텐츠입니다.</div>
          <div class="sc-footer">
            <span class="sc-meta">핵심 퀴즈</span>
            <button class="sc-go">▶ 시작하기</button>
          </div>
        </div>
      </div>
      <div class="sc-card" onclick="location.href='guide02_simulator.asp'">
        <div class="sc-thumb t2">
          <div class="sc-thumb-glow" style="background:radial-gradient(circle,rgba(142,61,76,.4),transparent 70%)"></div>
          <div class="sc-thumb-icon">START PACK<br>QUIZ</div>
        </div>
        <div class="sc-body">
          <div class="sc-label">Interactive Content</div>
          <div class="sc-title">스타트팩 알아보기</div>
          <div class="sc-desc">'누벨마리', '시그니처'스타트팩의 핵심 내용을 질문으로 복습하는 실습 콘텐츠입니다.</div>
          <div class="sc-footer">
            <span class="sc-meta">핵심 퀴즈</span>
            <button class="sc-go">▶ 시작하기</button>
          </div>
        </div>
      </div>
      <div class="sc-card disabled">
        <div class="sc-thumb t3">
          <div class="sc-thumb-glow"></div>
          <div class="sc-thumb-icon">BASE<br>BUSINESS<br>QUIZ</div>
        </div>
        <div class="sc-body">
          <div class="sc-label">Interactive Content</div>
          <div class="sc-title">BASE사업자 이해하기</div>
          <div class="sc-desc">BASE사업자 조건과 활용법에 대한 핵심 내용을 질문으로 복습하는 실습 콘텐츠입니다.</div>
          <div class="sc-footer">
            <span class="sc-meta">준비 중</span>
            <button type="button" class="sc-go off" disabled>준비 중</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>