<div id="layout-ov">

  <!-- ① 상단 프레임 -->
  <!--#include file="video_controller_top.asp"-->

  <!--
    ② 씬 1개 = 좌 모션(4:3) + 우 텍스트 + 음성(mp4)
       · 좌 #motion-canvas     — 씬별 모션 그래픽 (JS scene.motion)
       · 우 #lo-panel          — 부연·핵심 정보 (JS scene.panel)
       · #scene-media          — voice/{seriesId}/sceneNN.mp4 (SceneMedia 자동)
  -->
  <div id="lo-main">

    <div class="lo-motion-zone" aria-label="모션그래픽 4:3">
      <div class="lo-stage-frame">
        <section id="lo-canvas">

          <!-- 고정 스테이지 배경 (씬 전환해도 유지) -->
          <div id="motion-stage-bg" aria-hidden="true">
            <div class="scene-bg-circle" id="bg-circle-1"></div>
            <div class="scene-bg-circle" id="bg-circle-2"></div>
            <div class="scene-bg-circle" id="bg-circle-3"></div>
            <div id="dot-pattern"></div>
          </div>

          <!-- 씬별 모션 그래픽 주입면 -->
          <div id="motion-canvas"></div>

          <!-- 7×7 존 배치 그리드 (씬 reset 시에도 유지) -->
          <div id="motion-zone-grid" aria-hidden="true"></div>

        </section>
      </div>
    </div>

    <aside id="lo-panel" aria-label="씬 부연설명·핵심 정보">
      <h2 class="scene-title is-hidden" id="scene-title-main"></h2>
      <p id="panel-scene-desc" class="panel-desc is-hidden"></p>
      <ul class="scene-bullet-list is-hidden" id="scene-bullets"></ul>
    </aside>

  </div><!-- /lo-main -->

  <!-- ③ 하단 컨트롤러 -->
  <!--#include file="video_controller_bottom.asp"-->

</div>

<video id="scene-media" preload="auto" playsinline webkit-playsinline style="position:fixed;left:0;top:0;width:1px;height:1px;opacity:0;pointer-events:none;z-index:-1"></video>

<!--#include file="video_init.asp"-->
