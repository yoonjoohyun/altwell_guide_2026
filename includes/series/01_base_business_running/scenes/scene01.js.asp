<script>
/* Scene 01 - BASE badge intro (see Scene01.md) */
var BaseScene01 = {
  id: 'base-scene-01',
  title: "'BASE사업자'란?",
  duration: 16000,
  _baseAnimMs: 12500,
  _badge: null,
  _descEl: null,

  _mountCanvas: function(canvas){
    canvas.innerHTML = '';

    var bg = document.createElement('div');
    bg.className = 'scene01-stage-bg scene-canvas-bg';
    canvas.appendChild(bg);

    var circleIds = ['bg-circle-1', 'bg-circle-2', 'bg-circle-3'];
    for(var i=0;i<circleIds.length;i++){
      var c = document.createElement('div');
      c.className = 'scene-bg-circle scene-canvas-bg';
      c.id = circleIds[i];
      canvas.appendChild(c);
    }

    var dots = document.createElement('div');
    dots.id = 'dot-pattern';
    dots.className = 'scene-canvas-bg';
    canvas.appendChild(dots);

    var badge = document.createElement('div');
    badge.className = 'qualification-badge base-business scene-canvas-badge';
    badge.id = 'scene01-base-badge';
    badge.innerHTML = '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>';
    badge.classList.add('is-hidden');
    canvas.appendChild(badge);
    this._badge = badge;
  },

  reset: function(){
    var canvas = document.getElementById('motion-canvas');
    if(canvas) canvas.innerHTML = '';
    this._badge = null;
    this._descEl = null;

    var title = document.getElementById('scene-title-main');
    var desc = document.getElementById('panel-scene-desc');
    var chapter = document.getElementById('panel-fixed-title');

    if(title){
      title.innerHTML = '';
      title.classList.add('is-hidden');
      title.style.cssText = '';
    }
    if(desc){
      desc.textContent = '';
      desc.classList.add('is-hidden');
      desc.style.cssText = '';
    }
    if(chapter){
      chapter.textContent = '';
      chapter.classList.add('is-hidden');
    }
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    this._mountCanvas(canvas);
    var badge = this._badge;
    var cancelled = function(){ return ctx.isCancelled && ctx.isCancelled(); };
    var T = createSceneTiming(ctx, this._baseAnimMs);
    setActiveSceneTiming(T);

    try {
      await T.padStart();
      if(cancelled()) return;

      await sceneWait(200);
      if(cancelled()) return;

      setSceneTitle("'BASE사업자'란?");
      showElement('#scene-title-main');
      await Promise.all([
        softAcquireElement(badge, { duration: sceneDur(1100), glow: true, hero: true }),
        slideUpElement('#scene-title-main', { duration: sceneDur(600) })
      ]);
      T.after(Math.max(1100, 600));
      if(cancelled()) return;

      await sceneWait(600);
      if(cancelled()) return;

      this._descEl = document.getElementById('panel-scene-desc');
      if(this._descEl){
        this._descEl.textContent = '권리 소득이 시작되는 첫 번째 전환점';
        await enterElement(this._descEl, { duration: sceneDur(550) });
        T.after(550);
      }

      await sceneWait(400);
      if(cancelled()) return;
      if(badge) badge.classList.add('motion-idle-float');

      await sceneWait(6800);
      if(cancelled()) return;

      if(this._descEl){
        this._descEl.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
        await sceneWait(700);
        this._descEl.style.animation = '';
      }

      await sceneWait(2600);
      if(cancelled()) return;

      if(this._descEl) await exitElement(this._descEl, { duration: sceneDur(500) });
      await Promise.all([
        exitElement('#scene-title-main', { duration: sceneDur(500) }),
        badge ? (function(b){
          b.classList.remove('motion-idle-float');
          return exitElement(b, { duration: sceneDur(500) });
        })(badge) : Promise.resolve()
      ]);
      T.after(500);
      if(cancelled()) return;

      await fadeCanvas(canvas, 0, sceneDur(400));
      canvas.innerHTML = '';
      canvas.style.opacity = '';
      this._badge = null;
      T.after(400);

      var chapter = document.getElementById('panel-fixed-title');
      if(chapter){
        chapter.textContent = 'BASE사업자 이해하기';
        showElement(chapter);
      }

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'BASE사업자 이해하기';
      showElement(chapter);
    }
    this._badge = null;
    this._descEl = null;
  }
};
</script>
