<%@ Language=VBScript CodePage=65001 %>

<!--#include virtual="/includes/asp_utf8.asp"-->

<html lang="ko">

<head>

<meta charset="utf-8"/>

<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<title>오토십 알아보기 - ALTWELL SMART GUIDE</title>

<!--#include virtual="/includes/fonts.asp"-->

<link rel="stylesheet" href="/_css/main.css"/>

<link rel="stylesheet" href="/_css/icon_style.css"/>

<link rel="stylesheet" href="/_css/guide01.css"/>

<link rel="stylesheet" href="/_css/video_controller.css"/>

<style>

<!--#include virtual="/includes/styles.asp"-->

</style>

</head>

<body class="page-layout">



<!--#include virtual="/includes/player/video_layout.asp"-->

<!--#include virtual="/includes/components/guide01_templates.asp"-->

<!--#include virtual="/includes/images.asp"-->

<!--#include virtual="/includes/video_runtime.asp"-->

<!--#include virtual="/includes/series/guide01/guide01_common.js.asp"-->



<!-- 씬 추가 시: scenes/sceneNN.js.asp include 후 guide01.asp에서 registerScene -->
<!--#include virtual="/includes/series/guide01/scenes/scene01.constants.js.asp"-->
<!--#include virtual="/includes/series/guide01/scenes/scene01.setup.js.asp"-->
<!--#include virtual="/includes/series/guide01/scenes/scene01.js.asp"-->

<!--#include virtual="/includes/series/guide01/guide01.asp"-->

<script>SeriesGuide01.init();</script>



</body>

</html>

