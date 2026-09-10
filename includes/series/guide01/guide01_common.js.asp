<script>
/* guide01 공통 — 타임라인·패널·에셋·DOM 헬퍼 */
var Guide01 = (function(){
  var CANVAS_CLS = 'guide01-canvas';
  var BADGE_BASES = ['base_business_icon', 'autoship_icon', 'recommend_bonus_icon'];

  function setSceneDesc(text){
    var el = document.getElementById('panel-scene-desc');
    if(el) el.textContent = text;
  }

  function timeline(ctx){
    var origin = performance.now();
    var elapsed = 0;
    return {
      wait: async function(ms){
        var target = origin + ms;
        var now = performance.now();
        if(target > now){
          await wait(target - now);
        }
        elapsed = ms;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      },
      finish: async function(){
        var total = (ctx && ctx.sceneDuration) || elapsed;
        var target = origin + total;
        var now = performance.now();
        if(target > now){
          await wait(target - now);
        }
        elapsed = total;
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      },
      get elapsed(){ return elapsed; }
    };
  }

  function resetScene(extraCls){
    var canvas = document.getElementById('motion-canvas');
    var cls = CANVAS_CLS + (extraCls ? ' ' + extraCls : '');
    CanvasStage.reset(canvas, cls);
    ScenePanel.reset();
  }

  function mountStage(canvas, extraCls){
    var cls = CANVAS_CLS + (extraCls ? ' ' + extraCls : '');
    MotionCanvasStandardStage.run({ canvas: canvas }, { sceneClass: cls });
  }

  function cloneTemplate(id){
    var wrap = document.querySelector('#guide01-templates [data-template="' + id + '"]');
    if(!wrap || !wrap.firstElementChild) return null;
    return wrap.firstElementChild.cloneNode(true);
  }

  function addAsset(canvas, templateId, elId){
    var node = cloneTemplate(templateId);
    if(!node) return null;
    node.id = elId;
    node.classList.add('guide01-asset', 'is-hidden');
    canvas.appendChild(node);
    return node;
  }

  function parseZone(zone){
    return G01ZonedAnim.parseZone(zone);
  }

  function placeAtZone(el, zone){
    return G01ZonedAnim.placeAtZone(el, zone);
  }

  function addZonedAsset(canvas, templateId, elId, zone, opts){
    opts = opts || {};
    var node = cloneTemplate(templateId);
    if(!node) return null;
    return mountZonedNode(canvas, node, elId, zone, opts);
  }

  function badgeClosedTemplateId(templateId){
    if(!templateId) return templateId;
    if(/_icon_c$/.test(templateId)) return templateId;
    if(/_icon_o$/.test(templateId)) return templateId.replace(/_icon_o$/, '_icon_c');
    if(/_icon$/.test(templateId)) return templateId + '_c';
    return templateId;
  }

  function addZonedBadge(canvas, templateId, elId, zone, opts){
    return addZonedAsset(canvas, badgeClosedTemplateId(templateId), elId, zone, opts);
  }

  function resolveZonedBadge(wrap){
    if(!wrap) return null;
    if(typeof G01BadgeFold !== 'undefined'){
      return G01BadgeFold.resolveBadge(wrap);
    }
    for(var i = 0; i < BADGE_BASES.length; i++){
      var base = BADGE_BASES[i];
      var found = wrap.querySelector('.' + base + '_o, .' + base + '_c, .' + base);
      if(found) return found;
    }
    return null;
  }

  function mountZonedNode(canvas, node, elId, zone, opts){
    opts = opts || {};
    if(!node || !canvas) return null;

    var wrap = document.createElement('div');
    wrap.id = elId;
    wrap.className = 'g01-zone-wrap is-hidden' + (opts.extraCls ? ' ' + opts.extraCls : '');
    placeAtZone(wrap, zone);

    var inner = document.createElement('div');
    inner.className = 'g01-float-inner';
    var baseScale = opts.scale != null ? opts.scale : 1;
    inner.style.setProperty('--g01-base-scale', String(baseScale));
    inner.style.transform = 'scale(' + baseScale + ')';

    node.classList.add('guide01-asset');
    inner.appendChild(node);
    wrap.appendChild(inner);
    canvas.appendChild(wrap);
    wrap._float = inner;
    return wrap;
  }

  function zonedInner(wrap){
    return G01ZonedAnim.zonedInner(wrap);
  }

  function zoneCenterPx(canvas, zone){
    return G01ZonedAnim.zoneCenterPx(canvas, zone);
  }

  async function fadeZoned(wrap, show, opts){
    opts = opts || {};
    if(!wrap) return;
    if(show){
      if(opts.pop) return G01ZonedAnim.enterPop(wrap, opts);
      if(opts.coinDrop) return G01ZonedAnim.enterDrop(wrap, opts);
      return G01ZonedAnim.enterFade(wrap, opts);
    }
    await G01ZonedAnim.exitHide(wrap, opts);
  }

  function getZonedScale(wrap){
    return G01ZonedAnim.getZonedScale(wrap);
  }

  async function moveZoned(wrap, zone, durationOrOpts){
    var opts = typeof durationOrOpts === 'number'
      ? { duration: durationOrOpts }
      : (durationOrOpts || {});
    return G01ZonedAnim.move(wrap, zone, opts);
  }

  function setZonedScale(wrap, scale){
    G01ZonedAnim.setBaseScale(wrap, scale);
  }

  function startIdleFloat(wrap){
    G01ZonedAnim.idleStart(wrap);
  }

  function stopIdleFloat(wrap){
    G01ZonedAnim.idleStop(wrap);
  }

  function addZonedCalendar(canvas, elId, zone, label){
    var node = cloneTemplate('calendar_month_card');
    if(!node) return null;
    node.classList.remove('is_active');
    var title = node.querySelector('.calendar_title');
    if(title) title.textContent = label;
    return mountZonedNode(canvas, node, elId, zone, { scale: 0.88 });
  }

  function addZonedBonusPlate(canvas, elId, zone, label, value){
    var node = document.createElement('div');
    node.className = 'bonus-plate support-bonus g01-mini-bonus guide01-asset';
    node.innerHTML =
      '<span class="bonus-indicator"></span>' +
      '<span class="bonus-label">' + label + '</span>' +
      '<strong class="bonus-value">' + value + '</strong>';
    return mountZonedNode(canvas, node, elId, zone, { scale: 1 });
  }

  function mountConnectorSvg(canvas, id){
    var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.id = id;
    svg.setAttribute('class', 'g01-connector-svg');
    svg.setAttribute('aria-hidden', 'true');
    canvas.appendChild(svg);
    return svg;
  }

  function linkZones(svg, canvas, lineId, zoneA, zoneB){
    if(!svg || !canvas) return null;
    var a = zoneCenterPx(canvas, zoneA);
    var b = zoneCenterPx(canvas, zoneB);
    var line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line.id = lineId;
    line.setAttribute('x1', a.x);
    line.setAttribute('y1', a.y);
    line.setAttribute('x2', b.x);
    line.setAttribute('y2', b.y);
    svg.appendChild(line);
    return line;
  }

  async function revealConnector(lineId, duration){
    await MotionConnectorDraw.run({}, { lineId: lineId, duration: duration || 700 });
  }

  function hideConnectors(svg){
    if(!svg) return;
    var lines = svg.querySelectorAll('line');
    for(var i = 0; i < lines.length; i++){
      lines[i].classList.remove('is-visible');
    }
  }

  function clearConnectorSvg(svg){
    if(svg) svg.innerHTML = '';
  }

  async function popScaleZoned(wrap, opts){
    return G01ZonedAnim.popScale(wrap, opts || {});
  }

  function panelInitBullets(items){
    setSceneBullets(items);
    showElement('#scene-bullets');
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i = 0; i < bullets.length; i++){
      bullets[i].classList.add('is-dim');
      bullets[i].classList.remove('is-emphasis', 'g01-flash');
    }
  }

  function panelFlashBullet(index){
    var bullets = document.querySelectorAll('#scene-bullets .bullet-item');
    for(var i = 0; i < bullets.length; i++){
      bullets[i].classList.toggle('is-emphasis', i === index);
      bullets[i].classList.toggle('is-dim', i !== index);
      bullets[i].classList.remove('g01-flash');
    }
    if(bullets[index]){
      bullets[index].classList.add('g01-flash');
    }
  }

  async function panelBulletTimeline(tl, title, items, flashes){
    await tl.wait(0);
    setSceneTitle(title);
    showElement('#scene-title-main');
    panelInitBullets(items);
    for(var i = 0; i < flashes.length; i++){
      await tl.wait(flashes[i].at);
      panelFlashBullet(flashes[i].index);
    }
  }

  async function finishSceneHold(tl, duration){
    await tl.wait(duration);
    await tl.finish();
  }

  async function showAsset(el){
    if(!el) return;
    showElement(el);
    el.classList.add('asset-enter');
    await wait(500);
    el.classList.remove('asset-enter');
  }

  async function showZoned(wrap){
    if(!wrap) return;
    showElement(wrap);
    var inner = wrap.querySelector('.guide01-asset') || wrap.firstElementChild;
    if(!inner) return;
    showElement(inner);
    inner.classList.add('asset-enter');
    await wait(500);
    inner.classList.remove('asset-enter');
    inner.style.opacity = '1';
  }

  function animateZoneBouncePath(ctx, wrap, options){
    options = options || {};
    if(!wrap) return Promise.resolve();

    var from = parseZone(options.from || 'a1');
    var to = parseZone(options.to || 'g7');
    if(!from || !to) return Promise.resolve();

    var duration = options.duration || 29000;
    var bouncePx = options.bouncePx != null ? options.bouncePx : 16;
    var cycles = options.bounces != null ? options.bounces : 13;
    var scale = options.scale != null ? options.scale : 1.15;
    var inner = wrap.querySelector('.guide01-asset') || wrap.firstElementChild;
    var rafId = 0;

    wrap.classList.add('is-zone-travel');

    return new Promise(function(resolve){
      var start = performance.now();

      function finish(){
        if(rafId) cancelAnimationFrame(rafId);
        wrap.classList.remove('is-zone-travel');
        placeAtZone(wrap, options.to || 'g7');
        if(inner) inner.style.transform = 'scale(' + scale + ') translateY(0)';
        resolve();
      }

      function frame(now){
        if(ctx && MotionComponent.cancelled(ctx)) return finish();

        var t = Math.min(1, (now - start) / duration);
        var eased = t < 0.5
          ? 4 * t * t * t
          : 1 - Math.pow(-2 * t + 2, 3) / 2;

        wrap.style.setProperty('--zone-row', String(from.row + (to.row - from.row) * eased));
        wrap.style.setProperty('--zone-col', String(from.col + (to.col - from.col) * eased));

        if(inner){
          var bounce = Math.sin(t * Math.PI * 2 * cycles) * bouncePx;
          inner.style.transform = 'scale(' + scale + ') translateY(' + bounce.toFixed(2) + 'px)';
        }

        if(t < 1) rafId = requestAnimationFrame(frame);
        else finish();
      }

      rafId = requestAnimationFrame(frame);
    });
  }

  function addCard(canvas, id, html, extraCls){
    var div = document.createElement('div');
    div.id = id;
    div.className = 'g01-card is-hidden' + (extraCls ? ' ' + extraCls : '');
    div.innerHTML = html;
    canvas.appendChild(div);
    return div;
  }

  async function showCard(el){
    if(!el) return;
    showElement(el);
    await enterElement(el, { duration: 400 });
  }

  async function hideCard(el){
    if(!el) return;
    await exitElement(el, { duration: 250 });
  }

  function addMonthRow(canvas, id, labels, top){
    var row = document.createElement('div');
    row.id = id;
    row.className = 'g01-month-row is-hidden';
    row.style.top = top || '42%';
    labels.forEach(function(lb){
      var m = document.createElement('div');
      m.className = 'g01-month';
      m.textContent = lb;
      row.appendChild(m);
    });
    canvas.appendChild(row);
    return row;
  }

  async function activateMonths(row, indices){
    if(!row) return;
    showElement(row);
    var items = row.querySelectorAll('.g01-month');
    for(var i = 0; i < indices.length; i++){
      if(items[indices[i]]) items[indices[i]].classList.add('is-active');
      await wait(350);
    }
  }

  function mountReferral(canvas, meOpts, childOpts){
    var me = MemberUnit.mountMain(canvas, MotionComponent.merge({
      id: 'member-unit-main',
      suffix: 'main',
      includeBaseBadge: false,
      imageSrc: MemberUnit.IMGS.member,
      imageAlt: '나 · 추천인'
    }, meOpts || {}));
    me.classList.add('g01-me', 'is-hidden');

    var child = MemberUnit.create(MotionComponent.merge({
      id: 'member-unit-child',
      suffix: 'child',
      isChild: true,
      includeBaseBadge: false,
      imageSrc: MemberUnit.IMGS.people,
      imageAlt: '추천한 회원'
    }, childOpts || {}));
    child.classList.add('g01-child', 'refer-member', 'is-hidden');
    canvas.appendChild(child);

    var lblMe = document.createElement('div');
    lblMe.className = 'g01-member-label is-hidden';
    lblMe.id = 'g01-label-me';
    lblMe.style.left = '26%';
    lblMe.style.top = '68%';
    lblMe.textContent = '나 · 추천인';
    canvas.appendChild(lblMe);

    var lblChild = document.createElement('div');
    lblChild.className = 'g01-member-label is-hidden';
    lblChild.id = 'g01-label-child';
    lblChild.style.left = '74%';
    lblChild.style.top = '68%';
    lblChild.textContent = '추천한 회원';
    canvas.appendChild(lblChild);

    return { me: me, child: child, lblMe: lblMe, lblChild: lblChild };
  }

  async function showReferralPair(pair){
    await MotionMemberEnter.run({}, { target: pair.me.id, duration: 700 });
    showElement(pair.lblMe);
    await MotionMemberEnter.run({}, { target: pair.child.id, duration: 700 });
    showElement(pair.lblChild);
  }

  async function panelTitle(title, t, tl){
    await tl.wait(t);
    setSceneTitle(title);
    showElement('#scene-title-main');
    await slideUpElement('#scene-title-main', { duration: 400 });
  }

  async function panelDesc(text, t, tl){
    await tl.wait(t);
    setSceneDesc(text);
    showElement('#panel-scene-desc');
    await slideUpElement('#panel-scene-desc', { duration: 350 });
  }

  async function panelBullets(items, t, tl){
    await tl.wait(t);
    setSceneBullets(items);
    showElement('#scene-bullets');
    await MotionPanelRevealBullets.run({}, { initialDelay: 0, gap: 180, itemDuration: 380 });
  }

  async function panelSwapDesc(text, t, tl){
    await tl.wait(t);
    await exitElement('#panel-scene-desc', { duration: 200 });
    setSceneDesc(text);
    showElement('#panel-scene-desc');
    await slideUpElement('#panel-scene-desc', { duration: 300 });
  }

  async function panelAddBullet(text, t, tl, existing){
    await tl.wait(t);
    var items = existing.slice();
    items.push(text);
    setSceneBullets(items);
    showElement('#scene-bullets');
    var last = document.querySelector('#scene-bullets .bullet-item:last-child');
    if(last){
      showElement(last);
      await slideUpElement(last, { duration: 350 });
    }
  }

  async function panelHideBullets(t, tl){
    await tl.wait(t);
    await exitElement('#scene-bullets', { duration: 200 });
    hideElement('#scene-bullets');
  }

  async function endScene(ctx, canvas, tl){
    var endAt = Math.max(0, (ctx.sceneDuration || 30000) - 1000);
    await tl.wait(endAt);
    hideElement('#scene-bullets');
    hideElement('#panel-scene-desc');
    hideElement('#scene-title-main');
    await MotionCanvasFadeOut.run(ctx, { canvas: canvas, duration: 450, clear: true });
    await tl.finish();
  }

  function disclaimer(canvas, text){
    var el = document.createElement('div');
    el.className = 'g01-disclaimer';
    el.textContent = text || '구독 방식 예시';
    canvas.appendChild(el);
    return el;
  }

  var ATTACH_SLOT_KEYS = ['autoship', 'rank', 'base', 'bonus'];

  function mountMemberAtZone(canvas, elId, zone){
    var wrap = document.createElement('div');
    wrap.id = elId;
    wrap.className = 'g01-zone-wrap g01-member-unit is-hidden';
    placeAtZone(wrap, zone);

    var stack = document.createElement('div');
    stack.className = 'g01-member-stack';

    var icon = cloneTemplate('member_icon');
    if(icon){
      icon.id = elId + '-icon';
      stack.appendChild(icon);
    }

    var slots = document.createElement('div');
    slots.className = 'g01-member-slots';
    for(var i = 0; i < ATTACH_SLOT_KEYS.length; i++){
      var key = ATTACH_SLOT_KEYS[i];
      var slot = document.createElement('div');
      slot.className = 'g01-attach-slot';
      slot.setAttribute('data-slot', key);
      slot.id = elId + '-slot-' + key;
      slots.appendChild(slot);
    }
    stack.appendChild(slots);
    wrap.appendChild(stack);
    canvas.appendChild(wrap);
    return wrap;
  }

  function prepareMemberAttach(wrap, spec){
    if(!wrap || !spec) return null;
    var slot = wrap.querySelector('[data-slot="' + spec.slot + '"]');
    if(!slot) return null;

    var attached = cloneTemplate(spec.closedTemplate);
    if(!attached) return null;
    attached.id = (wrap.id || 'member') + '-attached-' + spec.slot;
    attached.classList.add('g01-attached-badge', 'is-hidden');
    slot.appendChild(attached);
    return { slot: slot, attached: attached, openTemplate: spec.openTemplate };
  }

  async function showMemberWrap(wrap){
    if(!wrap) return;
    showElement(wrap);
    var icon = wrap.querySelector('.member_icon');
    if(!icon) return;
    icon.classList.add('asset-enter');
    await wait(500);
    icon.classList.remove('asset-enter');
  }

  async function flyAttachToMember(ctx, canvas, plan, options){
    options = options || {};
    if(!plan || !plan.attached || !canvas) return;

    var flyTpl = plan.closedTemplate || badgeClosedTemplateId(plan.openTemplate);
    var flyer = cloneTemplate(flyTpl);
    if(!flyer) return;

    badgeToClosed(flyer);

    flyer.classList.add('g01-fly-badge', 'guide01-asset');
    canvas.appendChild(flyer);

    var canvasRect = canvas.getBoundingClientRect();
    var centerX = canvasRect.width / 2;
    var centerY = canvasRect.height / 2;

    plan.attached.classList.remove('is-hidden');
    plan.attached.style.visibility = 'hidden';
    var targetRect = plan.attached.getBoundingClientRect();
    plan.attached.style.visibility = '';
    plan.attached.classList.add('is-hidden');

    var endX = targetRect.left + targetRect.width / 2 - canvasRect.left;
    var endY = targetRect.top + targetRect.height / 2 - canvasRect.top;
    var flyDur = options.duration || 900;
    var fadeDur = options.fadeDuration || 280;

    flyer.style.left = centerX + 'px';
    flyer.style.top = centerY + 'px';
    flyer.style.opacity = '1';
    flyer.style.transition = 'none';
    flyer.style.transform = 'translate(-50%,-50%) scale(1.15)';
    void flyer.offsetWidth;

    var flyRect = flyer.getBoundingClientRect();
    var targetScale = targetRect.width / Math.max(flyRect.width, 1);

    flyer.style.transition =
      'left ' + flyDur + 'ms var(--ease-smooth), ' +
      'top ' + flyDur + 'ms var(--ease-smooth), ' +
      'transform ' + flyDur + 'ms var(--ease-smooth)';

    await wait(40);
    if(ctx && MotionComponent.cancelled(ctx)) return;

    flyer.style.left = endX + 'px';
    flyer.style.top = endY + 'px';
    flyer.style.transform = 'translate(-50%,-50%) scale(' + targetScale + ')';
    await wait(flyDur);

    if(ctx && MotionComponent.cancelled(ctx)) return;

    flyer.style.transition = 'opacity ' + fadeDur + 'ms var(--ease-smooth)';
    flyer.style.opacity = '0';
    await wait(fadeDur);
    if(flyer.parentNode) flyer.parentNode.removeChild(flyer);

    showElement(plan.attached);
    await softAcquireElement(plan.attached, {
      duration: options.acquireDuration || 520,
      glow: options.glow !== false
    });

    await unfoldZonedBadge(plan.attached, {
      unfoldDuration: options.unfoldDuration || 620
    });
  }

  async function runMemberAttachSequence(ctx, canvas, plans, tl, schedule){
    schedule = schedule || [];
    for(var i = 0; i < plans.length; i++){
      var when = schedule[i] != null ? schedule[i] : (800 + i * 6500);
      await tl.wait(when);
      if(ctx && MotionComponent.cancelled(ctx)) return;
      await flyAttachToMember(ctx, canvas, plans[i], { duration: 900 });
    }
  }

  function badgeSetMode(el, mode){
    if(!el) return el;
    var suffix = mode === 'c' ? '_c' : '_o';
    for(var i = 0; i < BADGE_BASES.length; i++){
      var base = BADGE_BASES[i];
      if(el.classList.contains(base) || el.classList.contains(base + '_o') || el.classList.contains(base + '_c')){
        el.classList.remove(base, base + '_o', base + '_c');
        el.classList.add(base + suffix);
        break;
      }
    }
    return el;
  }

  function badgeToOpen(el){ return badgeSetMode(el, 'o'); }
  function badgeToClosed(el){ return badgeSetMode(el, 'c'); }

  async function unfoldZonedBadge(wrap, opts){
    opts = opts || {};
    var badge = resolveZonedBadge(wrap);
    if(!badge) return;
    var unfoldMs = opts.unfoldDuration != null ? opts.unfoldDuration : 620;
    var dur = typeof sceneDur === 'function' ? sceneDur(unfoldMs) : unfoldMs;
    if(typeof G01BadgeFold !== 'undefined'){
      await G01BadgeFold.unfold(badge, { duration: dur });
    } else {
      badgeToOpen(badge);
    }
  }

  /* 접힌(_c) 상태로 등장 → 펼침까지 한 세트 */
  async function enterZonedBadge(wrap, opts){
    opts = opts || {};
    if(!wrap) return;
    var badge = resolveZonedBadge(wrap);
    if(badge) badgeToClosed(badge);
    await fadeZoned(wrap, true, opts);
    if(badge) await unfoldZonedBadge(wrap, opts);
  }

  return {
    CANVAS_CLS: CANVAS_CLS,
    setSceneDesc: setSceneDesc,
    timeline: timeline,
    resetScene: resetScene,
    mountStage: mountStage,
    addAsset: addAsset,
    parseZone: parseZone,
    placeAtZone: placeAtZone,
    addZonedAsset: addZonedAsset,
    addZonedBadge: addZonedBadge,
    badgeClosedTemplateId: badgeClosedTemplateId,
    mountZonedNode: mountZonedNode,
    zonedInner: zonedInner,
    zoneCenterPx: zoneCenterPx,
    fadeZoned: fadeZoned,
    moveZoned: moveZoned,
    getZonedScale: getZonedScale,
    setZonedScale: setZonedScale,
    startIdleFloat: startIdleFloat,
    stopIdleFloat: stopIdleFloat,
    addZonedCalendar: addZonedCalendar,
    addZonedBonusPlate: addZonedBonusPlate,
    mountConnectorSvg: mountConnectorSvg,
    linkZones: linkZones,
    revealConnector: revealConnector,
    hideConnectors: hideConnectors,
    clearConnectorSvg: clearConnectorSvg,
    popScaleZoned: popScaleZoned,
    panelInitBullets: panelInitBullets,
    panelFlashBullet: panelFlashBullet,
    panelBulletTimeline: panelBulletTimeline,
    finishSceneHold: finishSceneHold,
    showAsset: showAsset,
    showZoned: showZoned,
    animateZoneBouncePath: animateZoneBouncePath,
    mountMemberAtZone: mountMemberAtZone,
    prepareMemberAttach: prepareMemberAttach,
    showMemberWrap: showMemberWrap,
    flyAttachToMember: flyAttachToMember,
    runMemberAttachSequence: runMemberAttachSequence,
    addCard: addCard,
    showCard: showCard,
    hideCard: hideCard,
    addMonthRow: addMonthRow,
    activateMonths: activateMonths,
    mountReferral: mountReferral,
    showReferralPair: showReferralPair,
    panelTitle: panelTitle,
    panelDesc: panelDesc,
    panelBullets: panelBullets,
    panelSwapDesc: panelSwapDesc,
    panelAddBullet: panelAddBullet,
    panelHideBullets: panelHideBullets,
    endScene: endScene,
    disclaimer: disclaimer,
    badgeSetMode: badgeSetMode,
    badgeToOpen: badgeToOpen,
    badgeToClosed: badgeToClosed,
    resolveZonedBadge: resolveZonedBadge,
    unfoldZonedBadge: unfoldZonedBadge,
    enterZonedBadge: enterZonedBadge
  };
})();
</script>
