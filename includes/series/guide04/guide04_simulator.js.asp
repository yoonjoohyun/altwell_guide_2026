<script>
/* 가이드04 시뮬레이션 — 앞단: 핵심 퀴즈(씬 모션 재사용), 뒷단: 가상 피라미드 문제풀이.
   문제풀이는 멤버 에셋 우측의 선택 박스(지위·Base 사업자 자격·오토십·스타트팩)를 직접 골라 추천포인트를 맞춘다. */
var Guide04SimLayout = G04Kit.makeLayout();

/* 추천포인트 규칙: Base 사업자 자격 유지 + 추천 회원 1명당 오토십 구독 1P, 스타트팩 구매 5P(두 종류 모두 구매해도 최대 5P), 본인 이용은 제외 */
var G04SIM_FIELDS = {
  base: { label: 'Base 사업자 자격', opts: [[0, '미유지'], [1, '유지']] },
  auto: { label: '오토십', opts: [[0, '미구독'], [1, '구독']] },
  pack: { label: '스타트팩', opts: [[0, '미구매'], [1, '구매']] }
};

function guide04SimGain(m){
  return (m.auto ? 1 : 0) + (m.pack ? 5 : 0);
}

function guide04SimPoints(st){
  var sum = 0;
  var i;
  if(!st.self.base) return 0;
  for(i = 0; i < st.m.length; i++) sum += guide04SimGain(st.m[i]);
  return sum;
}

function guide04SimOpen(slot){
  if(!slot) return;
  slot.classList.add('is-open', 'is-settled');
}

/* 멤버 옆 정보 카드(코인 문제): 구독 중인 오토십 개수 / 구매한 스타트팩 종류 */
function guide04SimInfo(K, info){
  var wrap = K.el('div', 'g04sim-info');
  var node;
  var i;
  if(info.type === 'auto'){
    node = K.product('auto', { hidden: false, text: '오토십 ' + info.count + '개' });
    wrap.appendChild(node);
    var boxes = K.el('div', 'g04sim-boxes');
    for(i = 0; i < info.count; i++){
      var bx = Guide04.cloneTemplate('product_swap_box');
      if(bx){
        bx.textContent = '';
        bx.setAttribute('aria-label', '제품 박스');
        boxes.appendChild(bx);
      }
    }
    wrap.appendChild(boxes);
    return wrap;
  }
  for(i = 0; i < info.kinds.length; i++){
    var sig = info.kinds[i] === 's';
    var card = K.el('div', 'g04-pack-card' + (sig ? ' is-sig' : ''));
    card.appendChild(K.el('span', 'g04-pack-dot', sig ? 'S' : 'N'));
    card.appendChild(K.el('span', '', sig ? '시그니처 스타트팩' : '누벨마리 스타트팩'));
    wrap.appendChild(card);
  }
  return wrap;
}

/* 문제풀이 화면(왼쪽 모션 영역). 멤버마다 우측에 박스를 둔다.
   kind 'coin' : 관계도를 보고 본인의 Base 자격과 받을 포인트 코인을 고른다.
   kind 'toggle': 멤버 박스에서 조건을 직접 선택해 목표 포인트를 만든다. */
