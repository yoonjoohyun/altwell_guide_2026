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
    MotionCanvasStandardStage.run({ canvas: canvas, sceneClass: cls });
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

  async function showAsset(el){
    if(!el) return;
    showElement(el);
    el.classList.add('asset-enter');
    await wait(500);
    el.classList.remove('asset-enter');
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

  return {
    CANVAS_CLS: CANVAS_CLS,
    setSceneDesc: setSceneDesc,
    timeline: timeline,
    resetScene: resetScene,
    mountStage: mountStage,
    addAsset: addAsset,
    showAsset: showAsset,
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
    disclaimer: disclaimer
  };
})();
</script>
