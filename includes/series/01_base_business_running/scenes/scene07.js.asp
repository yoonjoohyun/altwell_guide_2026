<script>

/* Scene 07 - 핵심 요약 (see Scene07.md) */

var BaseScene07 = {

  id: 'base-scene-07',

  title: '핵심 요약',

  duration: 22000,

  _baseAnimMs: 17200,



  _mountCanvas: function(canvas){

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

    main.className = 'member-unit scene07-main is-hidden';

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

        '<div class="member-metrics is-hidden" id="member-metrics-main">' +

          '<div class="metric-badge sep-badge is-hidden" id="sep-badge-main" data-status="complete">' +

            '<span class="sep-badge-text">S.E.P<br>30만↑</span>' +

          '</div>' +

        '</div>' +

      '</div>' +

      '<div class="scene07-status-plate is-hidden" id="scene07-status-plate">권리 소득 시스템의 시작</div>';

    canvas.appendChild(main);



    var stack = document.createElement('div');

    stack.className = 'scene07-summary-stack is-hidden';

    stack.id = 'scene07-summary-stack';

    stack.innerHTML =

      '<div class="scene07-summary-card is-hidden" id="summary-card-1">① 직급이 아닌 권리 자격</div>' +

      '<div class="scene07-summary-card is-hidden" id="summary-card-2">② 본인 + 하위 2명 조건 유지</div>' +

      '<div class="scene07-summary-card is-hidden" id="summary-card-3">③ 추천 보너스의 시작</div>';

    canvas.appendChild(stack);

  },



  _setupPanel: function(){

    setSceneTitle('핵심 요약');

    setSceneBullets([

      '권리 소득이 시작되는 첫 번째 자격',

      '앨트웰 비즈니스의 우선 목표',

      '함께 성장하는 시스템의 시작점'

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

    await enterMember('member-unit-main', { duration: sceneDur(700) });

    if(isCancelled()) return;



    await softAcquireElement('#autoship-emblem-main', { duration: sceneDur(680), glow: true });

    if(isCancelled()) return;



    showElement('#base-business-badge-main');

    await softAcquireElement('#base-business-badge-main', { duration: sceneDur(680), glow: true });

    if(isCancelled()) return;



    await enterElement('#rank-medal-main', { duration: sceneDur(580) });

    if(isCancelled()) return;



    showElement('#member-metrics-main');

    showElement('#sep-badge-main');

    await slideUpElement('#sep-badge-main', { duration: sceneDur(650) });

  },



  _revealSummaryCard: async function(id, isCancelled){

    if(isCancelled()) return;

    showElement('#scene07-summary-stack');

    showElement(id);

    await enterElement(id, { duration: sceneDur(580) });

    if(isCancelled()) return;

    await slideUpElement(id, { duration: sceneDur(680) });

    if(isCancelled()) return;

    await this._pulseHighlight(id);

  },



  _revealPanelSlow: async function(isCancelled){

    await sceneWait(280);

    if(isCancelled()) return;

    showElement('#scene-bullets');

    var items = document.querySelectorAll('#scene-bullets .bullet-item');

    for(var i=0;i<items.length;i++){

      if(isCancelled()) return;

      showElement(items[i]);

      await slideUpElement(items[i], { duration: sceneDur(700) });

      if(i < items.length - 1) await sceneWait(340);

    }

  },



  _pulseHighlight: async function(target){

    var el = typeof target === 'string' ? document.querySelector(target) : target;

    if(!el) return;

    el.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';

    await sceneWait(700);

    el.style.animation = '';

  },



  _softGlow: async function(target){

    var el = typeof target === 'string' ? document.querySelector(target) : target;

    if(!el) return;

    var glowEl = el.querySelector('img') || el;

    glowEl.style.animation = 'kf-glow-once ' + sceneDur(800) + 'ms ease forwards';

    await sceneWait(800);

    glowEl.style.animation = '';

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

      T.after(3290);

      if(cancelled()) return;



      showElement('#scene-title-main');

      await slideUpElement('#scene-title-main', { duration: sceneDur(820) });

      T.after(820);

      if(cancelled()) return;



      showElement('#scene07-status-plate');

      await slideUpElement('#scene07-status-plate', { duration: sceneDur(720) });

      T.after(720);

      if(cancelled()) return;



      await sceneWait(350);

      if(cancelled()) return;



      await this._revealSummaryCard('#summary-card-1', cancelled);

      T.after(1960);

      if(cancelled()) return;



      await sceneWait(280);

      if(cancelled()) return;



      await this._revealSummaryCard('#summary-card-2', cancelled);

      T.after(1960);

      if(cancelled()) return;



      await sceneWait(280);

      if(cancelled()) return;



      await this._revealSummaryCard('#summary-card-3', cancelled);

      T.after(1960);

      if(cancelled()) return;



      this._revealPanelSlow(cancelled);

      if(cancelled()) return;



      await sceneWait(500);

      if(cancelled()) return;



      await this._softGlow('#member-visual-main');

      T.after(800);

      if(cancelled()) return;



      await this._softGlow('#base-business-badge-main');

      T.after(800);

      if(cancelled()) return;



      await this._softGlow('#scene07-status-plate');

      T.after(800);

      if(cancelled()) return;



      await this._softGlow('#summary-card-1');

      await this._softGlow('#summary-card-2');

      await this._softGlow('#summary-card-3');

      T.after(2400);



      await T.padEnd();

    } finally {

      setActiveSceneTiming(null);

    }

  },



  endState: function(){

    showElement('#scene-title-main');

    showElement('#scene-bullets');

    showElement('#member-unit-main');

    showElement('#autoship-emblem-main');

    showElement('#base-business-badge-main');

    showElement('#rank-medal-main');

    showElement('#member-metrics-main');

    showElement('#sep-badge-main');

    showElement('#scene07-status-plate');

    showElement('#scene07-summary-stack');

    showElement('#summary-card-1');

    showElement('#summary-card-2');

    showElement('#summary-card-3');



    var items = document.querySelectorAll('#scene-bullets .bullet-item');

    for(var i=0;i<items.length;i++) showElement(items[i]);



    var chapter = document.getElementById('panel-fixed-title');

    if(chapter){

      chapter.textContent = 'BASE사업자 이해하기';

      showElement(chapter);

    }

  }

};

</script>

