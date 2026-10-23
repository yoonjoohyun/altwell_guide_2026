<script>
/* 가이드01 시뮬레이션 — 씬 모션은 가이드01을 그대로 재생하고, 오른쪽은 질문으로 복습한다. */
var Guide01Simulator = (function(){
  var STEPS = [
    {
      config: Scene01Config,
      question: '오토십은 어떤 서비스인가요?',
      choices: [
        '3개월 정기 구독 서비스',
        '1개월마다 끝나는 단품 구매',
        '가입 즉시 받는 일시 보너스'
      ],
      answer: 0,
      feedback: '오토십은 3개월 단위로 이어지는 정기 구독 서비스입니다.'
    },
    {
      config: Scene02Config,
      question: '오토십의 가격 혜택으로 맞는 것은?',
      choices: [
        '25% 할인된 회원가에 추가 20% 할인',
        '정가에서 10%만 할인',
        '할인 없이 배송비만 면제'
      ],
      answer: 0,
      feedback: '회원가 25% 할인에 오토십 추가 20% 할인이 더해집니다.'
    },
    {
      config: Scene03Config,
      question: '구독 신청의 방법으로 맞는 것은?',
      choices: [
        '앨트웰의 모든 회원이 신청할 수 있고, 최대 5품목이며 같은 상품은 중복 구독할 수 없다',
        '일반 소비회원도 개수 제한 없이 오토십을 신청할 수 있다',
        '앨트웰 회원은 오토십의 같은 상품을 중복 구독할 수 있다'
      ],
      answer: 0,
      feedback: '오토십은 소비회원을 제외한 모든 회원이 신청할 수 있고, 최대 5품목까지 구독 가능하며 동일 상품은 중복 구독할 수 없습니다.'
    },
    {
      config: Scene04Config,
      question: '결제와 배송은 어떻게 이뤄지나요?',
      choices: [
        '3개월분을 한 번에 결제하고 배송한다',
        '매월 1개월분씩 결제하고 배송한다',
        '1년치를 한 번에 결제한다'
      ],
      answer: 0,
      feedback: '오토십은 3개월분을 일괄 결제·배송하고, 4개월 차부터 3개월 단위로 자동 갱신됩니다.'
    },
    {
      config: Scene05Config,
      question: 'E.P와 추천포인트는 어떻게 발생하나요?',
      choices: [
        'E.P는 3개월간 매월 나뉘어 발생하고, 추천포인트는 회원 1인당 매월 1Point다',
        'E.P와 추천포인트가 첫달에 한 번만 발생한다',
        '추천포인트는 구독과 관계없이 즉시 10Point다'
      ],
      answer: 0,
      feedback: 'E.P는 3개월 동안 매월 분할 발생하고, 추천포인트는 오토십 회원 1인당 매월 1Point입니다.'
    },
    {
      config: Scene06Config,
      question: '구독 중 추가와 갱신 종료에 대한 설명으로 맞는 것은?',
      choices: [
        '기존에 구독중인 상품과 다른 상품을 추가할 수 있으며, 갱신 종료는 다음 자동 결제부터 중지됩니다',
        '같은 상품으로 언제든 자유롭게 바꿀 수 있으며, 갱신 종료 시 구독이 즉시 종료된다',
        '상품 추가는 제한 없이 가능하며, 갱신 종료를 하면 이미 결제한 배송까지 취소된다'
      ],
      answer: 0,
      feedback: '오토십은 각각 다른 상품으로 최대 5품목까지 구독할 수 있습니다. 동일 상품 중복과 상품 변경은 불가하고, 갱신 종료는 다음 자동결제부터 중지됩니다.'
    },
    {
      config: Scene07Config,
      question: '오토십에서 꼭 기억할 내용으로 맞는 것은?',
      choices: [
        '배송과 결제는 한 번에 하고, E.P는 3개월에 나눠 지급한다',
        '상품은 매월 배송되며 E.P는 한 번에 지급된다',
        '추천회원이 오토십을 구독하더라도 추천포인트는 발생하지 않는다'
      ],
      answer: 0,
      feedback: '오토십 구독 시 배송과 결제는 한 번에 하지만 E.P, 캐시백, 추천포인트는 매월 발생합니다.'
    }
  ];

  var motionToken = 0;
  var index = 0;
  var solved = [];
  var KEYS = ['A', 'B', 'C'];

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
    var scenes = [Guide01Scene01, Guide01Scene02, Guide01Scene03, Guide01Scene04, Guide01Scene05, Guide01Scene06, Guide01Scene07];
    var i;
    for(i = 0; i < scenes.length; i++){
      if(scenes[i] && scenes[i].reset) scenes[i].reset();
    }
  }

  function launchMotion(stepIndex, token){
    var config = STEPS[stepIndex].config;
    var canvas = canvasEl();
    var ctx;
    var tl;
    var assets;
    var job = null;

    releaseScenes();
    if(token !== motionToken || !canvas) return;

    ctx = simCtx(token, config);
    tl = Guide01.timeline(ctx);
    Guide01.resetScene(config.canvasCls);
    Guide01.mountStage(canvas, config.canvasCls);

    if(stepIndex === 0){
      assets = setupScene01Assets(canvas);
      if(typeof Scene01Layout !== 'undefined') Scene01Layout.applyLayout(canvas, assets.group, assets);
      job = runScene01MotionCore(tl, assets, ctx);
    }else if(stepIndex === 1){
      assets = setupScene02Assets(canvas);
      job = runScene02MotionCore(tl, assets, ctx);
    }else if(stepIndex === 2){
      assets = setupScene03Assets(canvas);
      job = runScene03MotionCore(tl, assets, canvas, ctx);
    }else if(stepIndex === 3){
      assets = setupScene04Assets(canvas);
      job = runScene04MotionCore(tl, assets, canvas, ctx);
    }else if(stepIndex === 4){
      assets = setupScene05Assets(canvas);
      job = runScene05MotionCore(tl, assets, canvas, ctx);
    }else if(stepIndex === 5){
      assets = setupScene06Assets(canvas);
      job = runScene06MotionCore(tl, assets, canvas, ctx);
    }else{
      assets = setupScene07Assets(canvas);
      job = runScene07Motion(tl, assets, ctx);
    }

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
      '3개월 정기 구독과 추가 할인',
      '3개월분 일괄 결제·배송, E.P는 3회 분할 지급',
      '추천포인트와 BASE사업자로 이어지는 구독 서비스'
    ];
    var i;
    var item;
    if(q) q.classList.add('is-hidden');
    if(result) result.classList.remove('is-hidden');
    setText('sim-result-chapter', '오토십 알아보기');
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
    if(typeof SimVoice !== 'undefined') SimVoice.playClose('guide01');
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
    if(label) label.textContent = '오토십 알아보기';
    if(typeof SimVoice !== 'undefined') SimVoice.playStep('guide01', index);
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
    if(typeof ReadLog !== 'undefined') ReadLog.simulation('guide01', index + 1);
    if(index >= STEPS.length - 1){
      motionToken++;
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
      location.href = 'guide01_smartguide.asp?from=sim';
    });
    if(back) back.addEventListener('click', function(){
      location.href = 'sim.asp';
    });
  }

  function init(){
    var label = document.getElementById('lo-scene-label');
    if(label) label.textContent = '오토십 알아보기';
    document.title = '오토십 알아보기 시뮬레이션 - ALTWELL SMART GUIDE';
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
