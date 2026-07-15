<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<!--#include file="includes/images.asp"-->
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>BASE사업자 이해하기 시뮬레이터 - ALTWELL SMART GUIDE</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
<style>
<!--#include file="includes/styles.asp"-->
</style>
</head>
<body class="page-layout">

<!--#include file="includes/simulator_layout.asp"-->

<script>
function closeSimulator(){
  location.href = 'sim.asp';
}
</script>

<!-- Object & Motion Library -->
<!--#include file="includes/motion.js.asp"-->
<!-- Simulator Scene -->
<!--#include file="includes/series/01_base_business_running/scenes/sm_scene00.js.asp"-->

<script>
document.addEventListener('DOMContentLoaded', function(){
  BaseSimulator.initializeSimulator();
});
</script>

</body>
</html>
