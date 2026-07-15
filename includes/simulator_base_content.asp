      <!-- Question Panel -->
      <div id="sim-question-panel">
        <p id="panel-fixed-title">BASE사업자 이해하기</p>
        <p id="sim-step-label" class="sim-step-label">STEP 1</p>
        <h2 class="scene-title" id="scene-title-main"></h2>
        <p id="sim-question" class="sim-question"></p>
        <div id="sim-choices" class="sim-choices" role="group" aria-label="선택지"></div>
        <div id="sim-feedback" class="sim-feedback is-hidden" aria-live="polite" role="status"></div>
        <button type="button" id="sim-next-btn" class="sim-next-btn is-hidden" disabled>다음 단계</button>
      </div>

      <!-- Result Panel -->
      <div id="sim-result-panel" class="is-hidden" aria-label="학습 결과">
        <p id="sim-result-chapter" class="sim-result-chapter">BASE사업자 이해하기</p>
        <h2 id="sim-result-title" class="sim-result-title">BASE사업자의 핵심을 이해했습니다</h2>
        <ul id="sim-result-summary" class="sim-result-summary">
          <li class="sim-result-item">
            <span class="sim-result-icon" aria-hidden="true">&#10003;</span>
            <span class="sim-result-text">BASE사업자는 지위가 아닌 권리 자격</span>
          </li>
          <li class="sim-result-item">
            <span class="sim-result-icon" aria-hidden="true">&#10003;</span>
            <span class="sim-result-text">혜택을 공유하고 오토십 이용자 2명을 확보하면서 시작</span>
          </li>
          <li class="sim-result-item">
            <span class="sim-result-icon" aria-hidden="true">&#10003;</span>
            <span class="sim-result-text">소비자에서 권리 소득을 만들어가는 사업자로 전환</span>
          </li>
        </ul>
        <div class="sim-result-actions">
          <button type="button" id="sim-btn-relearn" class="sim-action-btn sim-action-primary">다시 학습하기</button>
          <button type="button" id="sim-btn-watch-video" class="sim-action-btn">교육영상 다시 보기</button>
          <button type="button" id="sim-btn-back-list" class="sim-action-btn sim-action-muted">시뮬레이터 목록으로 돌아가기</button>
        </div>
      </div>
