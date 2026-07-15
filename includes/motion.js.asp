<script>
/* ??????????????????????????????????????????????????????
   ALTWELL OBJECT & MOTION LIBRARY  ? JavaScript API §8
???????????????????????????????????????????????????????? */

/* ── Rank image map ── */
var RANK_IMGS = {
  D:  '<%=lev01Img%>',
  P:  '<%=lev02Img%>',
  JP: '<%=lev03Img%>',
  SP: '<%=lev04Img%>',
  FC: '<%=lev05Img%>'
};

/* ── Utility ── */
function wait(ms){ return new Promise(function(r){setTimeout(r,ms);}); }

/* Scene timeline: voice duration with ~1s lead + ~1s trail padding */
var SCENE_PAD_MS = 1000;

function createSceneTiming(ctx, baseAnimMs){
  baseAnimMs = baseAnimMs || 12000;
  var total = baseAnimMs + SCENE_PAD_MS * 2;
  if(ctx){
    if(ctx.sceneDuration && ctx.sceneDuration > 0){
      total = ctx.sceneDuration;
    } else if(typeof ctx.sceneIndex === 'number' && ctx.sceneIndex >= 0 && typeof SceneRunner !== 'undefined'){
      var list = SceneRunner.getScenes();
      if(list[ctx.sceneIndex] && list[ctx.sceneIndex].duration > 0){
        total = list[ctx.sceneIndex].duration;
      }
    }
  }
  var lead = SCENE_PAD_MS;
  var trail = SCENE_PAD_MS;
  var anim = Math.max(600, total - lead - trail);
  var scale = anim / baseAnimMs;
  var elapsed = 0;

  function report(){
    if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
  }

  return {
    total: total,
    anim: anim,
    scale: scale,
    dur: function(ms){ return Math.max(80, Math.round(ms * scale)); },
    w: async function(ms){
      var s = Math.max(0, Math.round(ms * scale));
      if(s > 0){
        await wait(s);
        elapsed += s;
      }
      report();
    },
    after: function(ms){
      elapsed += Math.max(0, Math.round(ms * scale));
      report();
    },
    padStart: async function(){
      if(lead > 0){
        await wait(lead);
        elapsed = lead;
      }
      report();
    },
    padEnd: async function(){
      var remain = total - elapsed;
      if(remain > 0){
        await wait(remain);
        elapsed = total;
      }
      report();
    }
  };
}

var _activeSceneTiming = null;

function setActiveSceneTiming(timing){
  _activeSceneTiming = timing || null;
}

function sceneWait(ms){
  if(_activeSceneTiming) return _activeSceneTiming.w(ms);
  return wait(ms);
}

function sceneDur(ms){
  if(_activeSceneTiming) return _activeSceneTiming.dur(ms);
  return ms;
}

function _el(target){
  if(typeof target === 'string') return document.querySelector(target);
  return target;
}
function _els(target){
  if(typeof target === 'string') return Array.from(document.querySelectorAll(target));
  if(NodeList && target instanceof NodeList) return Array.from(target);
  if(Array.isArray(target)) return target;
  return [target];
}
function _clearAnim(el){
  el.style.animation = 'none';
  void el.offsetWidth; // reflow
  el.style.animation = '';
}

/* ── §8 Object State ── */
function showElement(target){
  var el = _el(target);
  if(!el) return;
  el.classList.remove('is-hidden');
}
function hideElement(target){
  var el = _el(target);
  if(!el) return;
  el.classList.add('is-hidden');
}
function activateElement(target){
  var el = _el(target);
  if(!el) return;
  el.classList.remove('is-inactive');
  el.classList.add('is-active');
}
function deactivateElement(target){
  var el = _el(target);
  if(!el) return;
  el.classList.remove('is-active');
  el.classList.add('is-inactive');
}

/* ── §5-1 Enter / §6 Exit ── */
function enterElement(target, options){
  options = options || {};
  var el = _el(target);
  if(!el) return Promise.resolve();
  var dur = options.duration || 600;
  var delay = options.delay || 0;
  return new Promise(function(resolve){
    el.classList.remove('is-hidden');
    _clearAnim(el);
    el.style.animationDuration = dur + 'ms';
    el.style.animationDelay = delay + 'ms';
    el.classList.add('is-entering');
    function onEnd(){
      el.removeEventListener('animationend', onEnd);
      el.classList.remove('is-entering');
      el.style.animationDuration = '';
      el.style.animationDelay = '';
      resolve();
    }
    el.addEventListener('animationend', onEnd);
  });
}