function setupGuide04SimBuild(canvas, step, handlers){
  var K = G04Kit;
  var m = K.mountStack(canvas, 'd4');
  var board = K.el('div', 'g04-board g04sim-board');
  var tree = K.el('div', 'g04-tree g04sim-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, step.members.length);
  var selfRow = K.el('div', 'g04sim-row');
  var memRow = K.el('div', 'g04sim-row');
  var goal = K.el('div', 'g04sim-goal');
  var self = K.member({ id: 'g04sim-self', label: '본인', cap: '본인', kind: 'plain' });
  var tag = K.tag(0);
  var tagSlot = K.under(self, K.grow(tag));
  var baseDock = K.dock(self.fig, 'g04sim-base', 'base_business_icon', true);
  var selfBox = makeBox('본인', step.selfFields, 'self', 0);
  var selfCard = K.el('div', 'g04sim-card is-self');
  var cards = [];
  var tray = null;
  var coins = [];
  var i;

  function makeBox(name, fields, who, idx){
    var box = K.el('div', 'g04sim-box');
    var gain = K.el('div', 'g04sim-gain', '');
    var btns = {};
    box.appendChild(K.el('div', 'g04sim-name', name));
    fields.forEach(function(key){
      var def = G04SIM_FIELDS[key];
      var field = K.el('div', 'g04sim-field');
      var seg = K.el('div', 'g04sim-seg');
      field.appendChild(K.el('div', 'g04sim-flabel', def.label));
      btns[key] = [];
      def.opts.forEach(function(opt){
        var b = K.el('button', 'g04sim-opt', opt[1]);
        b.type = 'button';
        b.setAttribute('data-who', who);
        b.setAttribute('data-idx', String(idx));
        b.setAttribute('data-key', key);
        b.setAttribute('data-val', String(opt[0]));
        b.addEventListener('click', function(){ handlers.onPick(who, idx, key, opt[0]); });
        btns[key].push(b);
        seg.appendChild(b);
      });
      field.appendChild(seg);
      box.appendChild(field);
    });
    return { box: box, btns: btns, gain: gain };
  }

  guide04SimOpen(tagSlot);
  selfCard.appendChild(self.wrap);
  selfCard.appendChild(selfBox.box);
  if(step.selfNote){
    selfBox.box.appendChild(K.el('div', 'g04sim-note', step.selfNote));
  }
  selfRow.appendChild(selfCard);

  for(i = 0; i < step.members.length; i++){
    (function(n){
      var cfg = step.members[n];
      var mem = K.member({ id: 'g04sim-m' + n, label: cfg.label, cap: cfg.cap, kind: 'plain', size: 'sm' });
      var card = K.el('div', 'g04sim-card');
      var box;
      if(step.kind === 'coin'){
        box = { box: K.el('div', 'g04sim-info-wrap'), btns: {}, gain: K.el('div') };
        box.box.appendChild(guide04SimInfo(K, cfg.info));
      }else{
        box = makeBox(cfg.cap, cfg.fields, 'm', n);
        box.box.appendChild(box.gain);
      }
      card.appendChild(mem.wrap);
      card.appendChild(box.box);
      memRow.appendChild(card);
      cards.push({ mem: mem, box: box });
    })(i);
  }

  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(memRow);
  board.appendChild(goal);
  board.appendChild(tree);

  if(step.kind === 'coin'){
    tray = K.el('div', 'g04sim-tray');
    tray.appendChild(K.el('div', 'g04sim-tray-label', '본인에게 들어올 이번 달 추천포인트를 선택하세요'));
    var row = K.el('div', 'g04sim-coinrow');
    step.coins.forEach(function(v){
      var c = K.el('button', 'g04sim-coin');
      c.type = 'button';
      c.setAttribute('data-coin', String(v));
      c.appendChild(K.el('span', 'g04sim-coin-num', v + 'P'));
      c.addEventListener('click', function(){ handlers.onCoin(v); });
      row.appendChild(c);
      coins.push(c);
    });
    tray.appendChild(row);
    board.appendChild(tray);
  }
  m.stage.appendChild(board);
  m.stage._g04GroupInset = 0.95;

  Guide04SimLayout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: null });
  Guide04SimLayout.schedule();

  window.requestAnimationFrame(function(){
    cards.forEach(function(c, n){
      K.drawLine(tree, svg, paths, n, self.icon, c.mem.icon, 1, 0.1, false);
    });
  });

  return {
    simBuild: true, stage: m.stage, board: board, tree: tree, goal: goal,
    self: self, tag: tag, baseDock: baseDock, selfBox: selfBox, cards: cards, coins: coins
  };
}

