<script>
/* 가이드03 시뮬레이션 — 왼쪽은 해당 씬 모션, 오른쪽은 이번 달 BASE 판정 보드. */
var Guide03Simulator = (function(){
  function blank(){
    return {
      self: { auto: false, sep: false },
      a: { auto: false, sep: false },
      b: { auto: false, sep: false },
      total: 0
    };
  }

  function withSelf(){
    var state = blank();
    state.self.auto = true;
    state.self.sep = true;
    return state;
  }

  var STEPS = [
    {
      config: Guide03Scene03Config,
      scene: Guide03Scene03,
      setup: setupGuide03Scene03,
      run: runGuide03Scene03,
      mode: 'quiz',
      question: 'BASE사업자의 본인 조건으로 맞는 것은?',
      choices: [
        '오토십을 유지하고 S.E.P 30만 이상을 달성해야 하며, S.E.P에는 오토십이 포함되어야 한다',
        '오토십만 유지하면 본인 조건이 된다',
        'S.E.P 30만이면 오토십이 없어도 본인 조건이 된다'
      ],
      answer: 0,
      feedback: '본인 조건은 오토십을 유지하면서 S.E.P 30만 이상을 달성하는 것입니다. S.E.P에는 오토십이 포함되어야 합니다.'
    },
    {
      config: Guide03Scene05Config,
      scene: Guide03Scene05,
      setup: setupGuide03Scene05,
      run: runGuide03Scene05,
      mode: 'quiz',
      question: '오토십 구독으로 파트너 조건을 충족 시키는 방법으로 맞는 것은?',
      choices: [
        '직 1대 파트너 두 명 모두 오토십을 1개 이상 유지한다',
        '파트너 한 명만 오토십을 유지해도 된다',
        '본인만 오토십을 유지하면 파트너 조건이 된다'
      ],
      answer: 0,
      feedback: '직 1대 파트너 두 명 모두 오토십을 유지하면 파트너 조건이 됩니다.'
    },
    {
      config: Guide03Scene06Config,
      scene: Guide03Scene06,
      setup: setupGuide03Scene06,
      run: runGuide03Scene06,
      mode: 'quiz',
      question: 'S.E.P 실적으로 파트너 조건을 충족하는 방법으로 맞는 것은?',
      choices: [
        '파트너 두 명 모두 S.E.P 30만 이상이고, 구성원 합산 S.E.P는 100만 이상이다',
        '파트너 한 명만 S.E.P 30만 이상이면 된다',
        '합산 S.E.P가 100만이면 각자 실적은 없어도 된다'
      ],
      answer: 0,
      feedback: '파트너 두 명 모두 S.E.P 30만 이상이어야 하고, 구성원 합산 S.E.P도 매월 100만 이상이어야 합니다.'
    },
    {
      config: Guide03Scene07Config,
      scene: Guide03Scene07,
      setup: setupGuide03Scene07,
      run: runGuide03Scene07,
      prompt: '파트너의 이번 달 현황을 보고 베이스사업자 파트너의 조건을 충족하는지 판단해보세요.',
      mode: 'verdict',
      verdict: false,
      showTotal: true,
      totalLock: true,
      people: [
        { who: 'self', name: '본인', keys: ['auto', 'sep'], lock: true },
        { who: 'a', name: '파트너 1', keys: ['auto', 'sep'], lock: true },
        { who: 'b', name: '파트너 2', keys: ['auto', 'sep'], lock: true }
      ],
      start: (function(){
        var state = withSelf();
        state.a.auto = true;
        state.b.sep = true;
        state.total = 100;
        return state;
      })(),
      success: '파트너 두 명은 같은 조건이어야 합니다. 한 명은 오토십만, 다른 한 명은 S.E.P만이면 인정되지 않습니다.',
      fail: '조건을 섞은 구성은 미달입니다. 두 파트너가 같은 조건인지 다시 보세요.'
    },
    {
      config: Guide03Scene06Config,
      scene: Guide03Scene06,
      setup: setupGuide03Scene06,
      run: runGuide03Scene06,
      prompt: '베이스사업자 본인과 파트너의 조건이 충족되었을때 합산 S.E.P를 보고 BASE사업자 조건이 충족되는지 판정하세요.',
      mode: 'verdict',
      verdict: false,
      showTotal: true,
      totalLock: true,
      totals: [90],
      people: [
        { who: 'self', name: '본인', keys: ['auto', 'sep'], lock: true },
        { who: 'a', name: '파트너 1', keys: ['sep'], lock: true },
        { who: 'b', name: '파트너 2', keys: ['sep'], lock: true }
      ],
      start: (function(){
        var state = withSelf();
        state.a.sep = true;
        state.b.sep = true;
        state.total = 90;
        return state;
      })(),
      success: '구성원 합산 S.E.P가 90만이면 매월 100만 이상 조건에 미달합니다.',
      fail: '합산 S.E.P가 100만 미만이면 미달입니다.'
    },
    {
      config: Guide03Scene10Config,
      scene: Guide03Scene10,
      setup: setupGuide03Scene10,
      run: runGuide03Scene10,
      prompt: '본인, 파트너, 합산 S.E.P를 설정하여 이번 달 BASE사업자 자격을 충족시키세요.',
      mode: 'build',
      goal: 'all',
      showTotal: true,
      people: [
        { who: 'self', name: '본인', keys: ['auto', 'sep'] },
        { who: 'a', name: '파트너 1', keys: ['auto', 'sep'] },
        { who: 'b', name: '파트너 2', keys: ['auto', 'sep'] }
      ],
      start: blank(),
      success: '본인 조건, 파트너 두 명의 같은 조건, 합산 S.E.P 100만 이상이 모두 맞아 이번 달 BASE사업자 자격의 조건이 충족되었습니다.',
      fail: ''
    }
  ];

  var KEYS = ['A', 'B', 'C'];
  var LABELS = { auto: '오토십 유지', sep: 'S.E.P 30만' };
  var TOTALS = [70, 100, 150];
  var motionToken = 0;
  var index = 0;
  var solved = [];
  var saved = [];
  var board = null;
  var currentAssets = null;

  function copyState(state){
    return {
      self: { auto: !!state.self.auto, sep: !!state.self.sep },
      a: { auto: !!state.a.auto, sep: !!state.a.sep },
      b: { auto: !!state.b.auto, sep: !!state.b.sep },
      total: state.total || 0
    };
  }

  function selfOk(state){ return state.self.auto && state.self.sep; }
  function partnersAuto(state){ return state.a.auto && state.b.auto; }
  function partnersSep(state){ return state.a.sep && state.b.sep; }
  function partnersOk(state){ return partnersAuto(state) || partnersSep(state); }
  function totalOk(state){ return state.total >= 100; }

  function goalMet(step, state){
    if(step.goal === 'self') return selfOk(state);
    if(step.goal === 'auto') return partnersAuto(state);
    if(step.goal === 'sep') return partnersSep(state);
    return selfOk(state) && partnersOk(state) && totalOk(state);
  }

  function failText(step, state){
    if(step.fail) return step.fail;
    if(!selfOk(state)) return '본인은 오토십 유지와 S.E.P 30만을 함께 채워야 합니다.';
    if(!partnersOk(state)) return '파트너 두 명은 둘 다 오토십이거나, 둘 다 S.E.P 30만이어야 합니다.';
    if(!totalOk(state)) return '구성원 합산 S.E.P가 매월 100만 이상이어야 합니다.';
    return '조건을 다시 확인해 보세요.';
  }

  function canvasEl(){ return document.getElementById('motion-canvas'); }

  function releaseScenes(){
    var seen = [];
    var i;
    var scene;
    for(i = 0; i < STEPS.length; i++){
      scene = STEPS[i].scene;
      if(!scene || seen.indexOf(scene) >= 0) continue;
      seen.push(scene);
      if(scene.reset) scene.reset();
    }
  }

  function setShown(el, on){
    if(!el) return;
    if(on){
      if(!el.classList.contains('is-hidden')) return;
      el.classList.remove('is-hidden');
      el.classList.remove('g03-enter');
      void el.offsetWidth;
      el.classList.add('g03-enter');
      return;
    }
    el.classList.add('is-hidden');
    el.classList.remove('g03-enter');
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

  function launchMotion(stepIndex, token){
    var step = STEPS[stepIndex];
    var canvas = canvasEl();
    var ctx;
    var tl;
    var job;
    releaseScenes();
    currentAssets = null;
    if(token !== motionToken || !canvas || !step) return;
    Guide03.resetScene(step.config.canvasCls);
    Guide03.mountStage(canvas, step.config.canvasCls);
    currentAssets = step.setup(canvas);
    if(step.mode !== 'quiz' || !step.run) return;
    ctx = simCtx(token, step.config);
    tl = Guide03.timeline(ctx);
    job = step.run(tl, currentAssets, ctx);
    if(job && job.catch) job.catch(function(){});
  }

  function syncMotion(){
    var step = STEPS[index];
    var assets = currentAssets;
    var state = board;
    var id;
    var full;
    if(!step || !assets || !state) return;
    id = step.config.id;
    if(id === 'guide03-scene-03'){
      setShown(assets.member, true);
      setShown(assets.badge, true);
      setShown(assets.sep, state.self.sep);
      setShown(assets.autoship, state.self.auto);
      setShown(assets.sliceLabel, state.self.auto && state.self.sep);
      if(assets.sep) assets.sep.classList.toggle('is-slice', !!(state.self.auto && state.self.sep));
      Guide03Scene03Layout.schedule();
      return;
    }
    if(id === 'guide03-scene-05'){
      setShown(assets.partners[0], true);
      setShown(assets.partners[1], true);
      setShown(assets.autos[0], state.a.auto);
      setShown(assets.autos[1], state.b.auto);
      Guide03Scene05Layout.schedule();
      return;
    }
    if(id === 'guide03-scene-06'){
      setShown(assets.board, true);
      assets.members[0].slot.classList.add('is-open', 'is-settled');
      assets.members[1].slot.classList.add('is-open', 'is-settled');
      assets.members[2].slot.classList.add('is-open', 'is-settled');
      setShown(assets.seps[0], state.a.sep);
      setShown(assets.seps[1], state.b.sep);
      setShown(assets.sum, false);
      if(!assets.totalNote && assets.board){
        assets.totalNote = document.createElement('div');
        assets.totalNote.className = 'g03-s06-sum';
        assets.totalNote.textContent = '구성원 합산 S.E.P 90만';
        assets.board.insertBefore(assets.totalNote, assets.board.firstChild);
      }
      setShown(assets.totalNote, true);
      Guide03Scene06Layout.schedule();
      window.requestAnimationFrame(function(){
        if(!currentAssets || currentAssets !== assets) return;
        if(typeof guide03Scene01DrawLines === 'function') guide03Scene01DrawLines(assets, false);
      });
      return;
    }
    if(id === 'guide03-scene-07'){
      setShown(assets.badge, true);
      setShown(assets.mixed.card, true);
      setShown(assets.mixed.board, true);
      setShown(assets.mixed.left.wrap, true);
      setShown(assets.mixed.right.wrap, true);
      setShown(assets.mixed.left.chips.auto, true);
      setShown(assets.mixed.right.chips.sep, true);
      setShown(assets.mixed.right.chips.auto, false);
      setShown(assets.mixed.ban, true);
      Guide03Scene07Layout.schedule();
      return;
    }
    if(id === 'guide03-scene-10'){
      setShown(assets.card, true);
      assets.card.classList.add('is-on');
      setShown(assets.self.host, true);
      setShown(assets.partners[0].host, true);
      setShown(assets.partners[1].host, true);
      setShown(assets.selfAuto, state.self.auto);
      setShown(assets.selfSep, state.self.sep);
      setShown(assets.partnerAuto, state.a.auto || state.b.auto);
      setShown(assets.partnerSep, state.a.sep || state.b.sep);
      setShown(assets.or, state.a.auto || state.b.auto || state.a.sep || state.b.sep);
      setShown(assets.caption, state.total >= 100);
      full = selfOk(state) && partnersOk(state) && totalOk(state);
      setShown(assets.orbWrap, full);
      setShown(assets.orbs[0], full);
      setShown(assets.orbs[1], full);
      setShown(assets.orbs[2], full);
      setShown(assets.orbSeps[0], full);
      setShown(assets.orbSeps[1], full);
      Guide03Scene10Layout.schedule();
    }
  }

  function setText(id, text){
    var el = document.getElementById(id);
    if(!el) return;
    el.classList.remove('is-hidden');
    if(el.tagName === 'H2') el.innerHTML = text;
    else el.textContent = text;
  }

  function showQuestion(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    if(q) q.classList.remove('is-hidden');
    if(result) result.classList.add('is-hidden');
  }

  function syncQuizCompact(){
    document.body.classList.toggle('sim-quiz-compact', index >= 0 && index < 3);
  }

  function showResult(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    var summary = document.getElementById('sim-result-summary');
    var lines = [
      '본인: 오토십이 포함된 S.E.P 30만 이상',
      '파트너 2명: 둘 다 오토십, 또는 둘 다 S.E.P 30만',
      '구성원 합산 S.E.P 매월 100만 이상'
    ];
    var i;
    var item;
    if(q) q.classList.add('is-hidden');
    if(result) result.classList.remove('is-hidden');
    document.body.classList.remove('sim-quiz-compact');
    setText('sim-result-chapter', 'BASE사업자 이해하기');
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
    if(typeof SimVoice !== 'undefined') SimVoice.playClose('guide03');
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
    if(bar) bar.setAttribute('aria-valuenow', String(pct));
    if(prev) prev.disabled = !done && stepIndex <= 0;
    if(next) next.disabled = done || !solved[stepIndex];
  }

  function showFeedback(ok, text){
    var feedback = document.getElementById('sim-feedback');
    if(!feedback) return;
    feedback.className = 'sim-feedback ' + (ok ? 'sim-feedback-correct' : 'sim-feedback-incorrect');
    feedback.innerHTML = '<span class="sim-feedback-icon"></span><span class="sim-feedback-text"></span>';
    feedback.querySelector('.sim-feedback-icon').textContent = ok ? '✓' : '!';
    feedback.querySelector('.sim-feedback-text').textContent = text;
  }

  function showNext(){
    var next = document.getElementById('sim-next-btn');
    if(!next) return;
    next.classList.remove('is-hidden');
    next.disabled = false;
    next.textContent = index >= STEPS.length - 1 ? '결과 보기' : '다음 단계';
  }

  function hideNext(){
    var next = document.getElementById('sim-next-btn');
    var feedback = document.getElementById('sim-feedback');
    if(next){
      next.classList.add('is-hidden');
      next.disabled = true;
    }
    if(feedback){
      feedback.className = 'sim-feedback is-hidden';
      feedback.innerHTML = '';
    }
  }

  function makeToggle(who, key, locked){
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'sim-toggle' + (board[who][key] ? ' is-on' : '');
    btn.textContent = LABELS[key];
    btn.setAttribute('aria-pressed', board[who][key] ? 'true' : 'false');
    btn.disabled = !!locked;
    btn.addEventListener('click', function(){
      if(solved[index] || locked) return;
      board[who][key] = !board[who][key];
      btn.classList.toggle('is-on', board[who][key]);
      btn.setAttribute('aria-pressed', board[who][key] ? 'true' : 'false');
      syncMotion();
    });
    return btn;
  }

  function renderPeople(step){
    var host = document.createElement('div');
    var i;
    var person;
    var row;
    var name;
    var toggles;
    var k;
    host.className = 'sim-board';
    for(i = 0; i < step.people.length; i++){
      person = step.people[i];
      row = document.createElement('div');
      row.className = 'sim-person';
      name = document.createElement('div');
      name.className = 'sim-person-name';
      name.textContent = person.name;
      toggles = document.createElement('div');
      toggles.className = 'sim-toggles';
      for(k = 0; k < person.keys.length; k++){
        toggles.appendChild(makeToggle(person.who, person.keys[k], person.lock || solved[index]));
      }
      row.appendChild(name);
      row.appendChild(toggles);
      host.appendChild(row);
    }
    return host;
  }

  function renderTotal(step){
    var row = document.createElement('div');
    var label = document.createElement('div');
    var i;
    var btn;
    row.className = 'sim-total';
    label.className = 'sim-total-label';
    label.textContent = '구성원 합산 S.E.P';
    row.appendChild(label);
    var totals = step.totals || TOTALS;
    for(i = 0; i < totals.length; i++){
      btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'sim-total-btn' + (board.total === totals[i] ? ' is-on' : '');
      btn.textContent = totals[i] + '만';
      btn.disabled = !!step.totalLock || !!solved[index];
      btn.setAttribute('data-total', String(totals[i]));
      btn.addEventListener('click', function(ev){
        var value = Number(ev.currentTarget.getAttribute('data-total'));
        var buttons;
        var n;
        if(solved[index] || step.totalLock) return;
        board.total = value;
        buttons = document.querySelectorAll('.sim-total-btn');
        for(n = 0; n < buttons.length; n++){
          buttons[n].classList.toggle('is-on', Number(buttons[n].getAttribute('data-total')) === value);
        }
        syncMotion();
      });
      row.appendChild(btn);
    }
    return row;
  }

  function lockSolved(step){
    var buttons = document.querySelectorAll('.sim-toggle, .sim-total-btn, .sim-judge, .sim-verdict-btn');
    var boardEl = document.querySelector('.sim-board');
    var totalEl = document.querySelector('.sim-total');
    var i;
    for(i = 0; i < buttons.length; i++) buttons[i].disabled = true;
    if(boardEl) boardEl.style.display = 'none';
    if(totalEl) totalEl.style.display = 'none';
    showFeedback(true, step.success);
    showNext();
    setChrome(index, false);
  }

  function onBuildJudge(){
    var step = STEPS[index];
    if(!step || solved[index]) return;
    if(!goalMet(step, board)){
      showFeedback(false, failText(step, board));
      return;
    }
    solved[index] = true;
    saved[index] = copyState(board);
    lockSolved(step);
  }

  function onVerdict(pass){
    var step = STEPS[index];
    var btn;
    if(!step || solved[index]) return;
    if(pass !== step.verdict){
      btn = document.querySelector('.sim-verdict-btn[data-pass="' + (pass ? '1' : '0') + '"]');
      if(btn){
        btn.classList.remove('is-wrong');
        void btn.offsetWidth;
        btn.classList.add('is-wrong');
      }
      showFeedback(false, step.fail);
      return;
    }
    solved[index] = true;
    saved[index] = copyState(board);
    btn = document.querySelector('.sim-verdict-btn[data-pass="' + (pass ? '1' : '0') + '"]');
    if(btn) btn.classList.add('is-correct-choice');
    lockSolved(step);
  }

  function renderActions(step){
    var row = document.createElement('div');
    var judge;
    var passBtn;
    var missBtn;
    row.className = 'sim-actions';
    if(step.mode === 'verdict'){
      passBtn = document.createElement('button');
      missBtn = document.createElement('button');
      passBtn.type = 'button';
      missBtn.type = 'button';
      passBtn.className = 'sim-verdict-btn';
      missBtn.className = 'sim-verdict-btn is-miss';
      passBtn.textContent = '충족';
      missBtn.textContent = '미흡';
      passBtn.setAttribute('data-pass', '1');
      missBtn.setAttribute('data-pass', '0');
      passBtn.addEventListener('click', function(){ onVerdict(true); });
      missBtn.addEventListener('click', function(){ onVerdict(false); });
      row.appendChild(passBtn);
      row.appendChild(missBtn);
      return row;
    }
    judge = document.createElement('button');
    judge.type = 'button';
    judge.className = 'sim-judge';
    judge.textContent = '이번 달 판정';
    judge.addEventListener('click', onBuildJudge);
    row.appendChild(judge);
    return row;
  }

  function lockQuiz(step){
    var buttons = document.querySelectorAll('.sim-choice-btn');
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
    showFeedback(true, step.feedback);
    if(next){
      next.classList.remove('is-hidden');
      next.disabled = false;
      next.textContent = index >= STEPS.length - 1 ? '결과 보기' : '다음 단계';
    }
    setChrome(index, false);
  }

  function onChoice(ev){
    var step = STEPS[index];
    var btn = ev.currentTarget;
    var picked = Number(btn.getAttribute('data-index'));
    if(!step || step.mode !== 'quiz' || solved[index] || btn.disabled) return;
    if(picked !== step.answer){
      btn.classList.remove('is-wrong');
      void btn.offsetWidth;
      btn.classList.add('is-wrong');
      showFeedback(false, '다시 한번 골라 보세요.');
      return;
    }
    solved[index] = true;
    lockQuiz(step);
  }

  function renderChoices(step){
    var host = document.getElementById('sim-choices');
    var i;
    var btn;
    var key;
    var text;
    if(!host) return;
    host.innerHTML = '';
    hideNext();
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
    if(solved[index]) lockQuiz(step);
  }

  function renderBoard(step){
    var host = document.getElementById('sim-choices');
    if(!host) return;
    board = copyState(solved[index] && saved[index] ? saved[index] : step.start);
    host.innerHTML = '';
    host.appendChild(renderPeople(step));
    if(step.showTotal) host.appendChild(renderTotal(step));
    host.appendChild(renderActions(step));
    hideNext();
    syncMotion();
    if(solved[index]){
      if(step.mode === 'verdict'){
        var picked = document.querySelector('.sim-verdict-btn[data-pass="' + (step.verdict ? '1' : '0') + '"]');
        if(picked) picked.classList.add('is-correct-choice');
      }
      lockSolved(step);
    }
  }

  function renderStep(){
    var step = STEPS[index];
    var label = document.getElementById('lo-scene-label');
    launchMotion(index, motionToken);
    showQuestion();
    setText('sim-step-label', 'STEP ' + (index + 1));
    setText('scene-title-main', step.config.title);
    setText('sim-question', step.question || step.prompt);
    if(step.mode === 'quiz') renderChoices(step);
    else renderBoard(step);
    syncQuizCompact();
    setChrome(index, false);
    if(label) label.textContent = 'BASE사업자 이해하기';
    if(typeof SimVoice !== 'undefined') SimVoice.playStep('guide03', index);
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
    if(typeof ReadLog !== 'undefined') ReadLog.simulation('guide03', index + 1);
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
    saved[stepIndex] = null;
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
    for(i = 0; i < STEPS.length; i++){
      solved[i] = false;
      saved[i] = null;
    }
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
      location.href = 'guide03_smartguide.asp?from=sim';
    });
    if(back) back.addEventListener('click', function(){
      location.href = 'sim.asp';
    });
  }

  function init(){
    var label = document.getElementById('lo-scene-label');
    var i;
    if(label) label.textContent = 'BASE사업자 이해하기';
    document.title = 'BASE사업자 이해하기 시뮬레이션 - ALTWELL SMART GUIDE';
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
