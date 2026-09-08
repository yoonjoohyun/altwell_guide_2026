<!-- Simulator common layout frame (Motion Canvas + Question Panel + Controls) -->
<div id="layout-ov" class="layout-simulator">

  <!--#include file="player/video_controller_top.asp"-->

  <!-- Main: 4:3 Motion Stage + Text Panel -->
  <div id="lo-main">

    <div class="lo-motion-zone">
      <div class="lo-stage-frame">
        <section id="lo-canvas" aria-label="모션그래픽">
          <div id="motion-canvas"></div>
        </section>
      </div>
    </div>

    <aside id="lo-panel" aria-label="텍스트 표시">
<!--#include file="simulator_base_content.asp"-->
    </aside>

  </div><!-- /lo-main -->

  <!-- Simulator Controls -->
  <div id="sim-ctrl" aria-label="시뮬레이터 컨트롤">
    <div id="sim-progress-wrap">
      <div id="sim-progress-track" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
        <div id="sim-progress-fill"></div>
      </div>
    </div>
    <div id="sim-cr">
      <button type="button" id="sim-btn-prev" class="sim-ctrl-btn" disabled aria-label="이전 단계">&#9664; 이전</button>
      <span id="sim-step-number" aria-live="polite">1 / 3</span>
      <button type="button" id="sim-btn-next" class="sim-ctrl-btn" disabled aria-label="다음 단계">다음 &#9654;</button>
      <button type="button" id="sim-btn-restart" class="sim-ctrl-btn sim-ctrl-restart" aria-label="다시 시작">&#8635; 다시 시작</button>
    </div>
  </div>

</div>
