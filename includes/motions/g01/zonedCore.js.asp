<script>
/* G01 Zoned Animation Core — 7×7 존 에셋 등장/퇴장/idle/이동 (guide01 공통) */
var G01ZonedAnim = (function(){

  function parseZone(zone){
    var m = /^([a-g])([1-7])$/i.exec(String(zone || '').trim());
    if(!m) return null;
    return { row: m[1].toLowerCase().charCodeAt(0) - 96, col: parseInt(m[2], 10) };
  }

  function placeAtZone(el, zone){
    if(!el) return el;
    var z = parseZone(zone);
    if(!z) return el;
    el.classList.add('lo-zone-place');
    el.setAttribute('data-zone', String(zone).toLowerCase());
    el.style.setProperty('--zone-row', z.row);
    el.style.setProperty('--zone-col', z.col);
    return el;
  }

  function resolveWrap(target){
    if(!target) return null;
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return null;
    if(el.classList && el.classList.contains('g01-zone-wrap')) return el;
    return el.closest ? el.closest('.g01-zone-wrap') : null;
  }

  function zonedInner(wrap){
    wrap = resolveWrap(wrap);
    return (wrap && wrap._float) || (wrap && wrap.querySelector('.g01-float-inner')) || wrap;
  }

  function zoneCenterPx(canvas, zone){
    var z = parseZone(zone);
    if(!z || !canvas) return { x: 0, y: 0 };
    var safe = window.matchMedia('(max-width:900px)').matches ? 5 : 10;
    var w = canvas.clientWidth - safe * 2;
    var h = canvas.clientHeight - safe * 2;
    return {
      x: safe + ((z.col - 0.5) / 7) * w,
      y: safe + ((z.row - 0.5) / 7) * h
    };
  }

  function getInnerBaseScale(inner){
    if(!inner) return 1;
    var v = inner.style.getPropertyValue('--g01-base-scale');
    if(v) return parseFloat(v) || 1;
    var m = (inner.style.transform || '').match(/scale\(([\d.]+)\)/);
    return m ? parseFloat(m[1]) : 1;
  }

  function getZonedScale(wrap){
    return getInnerBaseScale(zonedInner(wrap));
  }

  function settleZonedInner(inner){
    if(!inner) return;
    var base = getInnerBaseScale(inner);
    inner.style.transform = 'scale(' + base + ') translateZ(0)';
    inner.style.opacity = '';
    inner.style.removeProperty('--g01-from-scale');
  }

  function prepZonedAnimScales(inner, fromMul){
    var base = getInnerBaseScale(inner);
    inner.style.setProperty('--g01-base-scale', String(base));
    inner.style.setProperty('--g01-from-scale', String(base * fromMul));
    return base;
  }

  function runInnerAnim(inner, animClass, duration){
    duration = duration || 480;
    return new Promise(function(resolve){
      if(!inner) return resolve();
      var fromMul = animClass === 'g01-anim-pop' ? 0.88 : (animClass === 'g01-anim-enter' ? 0.94 : 1);
      prepZonedAnimScales(inner, fromMul);
      inner.style.setProperty('--g01-anim-dur', duration + 'ms');
      inner.classList.remove('g01-anim-enter', 'g01-anim-pop', 'g01-anim-drop');
      void inner.offsetWidth;
      inner.classList.add(animClass);
      function onEnd(e){
        if(e.target !== inner) return;
        inner.removeEventListener('animationend', onEnd);
        inner.classList.remove(animClass);
        inner.style.removeProperty('--g01-anim-dur');
        settleZonedInner(inner);
        resolve();
      }
      inner.addEventListener('animationend', onEnd);
    });
  }

  function easeOutCubic(t){
    return 1 - Math.pow(1 - t, 3);
  }

  function clearMotionStyles(wrap){
    if(!wrap) return;
    wrap.style.removeProperty('left');
    wrap.style.removeProperty('top');
    wrap.style.removeProperty('transform');
  }

  function setBaseScale(wrap, scale){
    var inner = zonedInner(wrap);
    if(!inner) return;
    inner.style.setProperty('--g01-base-scale', String(scale));
    inner.style.transform = 'scale(' + scale + ')';
  }

  async function enterFade(wrap, opts){
    opts = opts || {};
    wrap = resolveWrap(wrap);
    if(!wrap) return;
    showElement(wrap);
    var inner = zonedInner(wrap);
    if(!inner) return wait(opts.duration || 420);
    await runInnerAnim(inner, 'g01-anim-enter', opts.duration || 420);
  }

  async function enterPop(wrap, opts){
    opts = opts || {};
    wrap = resolveWrap(wrap);
    if(!wrap) return;
    showElement(wrap);
    var inner = zonedInner(wrap);
    var dur = opts.duration || 420;
    if(!inner) return wait(Math.max(dur, 520));
    await runInnerAnim(inner, 'g01-anim-pop', Math.max(dur, 520));
  }

  async function enterDrop(wrap, opts){
    opts = opts || {};
    wrap = resolveWrap(wrap);
    if(!wrap) return;
    showElement(wrap);
    var inner = zonedInner(wrap);
    var dur = opts.duration || 420;
    if(!inner) return wait(Math.max(dur, 520));
    await runInnerAnim(inner, 'g01-anim-drop', Math.max(dur, 520));
  }

  async function popScale(wrap, opts){
    opts = opts || {};
    wrap = resolveWrap(wrap);
    if(!wrap) return;
    showElement(wrap);
    var inner = zonedInner(wrap);
    if(!inner) return;
    await runInnerAnim(inner, 'g01-anim-pop', opts.duration || 480);
  }

  async function exit(wrap, opts){
    opts = opts || {};
    wrap = resolveWrap(wrap);
    if(!wrap) return;
    var dur = opts.duration || 280;
    var inner = zonedInner(wrap);
    if(!inner){
      await exitElement(wrap, { duration: dur });
      return;
    }
    var base = getInnerBaseScale(inner);
    inner.classList.remove('g01-anim-enter', 'g01-anim-pop', 'g01-anim-drop', 'g01-idle-float');
    await new Promise(function(resolve){
      inner.style.transition =
        'opacity ' + dur + 'ms cubic-bezier(.22,1,.36,1), ' +
        'transform ' + dur + 'ms cubic-bezier(.22,1,.36,1)';
      inner.style.opacity = '1';
      void inner.offsetWidth;
      inner.style.opacity = '0';
      inner.style.transform = 'scale(' + (base * 0.94) + ')';
      setTimeout(function(){
        inner.style.transition = '';
        settleZonedInner(inner);
        resolve();
      }, dur);
    });
  }

  async function exitHide(wrap, opts){
    await exit(wrap, opts);
    hideElement(resolveWrap(wrap));
  }

  function idleStart(wrap){
    var inner = zonedInner(wrap);
    if(!inner) return;
    settleZonedInner(inner);
    inner.classList.add('g01-idle-float');
  }

  function idleStop(wrap){
    var inner = zonedInner(wrap);
    if(!inner) return;
    inner.classList.remove('g01-idle-float');
    settleZonedInner(inner);
  }

  async function move(wrap, zone, opts){
    wrap = resolveWrap(wrap);
    if(!wrap || !zone) return;
    opts = opts || {};

    var canvas = wrap.parentElement;
    var fromZone = wrap.getAttribute('data-zone');
    if(!canvas || !fromZone) return;

    var duration = opts.duration || 720;
    var startPx = zoneCenterPx(canvas, fromZone);
    var endPx = zoneCenterPx(canvas, zone);
    var dx = endPx.x - startPx.x;
    var dy = endPx.y - startPx.y;
    var inner = zonedInner(wrap);
    var fromScale = getZonedScale(wrap);
    var toScale = opts.toScale != null ? opts.toScale : fromScale;
    var rafId = 0;

    wrap.classList.add('is-zone-moving');
    wrap.style.left = startPx.x + 'px';
    wrap.style.top = startPx.y + 'px';
    wrap.style.transform = 'translate(-50%, -50%) translate3d(0, 0, 0)';

    var origin = performance.now();

    return new Promise(function(resolve){
      function finish(){
        if(rafId) cancelAnimationFrame(rafId);
        clearMotionStyles(wrap);
        wrap.classList.remove('is-zone-moving');
        placeAtZone(wrap, zone);
        if(inner){
          inner.style.setProperty('--g01-base-scale', String(toScale));
          inner.style.transform = 'scale(' + toScale + ')';
        }
        resolve();
      }

      function frame(now){
        var t = Math.min(1, (now - origin) / duration);
        var eased = easeOutCubic(t);
        var x = dx * eased;
        var y = dy * eased;
        var scale = fromScale + (toScale - fromScale) * eased;

        wrap.style.transform =
          'translate(-50%, -50%) translate3d(' +
          x.toFixed(2) + 'px,' + y.toFixed(2) + 'px,0)';

        if(inner){
          inner.style.transform = 'scale(' + scale.toFixed(4) + ')';
        }

        if(t < 1) rafId = requestAnimationFrame(frame);
        else finish();
      }

      rafId = requestAnimationFrame(frame);
    });
  }

  return {
    parseZone: parseZone,
    placeAtZone: placeAtZone,
    resolveWrap: resolveWrap,
    zonedInner: zonedInner,
    zoneCenterPx: zoneCenterPx,
    getInnerBaseScale: getInnerBaseScale,
    getZonedScale: getZonedScale,
    setBaseScale: setBaseScale,
    settleZonedInner: settleZonedInner,
    enterFade: enterFade,
    enterPop: enterPop,
    enterDrop: enterDrop,
    popScale: popScale,
    exit: exit,
    exitHide: exitHide,
    idleStart: idleStart,
    idleStop: idleStop,
    move: move
  };
})();
</script>
