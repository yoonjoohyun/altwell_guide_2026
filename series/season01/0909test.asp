<%@ Language=VBScript CodePage=65001 %>

<!--#include virtual="/includes/asp_utf8.asp"-->

<html lang="ko">

<head>

<meta charset="utf-8"/>

<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<title>0909 모션 테스트 - ALTWELL SMART GUIDE</title>

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



<!-- 0909 테스트: 멤버 에셋 부착 등 실험 씬 -->
<!--#include virtual="/includes/series/guide01/scenes/scene01_test.js.asp"-->

<!--#include virtual="/includes/series/guide01/guide01.asp"-->

<script>
SceneRunner.registerScene(Guide01Scene01);
SeriesGuide01.init();
</script>



</body>

</html>