function exitElement(target, options){
  options = options || {};
  var el = _el(target);
  if(!el) return Promise.resolve();
  var dur = options.duration || 400;
  return new Promise(function(resolve){
    el.classList.remove('is-hidden');
    el.style.opacity = '1';
    el.style.transform = 'scale(1)';
    el.style.transition = 'opacity '+dur+'ms var(--ease-standard), transform '+dur+'ms var(--ease-standard)';
    void el.offsetWidth;
    el.style.opacity = '0';
    el.style.transform = 'scale(0.97)';
    setTimeout(function(){
      el.classList.add('is-hidden');
      el.style.transition = '';
      el.style.opacity = '';
      el.style.transform = '';
      resolve();
    }, dur);
  });
}

function fadeCanvas(canvas, opacity, duration){
  duration = duration || 450;
  if(!canvas) return Promise.resolve();
  return new Promise(function(resolve){
    canvas.style.transition = 'opacity '+duration+'ms var(--ease-standard)';
    canvas.style.opacity = String(opacity);
    setTimeout(function(){
      canvas.style.transition = '';
      if(opacity >= 1){
        canvas.style.opacity = '';
      }
      resolve();
    }, duration);
  });
}

function transitionCanvas(canvas, buildFn, options){
  options = options || {};
  var outMs = options.outDuration != null ? options.outDuration : 450;
  var inMs = options.inDuration != null ? options.inDuration : 450;
  if(!canvas) return Promise.resolve();
  return new Promise(function(resolve){
    if(outMs > 0){
      canvas.style.transition = 'opacity '+outMs+'ms var(--ease-standard)';
      canvas.style.opacity = '0';
    }
    setTimeout(function(){
      if(buildFn) buildFn(canvas);
      else canvas.innerHTML = '';
      void canvas.offsetWidth;
      if(inMs > 0){
        canvas.style.transition = 'opacity '+inMs+'ms var(--ease-standard)';
        canvas.style.opacity = '1';
        setTimeout(function(){
          canvas.style.transition = '';
          canvas.style.opacity = '';
          resolve();
        }, inMs);
      } else {
        canvas.style.transition = '';
        canvas.style.opacity = '';
        resolve();
      }
    }, outMs);
  });
}

/* ── §5-2 Acquire (Glow + Bounce) ── */
function acquireElement(target, options){
  options = options || {};
  var el = _el(target);
  if(!el) return Promise.resolve();
  return new Promise(function(resolve){
    el.classList.remove('is-hidden');
    _clearAnim(el);
    el.style.animationDuration = '800ms';
    el.classList.add('motion-acquire');
    if(options.glow !== false){
      setTimeout(function(){
        var glowEl = el.querySelector('img') || el;
        _clearAnim(glowEl);
        glowEl.style.animation = 'kf-glow-once 700ms ease forwards';
        setTimeout(function(){ glowEl.style.animation = ''; }, 700);
      }, 500);
    }
    function onEnd(){
      el.removeEventListener('animationend', onEnd);
      el.classList.remove('motion-acquire');
      el.style.animationDuration = '';
      resolve();
    }
    el.addEventListener('animationend', onEnd);
  });
}

function softAcquireElement(target, options){
  options = options || {};
  var el = _el(target);
  if(!el) return Promise.resolve();
  var dur = options.duration || 750;
  return new Promise(function(resolve){
    el.classList.remove('is-hidden');
    _clearAnim(el);

    if(options.hero){
      var spinEl = el.querySelector('img') || el;
      _clearAnim(spinEl);
      spinEl.style.animationDuration = dur + 'ms';
      spinEl.classList.add('motion-badge-hero-enter');
      function onHeroEnd(){
        spinEl.removeEventListener('animationend', onHeroEnd);
        spinEl.classList.remove('motion-badge-hero-enter');
        spinEl.style.animationDuration = '';
        resolve();
      }
      spinEl.addEventListener('animationend', onHeroEnd);
      return;
    }

    el.style.animationDuration = dur + 'ms';
    el.classList.add('motion-soft-acquire');
    if(options.glow !== false){
      setTimeout(function(){
        var glowEl = el.querySelector('img') || el;
        _clearAnim(glowEl);
        glowEl.style.animation = 'kf-glow-once 800ms ease forwards';
        setTimeout(function(){ glowEl.style.animation = ''; }, 800);
      }, Math.floor(dur * 0.55));
    }
    function onEnd(){
      el.removeEventListener('animationend', onEnd);
      el.classList.remove('motion-soft-acquire');
      el.style.animationDuration = '';
      resolve();
    }
    el.addEventListener('animationend', onEnd);
  });
}

