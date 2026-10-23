<script>
/* 가이드03 시뮬레이션 — 왼쪽은 해당 씬 모션, 오른쪽은 이번 달 BASE 판정 보드. */
var Guide03SimQualifyLayout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide03 === 'undefined') return;
    Guide03.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, null);
  }

  function schedule(){ requestAnimationFrame(applyFit); }

  function bind(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', schedule);
  }

  return { schedule: schedule, bind: bind };
})();

function setupGuide03SimQualify(canvas){
  var zone = Guide03Scene10Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var pane = document.createElement('div');
  var board = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');
  var note = document.createElement('div');
  var noteInner = document.createElement('div');

  function chip(className, node){
    var el = document.createElement('div');
    el.className = 'g03-simq-chip g03-slot is-hidden ' + className;
    if(node) el.appendChild(node);
    return el;
  }

  function autoChip(){
    var icon = Guide03.cloneTemplate('autoship_icon');
    return chip('g03-simq-auto', icon);
  }

  function sepChip(){
    var el = chip('g03-simq-sep', null);
    el.textContent = 'S.E.P 30만 이상';
    return el;
  }

  function person(templateId, withBadge){
    var icon = Guide03.cloneTemplate(templateId);
    var col = document.createElement('div');
    var host = document.createElement('div');
    var dock = null;
    var badgeWrap = null;
    var badge = null;
    col.className = 'g03-simq-col';
    host.className = 'g03-member' + (withBadge ? ' g03-simq-self' : '');
    if(icon) host.appendChild(icon);
    col.appendChild(host);
    if(withBadge){
      dock = document.createElement('div');
      dock.className = 'g03-simq-dock';
      badgeWrap = document.createElement('div');
      badgeWrap.className = 'g03-slot g03-simq-badge is-hidden';
      badge = Guide03.cloneTemplate('base_business_icon');
      if(badge){
        badge.classList.remove('base_business_icon_o');
        badge.classList.add('base_business_icon_c');
        badgeWrap.appendChild(badge);
      }
      dock.appendChild(badgeWrap);
      host.appendChild(dock);
    }
    return {
      col: col,
      host: host,
      icon: icon,
      auto: autoChip(),
      sep: sepChip(),
      badge: badgeWrap
    };
  }

  function mountPerson(entry){
    entry.col.appendChild(entry.auto);
    entry.col.appendChild(entry.sep);
  }

  var self = person('member_base_self', true);
  var left = person('member_base_partner', false);
  var right = person('member_base_partner', false);
  mountPerson(self);
  mountPerson(left);
  mountPerson(right);

  lines.setAttribute('class', 'g03-lines');
  lines.setAttribute('aria-hidden', 'true');
  lines.appendChild(document.createElementNS('http://www.w3.org/2000/svg', 'path'));
  lines.appendChild(document.createElementNS('http://www.w3.org/2000/svg', 'path'));
  tree.className = 'g03-tree g03-simq-tree';
  rowTop.className = 'g03-member-row';
  rowBottom.className = 'g03-member-row';
  rowTop.appendChild(self.col);
  rowBottom.appendChild(left.col);
  rowBottom.appendChild(right.col);
  tree.appendChild(lines);
  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);

  board.className = 'g03-board g03-simq-board';
  board.appendChild(tree);
  note.className = 'g03-simq-note g03-slot is-hidden';
  noteInner.className = 'g03-simq-note-inner';
  noteInner.innerHTML = '구성원 합산 조건 등<span class="g03-simq-note-em">추가 조건 필요 없음</span>';
  note.appendChild(noteInner);
  pane.className = 'g03-simq-pane';
  pane.appendChild(board);
  pane.appendChild(note);
  stage.className = 'g03-simq';
  stage.appendChild(pane);

  stack.className = 'g03-stack g01-zone-wrap lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);
  Guide03SimQualifyLayout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03SimQualifyLayout.schedule();

  return {
    simQualify: true,
    stage: stage,
    board: board,
    tree: tree,
    lines: lines,
    members: [self, left, right],
    chips: { self: self, a: left, b: right },
    note: note,
    badge: self.badge
  };
}

