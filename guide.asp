<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>가이드 영상 - ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/guide.css"/>
</head>
<body class="d2 page-list">
<nav id="nav">
  <!--<button class="nav-back" onclick="location.href='index.asp'">&#8592;</button>-->
  <button type="button" class="nav-logo" onclick="location.href='index.asp'" aria-label="홈으로">ALTWELL<span> SMART GUIDE</span></button>
  <span id="nav-page-title">가이드 영상</span>
  <div class="nav-spacer"></div>
</nav>
<div class="list-page" id="guide-page">
  <div class="list-wrap">
    <div class="lp-head">
      <div class="lp-title">가이드 영상</div>
      <div class="lp-desc">단계별로 앨트웰 비즈니스 구조를 배워보세요.</div>
    </div>
    <div class="view-tabs">
      <button class="vt on" onclick="setView('grid',this)">단계별</button>
      <button class="vt" onclick="setView('list',this)">리스트</button>
    </div>
    <div class="cards-grid" id="vcards">
      <div class="vcard" onclick="location.href='frame_layout.asp'">
        <div class="vc-thumb"><div class="vc-thumb-inner g1">
          <span>?</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span class="vc-step">STEP 1</span><span class="vc-done">완료</span></div>
          <div class="vc-title">앨트웰 시작하기</div>
          <div class="vc-desc">디슈머로 시작해 사업자로 성장하는 여정의 첫 단계</div>
          <div class="vc-meta">? 12분</div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:100%"></div></div>
        </div>
      </div>
      <div class="vcard" onclick="location.href='/series/season01/guide01_smartguide.asp?from=guide'">
        <div class="vc-thumb"><div class="vc-thumb-inner g2">
          <span>?</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span class="vc-step">STEP 2</span><span class="vc-soon">제작 중</span></div>
          <div class="vc-title">오토십 알아보기</div>
          <div class="vc-desc">3개월 정기 구독 서비스의 혜택과 이용 기준</div>
          <div class="vc-meta">? —</div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
      <div class="vcard">
        <div class="vc-thumb"><div class="vc-thumb-inner g4">
          <span>?</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span class="vc-step">STEP 2B</span><span class="vc-soon">준비 중</span></div>
          <div class="vc-title">BASE사업자 이해하기</div>
          <div class="vc-desc">권리 소득이 시작되는 첫 번째 전환점, BASE사업자</div>
          <div class="vc-meta">? 3분</div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
      <div class="vcard" onclick="location.href='03_sep_growth_smartguide.asp?from=guide'">
        <div class="vc-thumb"><div class="vc-thumb-inner g3">
          <span>?</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span class="vc-step">STEP 3</span><span class="vc-new">TEST</span></div>
          <div class="vc-title">SEP 성장하기</div>
          <div class="vc-desc">실적을 쌓고 조직을 성장시키는 SEP 전략</div>
          <div class="vc-meta">? 0:10</div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
      <div class="vcard">
        <div class="vc-thumb"><div class="vc-thumb-inner g4">
          <span>?</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span class="vc-step">STEP 4</span><span class="vc-soon">준비 중</span></div>
          <div class="vc-title">권리 소득 시스템 구축하기</div>
          <div class="vc-desc">리더십 보너스와 장기적 수동 소득 시스템 완성</div>
          <div class="vc-meta">? 24분</div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
    </div>
  </div>
</div><script>
function setView(mode,btn){
  var vc=document.getElementById('vcards');
  if(!vc)return;
  document.querySelectorAll('.vt').forEach(function(t){t.classList.remove('on')});
  btn.classList.add('on');
  vc.className=mode==='list'?'cards-list':'cards-grid';
}
</script>
</body>
</html>