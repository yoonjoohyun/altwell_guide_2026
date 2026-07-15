<script>

/* Scene 02 - 비즈니스 성장의 전환점 (see Scene02.md) */

var BaseScene02 = {

  id: 'base-scene-02',

  title: '비즈니스 성장의 전환점',

  duration: 20000,

  mediaStartDelay: 2000,

  _baseAnimMs: 21000,

  _flyBadge: null,



  _mountCanvas: function(canvas){

    canvas.classList.add('scene02-canvas');
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

    connectors.setAttribute('viewBox', '0 0 100 100');

    connectors.setAttribute('preserveAspectRatio', 'none');

    var canvasH = canvas.clientHeight || canvas.offsetHeight || 500;
    var y1Start = 40 - (20 / canvasH) * 100;
    var y1Str = String(y1Start);

    var lineLeft = document.createElementNS(svgNS, 'line');

    lineLeft.setAttribute('id', 'connector-left');

    lineLeft.setAttribute('x1', '50');

    lineLeft.setAttribute('y1', y1Str);

    lineLeft.setAttribute('x2', '22');

    lineLeft.setAttribute('y2', '68');

    connectors.appendChild(lineLeft);



    var lineRight = document.createElementNS(svgNS, 'line');

    lineRight.setAttribute('id', 'connector-right');

    lineRight.setAttribute('x1', '50');

    lineRight.setAttribute('y1', y1Str);

    lineRight.setAttribute('x2', '78');

    lineRight.setAttribute('y2', '68');

    connectors.appendChild(lineRight);



    canvas.appendChild(connectors);



    var main = document.createElement('div');

    main.className = 'member-unit is-hidden';

    main.id = 'member-unit-main';

    main.innerHTML =

      '<div class="member-visual" id="member-visual-main">' +

        '<img class="member-image" id="member-image-main" src="<%=peopleImg%>" alt="일반 캐릭터"/>' +

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

      '</div>';

    canvas.appendChild(main);



    var left = document.createElement('div');

    left.className = 'member-unit member-child is-hidden';

    left.id = 'member-unit-left';

    left.innerHTML =

      '<div class="member-visual" id="member-visual-left">' +

        '<img class="member-image" id="member-image-left" src="<%=memberImg%>" alt="멤버"/>' +

        '<div class="member-emblems" id="member-emblems-left">' +

          '<div class="condition-emblem autoship-emblem is-hidden" id="autoship-emblem-left">' +

            '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +

          '</div>' +

        '</div>' +

      '</div>';

    canvas.appendChild(left);



    var right = document.createElement('div');

    right.className = 'member-unit member-child is-hidden';

    right.id = 'member-unit-right';

    right.innerHTML =

      '<div class="member-visual" id="member-visual-right">' +

        '<img class="member-image" id="member-image-right" src="<%=memberImg%>" alt="멤버"/>' +

        '<div class="member-emblems" id="member-emblems-right">' +

          '<div class="condition-emblem autoship-emblem is-hidden" id="autoship-emblem-right">' +

            '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +

          '</div>' +

        '</div>' +

      '</div>';

    canvas.appendChild(right);

  },



  _replaceMainToMember: function(){

    var img = document.getElementById('member-image-main');

    if(!img) return Promise.resolve();

    var d1 = sceneDur(750);

    var d2 = sceneDur(760);

    return new Promise(function(resolve){

      img.style.transition = 'opacity ' + d1 + 'ms var(--ease-smooth), transform ' + d1 + 'ms var(--ease-smooth)';

      img.style.transform = 'scale(0.95)';

      img.style.opacity = '0';

      setTimeout(function(){

        img.src = '<%=memberImg%>';

        img.alt = 'BASE사업자';

        void img.offsetWidth;

        img.style.transform = 'scale(1)';

        img.style.opacity = '1';

        setTimeout(function(){

          img.style.transition = '';

          img.style.transform = '';

          resolve();

        }, d2);

      }, d1);

    });

  },



  _acquireChildAutoship: async function(emblemId, isCancelled){

    var el = document.getElementById(emblemId);

    if(!el) return;

    if(isCancelled && isCancelled()) return;



    el.classList.remove('is-hidden');

    el.style.left = '50%';

    el.style.transform = 'translateX(-50%)';

    el.style.transition = 'none';



    var img = el.querySelector('img');

    if(img){

      _clearAnim(img);

      img.style.animationDuration = sceneDur(720) + 'ms';

      img.classList.add('motion-soft-acquire');

      await new Promise(function(resolve){

        function onEnd(){

          img.removeEventListener('animationend', onEnd);

          img.classList.remove('motion-soft-acquire');

          img.style.animationDuration = '';

          resolve();

        }

        img.addEventListener('animationend', onEnd);

      });

    }

    if(isCancelled && isCancelled()) return;



    el.style.transition = 'left ' + sceneDur(1000) + 'ms var(--ease-smooth)';

    await sceneWait(40);

    if(isCancelled && isCancelled()) return;

    el.style.left = '30%';

    await sceneWait(1000);

    el.style.transition = '';

  },



  _attachFlyBadge: async function(flyBadge, isCancelled){

    var canvas = document.getElementById('motion-canvas');

    var mainBadge = document.getElementById('base-business-badge-main');

    if(!canvas || !flyBadge || !mainBadge) return;

    if(isCancelled && isCancelled()) return;



    var canvasRect = canvas.getBoundingClientRect();

    var centerX = canvasRect.width / 2;

    var centerY = canvasRect.height / 2;



    mainBadge.classList.remove('is-hidden');

    mainBadge.style.visibility = 'hidden';

    var targetRect = mainBadge.getBoundingClientRect();

    mainBadge.style.visibility = '';

    mainBadge.classList.add('is-hidden');



    var endX = targetRect.left + targetRect.width / 2 - canvasRect.left;

    var endY = targetRect.top + targetRect.height / 2 - canvasRect.top;



    var flyImg = flyBadge.querySelector('img');

    if(flyImg){

      flyImg.classList.remove('motion-soft-acquire');

      flyImg.style.animation = '';

      flyImg.style.animationDuration = '';

    }



    flyBadge.classList.remove('is-hidden');

    flyBadge.style.position = 'absolute';

    flyBadge.style.left = centerX + 'px';

    flyBadge.style.top = centerY + 'px';

    flyBadge.style.margin = '0';

    flyBadge.style.opacity = '1';

    flyBadge.style.transition = 'none';

    flyBadge.style.transform = 'translate(-50%,-50%) scale(1)';

    void flyBadge.offsetWidth;



    var flyRect = flyBadge.getBoundingClientRect();

    var targetScale = targetRect.width / Math.max(flyRect.width, 1);

    var flyDur = sceneDur(1850);



    flyBadge.style.transition = 'left ' + flyDur + 'ms var(--ease-smooth), top ' + flyDur + 'ms var(--ease-smooth), transform ' + flyDur + 'ms var(--ease-smooth)';

    await sceneWait(50);

    if(isCancelled && isCancelled()) return;

    flyBadge.style.left = endX + 'px';

    flyBadge.style.top = endY + 'px';

    flyBadge.style.transform = 'translate(-50%,-50%) scale(' + targetScale + ')';

    await sceneWait(1850);

    if(isCancelled && isCancelled()) return;



    var fadeDur = sceneDur(450);

    flyBadge.style.transition = 'opacity ' + fadeDur + 'ms var(--ease-smooth)';

    flyBadge.style.opacity = '0';

    await sceneWait(450);

    if(flyBadge.parentNode) flyBadge.parentNode.removeChild(flyBadge);

    this._flyBadge = null;



    showElement(mainBadge);

    await softAcquireElement(mainBadge, { duration: sceneDur(500), glow: true });

  },



  _promoteMainHero: async function(isCancelled){

    var main = document.getElementById('member-unit-main');

    if(!main) return;

    var dur = sceneDur(1400);

    main.style.transition = 'left ' + dur + 'ms var(--ease-smooth), top ' + dur + 'ms var(--ease-smooth), transform ' + dur + 'ms var(--ease-smooth)';

    void main.offsetWidth;

    main.classList.add('scene02-main-hero');

    await sceneWait(1400);

    if(isCancelled && isCancelled()) return;

    main.style.transition = '';

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



  _hidePanelBullets: function(){

    var items = document.querySelectorAll('#scene-bullets .bullet-item');

    for(var i=0;i<items.length;i++) items[i].classList.add('is-hidden');

  },



  _revealPanelSlow: async function(isCancelled){

    await sceneWait(400);

    if(isCancelled()) return;



    showElement('#scene-bullets');

    var items = document.querySelectorAll('#scene-bullets .bullet-item');

    for(var i=0;i<items.length;i++){

      if(isCancelled()) return;

      showElement(items[i]);

      await slideUpElement(items[i], { duration: sceneDur(880) });

      if(i < items.length - 1) await sceneWait(520);

    }

  },



  reset: function(){

    var fly = document.getElementById('scene02-base-badge-fly');

    if(fly && fly.parentNode) fly.parentNode.removeChild(fly);

    this._flyBadge = null;

    var canvas = document.getElementById('motion-canvas');

    if(canvas){
      canvas.classList.remove('scene02-canvas');
      canvas.innerHTML = '';
    }

    var title = document.getElementById('scene-title-main');

    var bullets = document.getElementById('scene-bullets');

    var desc = document.getElementById('panel-scene-desc');

    if(title){ title.innerHTML = ''; title.classList.add('is-hidden'); title.style.cssText = ''; }

    if(bullets){ bullets.innerHTML = ''; bullets.classList.add('is-hidden'); }

    if(desc){ desc.textContent = ''; desc.classList.add('is-hidden'); }

  },



  play: async function(ctx){

    var canvas = ctx.canvas;

    if(!canvas) return;



    var cancelled = function(){ return ctx.isCancelled && ctx.isCancelled(); };

    var self = this;

    var T = createSceneTiming(ctx, this._baseAnimMs);

    setActiveSceneTiming(T);



    try {

      setSceneTitle('비즈니스 성장의 전환점');

      setSceneBullets([

        '디슈머 = 똑똑한 소비자',

        '내가 누리는 혜택을 다른 사람과 공유',

        '오토십 이용자 2명 확보',

        'BASE사업자 자격 획득'

      ]);

      hideElement('#scene-title-main');

      hideElement('#scene-bullets');

      hideElement('#panel-scene-desc');

      this._hidePanelBullets();



      if(ctx.sceneIndex > 0){

        await transitionCanvas(canvas, function(c){ self._mountCanvas(c); }, { outDuration: 0, inDuration: sceneDur(550) });

      } else {

        this._mountCanvas(canvas);

      }

      if(cancelled()) return;



      await T.padStart();

      if(cancelled()) return;



      await sceneWait(500);

      if(cancelled()) return;



      await enterMember('member-unit-main', { duration: sceneDur(750) });

      showElement('#scene-title-main');

      await slideUpElement('#scene-title-main', { duration: sceneDur(900) });

      T.after(900);



      await sceneWait(1000);

      if(cancelled()) return;



      await this._replaceMainToMember();

      T.after(1510);



      this._revealPanelSlow(cancelled);



      await sceneWait(300);

      if(cancelled()) return;



      await softAcquireElement('#rank-medal-main', { duration: sceneDur(750), glow: true });

      T.after(750);



      await sceneWait(700);

      if(cancelled()) return;



      await softAcquireElement('#autoship-emblem-main', { duration: sceneDur(750), glow: true });

      T.after(750);



      await sceneWait(2000);

      if(cancelled()) return;



      await Promise.all([

        enterMember('member-unit-left', { duration: sceneDur(700) }),

        this._showConnector('connector-left')

      ]);

      T.after(900);



      await sceneWait(800);

      if(cancelled()) return;



      await Promise.all([

        enterMember('member-unit-right', { duration: sceneDur(700) }),

        this._showConnector('connector-right')

      ]);

      T.after(900);



      await sceneWait(1200);

      if(cancelled()) return;



      await this._acquireChildAutoship('autoship-emblem-left', cancelled);

      T.after(1760);



      await sceneWait(1000);

      if(cancelled()) return;



      await this._acquireChildAutoship('autoship-emblem-right', cancelled);

      T.after(1760);



      await sceneWait(2000);

      if(cancelled()) return;



      var flyBadge = document.createElement('div');

      flyBadge.className = 'qualification-badge base-business scene-canvas-badge is-hidden';

      flyBadge.id = 'scene02-base-badge-fly';

      flyBadge.innerHTML = '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>';

      canvas.appendChild(flyBadge);

      this._flyBadge = flyBadge;



      showElement(flyBadge);

      flyBadge.style.position = 'absolute';

      flyBadge.style.left = '50%';

      flyBadge.style.top = '50%';

      flyBadge.style.margin = '0';

      flyBadge.style.transform = 'translate(-50%,-50%)';

      flyBadge.style.zIndex = '10';



      var flyImg = flyBadge.querySelector('img');

      if(flyImg) await softAcquireElement(flyImg, { duration: sceneDur(1100), glow: true, hero: true });

      else await softAcquireElement(flyBadge, { duration: sceneDur(1100), glow: true, hero: true });

      T.after(1100);



      await sceneWait(300);

      if(cancelled()) return;



      await this._attachFlyBadge(flyBadge, cancelled);

      T.after(2850);

      if(cancelled()) return;



      await this._promoteMainHero(cancelled);

      T.after(1400);

      if(cancelled()) return;



      await sceneWait(1000);

      if(cancelled()) return;



      var leftUnit = document.getElementById('member-unit-left');

      var rightUnit = document.getElementById('member-unit-right');

      if(leftUnit) leftUnit.classList.add('is-dimmed');

      if(rightUnit) rightUnit.classList.add('is-dimmed');



      await sceneWait(1000);

      if(cancelled()) return;



      var lastBullet = document.getElementById('bullet-4');

      if(lastBullet){

        lastBullet.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';

        await sceneWait(700);

        lastBullet.style.animation = '';

      }

      if(cancelled()) return;



      await Promise.all([

        exitElement('#scene-bullets', { duration: sceneDur(350) }),

        exitElement('#scene-title-main', { duration: sceneDur(350) })

      ]);

      T.after(350);



      await sceneWait(150);

      if(cancelled()) return;



      await T.padEnd();

    } finally {

      setActiveSceneTiming(null);

    }

  },



  endState: function(){

    hideElement('#scene-title-main');

    hideElement('#scene-bullets');

    hideElement('#panel-scene-desc');

  }

};

</script>