var Guide03Simulator = (function(){
  function blank(){
    return {
      self: { auto: false, sep: false },
      a: { auto: false, sep: false },
      b: { auto: false, sep: false },
      total: 0
    };
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
      mode: 'quiz',
      question: 'BASE사업자 하위 파트너들의 조건으로 알맞은것은 무엇인가요?',
      choices: [
        '두 명 모두 오토십을 유지하거나, 두 명 모두 S.E.P 30만 이상이어야 한다',
        '한 명은 오토십만, 다른 한 명은 S.E.P 30만이면 된다',
        '파트너 한 명만 조건을 채우면 된다'
      ],
      answer: 0,
      feedback: '하위 파트너 두 명은 같은 조건이어야 합니다. 둘 다 오토십을 유지하거나, 둘 다 S.E.P 30만 이상이어야 합니다.'
    },
    {
      config: Guide03Scene06Config,
      scene: Guide03Scene06,
      setup: setupGuide03Scene06,
      run: runGuide03Scene06,
      mode: 'quiz',
      question: 'BASE사업자 자격을 충족하기 위한 S.E.P 실적 조건으로 알맞은 것은?',
      choices: [
        '파트너 두 명 모두 S.E.P 30만 이상이고, 구성원 합산 S.E.P가 100만 이상이어야 한다',
        '각자 S.E.P 30만이면 합산이 100만 미만이어도 된다',
        '합산 S.E.P만 100만이면 파트너 각자의 실적은 없어도 된다'
      ],
      answer: 0,
      feedback: 'S.E.P 실적으로 자격을 충족하려면 파트너 두 명 모두 S.E.P 30만 이상이어야 하고, 구성원 합산 S.E.P도 매월 100만 이상이어야 합니다.'
    },
    {
      config: Guide03Scene10Config,
      scene: Guide03Scene10,
      run: runGuide03Scene10,
      title: 'BASE 사업자 자격 (오토십 활용법)',
      label: '6-1',
      voicePart: 'sim06-1',
      prompt: '본인, 파트너, 합산 S.E.P를 설정하여 오토십으로 이번 달 BASE사업자 자격을 충족시키세요.',
      mode: 'build',
      goal: 'all',
      sumRule: 'any',
      showTotal: true,
      totalBox: true,
      labels: { auto: '오토십 구독', sep: 'S.E.P 30만' },
      setup: setupGuide03SimQualify,
      totals: [40, 60, 80],
      people: [
        { who: 'self', name: '본인', keys: ['auto', 'sep'] },
        { who: 'a', name: '파트너 1', keys: ['auto'] },
        { who: 'b', name: '파트너 2', keys: ['auto', 'sep'] }
      ],
      start: blank(),
      success: '본인 조건과 파트너 두 명의 오토십 유지가 맞으면, 합산 S.E.P가 100만 미만이어도 베이스 사업자 자격이 됩니다.',
      fail: ''
    },
    {
      config: Guide03Scene10Config,
      scene: Guide03Scene10,
      run: runGuide03Scene10,
      title: 'BASE 사업자 자격 (S.E.P 활용법)',
      label: '6-2',
      progress: 5.5,
      voicePart: 'sim06-2',
      prompt: '본인, 파트너, 합산 S.E.P를 설정하여 S.E.P 실적으로 이번 달 BASE사업자 자격을 충족시키세요.',
      mode: 'build',
      goal: 'all',
      sumRule: '100',
      showTotal: true,
      totalBox: true,
      labels: { auto: '오토십 구독', sep: 'S.E.P 30만' },
      setup: setupGuide03SimQualify,
      totals: [90, 100, 150],
      people: [
        { who: 'self', name: '본인', keys: ['auto', 'sep'] },
        { who: 'a', name: '파트너 1', keys: ['auto', 'sep'] },
        { who: 'b', name: '파트너 2', keys: ['sep'] }
      ],
      start: blank(),
      success: '파트너 두 명 모두 S.E.P 30만 이상이어도, 구성원 합산 S.E.P가 100만 이상이어야 베이스 사업자 자격이 됩니다.',
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

  function totalChosen(step, state){
    var totals = step.totals || TOTALS;
    var i;
    for(i = 0; i < totals.length; i++){
      if(totals[i] === state.total) return true;
    }
    return false;
  }

  function goalMet(step, state){
    if(step.goal === 'self') return selfOk(state);
    if(step.goal === 'auto') return partnersAuto(state);
    if(step.goal === 'sep') return partnersSep(state);
    if(step.sumRule === 'any') return selfOk(state) && partnersAuto(state) && totalChosen(step, state);
    if(step.sumRule === '100') return selfOk(state) && partnersSep(state) && state.total >= 100;
    return selfOk(state) && partnersOk(state) && totalOk(state);
  }

  function failText(step, state){
    if(step.fail) return step.fail;
    if(!selfOk(state)){
      if(step.labels) return '본인은 오토십 구독과 S.E.P 30만을 함께 채워야 합니다.';
      return '본인은 오토십 유지와 S.E.P 30만을 함께 채워야 합니다.';
    }
    if(step.sumRule === 'any'){
      if(!partnersAuto(state)) return '파트너 두 명 모두 오토십을 구독해야 합니다. 그러면 합산 S.E.P 조건은 없습니다.';
      return '구성원 합산 S.E.P를 선택해 주세요. 오토십을 유지하면 40만, 60만, 80만 모두 자격입니다.';
    }
    if(step.sumRule === '100'){
      if(!partnersSep(state)) return '파트너 두 명 모두 S.E.P 30만 이상이어야 합니다.';
      return '파트너 두 명이 S.E.P 30만을 달성해도 구성원 합산 S.E.P가 100만 미만이면 미달입니다.';
    }
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
    if(id === 'guide03-scene-10' && assets.simQualify){
      var who;
      var pass = solved[index] && goalMet(step, state);
      setShown(assets.board, true);
      for(who in assets.chips){
        if(!assets.chips.hasOwnProperty(who)) continue;
        setShown(assets.chips[who].auto, !!state[who].auto);
        setShown(assets.chips[who].sep, !!state[who].sep);
      }
      if(assets.note){
        assets.note.firstElementChild.innerHTML = step.sumRule === '100'
          ? '구성원 3명의<span class="g03-s10-note-sep">합산 S.E.P 100만 이상</span>'
          : '구성원 합산 조건 등<span class="g03-simq-note-em">추가 조건 필요 없음</span>';
      }
      setShown(assets.note, pass);
      if(assets.note) assets.note.classList.remove('g03-enter');
      setShown(assets.badge, pass);
      assets.board.classList.toggle('is-pass', pass);
      if(pass && !assets.board._simPassed){
        assets.board._simPassed = true;
        assets.board.classList.remove('is-flash');
        void assets.board.offsetWidth;
        assets.board.classList.add('is-flash');
      }
      if(!pass) assets.board._simPassed = false;
      Guide03SimQualifyLayout.schedule();
      window.requestAnimationFrame(function(){
        if(!currentAssets || currentAssets !== assets) return;
        if(typeof guide03Scene01DrawLines === 'function') guide03Scene01DrawLines(assets, false);
      });
      return;
    }
    if(id === 'guide03-scene-10'){
      setShown(assets.card, true);
      setShown(assets.left.root, true);
      setShown(assets.right.root, true);
      setShown(assets.left.self.host, true);
      setShown(assets.right.self.host, true);
      setShown(assets.left.selfAuto, state.self.auto);
      setShown(assets.right.selfAuto, state.self.auto);
      setShown(assets.left.selfSep, state.self.sep);
      setShown(assets.right.selfSep, state.self.sep);
      setShown(assets.left.partners[0].host, true);
      setShown(assets.left.partners[1].host, true);
      setShown(assets.right.partners[0].host, true);
      setShown(assets.right.partners[1].host, true);
      setShown(assets.left.chip, state.a.auto || state.b.auto);
      setShown(assets.right.chip, state.a.sep || state.b.sep);
      setShown(assets.left.note, partnersAuto(state));
      setShown(assets.right.note, state.total >= 100);
      setShown(assets.left.badge, selfOk(state));
      setShown(assets.right.badge, selfOk(state));
      full = goalMet(step, state);
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
    document.body.classList.toggle('sim-quiz-compact', !!(STEPS[index] && STEPS[index].mode === 'quiz'));
  }

  function showResult(){
    var q = document.getElementById('sim-question-panel');
    var result = document.getElementById('sim-result-panel');
    var summary = document.getElementById('sim-result-summary');
    var lines = [
      '본인: 오토십이 포함된 S.E.P 30만 이상',
      '파트너 2명 모두 오토십 유지: 합산 S.E.P 조건 없이 자격',
      '파트너 2명 모두 S.E.P 30만: 합산 S.E.P가 100만 미만이면 미달'
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
    releaseScenes();
    if(typeof GuideClosePanel !== 'undefined'){
      GuideClosePanel.showSimulatorEnd(canvasEl(), {
        title: 'BASE사업자 이해하기',
        onRelearn: restart,
        onWatch: function(){ location.href = 'guide03_smartguide.asp?from=sim'; },
        onList: function(){ location.href = 'sim.asp'; }
      });
    }
  }

  function displayTotal(){ return 6; }

  function stepMark(stepIndex){
    var step = STEPS[stepIndex];
    if(step && step.label) return step.label;
    return String(stepIndex + 1);
  }

  function setChrome(stepIndex, done){
    var total = displayTotal();
    var num = document.getElementById('sim-step-number');
    var fill = document.getElementById('sim-progress-fill');
    var bar = document.getElementById('sim-progress-track');
    var prev = document.getElementById('sim-btn-prev');
    var next = document.getElementById('sim-btn-next');
    var pos = done ? total : (STEPS[stepIndex] && STEPS[stepIndex].progress != null ? STEPS[stepIndex].progress : stepIndex);
    var pct = done ? 100 : Math.round((pos / total) * 100);
    if(num) num.textContent = (done ? stepMark(STEPS.length - 1) : stepMark(stepIndex)) + ' / ' + total;
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

  function makeToggle(who, key, locked, label){
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'sim-toggle' + (board[who][key] ? ' is-on' : '');
    btn.textContent = label || LABELS[key];
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
        toggles.appendChild(makeToggle(person.who, person.keys[k], person.lock || solved[index], step.labels && step.labels[person.keys[k]]));
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
    row.className = 'sim-total' + (step.totalBox ? ' sim-person' : '');
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
    var judge = document.querySelector('.sim-judge');
    if(judge && step.mode === 'build'){
      judge.textContent = '이번 달 자격 충족';
      judge.classList.add('is-met');
    }
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
    syncMotion();
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
    var people;
    host.innerHTML = '';
    people = renderPeople(step);
    host.appendChild(people);
    if(step.showTotal){
      if(step.totalBox) people.appendChild(renderTotal(step));
      else host.appendChild(renderTotal(step));
    }
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
    setText('sim-step-label', 'STEP ' + (step.label || (index + 1)));
    setText('scene-title-main', step.title || step.config.title);
    setText('sim-question', step.question || step.prompt);
    if(step.mode === 'quiz') renderChoices(step);
    else renderBoard(step);
    syncQuizCompact();
    setChrome(index, false);
    if(label) label.textContent = 'BASE사업자 이해하기';
    if(typeof SimVoice !== 'undefined' && step.voice !== false) SimVoice.playStep('guide03', index, step.voicePart);
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
