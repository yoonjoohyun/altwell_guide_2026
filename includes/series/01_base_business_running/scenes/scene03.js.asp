<script>
/* Scene 03 - BASE사업자의 의미 (see Scene03.md) */
var BaseScene03 = {
  id: 'base-scene-03',
  title: 'BASE사업자의 의미',
  duration: 15000,
  _baseAnimMs: 14700,
  _badge: null,

  _mountCanvas: function(canvas){
    canvas.classList.add('scene03-canvas');
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

    var badge = document.createElement('div');
    badge.className = 'qualification-badge base-business scene-canvas-badge is-hidden';
    badge.id = 'scene03-base-badge';
    badge.innerHTML = '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>';
    canvas.appendChild(badge);
    this._badge = badge;

    var equalsLabel = document.createElement('div');
    equalsLabel.id = 'scene03-equals-label';
    equalsLabel.className = 'scene-canvas-html-label is-hidden';
    equalsLabel.innerHTML =
      '<span class="equals-sign">=</span>' +
      '<span class="label-text">권리 소득 자격</span>';
    canvas.appendChild(equalsLabel);

    var consumerTrans = document.createElement('div');
    consumerTrans.id = 'scene03-consumer-transition';
    consumerTrans.className = 'scene-canvas-html-label is-hidden';
    consumerTrans.innerHTML =
      '<span class="label-consumer">소비자</span>' +
      '<span class="label-arrow" aria-hidden="true">→</span>' +
      '<span class="label-business">사업자</span>';
    canvas.appendChild(consumerTrans);
  },

  _hidePanelBullets: function(){
    var items = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i=0;i<items.length;i++) items[i].classList.add('is-hidden');
  },

  _revealPanelSlow: async function(isCancelled){
    await wait(300);
    if(isCancelled()) return;

    showElement('#scene-bullets');
    var items = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i=0;i<items.length;i++){
      if(isCancelled()) return;
      showElement(items[i]);
      await slideUpElement(items[i], { duration: sceneDur(880) });
      if(i < items.length - 1) await wait(sceneDur(420));
    }
  },

  _pulseHighlight: async function(target){
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return;
    el.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
    await sceneWait(700);
    el.style.animation = '';
  },

  _enterScene03Badge: async function(badge, isCancelled){
    var canvas = document.getElementById('motion-canvas');
    if(!canvas || !badge) return;
    if(isCancelled()) return;

    showElement(badge);
    badge.style.position = 'absolute';
    badge.style.left = '50%';
    badge.style.top = '46%';
    badge.style.transform = 'translate(-50%,-50%)';
    badge.style.margin = '0';
    badge.style.zIndex = '11';

    var img = badge.querySelector('img');
    if(img) await softAcquireElement(img, { duration: sceneDur(1100), glow: true, hero: true });
    else await softAcquireElement(badge, { duration: sceneDur(1100), glow: true, hero: true });
    if(isCancelled()) return;

    var settleDur = sceneDur(950);
    badge.style.transition = 'left ' + settleDur + 'ms var(--ease-smooth), top ' + settleDur + 'ms var(--ease-smooth), transform ' + settleDur + 'ms var(--ease-smooth)';
    void badge.offsetWidth;
    badge.style.left = '43%';
    badge.style.top = '43%';
    badge.style.transform = 'translate(-50%,-50%)';
    await sceneWait(950);
    if(isCancelled()) return;

    badge.style.transition = '';
    badge.style.left = '';
    badge.style.top = '';
    badge.style.transform = '';
    badge.classList.add('scene03-badge-settled');
    if(img) img.classList.add('motion-scene03-badge-float');
  },

  _enterScene03Label: async function(selector, animClass, duration){
    var el = document.querySelector(selector);
    if(!el) return;
    showElement(el);
    el.style.animationDuration = sceneDur(duration) + 'ms';
    el.classList.add(animClass);
    await new Promise(function(resolve){
      function onEnd(){
        el.removeEventListener('animationend', onEnd);
        el.classList.remove(animClass);
        el.style.animationDuration = '';
        resolve();
      }
      el.addEventListener('animationend', onEnd);
    });
  },

  reset: function(){
    this._badge = null;

    var canvas = document.getElementById('motion-canvas');
    if(canvas) canvas.classList.remove('scene03-canvas');

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
    var badge = null;
    var T = createSceneTiming(ctx, this._baseAnimMs);
    setActiveSceneTiming(T);

    try {
      var chapter = document.getElementById('panel-fixed-title');
      if(chapter){
        chapter.textContent = 'BASE사업자 이해하기';
        showElement(chapter);
      }

      setSceneTitle('BASE사업자의 의미');
      setSceneBullets([
        '하나의 지위가 아닌 권리 자격',
        '권리 소득이 시작되는 첫 번째 전환점'
      ]);
      hideElement('#scene-title-main');
      hideElement('#scene-bullets');
      hideElement('#panel-scene-desc');
      this._hidePanelBullets();

      if(ctx.sceneIndex > 0){
        await transitionCanvas(canvas, function(c){ self._mountCanvas(c); }, { outDuration: sceneDur(320), inDuration: sceneDur(320) });
      } else {
        this._mountCanvas(canvas);
      }
      badge = this._badge;
      if(cancelled()) return;

      await T.padStart();
      if(cancelled()) return;

      if(!ctx.isFollowUp){
        await sceneWait(400);
        if(cancelled()) return;
      }

      await this._enterScene03Badge(badge, cancelled);
      T.after(2050);
      if(cancelled()) return;

      await sceneWait(350);
      if(cancelled()) return;

      showElement('#scene-title-main');
      await slideUpElement('#scene-title-main', { duration: sceneDur(900) });
      T.after(900);
      if(cancelled()) return;

      await sceneWait(320);
      if(cancelled()) return;

      await this._enterScene03Label('#scene03-equals-label', 'motion-scene03-equals-enter', 880);
      T.after(880);
      if(cancelled()) return;

      await sceneWait(260);
      if(cancelled()) return;

      await this._enterScene03Label('#scene03-consumer-transition', 'motion-scene03-consumer-enter', 800);
      T.after(800);
      if(cancelled()) return;

      await sceneWait(300);
      if(cancelled()) return;

      await this._revealPanelSlow(cancelled);
      T.after(2480);
      if(cancelled()) return;

      await sceneWait(450);
      if(cancelled()) return;

      await this._pulseHighlight('#scene03-equals-label .label-text');
      if(cancelled()) return;

      await sceneWait(280);
      if(cancelled()) return;

      await this._pulseHighlight('#scene03-consumer-transition .label-business');
      if(cancelled()) return;

      await sceneWait(280);
      if(cancelled()) return;

      var bullet2 = document.getElementById('bullet-2');
      if(bullet2) await this._pulseHighlight(bullet2);
      if(cancelled()) return;

      await sceneWait(700);
      if(cancelled()) return;

      await exitElement('#scene-bullets', { duration: sceneDur(500) });
      if(cancelled()) return;

      await exitElement('#scene-title-main', { duration: sceneDur(500) });
      if(cancelled()) return;

      await Promise.all([
        exitElement('#scene03-equals-label', { duration: sceneDur(500) }),
        exitElement('#scene03-consumer-transition', { duration: sceneDur(500) })
      ]);
      if(cancelled()) return;

      if(badge){
        var badgeImg = badge.querySelector('img');
        if(badgeImg) badgeImg.classList.remove('motion-scene03-badge-float');
        badge.classList.remove('scene03-badge-settled');
        await exitElement(badge, { duration: sceneDur(500) });
      }
      T.after(2000);
      if(cancelled()) return;

      await fadeCanvas(canvas, 0, sceneDur(400));
      canvas.innerHTML = '';
      canvas.style.opacity = '';
      this._badge = null;
      T.after(400);

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    hideElement('#scene-title-main');
    hideElement('#scene-bullets');
    hideElement('#panel-scene-desc');

    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'BASE사업자 이해하기';
      showElement(chapter);
    }

    this._badge = null;
  }
};
</script>
