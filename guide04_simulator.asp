<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>추천보너스 알아보기 시뮬레이션 - ALTWELL SMART GUIDE</title>
<script>window.GUIDE_ROOT="<%=GuideAppRoot()%>";</script>
<!--#include file="includes/fonts.asp"-->
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/main.css"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/icon_style.css?v=20261120s02"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide04.css?v=20261120s02"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide04_sim.css?v=20261127sim1"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide_close.css?v=20261024simclose"/>
<style>
<!--#include file="includes/styles.asp"-->
.sim-actions{display:flex;flex-wrap:nowrap;gap:8px;width:100%;box-sizing:border-box}
.sim-judge{
  flex:1 1 0;min-width:0;box-sizing:border-box;font-family:inherit;cursor:pointer;
  border:none;border-radius:8px;font-weight:700;background:#1e5ab4;color:#fff;
  padding:10px 8px;font-size:24px
}
.sim-judge.is-met{background:#10b981}
.sim-judge:disabled{cursor:default}
</style>
</head>
<body class="page-layout">

<!--#include file="includes/simulator_layout.asp"-->
<!--#include file="includes/components/guide04_templates.asp"-->
<!--#include file="includes/video_runtime.asp"-->
<!--#include file="includes/series/guide04/guide04_common.js.asp"-->

<!--#include file="includes/series/guide04/scenes/scene01.constants.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene01.setup.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene01.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene02.constants.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene02.setup.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene02.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene03.constants.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene03.setup.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene03.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene04.constants.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene04.setup.js.asp"-->
<!--#include file="includes/series/guide04/scenes/scene04.js.asp"-->
<!--#include file="includes/sim_sfx.js.asp"-->
<!--#include file="includes/components/guide_close_panel.js.asp"-->
<!--#include file="includes/series/guide04/guide04_simulator.js.asp"-->

<script>try{Guide04Simulator.init();}catch(e){console.error(e);}if(window.PageLoading)PageLoading.ready();</script>
</body>
</html>
