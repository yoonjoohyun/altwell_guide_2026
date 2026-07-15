<script>
/* Scene 04 - BASE사업자가 되는 조건 (see Scene04.md) */
var BaseScene04 = {
  id: 'base-scene-04',
  title: 'BASE사업자가 되는 법',
  duration: 25000,
  _baseAnimMs: 30400,

  _memberBlock: function(id, imgSrc, imgAlt, includeBaseBadge){
    var baseBadgeHtml = includeBaseBadge ? (
      '<div class="qualification-badge base-business is-hidden" id="base-business-badge-main">' +
        '<img src="<%=basebizImg%>" alt="BASE사업자 자격"/>' +
      '</div>'
    ) : '';
    return (
      '<div class="member-visual" id="member-visual-' + id + '">' +
        '<img class="member-image" id="member-image-' + id + '" src="' + imgSrc + '" alt="' + imgAlt + '"/>' +
        '<div class="member-emblems" id="member-emblems-' + id + '">' +
          '<div class="member-emblem-group">' +
            '<div class="condition-emblem autoship-emblem is-hidden" id="autoship-emblem-' + id + '">' +
              '<img src="<%=autoshipImg%>" alt="오토십 이용"/>' +
            '</div>' +
            baseBadgeHtml +
            '<div class="rank-medal is-hidden" id="rank-medal-' + id + '">' +
              '<img src="<%=lev01Img%>" alt="D 지위"/>' +
            '</div>' +
          '</div>' +
        '</div>' +
        '<div class="member-metrics is-hidden" id="member-metrics-' + id + '">' +
          '<div class="metric-badge sep-badge is-hidden" id="sep-badge-' + id + '" data-status="incomplete">' +
            '<span class="sep-badge-text">S.E.P<br>30만↑</span>' +
          '</div>' +
        '</div>' +
      '</div>'
    );
  },

  _mountCanvas: function(canvas){
    canvas.classList.add('scene04-canvas');
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
    main.className = 'member-unit is-hidden';
    main.id = 'member-unit-main';
    main.innerHTML = this._memberBlock('main', '<%=memberImg%>', '본인', true);
    canvas.appendChild(main);

    var left = document.createElement('div');
    left.className = 'member-unit member-child is-hidden';
    left.id = 'member-unit-left';
    left.innerHTML = this._memberBlock('left', '<%=peopleImg%>', '일반 캐릭터', false);
    canvas.appendChild(left);

    var right = document.createElement('div');
    right.className = 'member-unit member-child is-hidden';
    right.id = 'member-unit-right';
    right.innerHTML = this._memberBlock('right', '<%=peopleImg%>', '일반 캐릭터', false);
    canvas.appendChild(right);
  },

  _setupPanel: function(){
    setSceneTitle('BASE사업자가 되는 법');

    var desc = document.getElementById('panel-scene-desc');
    if(desc){
      desc.innerHTML =
        '<div id="scene04-panel-body">' +
          '<div class="scene04-panel-block is-hidden" id="panel-block-self">' +
            '<p class="scene04-panel-heading">본인</p>' +
            '<ul class="scene04-panel-list">' +
              '<li class="scene04-panel-item is-hidden" id="panel-self-1">오토십 이용</li>' +
              '<li class="scene04-panel-item is-hidden" id="panel-self-2">SEP 30만 이상</li>' +
            '</ul>' +
          '</div>' +
          '<div class="scene04-panel-block is-hidden" id="panel-block-children">' +
            '<p class="scene04-panel-heading">하위 디슈머 2명</p>' +
            '<ul class="scene04-panel-list">' +
              '<li class="scene04-panel-item is-hidden" id="panel-child-1">각자 오토십 이용</li>' +
              '<li class="scene04-panel-item is-hidden" id="panel-child-2">각자 SEP 30만 이상</li>' +
            '</ul>' +
          '</div>' +
        '</div>';
    }

    var panel = document.getElementById('lo-panel');
    var existing = document.getElementById('panel-highlight-message');
    if(existing && existing.parentNode) existing.parentNode.removeChild(existing);
    if(panel){
      var highlight = document.createElement('p');
      highlight.id = 'panel-highlight-message';
      highlight.className = 'scene04-highlight-message is-hidden';
      highlight.textContent = '본인을 포함한 세 사람 모두 조건 유지';
      panel.appendChild(highlight);
    }

    hideElement('#scene-title-main');
    hideElement('#panel-scene-desc');
    hideElement('#scene-bullets');
    hideElement('#panel-highlight-message');
  },

  _clearPanel: function(){
    var desc = document.getElementById('panel-scene-desc');
    if(desc){ desc.innerHTML = ''; desc.classList.add('is-hidden'); desc.style.cssText = ''; }
    var highlight = document.getElementById('panel-highlight-message');
    if(highlight && highlight.parentNode) highlight.parentNode.removeChild(highlight);
    var title = document.getElementById('scene-title-main');
    var bullets = document.getElementById('scene-bullets');
    if(title){ title.innerHTML = ''; title.classList.add('is-hidden'); title.style.cssText = ''; }
    if(bullets){ bullets.innerHTML = ''; bullets.classList.add('is-hidden'); }
  },

  _replaceToMember: function(imgId){
    var img = document.getElementById(imgId);
    if(!img) return Promise.resolve();
    var d1 = sceneDur(750);
    var d2 = sceneDur(760);
    return new Promise(function(resolve){
      img.style.transition = 'opacity ' + d1 + 'ms var(--ease-smooth), transform ' + d1 + 'ms var(--ease-smooth)';
      img.style.transform = 'scale(0.95)';
      img.style.opacity = '0';
      setTimeout(function(){
        img.src = '<%=memberImg%>';
        img.alt = '멤버';
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

  _revealPanelItems: async function(selectors, isCancelled){
    for(var i=0;i<selectors.length;i++){
      if(isCancelled()) return;
      var el = document.querySelector(selectors[i]);
      if(!el) continue;
      showElement(el);
      await slideUpElement(el, { duration: sceneDur(720) });
      if(i < selectors.length - 1) await sceneWait(380);
    }
  },

  _pulseHighlight: async function(target){
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return;
    el.style.animation = 'kf-highlight-pulse ' + sceneDur(700) + 'ms ease forwards';
    await sceneWait(700);
    el.style.animation = '';
  },

  _completeMember: async function(visualId, autoshipSel, sepSel, isCancelled){
    if(isCancelled()) return;
    await this._pulseHighlight(autoshipSel);
    if(isCancelled()) return;
    await this._pulseHighlight(sepSel);
    if(isCancelled()) return;
    await completeCondition(visualId);
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

    el.style.transition = 'left ' + sceneDur(900) + 'ms var(--ease-smooth)';
    await sceneWait(40);
    if(isCancelled && isCancelled()) return;
    el.style.left = '44%';
    await sceneWait(900);
    el.style.transition = '';
  },

  _setupChildMember: async function(side, isCancelled){
    var unitId = 'member-unit-' + side;
    var imgId = 'member-image-' + side;

    await enterMember(unitId, { duration: sceneDur(700) });
    if(isCancelled()) return;

    await sceneWait(500);
    if(isCancelled()) return;

    await this._replaceToMember(imgId);
    if(isCancelled()) return;

    await sceneWait(400);
    if(isCancelled()) return;

    await enterElement('#rank-medal-' + side, { duration: sceneDur(650) });
    if(isCancelled()) return;

    await this._acquireChildAutoship('autoship-emblem-' + side, isCancelled);
    if(isCancelled()) return;

    showElement('#member-metrics-' + side);
    showElement('#sep-badge-' + side);
    await slideUpElement('#sep-badge-' + side, { duration: sceneDur(720) });
  },

  _fadeOutStatusChecks: async function(){
    var checks = document.querySelectorAll('#motion-canvas .status-check');
    var promises = [];
    var fadeDur = sceneDur(350);
    var settle = sceneDur(360);
    for(var i=0;i<checks.length;i++){
      (function(check){
        promises.push(new Promise(function(resolve){
          check.style.transition = 'opacity ' + fadeDur + 'ms var(--ease-standard), transform ' + fadeDur + 'ms var(--ease-standard)';
          check.style.opacity = '0';
          check.style.transform = 'scale(0.8)';
          setTimeout(function(){
            check.classList.remove('is-visible');
            check.style.transition = '';
            check.style.opacity = '';
            check.style.transform = '';
            if(check.parentNode) check.parentNode.removeChild(check);
            resolve();
          }, settle);
        }));
      })(checks[i]);
    }
    await Promise.all(promises);
  },

  reset: function(){
    var canvas = document.getElementById('motion-canvas');
    if(canvas) canvas.classList.remove('scene04-canvas');
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

      if(!ctx.isFollowUp){
        await sceneWait(350);
        if(cancelled()) return;
      }

      showElement('#scene-title-main');
      await slideUpElement('#scene-title-main', { duration: sceneDur(900) });
      T.after(900);
      if(cancelled()) return;

      await enterMember('member-unit-main', { duration: sceneDur(750) });
      T.after(750);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      await enterElement('#rank-medal-main', { duration: sceneDur(650) });
      T.after(650);
      if(cancelled()) return;

      await softAcquireElement('#autoship-emblem-main', { duration: sceneDur(750), glow: true });
      T.after(750);
      if(cancelled()) return;

      showElement('#member-metrics-main');
      showElement('#sep-badge-main');
      await slideUpElement('#sep-badge-main', { duration: sceneDur(720) });
      T.after(720);
      if(cancelled()) return;

      showElement('#panel-scene-desc');
      showElement('#panel-block-self');
      await this._revealPanelItems(['#panel-self-1', '#panel-self-2'], cancelled);
      if(cancelled()) return;

      await sceneWait(600);
      if(cancelled()) return;

      await this._setupChildMember('left', cancelled);
      if(cancelled()) return;

      showElement('#panel-block-children');
      await this._revealPanelItems(['#panel-child-1'], cancelled);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      await this._setupChildMember('right', cancelled);
      if(cancelled()) return;

      await this._revealPanelItems(['#panel-child-2'], cancelled);
      if(cancelled()) return;

      await sceneWait(800);
      if(cancelled()) return;

      await this._completeMember('#member-visual-main', '#autoship-emblem-main', '#sep-badge-main', cancelled);
      T.after(1400);
      if(cancelled()) return;

      await sceneWait(350);
      if(cancelled()) return;

      await this._completeMember('#member-visual-left', '#autoship-emblem-left', '#sep-badge-left', cancelled);
      T.after(1400);
      if(cancelled()) return;

      await sceneWait(350);
      if(cancelled()) return;

      await this._completeMember('#member-visual-right', '#autoship-emblem-right', '#sep-badge-right', cancelled);
      T.after(1400);
      if(cancelled()) return;

      await sceneWait(500);
      if(cancelled()) return;

      showElement('#base-business-badge-main');
      await softAcquireElement('#base-business-badge-main', { duration: sceneDur(900), glow: true });
      T.after(900);
      if(cancelled()) return;

      await sceneWait(800);
      if(cancelled()) return;

      showElement('#panel-highlight-message');
      await slideUpElement('#panel-highlight-message', { duration: sceneDur(880) });
      T.after(880);
      if(cancelled()) return;

      await this._pulseHighlight('#panel-highlight-message');
      T.after(700);
      if(cancelled()) return;

      await sceneWait(600);
      if(cancelled()) return;

      await this._pulseHighlight('#autoship-emblem-main');
      await this._pulseHighlight('#sep-badge-main');
      await this._pulseHighlight('#autoship-emblem-left');
      await this._pulseHighlight('#sep-badge-left');
      await this._pulseHighlight('#autoship-emblem-right');
      await this._pulseHighlight('#sep-badge-right');
      T.after(4200);
      if(cancelled()) return;

      await sceneWait(1200);
      if(cancelled()) return;

      await exitElement('#panel-highlight-message', { duration: sceneDur(450) });
      if(cancelled()) return;

      await exitElement('#panel-scene-desc', { duration: sceneDur(450) });
      if(cancelled()) return;

      await exitElement('#scene-title-main', { duration: sceneDur(450) });
      T.after(450);
      if(cancelled()) return;

      await this._fadeOutStatusChecks();
      T.after(360);
      if(cancelled()) return;

      var badges = document.querySelectorAll('#motion-canvas .metric-badge[data-status="complete"]');
      for(var b=0;b<badges.length;b++){
        badges[b].setAttribute('data-status', 'incomplete');
        badges[b].style.animation = '';
      }

      await T.padEnd();
    } finally {
      setActiveSceneTiming(null);
    }
  },

  endState: function(){
    hideElement('#scene-title-main');
    hideElement('#panel-scene-desc');
    hideElement('#scene-bullets');
    hideElement('#panel-highlight-message');

    showElement('#member-unit-main');
    showElement('#member-unit-left');
    showElement('#member-unit-right');
    showElement('#rank-medal-main');
    showElement('#rank-medal-left');
    showElement('#rank-medal-right');
    showElement('#autoship-emblem-main');
    showElement('#autoship-emblem-left');
    showElement('#autoship-emblem-right');
    ['left', 'right'].forEach(function(side){
      var emblem = document.getElementById('autoship-emblem-' + side);
      if(emblem){
        emblem.style.left = '44%';
        emblem.style.transform = 'translateX(-50%)';
      }
    });
    showElement('#base-business-badge-main');
    showElement('#member-metrics-main');
    showElement('#member-metrics-left');
    showElement('#member-metrics-right');
    showElement('#sep-badge-main');
    showElement('#sep-badge-left');
    showElement('#sep-badge-right');

    var chapter = document.getElementById('panel-fixed-title');
    if(chapter){
      chapter.textContent = 'BASE사업자 이해하기';
      showElement(chapter);
    }
  }
};
</script>