var Guide04Simulator = (function(){
  var KEYS = ['A', 'B', 'C'];

  /* 4개의 핵심 퀴즈 + 3개의 문제풀이 */
  var STEPS = [
    {
      mode: 'quiz', config: Guide04Scene01Config, scene: Guide04Scene01,
      setup: setupGuide04Scene01, run: runGuide04Scene01,
      title: '추천보너스란 무엇일까요?',
      question: '추천보너스를 받기 위한 본인 조건으로 맞는 것은?',
      choices: [
        '자격과 관계없이 추천 회원이 있으면 받는다',
        '추천 회원이 10명 이상일 때만 받는다',
        'Base 사업자 자격을 유지해야 받는다'
      ],
      answer: 2,
      feedback: '추천보너스는 Base 사업자 자격을 유지할 때 받을 수 있습니다. 추천 회원이 늘어나도 자격이 없으면 받을 수 없습니다.'
    },
    {
      mode: 'quiz', config: Guide04Scene02Config, scene: Guide04Scene02,
      setup: setupGuide04Scene02, run: runGuide04Scene02,
      title: '오토십 추천보너스',
      question: '오토십 추천보너스의 기준으로 맞는 것은?',
      choices: [
        '오토십 상품 수가 많을수록 포인트가 늘어난다',
        '이용하는 추천 회원 1명당 매월 1P가 발생한다',
        '추천 회원이 오토십을 시작한 첫 달에만 발생한다'
      ],
      answer: 1,
      feedback: '기준은 상품 수가 아니라 오토십을 이용하는 추천 회원 수입니다. 1명당 매월 1P가 발생합니다.'
    },
    {
      mode: 'quiz', config: Guide04Scene03Config, scene: Guide04Scene03,
      setup: setupGuide04Scene03, run: runGuide04Scene03,
      title: '스타트팩 추천보너스',
      question: '스타트팩 추천보너스로 맞는 것은?',
      choices: [
        '두 종류를 모두 구매하면 1명당 10P가 발생한다',
        '매월 반복해서 1명당 5P가 발생한다',
        '등록 후 3개월 내 구매하면 1명당 최초 1회 최대 5P가 발생한다'
      ],
      answer: 2,
      feedback: '스타트팩은 등록 후 3개월 내 구매 시 1명당 최초 1회 최대 5P입니다. 두 종류를 모두 이용해도 5P까지만 적용됩니다.'
    },
    {
      mode: 'quiz', config: Guide04Scene04Config, scene: Guide04Scene04,
      setup: setupGuide04Scene04, run: runGuide04Scene04,
      title: '추천관계와 포인트 산정 기준',
      question: '추천관계와 포인트 산정에 대해 맞는 것은?',
      choices: [
        '본인 이용 실적도 내 추천포인트에 포함된다',
        '등록 후에도 추천인은 자유롭게 바꿀 수 있다',
        '본인 이용 실적은 내 추천포인트에서 제외되고, 내 실적은 추천인의 포인트가 된다'
      ],
      answer: 2,
      feedback: '본인 이용 실적은 내 추천포인트에서 제외됩니다. 내 이용 실적은 추천인의 포인트이고, 추천인은 등록 후 변경할 수 없습니다.'
    },
    {
      mode: 'build', kind: 'coin', title: '오토십 추천포인트 계산하기',
      prompt: '추천 회원 A, B, C가 오토십을 각각 1개, 3개, 5개 구독 중입니다. 본인의 Base 사업자 자격과 이번 달 받을 추천포인트 코인을 선택하세요.',
      answer: 3, coins: [1, 3, 9],
      selfFields: ['base'],
      members: [
        { label: 'A', cap: '추천 회원 A', info: { type: 'auto', count: 1 } },
        { label: 'B', cap: '추천 회원 B', info: { type: 'auto', count: 3 } },
        { label: 'C', cap: '추천 회원 C', info: { type: 'auto', count: 5 } }
      ],
      start: { self: { base: 0 }, coin: null, m: [] },
      success: 'Base 사업자 자격을 유지하면 오토십 추천보너스는 구독 중인 추천 회원 1명당 1P입니다. 구독 개수와 관계없이 3명이므로 3P입니다.',
      failCoin: {
        1: '추천 회원 3명이 모두 오토십을 구독 중입니다. 1명당 1P이니 다시 계산해 보세요.',
        9: '기준은 오토십 개수가 아니라 구독 중인 추천 회원 수입니다. 1개든 5개든 회원 1명당 1P입니다.'
      }
    },
    {
      mode: 'build', kind: 'coin', title: '스타트팩 추천포인트 계산하기',
      prompt: '추천 회원 A는 누벨마리, B는 시그니처, C는 두 종류를 모두 등록 후 3개월 내에 구매했습니다. 본인의 Base 사업자 자격과 이번 달 받을 추천포인트 코인을 선택하세요.',
      answer: 15, coins: [10, 15, 20],
      selfFields: ['base'],
      members: [
        { label: 'A', cap: '추천 회원 A', info: { type: 'pack', kinds: ['n'] } },
        { label: 'B', cap: '추천 회원 B', info: { type: 'pack', kinds: ['s'] } },
        { label: 'C', cap: '추천 회원 C', info: { type: 'pack', kinds: ['n', 's'] } }
      ],
      start: { self: { base: 0 }, coin: null, m: [] },
      success: '스타트팩은 추천 회원 1명당 최초 1회 최대 5P입니다. 두 종류를 모두 구매한 C도 5P까지만 인정되어 3명 합계 15P입니다.',
      failCoin: {
        10: '구매한 추천 회원은 3명입니다. 한 명당 5P씩 다시 계산해 보세요.',
        20: '두 종류를 모두 구매한 회원도 1명당 최대 5P까지만 인정됩니다.'
      }
    },
    {
      mode: 'build', kind: 'toggle', title: '추천포인트 종합 문제',
      prompt: '본인의 Base 사업자 자격과 추천 회원 3명의 오토십 구독, 스타트팩 구매를 선택해 이번 달 추천포인트 7P를 만드세요.',
      goal: 7,
      selfFields: ['base'],
      members: [
        { label: '추천', cap: '추천 회원 1', fields: ['auto', 'pack'] },
        { label: '추천', cap: '추천 회원 2', fields: ['auto', 'pack'] },
        { label: '추천', cap: '추천 회원 3', fields: ['auto', 'pack'] }
      ],
      start: { self: { base: 0 }, coin: null, m: [
        { auto: 0, pack: 0 }, { auto: 0, pack: 0 }, { auto: 0, pack: 0 }
      ] },
      success: '본인이 Base 사업자 자격을 유지한 상태에서 추천 회원의 오토십 구독은 1명당 1P, 스타트팩 구매는 1명당 5P입니다. 본인의 이용 실적은 포함되지 않습니다.'
    }
  ];

  var motionToken = 0;
  var index = 0;
  var solved = [];
  var saved = [];
  var board = null;
  var currentAssets = null;

  function canvasEl(){ return document.getElementById('motion-canvas'); }

  function copyState(st){
    return {
      self: { base: st.self.base ? 1 : 0 },
      coin: st.coin == null ? null : st.coin,
      m: st.m.map(function(x){ return { auto: x.auto ? 1 : 0, pack: x.pack ? 1 : 0 }; })
    };
  }

  function releaseScenes(){
    var i;
    for(i = 0; i < STEPS.length; i++){
      if(STEPS[i].scene && STEPS[i].scene.reset) STEPS[i].scene.reset();
    }
    Guide04SimLayout.unbind();
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
    if(step.mode === 'quiz'){
      Guide04.resetScene(step.config.canvasCls);
      Guide04.mountStage(canvas, step.config.canvasCls);
      /* 퀴즈 구간은 타이틀 뱃지 없이 바로 본 그래픽부터 보여준다 */
      step.config.media.titleMs = 0;
      currentAssets = step.setup(canvas);
      if(currentAssets) currentAssets.badge = null;
      ctx = simCtx(token, step.config);
      tl = Guide04.timeline(ctx);
      job = step.run(tl, currentAssets, ctx);
      if(job && job.catch) job.catch(function(){});
      return;
    }
    Guide04.resetScene('g04-sim-canvas');
    Guide04.mountStage(canvas, 'g04-sim-canvas');
    currentAssets = setupGuide04SimBuild(canvas, step, { onPick: onPick, onCoin: onCoin });
  }

  /* ───── 문제풀이 상태 반영 ───── */
  function applyBuild(){
    var step = STEPS[index];
    var A = currentAssets;
    var st = board;
    var pts;
    var i;
    var isSolved = !!solved[index];
    if(!step || step.mode !== 'build' || !A || !A.simBuild || !st) return;

    A.self.icon.classList.toggle('member_base_self', !!st.self.base);
    A.baseDock.classList.toggle('is-hidden', !st.self.base);
    refreshBox(A.selfBox, st.self, isSolved);

    if(step.kind === 'coin'){
      for(i = 0; i < A.coins.length; i++){
        var cv = Number(A.coins[i].getAttribute('data-coin'));
        A.coins[i].classList.toggle('is-on', st.coin === cv);
        A.coins[i].disabled = isSolved;
      }
      if(A.tag.numNode){
        A.tag.numNode.textContent = st.coin == null ? '?' : String(st.coin);
        A.tag.value = st.coin == null ? 0 : st.coin;
      }
      A.goal.innerHTML = '본인의 이번 달 추천포인트는?';
      A.goal.classList.toggle('is-met', isSolved);
      Guide04SimLayout.schedule();
      return;
    }

    /* 계산 과정은 보여주지 않는다. 판정 전에는 ?P, 정답이 되면 합계를 보여준다. */
    if(A.tag.numNode && !isSolved){
      A.tag.numNode.textContent = '?';
      A.tag.value = 0;
    }else if(isSolved){
      G04Kit.tagSet(A.tag, step.goal, false);
    }
    for(i = 0; i < A.cards.length; i++){
      refreshBox(A.cards[i].box, st.m[i], isSolved);
    }
    A.goal.innerHTML = '목표 <b>' + step.goal + 'P</b>';
    A.goal.classList.toggle('is-met', isSolved);
    Guide04SimLayout.schedule();
  }

  function refreshBox(box, data, isSolved){
    var key;
    var list;
    var n;
    for(key in box.btns){
      if(!box.btns.hasOwnProperty(key)) continue;
      list = box.btns[key];
      for(n = 0; n < list.length; n++){
        list[n].classList.toggle('is-on', list[n].getAttribute('data-val') === String(data[key] ? 1 : 0));
        list[n].disabled = !!isSolved;
      }
    }
  }

  function onPick(who, idx, key, val){
    var data;
    if(solved[index] || !board) return;
    SimSfx.play('next');
    data = who === 'self' ? board.self : board.m[idx];
    data[key] = Number(val);
    applyBuild();
  }

  function onCoin(val){
    if(solved[index] || !board) return;
    SimSfx.play('next');
    board.coin = val;
    applyBuild();
    if(currentAssets && currentAssets.tag) G04Kit.tagSet(currentAssets.tag, val, true);
  }

  function failText(step, st){
    var pts;
    if(step.kind === 'coin'){
      if(!st.self.base) return '본인이 Base 사업자 자격을 유지해야 추천포인트를 받을 수 있습니다.';
      if(st.coin == null) return '이번 달 받을 추천포인트 코인을 선택해 주세요.';
      return step.failCoin[st.coin] || '다시 한번 계산해 보세요.';
    }
    pts = guide04SimPoints(st);
    if(!st.self.base) return '본인이 Base 사업자 자격을 유지해야 추천포인트를 받을 수 있습니다.';
    if(pts < step.goal) return '목표보다 적습니다. 오토십 구독(1명당 1P)과 스타트팩 구매(1명당 5P)를 다시 확인해 보세요.';
    return '목표보다 많습니다. 추천 회원의 선택을 다시 확인해 보세요.';
  }

  /* ───── 패널 ───── */
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
    document.body.classList.toggle('sim-quiz-compact', !!STEPS[index]);
  }

  function stepMark(stepIndex){
    var step = STEPS[stepIndex];
    if(step && step.label) return step.label;
    return String(stepIndex + 1);
  }

  function setChrome(stepIndex, done){
    var total = STEPS.length;
    var num = document.getElementById('sim-step-number');
    var fill = document.getElementById('sim-progress-fill');
    var bar = document.getElementById('sim-progress-track');
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var pct = done ? 100 : Math.round((stepIndex / total) * 100);
    if(num) num.textContent = (done ? total : (stepIndex + 1)) + ' / ' + total;
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

  /* ───── 퀴즈 ───── */
  function lockQuiz(step){
    var buttons = document.querySelectorAll('.sim-choice-btn');
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
    showNext();
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
      SimSfx.play('wrong');
      showFeedback(false, '다시 한번 골라 보세요.');
      return;
    }
    SimSfx.play('correct');
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

  /* ───── 문제풀이 ───── */
  function buildMet(step, st){
    if(step.kind === 'coin') return !!st.self.base && st.coin === step.answer;
    return guide04SimPoints(st) === step.goal;
  }

  function onBuildJudge(){
    var step = STEPS[index];
    var judge;
    if(!step || solved[index]) return;
    if(!buildMet(step, board)){
      SimSfx.play('wrong');
      showFeedback(false, failText(step, board));
      return;
    }
    SimSfx.play('correct');
    solved[index] = true;
    saved[index] = copyState(board);
    applyBuild();
    judge = document.querySelector('.sim-judge');
    if(judge){
      judge.textContent = '정답';
      judge.classList.add('is-met');
      judge.disabled = true;
    }
    showFeedback(true, step.success);
    showNext();
    setChrome(index, false);
  }

  function renderBuild(step){
    var host = document.getElementById('sim-choices');
    var row;
    var judge;
    if(!host) return;
    board = copyState(solved[index] && saved[index] ? saved[index] : step.start);
    host.innerHTML = '';
    row = document.createElement('div');
    row.className = 'sim-actions';
    judge = document.createElement('button');
    judge.type = 'button';
    judge.className = 'sim-judge';
    judge.textContent = '정답 확인';
    judge.addEventListener('click', onBuildJudge);
    row.appendChild(judge);
    host.appendChild(row);
    hideNext();
    applyBuild();
    if(solved[index]){
      judge.textContent = '정답';
      judge.classList.add('is-met');
      judge.disabled = true;
      showFeedback(true, step.success);
      showNext();
    }
  }

  /* ───── 결과 · 이동 ───── */
  function showResult(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    var summary = document.getElementById('sim-result-summary');
    var lines = [
      '추천보너스는 Base 사업자 자격을 유지할 때 받는다',
      '오토십은 회원 1명당 매월 1P, 스타트팩은 1명당 최초 1회 최대 5P',
      '본인 이용 실적은 내 추천포인트에서 제외되고 추천인의 포인트가 된다'
    ];
    var i;
    var item;
    if(q) q.classList.add('is-hidden');
    if(result) result.classList.remove('is-hidden');
    document.body.classList.remove('sim-quiz-compact');
    setText('sim-result-chapter', '추천보너스 알아보기');
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
    releaseScenes();
    if(typeof GuideClosePanel !== 'undefined'){
      GuideClosePanel.showSimulatorEnd(canvasEl(), {
        title: '추천보너스 알아보기',
        onRelearn: restart,
        onWatch: function(){ location.href = 'guide04_smartguide.asp?from=sim'; },
        onList: function(){ location.href = 'sim.asp'; }
      });
    }
  }

  function renderStep(){
    var step = STEPS[index];
    var label = document.getElementById('lo-scene-label');
    launchMotion(index, motionToken);
    showQuestion();
    setText('sim-step-label', 'STEP ' + stepMark(index));
    setText('scene-title-main', step.title);
    setText('sim-question', step.question || step.prompt);
    if(step.mode === 'quiz') renderChoices(step);
    else renderBuild(step);
    syncQuizCompact();
    setChrome(index, false);
    if(label) label.textContent = '추천보너스 알아보기';
  }

  function reopen(stepIndex){
    if(stepIndex < 0 || stepIndex >= STEPS.length) return;
    solved[stepIndex] = false;
    saved[stepIndex] = null;
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
    if(typeof ReadLog !== 'undefined') ReadLog.simulation('guide04', index + 1);
    if(index >= STEPS.length - 1){
      SimSfx.play('result');
      motionToken++;
      releaseScenes();
      showResult();
      return;
    }
    SimSfx.play('next');
    go(index + 1);
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
    if(watch) watch.addEventListener('click', function(){ location.href = 'guide04_smartguide.asp?from=sim'; });
    if(back) back.addEventListener('click', function(){ location.href = 'sim.asp'; });
  }

  function init(){
    var label = document.getElementById('lo-scene-label');
    var i;
    if(label) label.textContent = '추천보너스 알아보기';
    document.title = '추천보너스 알아보기 시뮬레이션 - ALTWELL SMART GUIDE';
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
