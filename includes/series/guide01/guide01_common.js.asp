<script>
/* guide01 공통 — 타임라인·패널·에셋·DOM 헬퍼 */
var Guide01 = (function(){
  var CANVAS_CLS = 'guide01-canvas';

  function setSceneDesc(text){
    var el = document.getElementById('panel-scene-desc');
    if(el) el.textContent = text;
  }

  function timeline(ctx){
    var elapsed = 0;
    return {
      wait: async function(ms){
        if(ms > elapsed){
          await wait(ms - elapsed);
          elapsed = ms;
        }
        if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
      },
      finish: async function(){
        var total = (ctx && ctx.sceneDuration) || elapsed;
        if(elapsed < total){
          await wait(total - elapsed);
          elapsed = total;
          if(ctx && ctx.reportProgress) ctx.reportProgress(elapsed);
        }
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

  function addZonedAsset(canvas, templateId, elId, zone){
    var node = cloneTemplate(templateId);
    if(!node) return null;

    var wrap = document.createElement('div');
    wrap.id = elId;
    wrap.className = 'g01-zone-wrap is-hidden';
    placeAtZone(wrap, zone);

    node.classList.add('guide01-asset');
    wrap.appendChild(node);
    canvas.appendChild(wrap);
    return wrap;
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

  var BADGE_BASES = ['base_business_icon', 'autoship_icon', 'recommend_bonus_icon'];

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
    showAsset: showAsset,
    showZoned: showZoned,
    animateZoneBouncePath: animateZoneBouncePath,
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
    badgeToClosed: badgeToClosed
  };
})();
</script>
