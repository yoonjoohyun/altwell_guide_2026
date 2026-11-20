<script>
/* guide04 공통. guide01~03 런타임 파일은 수정하지 않는다. */
var Guide04 = (function(){
  function timeline(ctx){
    var origin = performance.now();
    var elapsed = 0;
    return {
      wait: async function(ms){
        var target = origin + ms;
        var now = performance.now();
        if(target > now) await wait(target - now);
        elapsed = ms;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      },
      finish: async function(){
        var total = (ctx && ctx.sceneDuration) || elapsed;
        var target = origin + total;
        var now = performance.now();
        if(target > now) await wait(target - now);
        elapsed = total;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      }
    };
  }

  function resetScene(extraCls){
    var canvas = document.getElementById('motion-canvas');
    if(typeof CanvasStage !== 'undefined'){
      CanvasStage.reset(canvas, extraCls ? ('g04-canvas ' + extraCls) : 'g04-canvas');
    }else if(canvas){
      canvas.innerHTML = '';
    }
    if(typeof ScenePanel !== 'undefined' && ScenePanel.reset) ScenePanel.reset();
  }

  function mountStage(canvas, extraCls){
    if(!canvas) return;
    canvas.classList.add('g04-canvas');
    if(extraCls) canvas.classList.add(extraCls);
  }

  function cloneTemplate(templateId){
    var host = document.querySelector('#guide04-templates [data-template="' + templateId + '"]');
    if(!host || !host.firstElementChild) return null;
    return host.firstElementChild.cloneNode(true);
  }

  function placeAtZone(el, zone){
    if(typeof G01ZonedAnim !== 'undefined' && G01ZonedAnim.placeAtZone){
      return G01ZonedAnim.placeAtZone(el, zone);
    }
    return el;
  }

  function badgeAlone(stage, badge){
    var nodes;
    var i;
    var shown = 0;
    var only = null;
    if(!stage || !badge || badge.classList.contains('is-hidden')) return false;
    nodes = stage.children;
    for(i = 0; i < nodes.length; i++){
      if(nodes[i].classList.contains('is-hidden')) continue;
      if((nodes[i].offsetWidth || 0) < 2 && (nodes[i].offsetHeight || 0) < 2) continue;
      shown++;
      only = nodes[i];
    }
    return shown === 1 && only === badge;
  }

  function fitGroup(canvas, inner, stage, badge, after, groupInset){
    var w;
    var h;
    var ratio;
    var fit;
    var ro;
    if(!canvas || !inner || !stage) return;
    if(groupInset != null && groupInset > 0) stage._g04GroupInset = groupInset;
    else if(stage._g04GroupInset != null) groupInset = stage._g04GroupInset;
    w = stage.offsetWidth || 0;
    h = stage.offsetHeight || 0;
    if(w >= 2 && h >= 2 && canvas.clientWidth && canvas.clientHeight){
      ratio = badgeAlone(stage, badge) ? 0.4 : (groupInset != null && groupInset > 0 ? groupInset : 0.8);
      fit = Math.min((canvas.clientWidth * ratio) / w, (canvas.clientHeight * ratio) / h);
      if(fit > 0) inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
    }
    if(after) after();
    if(stage._g04Watch || typeof ResizeObserver === 'undefined') return;
    stage._g04Watch = true;
    ro = new ResizeObserver(function(){
      if(!stage.isConnected){
        ro.disconnect();
        return;
      }
      fitGroup(canvas, inner, stage, badge, after);
    });
    ro.observe(stage);
  }

  function panelInitBullets(items){
    setSceneBullets(items);
    if(!items || !items.length){
      hideElement('#scene-bullets');
      return;
    }
    showElement('#scene-bullets');
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    var i;
    for(i = 0; i < bullets.length; i++){
      bullets[i].classList.add('is-dim');
      bullets[i].classList.remove('is-emphasis', 'g04-flash');
    }
  }

  function panelFlashBullet(index){
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    var i;
    for(i = 0; i < bullets.length; i++){
      bullets[i].classList.toggle('is-emphasis', i === index);
      bullets[i].classList.toggle('is-dim', i !== index);
      bullets[i].classList.remove('g04-flash');
    }
    if(bullets[index]) bullets[index].classList.add('g04-flash');
  }

  async function panelBulletTimeline(tl, title, items, flashes){
    await tl.wait(0);
    setSceneTitle(title);
    showElement('#scene-title-main');
    panelInitBullets(items || []);
    var i;
    flashes = flashes || [];
    for(i = 0; i < flashes.length; i++){
      await tl.wait(flashes[i].at);
      panelFlashBullet(flashes[i].index);
    }
  }

  async function finishSceneHold(tl, duration){
    await tl.wait(duration);
    await tl.finish();
  }

  return {
    timeline: timeline,
    resetScene: resetScene,
    mountStage: mountStage,
    cloneTemplate: cloneTemplate,
    placeAtZone: placeAtZone,
    fitGroup: fitGroup,
    panelBulletTimeline: panelBulletTimeline,
    panelFlashBullet: panelFlashBullet,
    finishSceneHold: finishSceneHold
  };
})();

