<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>가이드 영상 - ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/guide.css?v=20261024cardfoot"/>
<link rel="stylesheet" href="_css/page_loading.css?v=20261023load7"/>
</head>
<body class="d2 page-list">
<%
NavSubTitle = "가이드 영상"
NavShowMypage = False
%>
<!--#include file="includes/site_nav.asp"-->
<div class="list-page" id="guide-page">
  <div class="list-wrap">
    <div class="lp-head">
      <div class="lp-title">Guide Videos</div>
      <div class="lp-desc">앨트웰의 성공적인 비즈니스를 위해 필요한 모든 것들을 영상을 통해 알아보세요.</div>
    </div>
<%
ListSectionActive = "guide"
%>
<!--#include file="includes/list_section_tabs.asp"-->
    <div class="lp-panel">
    <div class="lp-panel-inner">
    <div class="lp-panel-top">
    <div class="view-tabs">
      <button class="vt on" onclick="setView('grid',this)">썸네일</button>
      <button class="vt" onclick="setView('list',this)">리스트</button>
    </div>
    </div>
    <div class="cards-grid" id="vcards">
      <div class="vcard" onclick="location.href='frame_layout.asp'" style="display:none;">
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

      <div class="vcard entry-nav-card" data-entry-href="<%=GuideAppRoot()%>/guide01_smartguide.asp?from=guide">
        <div class="vc-thumb"><div class="vc-thumb-inner g1">
          <span>SMART<br>AUTOSHIP<br>GUIDE</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span style="display:none;" class="vc-step">GUIDE 01</span><span class="vc-new">NEW</span></div>
          <div class="vc-title">스마트 오토십 알아보기</div>
          <div class="vc-desc">3개월 단위 정기 구독 서비스의 혜택과 이용 방법 및 활용도에 대해 알아보세요.</div>
          <div class="vc-meta">
            <span class="vc-meta-grid">4분 37초</span>
            <span class="vc-meta-list">4분 37초 (7/7)</span>
          </div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>

      <div class="vcard entry-nav-card" data-entry-href="<%=GuideAppRoot()%>/guide02_smartguide.asp?from=guide">
        <div class="vc-thumb"><div class="vc-thumb-inner g2">
          <span>START PACK<br>GUIDE</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span style="display:none;" class="vc-step">GUIDE 02</span><span class="vc-new">NEW</span></div>
          <div class="vc-title">스타트팩 알아보기</div>
          <div class="vc-desc">앨트웰 신규 회원 전용 특별 할인 패키지 '누벨마리', '시그니처' 스타트팩의 혜택에 대해 알아보세요.</div>
          <div class="vc-meta">
            <span class="vc-meta-grid">4분 40초</span>
            <span class="vc-meta-list">4분 40초 (8/8)</span>
          </div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
      
      <div class="vcard entry-nav-card" data-entry-href="<%=GuideAppRoot()%>/guide03_smartguide.asp?from=guide">
        <div class="vc-thumb"><div class="vc-thumb-inner g3">
          <span>BASE<br>BUSINESS<br>GUIDE</span><div class="vc-play">▶</div>
        </div></div>
        <div class="vc-body">
          <div class="vc-top"><span style="display:none;" class="vc-step">GUIDE 03</span><span class="vc-new">NEW</span></div>
          <div class="vc-title">BASE사업자 이해하기</div>
          <div class="vc-desc">권리 소득이 시작되는 첫 번째 전환점, BASE사업자 조건과 비즈니스 활용 방법에 대해 알아보세요.</div>
          <div class="vc-meta">
            <span class="vc-meta-grid">5분 28초</span>
            <span class="vc-meta-list">5분 28초 (10/10)</span>
          </div>
          <div class="vc-prog"><div class="vc-prog-fill" style="width:0%"></div></div>
        </div>
      </div>
      <div class="vcard" onclick="location.href='03_sep_growth_smartguide.asp?from=guide'" style="display:none;">
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
      <div class="vcard" style="display:none;">
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
    </div>
  </div>
<!--#include file="includes/list_footer.asp"-->
</div>
<!--#include file="includes/list_entry_nav.js.asp"-->
<script>
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