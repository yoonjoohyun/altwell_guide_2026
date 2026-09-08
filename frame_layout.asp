<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<!--
  frame_layout.asp — 영상 페이지 템플릿 + 에셋 컴포넌트 쇼케이스 데모

  재생 버튼 / 타임라인으로 15개 컴포넌트를 순차 소개합니다.
  새 영상 제작 시: 이 데모 블록 제거 후 [4][5][6] 씬 연동 추가
-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>에셋 컴포넌트 가이드 - ALTWELL SMART GUIDE</title>
<!--#include file="includes/fonts.asp"-->
<!--#include file="includes/main_css.asp"-->
<link rel="stylesheet" href="_css/icon_style.css"/>
<style>
<!--#include file="includes/styles.asp"-->
.asset-showcase-slot{
  position:absolute;inset:0;z-index:10;
  display:flex;align-items:center;justify-content:center;
  pointer-events:none;
}
.asset-showcase-slot > *{
  transform:scale(2);
  transform-origin:center center;
}
.asset-showcase-slot .base_business_icon,
.asset-showcase-slot .autoship_icon,
.asset-showcase-slot .recommend_bonus_icon{
  transform:scale(1.35);
}
.asset-enter{
  animation:asset-showcase-enter .55s cubic-bezier(.22,1,.36,1) both;
}
@keyframes asset-showcase-enter{
  from{opacity:0;transform:scale(1.4) translateY(12px)}
  to{opacity:1;transform:scale(2) translateY(0)}
}
.asset-showcase-slot .base_business_icon.asset-enter,
.asset-showcase-slot .autoship_icon.asset-enter,
.asset-showcase-slot .recommend_bonus_icon.asset-enter{
  animation-name:asset-showcase-enter-badge;
}
@keyframes asset-showcase-enter-badge{
  from{opacity:0;transform:scale(0.95) translateY(12px)}
  to{opacity:1;transform:scale(1.35) translateY(0)}
}
</style>
</head>
<body class="page-layout">

<!--#include file="includes/player/video_layout.asp"-->

<!--#include file="includes/components/asset_showcase_templates.asp"-->
<!--#include file="includes/components/asset_showcase.js.asp"-->
<script>AssetShowcase.init();</script>

</body>
</html>