function guide04EaseOpen(slot){
  var h;
  var w;
  var anim;
  if(!slot) return Promise.resolve();
  slot.style.transition = 'none';
  slot.classList.add('is-open', 'is-settled');
  h = slot.offsetHeight;
  w = slot.offsetWidth;
  if(h < 1 && w < 1){
    slot.style.transition = '';
    return Promise.resolve();
  }
  slot.style.overflow = 'hidden';
  anim = slot.animate([
    { height: '0px', width: '0px', opacity: 0 },
    { height: h + 'px', width: w + 'px', opacity: 1 }
  ], { duration: 740, easing: 'ease-in-out', fill: 'both' });
  return anim.finished.then(function(){
    anim.cancel();
    slot.style.overflow = '';
    slot.style.transition = '';
  }, function(){
    slot.style.overflow = '';
    slot.style.transition = '';
  });
}
</script>

<script>
/* guide04 씬 제작 도구. 씬 3파일(constants·setup·js)이 공통으로 쓴다. */
var G04Kit = (function(){
  var SVGNS = 'http://www.w3.org/2000/svg';

  function el(tag, cls, text){
    var node = document.createElement(tag);
    if(cls) node.className = cls;
    if(text != null) node.textContent = text;
    return node;
  }

  function grow(child){
    var slot = el('div', 'g04-grow');
    var clip = el('div', 'g04-grow-clip');
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function scaleOf(node){
    var w = node.offsetWidth || 1;
    var r = node.getBoundingClientRect();
    return (r.width / w) || 1;
  }

  /* 멤버: { id, label, cap, kind: self|partner|plain|new|up, size: sm|xs } */
  function member(o){
    var wrap = el('div', 'g04-member' + (o.size ? ' is-' + o.size : ''));
    var fig = el('div', 'g04-fig');
    var icon = Guide04.cloneTemplate('member_icon');
    var cap = null;
    if(icon){
      if(o.id) icon.id = o.id;
      icon.innerHTML = '<span class="member_face_label">' + (o.label || '') + '</span>';
      icon.setAttribute('aria-label', o.cap || o.label || '멤버');
      if(o.kind === 'self') icon.classList.add('member_base_self');
      if(o.kind === 'partner') icon.classList.add('member_base_partner');
      if(o.kind === 'new') icon.classList.add('g04-new');
      if(o.kind === 'up') icon.classList.add('g04-up');
      fig.appendChild(icon);
    }
    wrap.appendChild(fig);
    if(o.cap){
      cap = el('div', 'g04-cap', o.cap);
      wrap.appendChild(cap);
    }
    return { slot: grow(wrap), wrap: wrap, fig: fig, icon: icon, cap: cap };
  }

  /* 멤버 하단 도킹 뱃지(접힌 상태). 숨김으로 시작 */
  function dock(fig, id, templateId, folded){
    var host = el('div', 'g04-dock');
    var wrap = el('div', 'g04-slot is-hidden');
    var badge = Guide04.cloneTemplate(templateId);
    if(id) wrap.id = id;
    if(badge){
      if(folded) badge = compactBadge(badge);
      wrap.appendChild(badge);
    }
    host.appendChild(wrap);
    fig.appendChild(host);
    return wrap;
  }

  /* _o(펼침) 뱃지를 _c(접힘) 변형으로 바꾼다 */
  function compactBadge(node){
    var cls;
    if(!node) return node;
    cls = node.className || '';
    node.className = cls.replace('_icon_o', '_icon_c');
    return node;
  }

  function compact(templateId){
    return compactBadge(Guide04.cloneTemplate(templateId));
  }

  function medal(fig, templateId){
    var host = el('div', 'g04-medal g04-slot is-hidden');
    var node = Guide04.cloneTemplate(templateId);
    if(node) host.appendChild(node);
    fig.appendChild(host);
    return host;
  }

  function mark(fig, kind){
    var host = el('div', 'g04-mark g04-slot is-hidden');
    var node = Guide04.cloneTemplate(kind === 'cross' ? 'status_cross_icon' : 'status_check_icon');
    if(node) host.appendChild(node);
    fig.appendChild(host);
    return host;
  }

  /* 추천포인트 태그 */
  function tag(n){
    var node = Guide04.cloneTemplate('referral_point_tag');
    var wrap = el('div', 'g04-slot');
    if(node) wrap.appendChild(node);
    wrap.tagNode = node;
    wrap.numNode = node ? node.querySelector('.referral_point_tag_num') : null;
    wrap.value = n || 0;
    if(wrap.numNode) wrap.numNode.textContent = String(wrap.value);
    return wrap;
  }

  function tagSet(t, n, bump){
    if(!t || !t.numNode) return;
    t.value = n;
    t.numNode.textContent = String(n);
    if(bump && t.tagNode){
      t.tagNode.classList.remove('is_bump');
      void t.tagNode.offsetWidth;
      t.tagNode.classList.add('is_bump');
    }
  }

  async function tagCount(t, to, ms){
    var from;
    var steps;
    var i;
    if(!t) return;
    from = t.value || 0;
    if(from === to) return;
    steps = Math.min(Math.abs(to - from), 14);
    for(i = 1; i <= steps; i++){
      tagSet(t, Math.round(from + (to - from) * i / steps), i === steps);
      await wait((ms || 600) / steps);
    }
  }

  function tagLabel(t, text){
    var node = t && t.tagNode && t.tagNode.querySelector('.referral_point_tag_label');
    if(node) node.textContent = text;
  }

  /* 상품: kind = auto | pack, opts.mini */
  function product(kind, opts){
    var o = opts || {};
    var wrap = el('div', 'g04-slot g04-product' + (kind === 'pack' ? ' g04-startpack' : '') + (o.mini ? ' is-mini' : '') + (o.hidden === false ? '' : ' is-hidden'));
    var node = Guide04.cloneTemplate(kind === 'pack' ? 'startpack_badge' : 'autoship_icon');
    if(node){
      if(kind !== 'pack'){
        var t = node.querySelector('.autoship_text');
        if(t) t.textContent = o.text || '오토십';
      }
      wrap.appendChild(node);
    }
    return wrap;
  }

  function chip(text, cls){
    return el('div', 'g04-chip-text' + (cls ? ' ' + cls : ''), text);
  }

  function infoBadge(text, label, variant){
    var node = Guide04.cloneTemplate('guide_info_badge');
    if(!node) return null;
    var l = node.querySelector('.guide_info_badge_label');
    var t = node.querySelector('.guide_info_badge_text');
    if(l) l.textContent = label || 'i';
    if(t) t.textContent = text;
    if(variant) node.classList.add(variant);
    node.setAttribute('aria-label', text);
    return node;
  }

  function svgLayer(){
    var svg = document.createElementNS(SVGNS, 'svg');
    svg.setAttribute('class', 'g04-lines');
    svg.setAttribute('aria-hidden', 'true');
    return svg;
  }

  function addPaths(svg, n){
    var i;
    var out = [];
    for(i = 0; i < n; i++){
      var path = document.createElementNS(SVGNS, 'path');
      path.setAttribute('fill', 'none');
      svg.appendChild(path);
      out.push(path);
    }
    return out;
  }

  function pointIn(node, host, yRatio){
    var a = node.getBoundingClientRect();
    var b = host.getBoundingClientRect();
    var sc = scaleOf(host);
    return {
      x: (a.left + a.width / 2 - b.left) / sc,
      y: (a.top + a.height * yRatio - b.top) / sc
    };
  }

  /* host 안에서 from → 각 to 로 선을 그린다.
     animate: true=전체 / 숫자=그 인덱스부터 애니메이션 / false=없음 */
  function drawLines(host, svg, paths, fromEl, toEls, animate, fromRatio, toRatio){
    var w;
    var h;
    var from;
    var i;
    var animFrom = animate === true ? 0 : (typeof animate === 'number' ? animate : -1);
    if(!host || !svg || !fromEl) return;
    w = host.offsetWidth || 1;
    h = host.offsetHeight || 1;
    from = pointIn(fromEl, host, fromRatio == null ? 0.94 : fromRatio);
    svg.setAttribute('viewBox', '0 0 ' + w + ' ' + h);
    svg.setAttribute('width', String(w));
    svg.setAttribute('height', String(h));
    for(i = 0; i < paths.length; i++){
      var to = toEls[i];
      var path = paths[i];
      if(!to){
        path.setAttribute('d', '');
        continue;
      }
      var pt = pointIn(to, host, toRatio == null ? 0.18 : toRatio);
      path.setAttribute('d', 'M' + from.x + ' ' + from.y + ' L' + pt.x + ' ' + pt.y);
      path.style.transition = 'none';
      if(animFrom < 0 || i < animFrom){
        path.style.strokeDashoffset = '0';
        continue;
      }
      var len = path.getTotalLength ? path.getTotalLength() : 0;
      path.style.strokeDashoffset = String(len || 0);
    }
    svg.classList.add('is-on');
    if(animFrom < 0) return;
    window.requestAnimationFrame(function(){
      var j;
      for(j = animFrom; j < paths.length; j++){
        paths[j].style.transition = 'stroke-dashoffset 720ms cubic-bezier(.16,1,.3,1)';
        paths[j].style.strokeDashoffset = '0';
      }
    });
  }

  async function reveal(node, schedule){
    if(!node) return;
    showElement(node);
    node.classList.add('g04-enter');
    if(schedule) schedule();
    await wait(760);
    node.classList.remove('g04-enter');
  }

  async function fadeIn(node, schedule){
    if(!node) return;
    showElement(node);
    node.classList.add('g04-fade');
    if(schedule) schedule();
    await wait(760);
    node.classList.remove('g04-fade');
  }

  async function leave(node, schedule){
    if(!node) return;
    node.classList.add('g04-leave');
    await wait(620);
    node.classList.remove('g04-leave');
    node.classList.add('is-hidden');
    if(schedule) schedule();
  }

  async function open(slot, schedule){
    var done;
    if(!slot) return;
    done = guide04EaseOpen(slot);
    if(schedule) schedule();
    await done;
  }

  async function closeSlot(slot, schedule){
    var h;
    var w;
    var anim;
    if(!slot) return;
    slot.style.overflow = 'hidden';
    h = slot.offsetHeight;
    w = slot.offsetWidth;
    anim = slot.animate([
      { height: h + 'px', width: w + 'px', opacity: 1 },
      { height: '0px', width: '0px', opacity: 0 }
    ], { duration: 560, easing: 'ease-in-out', fill: 'both' });
    try{ await anim.finished; }catch(e){}
    slot.classList.add('is-hidden');
    if(schedule) schedule();
  }

  /* 뱃지 펼침/접힘 (recommend / base / autoship) */
  var BADGE_SEL = '.recommend_bonus_icon_o, .base_business_icon_o, .autoship_icon_o';
  var TEXT_SEL = '.recommend_bonus_text, .base_text, .autoship_text';

  async function unfold(wrap, schedule){
    var badge;
    var text;
    var track;
    var gap;
    var textW;
    if(!wrap) return;
    badge = wrap.querySelector(BADGE_SEL);
    text = badge && badge.querySelector(TEXT_SEL);
    if(!badge || !text){
      await reveal(wrap, schedule);
      return;
    }
    showElement(wrap);
    badge.classList.add('g04-fold');
    gap = parseFloat(getComputedStyle(badge).getPropertyValue('--size')) * 5 / 36;
    if(!gap || gap < 1) gap = 6;
    badge.style.setProperty('--g04-gap', gap + 'px');
    textW = Math.ceil(text.scrollWidth || text.getBoundingClientRect().width);
    track = el('span', 'g04-fold-track');
    text.parentNode.insertBefore(track, text);
    track.appendChild(text);
    track.style.maxWidth = '0px';
    text.style.opacity = '0';
    if(schedule) schedule();
    await wait(40);
    track.style.transition = 'max-width 640ms cubic-bezier(.22,1,.36,1)';
    text.style.transition = 'opacity 360ms cubic-bezier(.25,.1,.25,1) 120ms';
    track.style.maxWidth = (textW + gap) + 'px';
    text.style.opacity = '1';
    await wait(700);
  }

  async function foldAway(wrap, schedule){
    var badge;
    var track;
    var text;
    if(!wrap) return;
    badge = wrap.querySelector(BADGE_SEL);
    track = wrap.querySelector('.g04-fold-track');
    text = track && track.firstElementChild;
    if(badge && track && text){
      track.style.transition = 'max-width 420ms cubic-bezier(.22,1,.36,1)';
      text.style.transition = 'opacity 220ms ease';
      text.style.opacity = '0';
      track.style.maxWidth = '0px';
      await wait(440);
    }
    wrap.classList.add('is-hidden');
    if(schedule) schedule();
  }

  /* 코인 비행. opts: { text, bounce } — bounce 면 70% 지점까지 갔다가 되돌아온다 */
  async function fly(fromEl, toEl, stage, opts){
    var o = opts || {};
    var from;
    var to;
    var sb;
    var sc;
    var coin;
    var dx;
    var dy;
    if(!fromEl || !toEl || !stage) return;
    from = fromEl.getBoundingClientRect();
    to = toEl.getBoundingClientRect();
    sb = stage.getBoundingClientRect();
    sc = scaleOf(stage);
    coin = el('div', 'g04-point-coin', o.text || 'P');
    stage.appendChild(coin);
    coin.style.left = ((from.left + from.width / 2 - sb.left) / sc) + 'px';
    coin.style.top = ((from.top + from.height / 2 - sb.top) / sc) + 'px';
    dx = ((to.left + to.width / 2) - (from.left + from.width / 2)) / sc;
    dy = ((to.top + to.height / 2) - (from.top + from.height / 2)) / sc;
    await wait(30);
    if(o.bounce){
      coin.style.transform = 'translate(' + (dx * 0.72) + 'px,' + (dy * 0.72) + 'px) scale(.9)';
      await wait(620);
      coin.style.transform = 'translate(0px,0px) scale(.9)';
      coin.style.opacity = '0.3';
      await wait(640);
    }else{
      coin.style.transform = 'translate(' + dx + 'px,' + dy + 'px) scale(.72)';
      coin.style.opacity = '0.15';
      await wait(680);
    }
    if(coin.parentNode) coin.parentNode.removeChild(coin);
  }

  /* 커서를 대상 중심으로 이동 후 클릭 */
  async function cursorTo(cursor, stage, target, dxOff, dyOff){
    var sb = stage.getBoundingClientRect();
    var tb = target.getBoundingClientRect();
    var sc = scaleOf(stage);
    var x = (tb.left + tb.width / 2 - sb.left) / sc + (dxOff || 10);
    var y = (tb.top + tb.height / 2 - sb.top) / sc + (dyOff || 14);
    cursor.style.transform = 'translate(' + x + 'px,' + y + 'px)';
    await wait(780);
  }

  /* 오버레이 엘리먼트(✕·스탬프) 잠깐 표시 */
  async function flashOverlay(layer, ms){
    showElement(layer);
    layer.classList.add('g04-fade');
    await wait(ms || 900);
    layer.classList.remove('g04-fade');
    layer.classList.add('is-hidden');
  }

  function overlay(templateId, labelText){
    var layer = el('div', 'g04-overlay g04-slot is-hidden');
    var node = Guide04.cloneTemplate(templateId);
    layer.setAttribute('aria-hidden', 'true');
    if(node){
      if(labelText){
        var t = node.querySelector('.unavailable_stamp_text');
        if(t) t.textContent = labelText;
        node.setAttribute('aria-label', labelText);
      }
      layer.appendChild(node);
    }
    return layer;
  }

  function makeLayout(){
    var _ctx = null;
    var _bound = false;
    function applyFit(){
      if(!_ctx) return;
      Guide04.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
    }
    function schedule(){ requestAnimationFrame(applyFit); }
    function bind(ctx){
      _ctx = ctx;
      if(_bound) return;
      _bound = true;
      window.addEventListener('resize', schedule);
    }
    function unbind(){
      _bound = false;
      _ctx = null;
    }
    return { schedule: schedule, flush: applyFit, bind: bind, unbind: unbind };
  }

  /* 스택 마운트: 존 배치 + inner + stage. 반환 { stack, inner, stage } */
  function mountStack(canvas, zone){
    var stack = el('div', 'g04-stack g01-zone-wrap lo-zone-place');
    var inner = el('div', 'g04-stack-inner');
    var stage = el('div', 'g04-stage');
    Guide04.placeAtZone(stack, zone);
    inner.appendChild(stage);
    stack.appendChild(inner);
    canvas.appendChild(stack);
    return { stack: stack, inner: inner, stage: stage };
  }

  /* 타이틀 구간 뱃지 슬롯 */
  function titleBadge(templateId, id, text){
    var wrap = el('div', 'g04-slot g04-bonus-badge is-hidden');
    var badge = Guide04.cloneTemplate(templateId);
    if(id) wrap.id = id;
    if(badge){
      if(text){
        var t = badge.querySelector(TEXT_SEL);
        if(t) t.textContent = text;
      }
      wrap.appendChild(badge);
    }
    return wrap;
  }

  /* 3슬롯 (core_three_slot): items = [{ no, text, build(bodyEl) }] */
  function threeSlots(items, hostCls){
    var host = el('div', hostCls || 'g04-three');
    var out = [];
    items.forEach(function(item, i){
      var node = Guide04.cloneTemplate('core_three_slot');
      var body;
      var text;
      var no;
      if(!node) return;
      body = node.querySelector('.core_three_body');
      text = node.querySelector('.core_three_text');
      no = node.querySelector('.core_three_no');
      if(no) no.textContent = String(item.no || (i + 1));
      if(text) text.textContent = item.text;
      node.setAttribute('aria-label', '핵심 ' + (item.no || (i + 1)) + ' ' + item.text);
      if(item.build) item.build(body);
      host.appendChild(node);
      out.push(node);
    });
    return { host: host, slots: out };
  }

  async function fillSlot(node, schedule){
    if(!node) return;
    node.classList.remove('is_empty');
    node.classList.add('g04-pulse');
    if(schedule) schedule();
    await wait(900);
    node.classList.remove('g04-pulse');
  }

  return {
    el: el, grow: grow, scaleOf: scaleOf,
    member: member, dock: dock, medal: medal, mark: mark, compact: compact,
    tag: tag, tagSet: tagSet, tagCount: tagCount, tagLabel: tagLabel,
    product: product, chip: chip, infoBadge: infoBadge,
    svgLayer: svgLayer, addPaths: addPaths, drawLines: drawLines, pointIn: pointIn,
    reveal: reveal, fadeIn: fadeIn, leave: leave, open: open, closeSlot: closeSlot,
    unfold: unfold, foldAway: foldAway, fly: fly,
    cursorTo: cursorTo, flashOverlay: flashOverlay, overlay: overlay,
    makeLayout: makeLayout, mountStack: mountStack, titleBadge: titleBadge,
    threeSlots: threeSlots, fillSlot: fillSlot
  };
})();

/* 씬 공통 헬퍼 */
function guide04TitleMs(cfg, ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  return (cfg.media && cfg.media.titleMs) || 0;
}

function guide04AtMain(cfg, ms, ctx){
  return guide04TitleMs(cfg, ctx) + ms;
}

function guide04PanelFlashes(cfg, ctx){
  return cfg.panel.flashes.map(function(f){
    return { at: guide04AtMain(cfg, f.at, ctx), index: f.index };
  });
}

function guide04Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

/* 본문 시각(ms)을 기다린다. 취소되면 true */
async function guide04WaitMain(tl, cfg, ms, ctx){
  await tl.wait(guide04AtMain(cfg, ms, ctx));
  return guide04Cancelled(ctx);
}

/* defineScene 팩토리: reset/play 공통부 */
function guide04DefineScene(cfg, setupFn, runFn, layout){
  return defineScene({
    id: cfg.id,
    title: cfg.title,
    duration: cfg.duration,
    mediaSequence: cfg.media.sequence,
    mediaFallbackMs: cfg.media.fallbackMs,

    reset: function(){
      var panel = document.getElementById('lo-panel');
      if(panel) panel.classList.remove(cfg.panelCls);
      if(layout && layout.unbind) layout.unbind();
      Guide04.resetScene(cfg.canvasCls);
    },

    play: async function(ctx){
      var canvas = ctx.canvas;
      var panel;
      var tl;
      var assets;
      if(!canvas) return;
      panel = document.getElementById('lo-panel');
      if(panel) panel.classList.add(cfg.panelCls);
      tl = Guide04.timeline(ctx);
      Guide04.resetScene(cfg.canvasCls);
      Guide04.mountStage(canvas, cfg.canvasCls);
      assets = setupFn(canvas);

      await Promise.all([
        runFn(tl, assets, ctx),
        Guide04.panelBulletTimeline(tl, cfg.panel.title, cfg.panel.bullets, guide04PanelFlashes(cfg, ctx))
      ]);
      if(guide04Cancelled(ctx)) return;
      await Guide04.finishSceneHold(tl, ctx.sceneDuration || cfg.duration);
    }
  });
}
</script>