/* ── §5-2b Member Enter (avoids transform conflict on .member-unit) ── */
function enterMember(unitId, options){
  options = options || {};
  var unit = typeof unitId === 'string' ? document.getElementById(unitId) : unitId;
  if(!unit) return Promise.resolve();
  var dur = options.duration || 720;
  var delay = options.delay || 0;
  var target = unit.querySelector('.member-visual');
  if(!target) return enterElement(unit, options);
  return new Promise(function(resolve){
    setTimeout(function(){
      unit.classList.remove('is-hidden');
      _clearAnim(target);
      target.style.animationDuration = dur + 'ms';
      target.classList.add('motion-soft-enter');
      function onEnd(){
        target.removeEventListener('animationend', onEnd);
        target.classList.remove('motion-soft-enter');
        target.style.animationDuration = '';
        resolve();
      }
      target.addEventListener('animationend', onEnd);
    }, delay);
  });
}

/* ── §5-3 Rank Replace ── */
function setRank(memberId, rank){
  var unit = document.getElementById(memberId);
  if(!unit) return;
  var medal = unit.querySelector('.rank-medal');
  if(!medal) return;
  var img = medal.querySelector('img');
  if(!img) return;
  medal.setAttribute('data-rank', rank);
  img.src = RANK_IMGS[rank] || '';
  img.alt = rank + ' 지위';
}

function replaceRank(memberId, fromRank, toRank){
  var unit = document.getElementById(memberId);
  if(!unit) return Promise.resolve();
  var medal = unit.querySelector('.rank-medal');
  if(!medal) return Promise.resolve();
  var img = medal.querySelector('img');
  if(!img) return Promise.resolve();
  return new Promise(function(resolve){
    // Out
    _clearAnim(medal);
    medal.style.animation = 'kf-rank-out 300ms var(--ease-standard) forwards';
    setTimeout(function(){
      img.src = RANK_IMGS[toRank] || '';
      img.alt = toRank + ' 지위';
      medal.setAttribute('data-rank', toRank);
      // In
      _clearAnim(medal);
      medal.style.animation = 'kf-rank-in 400ms var(--ease-emphasis) forwards';
      // Glow
      setTimeout(function(){
        _clearAnim(img);
        img.style.animation = 'kf-glow-once 700ms ease forwards';
        setTimeout(function(){
          img.style.animation = '';
          medal.style.animation = '';
          resolve();
        }, 700);
      }, 200);
    }, 320);
  });
}

/* ── §8 Condition ── */
function setAutoship(memberId, state){
  var unit = document.getElementById(memberId);
  if(!unit) return;
  var badge = unit.querySelector('.autoship-badge');
  if(!badge) return;
  if(state === 'active' || state === true){
    activateElement(badge);
    badge.setAttribute('data-condition', 'autoship');
  } else {
    deactivateElement(badge);
  }
}

function setSEP(targetId, value, isComplete){
  var el = document.getElementById(targetId);
  if(!el) return;
  var textEl = el.querySelector('.sep-badge-text');
  var valText = '';
  if(value >= 1000000) valText = (value/10000).toFixed(0)+'만↑';
  else if(value >= 10000) valText = (value/10000).toFixed(0)+'만↑';
  else valText = value.toLocaleString();
  if(textEl){
    textEl.innerHTML = 'S.E.P<br>' + valText;
  } else {
    var valEl = el.querySelector('.metric-value');
    if(valEl) valEl.textContent = valText;
  }
  el.setAttribute('data-status', isComplete ? 'complete' : 'incomplete');
}

/* ── §5-5 Condition Complete (Check) ── */
function completeCondition(target, options){
  options = options || {};
  var el = _el(target);
  if(!el) return Promise.resolve();
  return new Promise(function(resolve){
    // Update data-status
    if(el.hasAttribute('data-status')) el.setAttribute('data-status','complete');
    if(el.hasAttribute('data-condition')) el.setAttribute('data-condition','complete');
    // Border highlight
    el.style.animation = 'kf-highlight-pulse 700ms ease forwards';
    // Find or create status-check
    var check = el.querySelector('.status-check');
    if(!check){
      check = document.createElement('div');
      check.className = 'status-check';
      check.setAttribute('aria-label','조건 충족');
      check.textContent = '?';
      el.style.position = el.style.position || 'relative';
      el.appendChild(check);
    }
    setTimeout(function(){
      _clearAnim(check);
      check.style.animation = 'kf-check-pop 600ms var(--ease-emphasis) forwards';
      check.classList.add('is-visible');
      setTimeout(function(){
        check.style.animation = '';
        el.style.animation = '';
        resolve();
      }, 700);
    }, 200);
  });
}

