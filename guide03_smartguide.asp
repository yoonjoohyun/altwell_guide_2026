<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>BASE사업자 이해하기 - ALTWELL SMART GUIDE</title>
<script>window.GUIDE_ROOT="<%=GuideAppRoot()%>";</script>
<!--#include file="includes/fonts.asp"-->
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/main.css"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/icon_style.css"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/guide03.css?v=20261005s03b"/>
<link rel="stylesheet" href="<%=GuideAppRoot()%>/_css/video_controller.css"/>
<style>
<!--#include file="includes/styles.asp"-->
</style>
</head>
<body class="page-layout">
<!--#include file="includes/player/video_layout.asp"-->
<!--#include file="includes/components/guide03_templates.asp"-->
<!--#include file="includes/video_runtime.asp"-->
<!--#include file="includes/series/guide03/guide03_common.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene01.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene01.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene01.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene02.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene02.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene02.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.constants.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.setup.js.asp"-->
<!--#include file="includes/series/guide03/scenes/scene03.js.asp"-->
<!--#include file="includes/series/guide03/guide03.asp"-->
<script>SeriesGuide03.init();</script>
</body>
</html>
