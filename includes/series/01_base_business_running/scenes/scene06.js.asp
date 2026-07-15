<script>
/* Scene 06 - 권리 소득 시스템의 출발점 (see Scene06.md) */
var BaseScene06 = {
  id: 'base-scene-06',
  title: '앨트웰 비즈니스의 핵심 구조',
  duration: 33000,
  _baseAnimMs: 28820,
  mediaStartDelay: 2000,

  _baseMemberHtml: function(id){
    return (
      '<div class="member-visual" id="member-visual-' + id + '">' +
        '<img class="member-image" id="member-image-' + id + '" src="<%=memberImg%>" alt="BASE사업자"/>' +
        '<div class="member-emblems" id="member-emblems-' + id + '">' +
          '<div class="member-emblem-group">' +
            '<div class="qualification-badge base-business" id="base-business-badge-' + id + '">' +
              '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>'
    );
  },

  _mountCanvas: function(canvas){
    var self = this;
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

    var svgNS = 'http://www.w3.org/2000/svg';
    var connectors = document.createElementNS(svgNS, 'svg');
    connectors.setAttribute('id', 'lo-connectors');
    connectors.setAttribute('class', 'scene06-connectors');
    connectors.setAttribute('viewBox', '0 0 100 100');
    connectors.setAttribute('preserveAspectRatio', 'none');

    var canvasH = canvas.clientHeight || canvas.offsetHeight || 500;
    var y1Start = 42 - (20 / canvasH) * 100;
    var y1Str = String(y1Start);

    var subs = [
      ['connector-main-b1', 32, 30],
      ['connector-main-b2', 68, 30],
      ['connector-main-b3', 26, 50],
      ['connector-main-b4', 74, 50],
      ['connector-main-b5', 34, 68],
      ['connector-main-b6', 66, 68]
    ];

    subs.forEach(function(spec){
      var line = document.createElementNS(svgNS, 'line');
      line.setAttribute('id', spec[0]);
      line.setAttribute('x1', '50');
      line.setAttribute('y1', y1Str);
      line.setAttribute('x2', String(spec[1]));
      line.setAttribute('y2', String(spec[2]));
      connectors.appendChild(line);
    });
    canvas.appendChild(connectors);

    var main = document.createElement('div');
    main.className = 'member-unit scene06-main is-hidden';
    main.id = 'member-unit-main';
    main.innerHTML =
      '<div class="member-visual" id="member-visual-main">' +
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
      '</div>' +
      '<div class="scene06-system-plate is-hidden" id="scene06-system-plate">권리 소득 시스템 확장</div>';
    canvas.appendChild(main);

    for(var n=1;n<=6;n++){
      var unit = document.createElement('div');
      unit.className = 'member-unit member-child base-member is-hidden';
      unit.id = 'base-member-' + n;
      unit.innerHTML = self._baseMemberHtml('base' + n);
      canvas.appendChild(unit);
    }

    var growthDock = document.createElement('div');
    growthDock.className = 'scene06-growth-dock is-hidden';
    growthDock.id = 'scene06-growth-dock';
    growthDock.innerHTML =
      '<div class="scene06-growth-stack">' +
        '<div class="scene06-growth-plate is-hidden" id="growth-plate-1">① 그룹 볼륨 성장</div>' +
        '<div class="scene06-growth-plate is-hidden" id="growth-plate-2">② 지위 승급 가능성 확대</div>' +
        '<div class="scene06-growth-plate is-hidden" id="growth-plate-3">③ 권리 소득 확대</div>' +
      '</div>';
    canvas.appendChild(growthDock);
  },

  _setupPanel: function(){
    setSceneTitle('앨트웰 비즈니스의 핵심 구조');
    setSceneBullets([
      'BASE사업자 = 권리 소득 시스템의 출발점',
      '그룹 볼륨의 성장',
      '지위와 권리의 확장',
      '함께 성장하며 커지는 시스템'
    ]);
    hideElement('#scene-title-main');
    hideElement('#scene-bullets');
    hideElement('#panel-scene-desc');

    var items = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i=0;i<items.length;i++) items[i].classList.add('is-hidden');
  },

  _clearPanel: function(){
    var title = document.getElementById('scene-title-main');
    var bullets = document.getElementById('scene-bullets');
    var desc = document.getElementById('panel-scene-desc');
    if(title){ title.innerHTML = ''; title.classList.add('is-hidden'); title.style.cssText = ''; }
    if(bullets){ bullets.innerHTML = ''; bullets.classList.add('is-hidden'); }
    if(desc){ desc.textContent = ''; desc.classList.add('is-hidden'); }
  },

  _introMain: async function(isCancelled){
    await enterMember('member-unit-main', { duration: sceneDur(720) });
    if(isCancelled()) return;

    await softAcquireElement('#autoship-emblem-main', { duration: sceneDur(700), glow: true });
    if(isCancelled()) return;

    showElement('#base-business-badge-main');
    await softAcquireElement('#base-business-badge-main', { duration: sceneDur(700), glow: true });
    if(isCancelled()) return;

    await enterElement('#rank-medal-main', { duration: sceneDur(600) });
  },

  _showConnector: function(id){
    var line = document.getElementById(id);
    if(!line) return Promise.resolve();
    return new Promise(function(resolve){
      line.classList.remove('is-visible');
      void line.getBoundingClientRect();
      line.classList.add('is-visible');
      setTimeout(resolve, sceneDur(900));
    });
  },

  _enterBaseMember: async function(num, connectorIds, isCancelled){
    var unitId = 'base-member-' + num;
    await enterMember(unitId, { duration: sceneDur(650) });
    if(isCancelled()) return;

    var badge = document.getElementById('base-business-badge-base' + num);
    if(badge) await softAcquireElement(badge, { duration: sceneDur(550), glow: true });
    if(isCancelled()) return;

    if(connectorIds && connectorIds.length){
      for(var i=0;i<connectorIds.length;i++){
        await this._showConnector(connectorIds[i]);
        if(isCancelled()) return;
      }
    }
  },

  _revealPanelSlow: async function(isCancelled){
    await wait(300);
    if(isCancelled()) return;
    showElement('#scene-bullets');
    var items = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i=0;i<items.length;i++){
      if(isCancelled()) return;
      showElement(items[i]);
      await slideUpElement(items[i], { duration: sceneDur(720) });
      if(i < items.length - 1) await wait(sceneDur(380));
    }
  },

  _pulseHighlight: async function(target){
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return;
    el.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
    await sceneWait(700);
    el.style.animation = '';
  },

  _glowConnectors: function(){
    var lines = document.querySelectorAll('#motion-canvas #lo-connectors line.is-visible');
    for(var i=0;i<lines.length;i++) lines[i].classList.add('is-glow');
  },

  reset: function(){
    this._clearPanel();
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var cancelled = function(){ return ctx.isCancelled && ctx.isCancelled(); };
    var self = this;
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

      if(!ctx.isFollowUp) await sceneWait(250);
      if(cancelled()) return;

      await this._introMain(cancelled);
      T.after(2720);
      if(cancelled()) return;

      showElement('#scene-title-main');
      await slideUpElement('#scene-title-main', { duration: sceneDur(820) });
      T.after(820);
      if(cancelled()) return;

      await this._revealPanelSlow(cancelled);
      T.after(4320);
      if(cancelled()) return;

      await sceneWait(400);
      if(cancelled()) return;

      await Promise.all([
        this._enterBaseMember(1, ['connector-main-b1'], cancelled),
        this._enterBaseMember(2, ['connector-main-b2'], cancelled)
      ]);
      T.after(2100);
      if(cancelled()) return;

      showElement('#scene06-system-plate');
      await slideUpElement('#scene06-system-plate', { duration: sceneDur(760) });
      T.after(760);
      if(cancelled()) return;

      await sceneWait(400);
      if(cancelled()) return;

      await Promise.all([
        this._enterBaseMember(3, ['connector-main-b3'], cancelled),
        this._enterBaseMember(4, ['connector-main-b4'], cancelled)
      ]);
      T.after(2100);
      if(cancelled()) return;

      await sceneWait(350);
      if(cancelled()) return;

      await Promise.all([
        this._enterBaseMember(5, ['connector-main-b5'], cancelled),
        this._enterBaseMember(6, ['connector-main-b6'], cancelled)
      ]);
      T.after(2100);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      showElement('#scene06-growth-dock');
      var growthIds = ['#growth-plate-1', '#growth-plate-2', '#growth-plate-3'];
      for(var g=0;g<growthIds.length;g++){
        if(cancelled()) return;
        showElement(growthIds[g]);
        await slideUpElement(growthIds[g], { duration: sceneDur(720) });
        await this._pulseHighlight(growthIds[g]);
        if(g < growthIds.length - 1) await sceneWait(420);
      }
      T.after(2160);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      var orgUnits = document.querySelectorAll('#motion-canvas .member-unit');
      for(var u=0;u<orgUnits.length;u++){
        orgUnits[u].style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
      }
      await sceneWait(700);
      for(var u2=0;u2<orgUnits.length;u2++) orgUnits[u2].style.animation = '';
      if(cancelled()) return;

      this._glowConnectors();
      await this._pulseHighlight('#scene06-system-plate');
      await this._pulseHighlight('#growth-plate-1');
      await this._pulseHighlight('#growth-plate-2');
      await this._pulseHighlight('#growth-plate-3');
      if(cancelled()) return;

      await sceneWait(800);
      if(cancelled()) return;

      await exitElement('#growth-plate-3', { duration: sceneDur(400) });
      await exitElement('#growth-plate-2', { duration: sceneDur(400) });
      await exitElement('#growth-plate-1', { duration: sceneDur(400) });
      hideElement('#scene06-growth-dock');
      if(cancelled()) return;

      await exitElement('#scene06-system-plate', { duration: sceneDur(400) });
      if(cancelled()) return;

      await exitElement('#scene-bullets', { duration: sceneDur(400) });
      if(cancelled()) return;

      await exitElement('#scene-title-main', { duration: sceneDur(400) });
      T.after(2400);
      if(cancelled()) return;

      await fadeCanvas(canvas, 0, sceneDur(450));
      canvas.innerHTML = '';
      canvas.style.opacity = '';
      T.after(450);

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    hideElement('#scene-title-main');
    hideElement('#scene-bullets');
    hideElement('#panel-scene-desc');
    hideElement('#scene06-system-plate');
    hideElement('#scene06-growth-dock');
    hideElement('#growth-plate-1');
    hideElement('#growth-plate-2');
    hideElement('#growth-plate-3');

    var canvas = document.getElementById('motion-canvas');
    if(canvas){
      canvas.innerHTML = '';
      canvas.style.opacity = '';
    }

    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'BASE사업자 이해하기';
      showElement(chapter);
    }
  }
};
</script>