/* ── §8 Bonus ── */
function setRecommendBonus(data){
  var el = document.getElementById(data.target || 'recommend-bonus-main');
  if(!el) return;
  var valEl = el.querySelector('.bonus-value');
  if(valEl) valEl.textContent = data.amount.toLocaleString()+'원 × '+data.count;
}

function setSupportBonus(targetId, rate){
  var el = document.getElementById(targetId);
  if(!el) return;
  var valEl = el.querySelector('.bonus-value');
  if(valEl) valEl.textContent = rate+'%';
}

/* ── §5-4 Text / Slide Up ── */
function setSceneTitle(text){
  var el = document.getElementById('scene-title-main');
  if(!el) return;
  el.innerHTML = text;
}

function setSceneBullets(items){
  var list = document.getElementById('scene-bullets');
  if(!list) return;
  list.innerHTML = '';
  items.forEach(function(item, i){
    var li = document.createElement('li');
    li.className = 'bullet-item';
    li.id = 'bullet-'+(i+1);
    li.innerHTML = '<span class="bullet-dot"></span><span class="bullet-text">'+item+'</span>';
    list.appendChild(li);
  });
}

function slideUpElement(target, options){
  options = options || {};
  var els = _els(target);
  var delay = options.delay || 0;
  var stagger = options.stagger || 0;
  var dur = options.duration || 550;
  var promises = els.map(function(el, i){
    return new Promise(function(resolve){
      var d = delay + i * stagger;
      setTimeout(function(){
        _clearAnim(el);
        el.style.animationDuration = dur+'ms';
        el.classList.add('motion-slide-up');
        function onEnd(){
          el.removeEventListener('animationend', onEnd);
          el.classList.remove('motion-slide-up');
          el.style.animationDuration = '';
          resolve();
        }
        el.addEventListener('animationend', onEnd);
      }, d);
    });
  });
  return Promise.all(promises);
}

/* ── §5-6 Stagger Fade ── */
function staggerFade(targets, options){
  options = options || {};
  var els = _els(targets);
  var stagger = options.stagger || 200;
  var dur = options.duration || 500;
  var promises = els.map(function(el, i){
    return new Promise(function(resolve){
      setTimeout(function(){
        el.classList.remove('is-hidden');
        el.style.opacity = '0';
        _clearAnim(el);
        el.style.animation = 'kf-stagger-item '+dur+'ms var(--ease-smooth) forwards';
        function onEnd(){
          el.removeEventListener('animationend', onEnd);
          el.style.animation = '';
          resolve();
        }
        el.addEventListener('animationend', onEnd);
      }, i * stagger);
    });
  });
  return Promise.all(promises);
}

/* ── §8 Utility ── */
function resetMotion(target){
  var els = _els(target);
  els.forEach(function(el){
    el.style.animation = 'none';
    el.style.opacity = '';
    el.style.transform = '';
    el.style.transition = '';
    el.classList.remove(
      'is-hidden','is-inactive','is-active','is-dimmed','is-visible',
      'is-entering','motion-enter','motion-acquire',
      'motion-soft-enter','motion-soft-acquire','motion-badge-hero-enter',
      'motion-slide-up','motion-check','motion-idle-float'
    );
    var check = el.querySelector('.status-check');
    if(check){ check.classList.remove('is-visible'); check.style.animation = ''; }
    void el.offsetWidth;
    el.style.animation = '';
  });
}

function resetMotionTree(root){
  var el = _el(root);
  if(!el) return;
  resetMotion(el);
  resetMotion(el.querySelectorAll('*'));
}

function resetScene(){
  var allUnits = document.querySelectorAll('.member-unit, .rank-medal, .qualification-badge, .condition-emblem, .metric-badge, .bonus-plate, .status-check, .scene-title, .bullet-item');
  allUnits.forEach(function(el){
    el.style.cssText = '';
    el.classList.remove(
      'is-hidden','is-inactive','is-active','is-dimmed','is-visible',
      'is-entering','motion-enter','motion-acquire',
      'motion-soft-enter','motion-soft-acquire','motion-badge-hero-enter',
      'motion-slide-up','motion-check','motion-idle-float'
    );
  });
  var checks = document.querySelectorAll('.status-check');
  checks.forEach(function(c){ c.classList.remove('is-visible'); });
}
</script>