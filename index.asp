<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/index.css"/>
</head>
<body class="d1 page-home">
<nav id="nav">
  <button class="nav-back" onclick="location.href='index.asp'">&#8592;</button>
  <button type="button" class="nav-logo" onclick="location.href='index.asp'" aria-label="홈으로">ALTWELL<span> SMART GUIDE</span></button>
  <span id="nav-page-title"></span>
  <div class="nav-spacer"></div>
</nav>
<div id="home-page" class="page">
  <section id="hero">
    <div class="hero-badge">ALTWELL SMART GUIDE</div>
    <h1 class="hero-title">앨트웰 비즈니스,<br><em>스마트하게</em> 시작하세요</h1>
    <p class="hero-desc">가이드 영상과 인터랙티브 시뮬레이터로<br>복잡한 구조를 쉽고 빠르게 이해하세요.</p>
    <div class="hero-ctas">
      <button class="hcta p" onclick="location.href='guide.asp'">
        <span class="hcta-icon">
          <svg viewBox="0 0 52 52" fill="none" xmlns="http://www.w3.org/2000/svg">
            <!-- projector body -->
            <rect x="8" y="16" width="36" height="22" rx="4" fill="rgba(255,255,255,.18)" stroke="rgba(255,255,255,.7)" stroke-width="1.8"/>
            <!-- lens circle -->
            <circle cx="26" cy="27" r="7" fill="rgba(255,255,255,.12)" stroke="rgba(255,255,255,.85)" stroke-width="1.8"/>
            <!-- inner lens -->
            <circle cx="26" cy="27" r="3.2" fill="rgba(255,255,255,.35)"/>
            <!-- film reel left -->
            <circle cx="13" cy="20" r="3.2" fill="none" stroke="rgba(255,255,255,.65)" stroke-width="1.5"/>
            <circle cx="13" cy="20" r="1.1" fill="rgba(255,255,255,.65)"/>
            <!-- film reel right -->
            <circle cx="39" cy="20" r="3.2" fill="none" stroke="rgba(255,255,255,.65)" stroke-width="1.5"/>
            <circle cx="39" cy="20" r="1.1" fill="rgba(255,255,255,.65)"/>
            <!-- stand -->
            <line x1="22" y1="38" x2="20" y2="44" stroke="rgba(255,255,255,.6)" stroke-width="1.8" stroke-linecap="round"/>
            <line x1="30" y1="38" x2="32" y2="44" stroke="rgba(255,255,255,.6)" stroke-width="1.8" stroke-linecap="round"/>
            <line x1="17" y1="44" x2="35" y2="44" stroke="rgba(255,255,255,.6)" stroke-width="1.8" stroke-linecap="round"/>
            <!-- beam rays -->
            <line x1="33" y1="25" x2="45" y2="20" stroke="rgba(255,255,255,.35)" stroke-width="1.2" stroke-linecap="round"/>
            <line x1="33" y1="27" x2="46" y2="27" stroke="rgba(255,255,255,.35)" stroke-width="1.2" stroke-linecap="round"/>
            <line x1="33" y1="29" x2="45" y2="34" stroke="rgba(255,255,255,.35)" stroke-width="1.2" stroke-linecap="round"/>
          </svg>
        </span>
        <span class="hcta-label">가이드 영상<br>시청하기</span>
      </button>
      <button class="hcta s" onclick="location.href='sim.asp'">
        <span class="hcta-icon">
          <svg viewBox="0 0 52 52" fill="none" xmlns="http://www.w3.org/2000/svg">
            <!-- tablet body -->
            <rect x="10" y="7" width="32" height="40" rx="5" fill="rgba(238,51,56,.06)" stroke="#EE3338" stroke-width="1.9"/>
            <!-- screen area -->
            <rect x="13.5" y="11" width="25" height="27" rx="2.5" fill="rgba(238,51,56,.08)" stroke="rgba(238,51,56,.3)" stroke-width="1.2"/>
            <!-- home button -->
            <circle cx="26" cy="43" r="2" fill="none" stroke="#EE3338" stroke-width="1.5"/>
            <!-- screen content ? play icon -->
            <circle cx="26" cy="24.5" r="7" fill="rgba(238,51,56,.12)" stroke="#EE3338" stroke-width="1.4"/>
            <path d="M24 21.5 L30 24.5 L24 27.5 Z" fill="#EE3338"/>
            <!-- camera dot -->
            <circle cx="26" cy="9.2" r="1" fill="#EE3338" opacity=".5"/>
          </svg>
        </span>
        <span class="hcta-label">시뮬레이터로<br>복습하기</span>
      </button>
    </div>
  </section>
</div>
</body>
</html>