<script>
/* Scene 05 - BASE사업자의 첫 번째 권리 (see Scene05.md) */
var BaseScene05 = {
  id: 'base-scene-05',
  title: 'BASE사업자의 권리',
  duration: 32000,
  _baseAnimMs: 31800,
  _bonusCount: 0,

  _starSvg: '<svg class="marker-icon" viewBox="0 0 24 24" aria-hidden="true"><path fill="#F59E0B" d="M12 2l2.6 5.27 5.82.85-4.21 4.1.99 5.78L12 15.9l-5.2 2.73.99-5.78-4.21-4.1 5.82-.85L12 2z"/></svg>',
  _crownSvg: '<svg class="marker-icon" viewBox="0 0 24 24" aria-hidden="true"><path fill="#EAB308" d="M3 18h18v2H3v-2zm2.5-9L7 11l3-5 2 3 3-4 3.5 6H5.5z"/></svg>',

  _mainBlock: function(){
    return (
      '<div class="member-visual" id="member-visual-main">' +
        '<div class="member-marker leader-crown is-hidden" id="leader-crown-main">' + this._crownSvg + '</div>' +
        '<img class="member-image" id="member-image-main" src="<%=memberImg%>" alt="본인"/>' +
        '<div class="member-emblems" id="member-emblems-main">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem is-hidden" id="autoship-emblem-main">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
            '<div class="qualification-badge base-business is-hidden" id="base-business-badge-main">' +
              '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
            '</div>' +
            '<div class="rank-medal is-hidden" id="rank-medal-main">' +
              '<img src="<%=lev01Img%>" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
        '<div class="member-metrics is-hidden" id="member-metrics-main">' +
          '<div class="metric-badge sep-badge is-hidden" id="sep-badge-main" data-status="complete">' +
            '<span class="sep-badge-text">S.E.P<br>30만↑</span>' +
          '</div>' +
        '</div>' +
      '</div>'
    );
  },

  _bonusDockBlock: function(){
    return (
      '<div class="member-income bonus-stack scene05-bonus-area" id="scene05-bonus-area">' +
        '<div class="bonus-plate recommend-bonus is-hidden" id="recommend-bonus-main">' +
          '<span class="bonus-indicator"></span>' +
          '<span class="bonus-label">추천 보너스</span>' +
          '<strong class="bonus-value" id="scene05-bonus-value">1명당 월 10,000원</strong>' +
        '</div>' +
        '<div class="scene05-base-status-plate is-hidden" id="scene05-base-status-plate">' +
          'BASE사업자 자격 유지 중' +
        '</div>' +
      '</div>'
    );
  },

  _referBlock: function(id){
    return (
      '<div class="member-visual" id="member-visual-' + id + '">' +
        '<div class="member-marker recommend-star" id="recommend-star-' + id + '">' + this._starSvg + '</div>' +
        '<img class="member-image" id="member-image-' + id + '" src="<%=memberImg%>" alt="추천 멤버"/>' +
        '<div class="member-emblems" id="member-emblems-' + id + '">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem" id="autoship-emblem-' + id + '">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
        '<div class="member-metrics" id="member-metrics-' + id + '">' +
          '<div class="metric-badge sep-badge" id="sep-badge-' + id + '" data-status="complete">' +
            '<span class="sep-badge-text">S.E.P<br>30만↑</span>' +
          '</div>' +
        '</div>' +
      '</div>'
    );
  },

  _referCount: 6,

  _mountCanvas: function(canvas){
    var self = this;
    canvas.classList.add('scene05-canvas');
    canvas.innerHTML = '';

    var bg = document.createElement('div');
    bg.className = 'scene01-stage-bg scene-canvas-bg';
    canvas.appendChild(bg);

    ['bg-circle-1','bg-circle-2','bg-circle-3'].forEach(function(id){
      var c = document.createElement('div');
      c.className = 'scene-bg-circle scene-canvas-bg';
      c.id = id;
      canvas.appendChild(c);
    });

    var dots = document.createElement('div');
    dots.id = 'dot-pattern';
    dots.className = 'scene-canvas-bg';
    canvas.appendChild(dots);

    var main = document.createElement('div');
    main.className = 'member-unit scene05-main is-hidden';
    main.id = 'member-unit-main';
    main.innerHTML = this._mainBlock();
    canvas.appendChild(main);

    var bonusDock = document.createElement('div');
    bonusDock.className = 'scene05-bonus-dock is-hidden';
    bonusDock.id = 'scene05-bonus-dock';
    bonusDock.innerHTML = this._bonusDockBlock();
    canvas.appendChild(bonusDock);

    for(var n = 1; n <= this._referCount; n++){
      var ref = document.createElement('div');
      ref.className = 'member-unit member-child refer-member is-hidden';
      ref.id = 'refer-member-' + n;
      ref.innerHTML = self._referBlock('ref' + n);
      canvas.appendChild(ref);
    }
  },

  _setupPanel: function(){
    setSceneTitle('BASE사업자의 권리');

    var desc = document.getElementById('panel-scene-desc');
    if(desc){
      desc.innerHTML =
        '<div id="scene05-panel-body">' +
          '<div class="scene05-panel-block is-hidden" id="panel-block-income">' +
            '<p class="scene05-panel-heading">권리 소득의 시작</p>' +
          '</div>' +
          '<div class="scene05-panel-block is-hidden" id="panel-block-bonus">' +
            '<p class="scene05-panel-heading">추천 보너스</p>' +
            '<ul class="scene05-panel-list">' +
              '<li class="scene05-panel-item is-hidden" id="panel-bonus-1">직접 추천한 조건 충족 사업자 1명당 월 10,000원</li>' +
              '<li class="scene05-panel-item is-hidden" id="panel-bonus-2">기본 조건 : 오토십 이용 + SEP 30만 이상</li>' +
              '<li class="scene05-panel-item is-hidden" id="panel-bonus-3">소속 그룹과 관계없이 직접 추천한 사업자에게 적용</li>' +
              '<li class="scene05-panel-item is-hidden" id="panel-bonus-4">본인도 BASE사업자 조건 유지 필요</li>' +
            '</ul>' +
          '</div>' +
        '</div>';
    }

    hideElement('#scene-title-main');
    hideElement('#panel-scene-desc');
    hideElement('#scene-bullets');
  },

  _clearPanel: function(){
    var desc = document.getElementById('panel-scene-desc');
    if(desc){ desc.innerHTML = ''; desc.classList.add('is-hidden'); desc.style.cssText = ''; }
    var title = document.getElementById('scene-title-main');
    var bullets = document.getElementById('scene-bullets');
    if(title){ title.innerHTML = ''; title.classList.add('is-hidden'); title.style.cssText = ''; }
    if(bullets){ bullets.innerHTML = ''; bullets.classList.add('is-hidden'); }
  },

  _showMainFromPrior: function(){
    showElement('#member-unit-main');
    showElement('#rank-medal-main');
    showElement('#autoship-emblem-main');
    showElement('#base-business-badge-main');
    showElement('#member-metrics-main');
    showElement('#sep-badge-main');
  },

  _revealPanelItems: async function(selectors, isCancelled){
    for(var i=0;i<selectors.length;i++){
      if(isCancelled()) return;
      var el = document.querySelector(selectors[i]);
      if(!el) continue;
      showElement(el);
      await slideUpElement(el, { duration: sceneDur(700) });
      if(i < selectors.length - 1) await sceneWait(320);
    }
  },

  _pulseHighlight: async function(target){
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return;
    el.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
    await sceneWait(700);
    el.style.animation = '';
  },

  _bonusFlowWithIcon: async function(fromUnitId){
    var canvas = document.getElementById('motion-canvas');
    var from = document.getElementById(fromUnitId);
    var plate = document.getElementById('recommend-bonus-main');
    if(!canvas || !from || !plate) return;

    var canvasRect = canvas.getBoundingClientRect();
    var fr = from.getBoundingClientRect();
    var pr = plate.getBoundingClientRect();

    var fly = document.createElement('img');
    fly.className = 'scene05-bonus-flow-icon';
    fly.src = '<%=bonusPlImg%>';
    fly.alt = '추천 보너스';

    var w = Math.min(112, Math.max(80, fr.width * 0.7));
    fly.style.width = w + 'px';
    fly.style.height = 'auto';

    var x1 = fr.left - canvasRect.left + fr.width / 2 - w / 2;
    var y1 = fr.top - canvasRect.top + fr.height * 0.22;
    var x2 = pr.left - canvasRect.left + pr.width * 0.12;
    var y2 = pr.top - canvasRect.top + pr.height / 2 - w / 2;

    fly.style.left = x1 + 'px';
    fly.style.top = y1 + 'px';
    fly.style.opacity = '0';
    canvas.appendChild(fly);

    await sceneWait(30);
    var fadeIn = sceneDur(400);
    fly.style.transition = 'opacity ' + fadeIn + 'ms var(--ease-smooth)';
    fly.style.opacity = '1';
    await sceneWait(400);

    _clearAnim(fly);
    fly.style.animation = 'kf-glow-once ' + sceneDur(700) + 'ms ease forwards';
    await sceneWait(200);

    var moveDur = sceneDur(1000);
    fly.style.transition = 'left ' + moveDur + 'ms var(--ease-smooth), top ' + moveDur + 'ms var(--ease-smooth), transform ' + moveDur + 'ms var(--ease-smooth)';
    fly.style.left = x2 + 'px';
    fly.style.top = y2 + 'px';
    fly.style.transform = 'scale(0.85)';
    await sceneWait(1000);

    _clearAnim(fly);
    fly.style.animationDuration = sceneDur(600) + 'ms';
    fly.classList.add('motion-acquire');
    await new Promise(function(resolve){
      function onEnd(){
        fly.removeEventListener('animationend', onEnd);
        fly.classList.remove('motion-acquire');
        fly.style.animationDuration = '';
        resolve();
      }
      fly.addEventListener('animationend', onEnd);
    });

    var fadeOut = sceneDur(300);
    fly.style.transition = 'opacity ' + fadeOut + 'ms var(--ease-standard)';
    fly.style.opacity = '0';
    await sceneWait(300);
    if(fly.parentNode) fly.parentNode.removeChild(fly);
  },

  _updateCounter: async function(count){
    this._bonusCount = count;
    var plate = document.getElementById('recommend-bonus-main');
    var valEl = document.getElementById('scene05-bonus-value');
    if(!plate || !valEl) return;

    showElement('#recommend-bonus-main');

    if(count <= 1){
      setRecommendBonus({ target: 'recommend-bonus-main', amount: 10000, count: 1 });
    } else {
      var prev = count - 1;
      for(var i=0;i<=6;i++){
        var shown = prev + Math.round((count - prev) * (i / 6));
        setRecommendBonus({ target: 'recommend-bonus-main', amount: 10000, count: shown });
        await sceneWait(50);
      }
      setRecommendBonus({ target: 'recommend-bonus-main', amount: 10000, count: count });
    }

    _clearAnim(valEl);
    valEl.style.animationDuration = sceneDur(650) + 'ms';
    valEl.classList.add('motion-acquire');
    await new Promise(function(resolve){
      function onEnd(){
        valEl.removeEventListener('animationend', onEnd);
        valEl.classList.remove('motion-acquire');
        valEl.style.animationDuration = '';
        resolve();
      }
      valEl.addEventListener('animationend', onEnd);
    });

    var indicator = plate.querySelector('.bonus-indicator');
    if(indicator){
      indicator.style.animation = 'kf-glow-once ' + sceneDur(700) + 'ms ease forwards';
      await sceneWait(700);
      indicator.style.animation = '';
    }
  },

  _enqueueCounter: function(num){
    var self = this;
    if(!this._counterChain) this._counterChain = Promise.resolve();
    this._counterChain = this._counterChain.then(function(){
      return self._updateCounter(num);
    });
    return this._counterChain;
  },

  _setupReferMember: async function(num, isCancelled){
    var self = this;
    var id = 'ref' + num;
    var unitId = 'refer-member-' + num;

    showElement('#recommend-star-' + id);
    showElement('#autoship-emblem-' + id);
    showElement('#member-metrics-' + id);
    showElement('#sep-badge-' + id);

    var enterP = enterMember(unitId, { duration: sceneDur(560) });
    var bonusP = (async function(){
      await sceneWait(100);
      if(isCancelled && isCancelled()) return;
      await self._bonusFlowWithIcon(unitId);
    })();

    await Promise.all([enterP, bonusP]);
    if(isCancelled && isCancelled()) return;

    await this._enqueueCounter(num);
  },

  _setupReferMembersStaggered: async function(isCancelled){
    var self = this;
    var stagger = sceneDur(340);
    this._counterChain = Promise.resolve();
    var tasks = [];

    for(var r = 1; r <= this._referCount; r++){
      (function(num){
        tasks.push((async function(){
          var startDelay = (num - 1) * stagger;
          if(num > 1) startDelay += (num - 1) * sceneDur(2300);
          if(startDelay > 0) await sceneWait(startDelay);
          if(isCancelled()) return;
          await self._setupReferMember(num, isCancelled);
        })());
      })(r);
    }

    await Promise.all(tasks);
    if(isCancelled()) return;
    await this._counterChain;
  },

  reset: function(){
    this._bonusCount = 0;
    this._counterChain = null;
    var canvas = document.getElementById('motion-canvas');
    if(canvas) canvas.classList.remove('scene05-canvas');
    this._clearPanel();
    var flows = document.querySelectorAll('#motion-canvas .scene05-bonus-flow-icon');
    for(var i=0;i<flows.length;i++){
      if(flows[i].parentNode) flows[i].parentNode.removeChild(flows[i]);
    }
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var cancelled = function(){ return ctx.isCancelled && ctx.isCancelled(); };
    var self = this;
    this._bonusCount = 0;
    var T = createSceneTiming(ctx, this._baseAnimMs);
    setActiveSceneTiming(T);

    try {
      var chapter = document.getElementById('panel-fixed-title');
      if(chapter){
        chapter.textContent = 'BASE사업자 이해하기';
        showElement(chapter);
      }

      this._setupPanel();

      if(ctx.sceneIndex > 0){
        await transitionCanvas(canvas, function(c){ self._mountCanvas(c); }, { outDuration: sceneDur(320), inDuration: sceneDur(320) });
      } else {
        this._mountCanvas(canvas);
      }
      if(cancelled()) return;

      await T.padStart();
      if(cancelled()) return;

      if(ctx.isFollowUp || ctx.sceneIndex > 0){
        this._showMainFromPrior();
      } else {
        await enterMember('member-unit-main', { duration: sceneDur(750) });
        if(cancelled()) return;
        await enterElement('#rank-medal-main', { duration: sceneDur(600) });
        await softAcquireElement('#autoship-emblem-main', { duration: sceneDur(720), glow: true });
        showElement('#base-business-badge-main');
        await softAcquireElement('#base-business-badge-main', { duration: sceneDur(720), glow: true });
        showElement('#member-metrics-main');
        showElement('#sep-badge-main');
        await slideUpElement('#sep-badge-main', { duration: sceneDur(680) });
        T.after(2770);
      }
      if(cancelled()) return;

      showElement('#leader-crown-main');
      await enterElement('#leader-crown-main', { duration: sceneDur(600) });
      T.after(600);
      if(cancelled()) return;

      showElement('#scene-title-main');
      await slideUpElement('#scene-title-main', { duration: sceneDur(880) });
      T.after(880);
      if(cancelled()) return;

      showElement('#panel-scene-desc');
      showElement('#panel-block-income');
      showElement('#panel-block-bonus');
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      showElement('#recommend-bonus-main');
      showElement('#scene05-bonus-dock');
      await slideUpElement('#recommend-bonus-main', { duration: sceneDur(720) });
      T.after(720);
      if(cancelled()) return;

      await this._revealPanelItems(['#panel-bonus-1', '#panel-bonus-2'], cancelled);
      if(cancelled()) return;

      await sceneWait(300);
      if(cancelled()) return;

      await this._setupReferMembersStaggered(cancelled);
      if(cancelled()) return;

      await this._revealPanelItems(['#panel-bonus-3'], cancelled);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      await this._revealPanelItems(['#panel-bonus-4'], cancelled);
      if(cancelled()) return;

      showElement('#scene05-base-status-plate');
      await slideUpElement('#scene05-base-status-plate', { duration: sceneDur(780) });
      T.after(780);
      if(cancelled()) return;

      var baseBadge = document.getElementById('base-business-badge-main');
      if(baseBadge){
        var badgeImg = baseBadge.querySelector('img') || baseBadge;
        badgeImg.style.animation = 'kf-glow-once ' + sceneDur(900) + 'ms ease forwards';
        await sceneWait(900);
        badgeImg.style.animation = '';
      }
      if(cancelled()) return;

      await this._pulseHighlight('#member-visual-main');
      T.after(700);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      await this._pulseHighlight('#autoship-emblem-main');
      await this._pulseHighlight('#sep-badge-main');
      T.after(1400);
      if(cancelled()) return;

      await sceneWait(1400);
      if(cancelled()) return;

      await exitElement('#recommend-bonus-main', { duration: sceneDur(450) });
      if(cancelled()) return;

      await exitElement('#scene05-base-status-plate', { duration: sceneDur(450) });
      if(cancelled()) return;

      await exitElement('#panel-scene-desc', { duration: sceneDur(450) });
      if(cancelled()) return;

      await exitElement('#scene-title-main', { duration: sceneDur(450) });
      T.after(450);

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    hideElement('#scene-title-main');
    hideElement('#panel-scene-desc');
    hideElement('#scene-bullets');
    hideElement('#recommend-bonus-main');
    hideElement('#scene05-bonus-dock');
    hideElement('#scene05-base-status-plate');

    showElement('#member-unit-main');
    showElement('#leader-crown-main');
    showElement('#rank-medal-main');
    showElement('#autoship-emblem-main');
    showElement('#base-business-badge-main');
    showElement('#member-metrics-main');
    showElement('#sep-badge-main');

    for(var n = 1; n <= this._referCount; n++){
      var id = 'ref' + n;
      showElement('#refer-member-' + n);
      showElement('#recommend-star-' + id);
      showElement('#autoship-emblem-' + id);
      showElement('#member-metrics-' + id);
      showElement('#sep-badge-' + id);
    }

    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'BASE사업자 이해하기';
      showElement(chapter);
    }
  }
};
</script>
