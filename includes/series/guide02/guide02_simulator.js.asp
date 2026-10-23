<script>
/* 가이드02 시뮬레이션 — 씬 모션은 가이드02를 그대로 재생하고, 오른쪽은 질문으로 복습한다. */
var Guide02Simulator = (function(){
  var STEPS = [
    {
      config: Guide02Scene01Config,
      question: '스타트팩에 대한 설명으로 맞는 것은?',
      choices: [
        '앨트웰 대표 제품으로 구성된 신규 회원 전용 패키지이며, 회원가에서 50% 추가 할인된다',
        '기존 회원도 횟수 제한 없이 구매하는 상시 패키지이다',
        '정가 그대로 제공되는 체험용 키트이다'
      ],
      answer: 0,
      feedback: '스타트팩은 대표 제품으로 구성된 신규 회원 전용 패키지이고, 회원가에서 50% 추가 할인된 가격입니다.'
    },
    {
      config: Guide02Scene02Config,
      question: '스타트팩은 누가, 언제까지 구매할 수 있나요?',
      choices: [
        '신규 회원이 가입월을 포함해 3개월 이내에 구매할 수 있다',
        '가입 후 1년 동안 모든 회원이 구매할 수 있다',
        '가입 당일에만 한 번 구매할 수 있다'
      ],
      answer: 0,
      feedback: '스타트팩은 신규 회원 특별 혜택이며, 가입월을 포함한 3개월 동안 구매할 수 있습니다.'
    },
    {
      config: Guide02Scene03Config,
      question: '스타트팩의 종류와 구매 가능 횟수로 맞는 것은?',
      choices: [
        '누벨마리와 시그니처 두 종류이며, 각각 한 번씩 구매할 수 있다',
        '한 종류만 있으며 원하는 만큼 반복 구매할 수 있다',
        '세 종류이며 같은 팩을 여러 번 구매할 수 있다'
      ],
      answer: 0,
      feedback: '스타트팩은 누벨마리와 시그니처 두 종류이고, 각각 한 번씩만 구매할 수 있습니다.'
    },
    {
      config: Guide02Scene04Config,
      question: '스타트팩의 가격·승급 혜택으로 맞는 것은?',
      choices: [
        '25% 할인된 회원가에 50%가 추가 할인되고, 스타트팩 각각 50만 승급 E.P가 제공된다',
        '회원가에서 10%만 할인되고 승급 E.P는 없다',
        '가격 할인 없이 배송비만 면제된다'
      ],
      answer: 0,
      feedback: '25% 할인된 회원가에 50%가 추가 할인됩니다. 두 종류를 모두 사면 약 125만원 할인 혜택이 있고, 각각 50만 승급 E.P가 제공됩니다.'
    },
    {
      config: Guide02Scene05Config,
      question: '추천인에게 생기는 혜택으로 맞는 것은?',
      choices: [
        '추천한 신규 회원이 스타트팩을 구매하면 추천인에게 최초 1회 5포인트가 발생한다',
        '스타트팩을 구매할 때마다 추천인에게 10포인트가 반복해서 발생한다',
        '추천포인트는 구매와 관계없이 매월 자동으로 발생한다'
      ],
      answer: 0,
      feedback: '신규 회원이 스타트팩을 구매하면 추천인에게 추천포인트가 생기고, 회원 1명당 최초 1회만 5포인트 발생됩니다.'
    },
    {
      config: Guide02Scene06Config,
      question: '스타트팩의 승급 E.P에 대한 설명으로 맞는 것은?',
      choices: [
        '각각 50만 승급 E.P가 제공되며, 승급에만 쓰이고 수당 E.P에는 적용되지 않는다',
        '50만 E.P가 수당으로 그대로 지급된다',
        '승급 E.P는 스타트팩 두 종류를 모두 샀을 때만 한 번 지급된다'
      ],
      answer: 0,
      feedback: '스타트팩을 구매하면 각각 50만 승급 E.P가 제공됩니다. 이 E.P는 승급을 위한 것이며, 약 30만의 수당 E.P는 따로 제공됩니다.'
    },
    {
      config: Guide02Scene07Config,
      question: '스타트팩을 운영하는 이유로 맞는 것은?',
      choices: [
        '큰 할인가로 대표 제품을 경험하여, 추천과 빠른 승급의 발판이 된다',
        '기존 회원의 재구매를 늘리기 위한 상시 할인이다',
        '배송 횟수만 줄이고 제품 경험이나 승급과는 관계가 없다'
      ],
      answer: 0,
      feedback: '스타트팩은 대표 제품 경험, 자연스러운 추천 활동, 빠른 초기 승급 등 앨트웰 비즈니스의 좋은 발판이 됩니다.'
    },
    {
      config: Guide02Scene08Config,
      question: '스타트팩에서 꼭 기억해야할 내용으로 맞는 것은?',
      choices: [
        '3개월 이내의 신규 회원, 50% 추가 할인, 50만 승급 E.P, 추천인 최초 1회 5포인트',
        '가입 후 6개월까지 구매할 수 있고 추천포인트는 없다',
        '할인과 승급 E.P는 시그니처 스타트팩에만 적용된다'
      ],
      answer: 0,
      feedback: '가입월 포함 3개월이내의 신규회원만 구매할 수 있고, 회원가에 50%가 추가 할인되며, 50만 승급 E.P와 추천인 최초 1회 5포인트가 함께합니다.'
    }
  ];

  var motionToken = 0;
  var index = 0;
  var solved = [];
  var KEYS = ['A', 'B', 'C'];
  var SCENES = [
    Guide02Scene01, Guide02Scene02, Guide02Scene03, Guide02Scene04,
    Guide02Scene05, Guide02Scene06, Guide02Scene07, Guide02Scene08
  ];
  var RUN = [
    { setup: setupGuide02Scene01, run: runGuide02Scene01 },
    { setup: setupGuide02Scene02, run: runGuide02Scene02 },
    { setup: setupGuide02Scene03, run: runGuide02Scene03 },
    { setup: setupGuide02Scene04, run: runGuide02Scene04 },
    { setup: setupGuide02Scene05, run: runGuide02Scene05 },
    { setup: setupGuide02Scene06, run: runGuide02Scene06 },
    { setup: setupGuide02Scene07, run: runGuide02Scene07 },
    { setup: setupGuide02Scene08, run: runGuide02Scene08 }
  ];

  function canvasEl(){
    return document.getElementById('motion-canvas');
  }

  function simCtx(token, config){
    return {
      canvas: canvasEl(),
      sceneDuration: config.duration || 0,
      mediaTitleMs: (config.media && config.media.titleMs) || 0,
      sceneIndex: 0,
      isFollowUp: false,
      isCancelled: function(){ return token !== motionToken; },
      reportProgress: function(){}
    };
  }

  function releaseScenes(){
    var i;
    for(i = 0; i < SCENES.length; i++){
      if(SCENES[i] && SCENES[i].reset) SCENES[i].reset();
    }
  }

  function launchMotion(stepIndex, token){
    var config = STEPS[stepIndex].config;
    var runner = RUN[stepIndex];
    var canvas = canvasEl();
    var ctx;
    var tl;
    var assets;
    var job;

    releaseScenes();
    if(token !== motionToken || !canvas || !runner) return;

    ctx = simCtx(token, config);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(config.canvasCls);
    Guide02.mountStage(canvas, config.canvasCls);
    assets = runner.setup(canvas);
    job = runner.run(tl, assets, ctx);
    if(job && job.catch) job.catch(function(){});
  }

  function setText(id, text){
    var el = document.getElementById(id);
    if(!el) return el;
    el.classList.remove('is-hidden');
    if(el.tagName === 'H2') el.innerHTML = text;
    else el.textContent = text;
    return el;
  }

  function showQuestion(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    if(q) q.classList.remove('is-hidden');
    if(result) result.classList.add('is-hidden');
  }

  function showResult(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    var summary = document.getElementById('sim-result-summary');
    var lines = [
      '가입월 포함 3개월, 신규 회원 전용',
      '누벨마리·시그니처 각 1회, 회원가에 50% 추가 할인',
      '각각 50만 승급 E.P, 추천인 최초 1회 5포인트'
    ];
    var i;
    var item;
    if(q) q.classList.add('is-hidden');
    if(result) result.classList.remove('is-hidden');
    setText('sim-result-chapter', '스타트팩 알아보기');
    setText('sim-result-title', '학습 완료!');
    if(summary){
      summary.innerHTML = '';
      for(i = 0; i < lines.length; i++){
        item = document.createElement('li');
        item.className = 'sim-result-item';
        item.innerHTML = '<span class="sim-result-icon" aria-hidden="true">&#10003;</span><span class="sim-result-text"></span>';
        item.querySelector('.sim-result-text').textContent = lines[i];
        summary.appendChild(item);
      }
    }
    setChrome(STEPS.length, true);
    if(typeof SimVoice !== 'undefined') SimVoice.playClose('guide02');
    releaseScenes();
    if(typeof GuideClosePanel !== 'undefined'){
      GuideClosePanel.showSimulatorEnd(canvasEl(), {
        title: '스타트팩 알아보기',
        onRelearn: restart,
        onWatch: function(){ location.href = 'guide02_smartguide.asp?from=sim'; },
        onList: function(){ location.href = 'sim.asp'; }
      });
    }
  }

  function setChrome(stepIndex, done){
    var total = STEPS.length;
    var num = document.getElementById('sim-step-number');
    var fill = document.getElementById('sim-progress-fill');
    var bar = document.getElementById('sim-progress-track');
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var pct = done ? 100 : Math.round((stepIndex / total) * 100);
    if(num) num.textContent = (done ? total : stepIndex + 1) + ' / ' + total;
    if(fill) fill.style.width = pct + '%';
    if(bar){
      bar.setAttribute('aria-valuenow', String(pct));
      bar.setAttribute('aria-valuemax', '100');
    }
    if(prev) prev.disabled = !done && stepIndex <= 0;
    if(next) next.disabled = done || !solved[stepIndex];
  }

  function renderChoices(step){
    var host = document.getElementById('sim-choices');
    var feedback = document.getElementById('sim-feedback');
    var next = document.getElementById('sim-next-btn');
    var i;
    var btn;
    var key;
    var text;
    if(!host) return;
    host.innerHTML = '';
    if(feedback){
      feedback.className = 'sim-feedback is-hidden';
      feedback.innerHTML = '';
    }
    if(next){
      next.classList.add('is-hidden');
      next.disabled = true;
    }
    for(i = 0; i < step.choices.length; i++){
      btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'sim-choice-btn';
      btn.setAttribute('data-index', String(i));
      key = document.createElement('span');
      key.className = 'sim-choice-key';
      key.textContent = KEYS[i] || String(i + 1);
      text = document.createElement('span');
      text.className = 'sim-choice-text';
      text.textContent = step.choices[i];
      btn.appendChild(key);
      btn.appendChild(text);
      btn.addEventListener('click', onChoice);
      host.appendChild(btn);
    }
    if(solved[index]) lockCorrect(step);
  }

  function lockCorrect(step){
    var buttons = document.querySelectorAll('.sim-choice-btn');
    var feedback = document.getElementById('sim-feedback');
    var next = document.getElementById('sim-next-btn');
    var i;
    for(i = buttons.length - 1; i >= 0; i--){
      if(Number(buttons[i].getAttribute('data-index')) !== step.answer){
        if(buttons[i].parentNode) buttons[i].parentNode.removeChild(buttons[i]);
        continue;
      }
      buttons[i].disabled = true;
      buttons[i].classList.add('is-locked', 'is-correct-choice');
    }
    if(feedback){
      feedback.className = 'sim-feedback sim-feedback-correct';
      feedback.innerHTML = '<span class="sim-feedback-icon">&#10003;</span><span class="sim-feedback-text"></span>';
      feedback.querySelector('.sim-feedback-text').textContent = step.feedback;
    }
    if(next){
      next.classList.remove('is-hidden');
      next.disabled = false;
      next.textContent = index >= STEPS.length - 1 ? '결과 보기' : '다음 단계';
    }
  }

  function onChoice(ev){
    var step = STEPS[index];
    var btn = ev.currentTarget;
    var picked = Number(btn.getAttribute('data-index'));
    var feedback = document.getElementById('sim-feedback');
    if(!step || solved[index] || btn.disabled) return;
    if(picked !== step.answer){
      btn.classList.remove('is-wrong');
      void btn.offsetWidth;
      btn.classList.add('is-wrong');
      if(feedback){
        feedback.className = 'sim-feedback sim-feedback-incorrect';
        feedback.innerHTML = '<span class="sim-feedback-icon">!</span><span class="sim-feedback-text">다시 한번 골라 보세요.</span>';
      }
      return;
    }
    solved[index] = true;
    lockCorrect(step);
    setChrome(index, false);
  }

  function renderStep(){
    var step = STEPS[index];
    var label = document.getElementById('lo-scene-label');
    launchMotion(index, motionToken);
    showQuestion();
    setText('sim-step-label', 'STEP ' + (index + 1));
    setText('scene-title-main', step.config.title);
    setText('sim-question', step.question);
    renderChoices(step);
    setChrome(index, false);
    if(label) label.textContent = '스타트팩 알아보기';
    if(typeof SimVoice !== 'undefined') SimVoice.playStep('guide02', index);
  }

  function go(nextIndex){
    if(nextIndex < 0 || nextIndex >= STEPS.length) return;
    motionToken++;
    index = nextIndex;
    reopen(index);
    renderStep();
  }

  function goNext(){
    if(!solved[index]) return;
    if(typeof ReadLog !== 'undefined') ReadLog.simulation('guide02', index + 1);
    if(index >= STEPS.length - 1){
      motionToken++;
      releaseScenes();
      showResult();
      return;
    }
    go(index + 1);
  }

  function reopen(stepIndex){
    if(stepIndex < 0 || stepIndex >= STEPS.length) return;
    solved[stepIndex] = false;
  }

  function goPrev(){
    var result = document.getElementById('sim-result-panel');
    if(result && !result.classList.contains('is-hidden')){
      reopen(index);
      motionToken++;
      renderStep();
      return;
    }
    reopen(index - 1);
    go(index - 1);
  }

  function restart(){
    var i;
    motionToken++;
    index = 0;
    solved = [];
    for(i = 0; i < STEPS.length; i++) solved[i] = false;
    renderStep();
  }

  function startSceneFromQuery(){
    var q = location.search.match(/[?&]scene=(\d+)/);
    var n = q ? parseInt(q[1], 10) : 1;
    if(!(n > 0) || n > STEPS.length) n = 1;
    index = n - 1;
  }

  function bind(){
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var panelNext = document.getElementById('sim-next-btn');
    var restartBtn = document.getElementById('sim-btn-restart');
    var relearn = document.getElementById('sim-btn-relearn');
    var watch = document.getElementById('sim-btn-watch-video');
    var back = document.getElementById('sim-btn-back-list');
    if(prev) prev.addEventListener('click', goPrev);
    if(next) next.addEventListener('click', goNext);
    if(panelNext) panelNext.addEventListener('click', goNext);
    if(restartBtn) restartBtn.addEventListener('click', restart);
    if(relearn) relearn.addEventListener('click', restart);
    if(watch) watch.addEventListener('click', function(){
      location.href = 'guide02_smartguide.asp?from=sim';
    });
    if(back) back.addEventListener('click', function(){
      location.href = 'sim.asp';
    });
  }

  function init(){
    var label = document.getElementById('lo-scene-label');
    var i;
    if(label) label.textContent = '스타트팩 알아보기';
    document.title = '스타트팩 알아보기 시뮬레이션 - ALTWELL SMART GUIDE';
    for(i = 0; i < STEPS.length; i++) solved[i] = false;
    bind();
    startSceneFromQuery();
    motionToken++;
    renderStep();
  }

  return { init: init };
})();

function closePlayer(){
  location.href = 'sim.asp';
}
</script>
