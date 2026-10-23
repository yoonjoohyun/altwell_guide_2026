<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>BASE사업자 이해하기 시뮬레이션 - ALTWELL SMART GUIDE</title>
<script>window.GUIDE_ROOT="<%=GuideAppRoot()%>";</script>
<!--#include file="includes/fonts.asp"-->
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/main.css"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/icon_style.css"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide03.css?v=20261024simq2"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide_close.css?v=20261024simclose"/>
<style>
<!--#include file="includes/styles.asp"-->
.sim-board{display:flex;flex-direction:column;gap:10px;margin:0 0 16px 0}
.sim-person{background:rgba(255,255,255,.88);border:1.5px solid rgba(30,90,180,.14);border-radius:10px;padding:10px 12px}
.sim-person-name{font-size:15px;font-weight:800;color:#0f172a;margin:0 0 8px 0}
.sim-toggles{display:flex;flex-wrap:wrap;gap:8px}
.sim-toggle,.sim-total-btn,.sim-verdict-btn,.sim-judge{
  font-family:inherit;cursor:pointer;border-radius:8px;font-weight:700
}
.sim-toggle,.sim-total-btn{
  border:1.5px solid rgba(30,90,180,.2);background:#fff;color:#334155;
  padding:8px 12px;font-size:15px
}
.sim-toggle.is-on,.sim-total-btn.is-on{
  border-color:#10b981;background:rgba(16,185,129,.12);color:#065f46
}
.sim-toggle:disabled,.sim-total-btn:disabled,.sim-verdict-btn:disabled,.sim-judge:disabled{cursor:default}
.sim-total{display:flex;flex-wrap:wrap;align-items:center;gap:8px}
.sim-total-label{font-size:15px;font-weight:800;color:#0f172a;width:100%}
.sim-actions{display:flex;flex-wrap:nowrap;gap:8px;width:100%;box-sizing:border-box}
.sim-judge,.sim-verdict-btn{
  flex:1 1 0;min-width:0;box-sizing:border-box;
  border:none;background:#1e5ab4;color:#fff;padding:10px 8px;font-size:24px
}
.sim-verdict-btn.is-miss{background:#fff;color:#991b1b;border:1.5px solid rgba(238,51,56,.45)}
.sim-verdict-btn.is-correct-choice{background:#10b981}
.sim-judge.is-met{background:#10b981;color:#fff}
.sim-verdict-btn.is-miss.is-correct-choice{border:none;color:#fff}
.sim-verdict-btn.is-wrong{animation:sim-shake .35s ease}
</style>
</head>
<body class="page-layout">

<!--#include file="includes/simulator_layout.asp"-->
<!--#include file="includes/components/guide03_templates.asp"-->
<!--#include file="includes/video_runtime.asp"-->
<!--#include file="includes/series/guide03/guide03_common.js.asp"-->

<!--#include file="includes/series/guide03/scenes/scene01.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene01.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene02.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene02.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene05.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene05.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene05.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene06.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene06.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene06.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene07.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene07.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene07.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene10.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene10.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene10.js.asp"-->
<!--#include file="includes/sim_voice.js.asp"-->
<!--#include file="includes/components/guide_close_panel.js.asp"-->
<!--#include file="includes/series/guide03/guide03_simulator.js.asp"-->

<script>try{Guide03Simulator.init();}catch(e){console.error(e);}if(window.PageLoading)PageLoading.ready();</script>
</body>
</html>
