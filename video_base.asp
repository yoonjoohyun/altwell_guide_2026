<%@ Language=VBScript CodePage=65001 %>
<!--#include file="includes/asp_utf8.asp"-->
<!--#include file="includes/images.asp"-->

<html lang="ko">

<head>

<meta charset="utf-8"/>

<meta name="viewport" content="width=device-width,initial-scale=1.0"/>

<title>ALTWELL SMART GUIDE</title>

<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>

<style>

<!--#include file="includes/styles.asp"-->

</style>

</head>

<body class="page-layout">

<div id="layout-ov">



  <!-- ① 헤더 (64px, 블랙) -->

  <div id="lo-bar">

    <div id="lo-bar-left">

      <button id="lo-back" onclick="closePlayer()">&#8592;</button>

      <span id="lo-breadcrumb">가이드 영상</span>

      <span class="lo-hd-sep"> &rsaquo; </span>

      <span id="lo-scene-label">ALTWELL SMART GUIDE</span>

    </div>

    <div id="lo-bar-right">

      <span id="lo-brand">ALTWELL SMART GUIDE</span>

      <span id="lo-brand-dot"></span>

    </div>

  </div>



  <!-- ② 메인 콘텐츠 -->

  <div id="lo-main">



    <!-- 모션 캔버스 (65%) ? 씬별 오브젝트 주입 -->

    <section id="lo-canvas">

      <div id="motion-canvas"></div>

    </section>



    <!-- 정보 패널 (35%) -->

    <aside id="lo-panel">

      <p id="panel-fixed-title" class="is-hidden"></p>

      <h2 class="scene-title is-hidden" id="scene-title-main"></h2>

      <p id="panel-scene-desc" class="panel-desc is-hidden"></p>

      <ul class="scene-bullet-list is-hidden" id="scene-bullets"></ul>

    </aside>



  </div><!-- /lo-main -->



  <!-- ③ 컨트롤러 (블랙) -->

  <div id="lo-ctrl">

    <div id="lo-progress-wrap">

      <div id="lo-tl" onclick="onSeek(event)">

        <div id="lo-tl-markers"></div>

        <div id="lo-tlf"></div>

        <div id="lo-tlt"></div>

      </div>

    </div>

    <div id="lo-cr">

      <button id="btn-play" onclick="togglePlay()">&#9654;</button>

      <span id="time-current">0:00</span>

      <span class="lo-time-sep">/</span>

      <span id="time-total">0:00</span>

      <span id="scene-number">· 준비</span>

    </div>

  </div>



</div>



<script>

var backUrl = (function(){

  var p = new URLSearchParams(location.search).get('from');

  return p === 'sim' ? 'sim.asp' : 'guide.asp';

})();



var breadcrumbMap = {guide:'가이드 영상', sim:'시뮬레이터'};



(function(){

  var p = new URLSearchParams(location.search).get('from') || 'guide';

  var bc = document.getElementById('lo-breadcrumb');

  if(bc) bc.textContent = breadcrumbMap[p] || breadcrumbMap.guide;

})();



function closePlayer(){

  SceneRunner.pauseLesson();

  location.href = backUrl;

}

</script>



<!-- Object & Motion Library -->

<!--#include file="includes/motion.js.asp"-->

<!-- Scene Runner + Controls -->

<!--#include file="includes/sceneRunner.js.asp"-->

<!--#include file="includes/playerControls.js.asp"-->

<!-- Scene Modules -->

<!--#include file="includes/scenes/base/scene01.js.asp"-->

<!--#include file="includes/scenes/base/lesson.asp"-->



<script>

LessonBase.init();

</script>



<!-- Legacy reference: includes/player.js.asp, includes/legacy/basePlayerStage.asp -->



</body>

</html>

