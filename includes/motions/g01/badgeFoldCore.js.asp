<script>
/* G01 Badge Fold — text track max-width (duration은 inline transition으로 강제) */
var G01BadgeFold = (function(){

  var BADGE_BASES = ['base_business_icon', 'autoship_icon', 'recommend_bonus_icon'];
  var DEFAULT_UNFOLD_DUR = 620;
  var DEFAULT_FOLD_DUR = Math.round(DEFAULT_UNFOLD_DUR * 1.2);
  var FOLD_SLOWER_RATIO = 1.2;
  var EASE_WIDTH = 'cubic-bezier(.22,1,.36,1)';
  var EASE_TEXT = 'cubic-bezier(.25,.1,.25,1)';

  function resolveBadge(target){
    if(!target) return null;
    var el = typeof target === 'string' ? document.querySelector(target) : target;
    if(!el) return null;
    if(el.classList && BADGE_BASES.some(function(b){
      return el.classList.contains(b) || el.classList.contains(b + '_o') || el.classList.contains(b + '_c');
    })) return el;
    for(var i = 0; i < BADGE_BASES.length; i++){
      var found = el.querySelector('.' + BADGE_BASES[i] + '_o, .' + BADGE_BASES[i] + '_c, .' + BADGE_BASES[i]);
      if(found) return found;
    }
    return null;
  }

  function getTextEl(badge){
    return badge ? badge.querySelector('[class$="_text"]') : null;
  }

  function getTrack(badge){
    return badge ? badge.querySelector('.g01-badge-text-track') : null;
  }

  function setModeClass(badge, open){
    if(!badge) return;
    for(var i = 0; i < BADGE_BASES.length; i++){
      var base = BADGE_BASES[i];
      if(badge.classList.contains(base) || badge.classList.contains(base + '_o') || badge.classList.contains(base + '_c')){
        badge.classList.remove(base, base + '_o', base + '_c');
        badge.classList.add(base + (open ? '_o' : '_c'));
        return;
      }
    }
  }

  function ensureTrack(badge, textEl){
    var track = getTrack(badge);
    if(track) return track;
    track = document.createElement('span');
    track.className = 'g01-badge-text-track';
    track.setAttribute('aria-hidden', 'true');
    textEl.parentNode.insertBefore(track, textEl);
    track.appendChild(textEl);
    return track;
  }

  function removeTrack(badge){
    var track = getTrack(badge);
    if(!track || !track.parentNode) return;
    resetTrackStyles(track);
    var textEl = track.querySelector('[class$="_text"]');
    if(textEl) track.parentNode.insertBefore(textEl, track);
    track.parentNode.removeChild(track);
  }

  function measureTextWidth(textEl){
    textEl.style.setProperty('display', 'inline-block', 'important');
    var w = Math.ceil(textEl.getBoundingClientRect().width);
    textEl.style.removeProperty('display');
    return Math.max(w, 1);
  }

  function measureGap(badge){
    var cs = getComputedStyle(badge);
    var gap = parseFloat(cs.gap);
    if(!isNaN(gap) && gap > 0) return Math.ceil(gap);
    var size = parseFloat(cs.getPropertyValue('--size')) || 36;
    return Math.ceil(size * 5 / 36);
  }

  function setTrackWidthVars(badge, textW, gapPx){
    gapPx = gapPx != null ? gapPx : measureGap(badge);
    var trackOpenPx = textW + gapPx;
    badge.style.setProperty('--g01-badge-gap', gapPx + 'px');
    badge.style.setProperty('--g01-badge-text-w', textW + 'px');
    badge.style.setProperty('--g01-badge-track-w', trackOpenPx + 'px');
    return trackOpenPx;
  }

  function prepFoldTiming(duration, isFold){
    if(isFold){
      return {
        widthDur: Math.round(duration * 0.72),
        textDur: Math.round(duration * 0.28),
        textDelay: 0
      };
    }
    return {
      widthDur: duration,
      textDur: Math.round(duration * 0.55),
      textDelay: Math.round(duration * 0.15)
    };
  }

  function waitMs(ms){
    return new Promise(function(r){ setTimeout(r, ms); });
  }

  function resolveFoldDuration(opts){
    if(opts && opts.duration) return opts.duration;
    if(opts && opts.unfoldDuration) return Math.round(opts.unfoldDuration * FOLD_SLOWER_RATIO);
    return DEFAULT_FOLD_DUR;
  }

  function waitElTransition(el, prop, duration){
    return new Promise(function(resolve){
      if(!el) return resolve();
      var done = false;
      function finish(){
        if(done) return;
        done = true;
        el.removeEventListener('transitionend', onEnd);
        resolve();
      }
      function onEnd(e){
        if(e.target !== el) return;
        if(e.propertyName !== prop) return;
        finish();
      }
      el.addEventListener('transitionend', onEnd);
      setTimeout(finish, duration + 120);
    });
  }

  function resetTrackStyles(track){
    if(!track) return;
    track.style.removeProperty('max-width');
    track.style.removeProperty('transition');
  }

  function resetInlineStyles(badge, textEl){
    resetTrackStyles(getTrack(badge));
    if(textEl){
      textEl.style.removeProperty('display');
      textEl.style.removeProperty('opacity');
      textEl.style.removeProperty('transform');
      textEl.style.removeProperty('transition');
      textEl.style.removeProperty('transition-delay');
      textEl.style.removeProperty('margin-left');
    }
    if(badge){
      badge.classList.remove(
        'g01-badge-foldable', 'g01-badge-folding', 'g01-badge-unfolding',
        'g01-badge-is-open', 'g01-badge-is-closed',
        'g01-badge-text-out', 'g01-badge-text-in'
      );
      badge.style.removeProperty('--g01-badge-text-w');
      badge.style.removeProperty('--g01-badge-track-w');
      badge.style.removeProperty('--g01-badge-gap');
    }
  }

  function nextFrame(){
    return new Promise(function(r){ requestAnimationFrame(function(){ requestAnimationFrame(r); }); });
  }

  async function animateTrackWidth(track, fromPx, toPx, duration){
    track.style.transition = 'none';
    track.style.maxWidth = fromPx + 'px';
    await nextFrame();
    track.style.transition = 'max-width ' + duration + 'ms ' + EASE_WIDTH;
    track.style.maxWidth = toPx + 'px';
    return waitElTransition(track, 'max-width', duration);
  }

  async function animateTextOpacity(textEl, toOpacity, duration){
    textEl.style.transition = 'opacity ' + duration + 'ms ' + EASE_TEXT;
    textEl.style.opacity = String(toOpacity);
    return waitElTransition(textEl, 'opacity', duration);
  }

  async function unfold(badge, opts){
    opts = opts || {};
    badge = resolveBadge(badge);
    var textEl = getTextEl(badge);
    if(!badge || !textEl) return;

    var dur = opts.duration || DEFAULT_UNFOLD_DUR;
    var gapPx = measureGap(badge);
    var textW = measureTextWidth(textEl);
    var trackOpenPx = textW + gapPx;
    var timing = prepFoldTiming(dur, false);

    badge.classList.add('g01-badge-foldable', 'g01-badge-unfolding', 'g01-badge-is-closed');
    setModeClass(badge, true);
    setTrackWidthVars(badge, textW, gapPx);
    var track = ensureTrack(badge, textEl);
    textEl.style.opacity = '0';
    track.style.maxWidth = '0px';
    await nextFrame();

    badge.classList.add('g01-badge-is-open');
    var widthAnim = animateTrackWidth(track, 0, trackOpenPx, timing.widthDur);
    var textAnim = (async function(){
      if(timing.textDelay) await waitMs(timing.textDelay);
      badge.classList.add('g01-badge-text-in');
      await animateTextOpacity(textEl, 1, timing.textDur);
    })();
    await Promise.all([widthAnim, textAnim]);

    badge.classList.remove('g01-badge-unfolding');
    removeTrack(badge);
    resetInlineStyles(badge, textEl);
    setModeClass(badge, true);
  }

  async function fold(badge, opts){
    opts = opts || {};
    badge = resolveBadge(badge);
    var textEl = getTextEl(badge);
    if(!badge || !textEl) return;

    var dur = resolveFoldDuration(opts);
    var gapPx = measureGap(badge);
    var textW = measureTextWidth(textEl);
    var trackOpenPx = textW + gapPx;
    var timing = prepFoldTiming(dur, true);

    setModeClass(badge, true);
    badge.classList.add('g01-badge-foldable', 'g01-badge-folding', 'g01-badge-is-open');
    setTrackWidthVars(badge, textW, gapPx);
    var track = ensureTrack(badge, textEl);
    textEl.style.opacity = '1';
    track.style.maxWidth = trackOpenPx + 'px';
    await nextFrame();

    badge.classList.remove('g01-badge-is-open');
    badge.classList.add('g01-badge-is-closed');
    await animateTrackWidth(track, trackOpenPx, 0, timing.widthDur);

    badge.classList.add('g01-badge-text-out');
    await animateTextOpacity(textEl, 0, timing.textDur);

    setModeClass(badge, false);
    removeTrack(badge);
    resetInlineStyles(badge, textEl);
  }

  function isClosed(badge){
    if(!badge) return true;
    for(var i = 0; i < BADGE_BASES.length; i++){
      if(badge.classList.contains(BADGE_BASES[i] + '_c')) return true;
    }
    return false;
  }

  async function toggle(badge, opts){
    opts = opts || {};
    badge = resolveBadge(badge);
    if(!badge) return;
    if(isClosed(badge)){
      return unfold(badge, {
        duration: opts.unfoldDuration || opts.duration || DEFAULT_UNFOLD_DUR
      });
    }
    return fold(badge, {
      duration: opts.foldDuration,
      unfoldDuration: opts.unfoldDuration || opts.duration || DEFAULT_UNFOLD_DUR
    });
  }

  return {
    resolveBadge: resolveBadge,
    unfold: unfold,
    fold: fold,
    toggle: toggle
  };
})();
</script>
