<script>
var Guide02Scene06 = defineScene({
  id: Guide02Scene06Config.id,
  title: Guide02Scene06Config.title,
  duration: Guide02Scene06Config.duration,
  mediaSequence: Guide02Scene06Config.media.sequence,
  mediaFallbackMs: Guide02Scene06Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene06Config.panelCls);
    if(typeof Guide02Scene06Layout !== 'undefined') Guide02Scene06Layout.unbind();
    Guide02.resetScene(Guide02Scene06Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene06Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene06Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene06Config.canvasCls);
    assets = setupGuide02Scene06(canvas);

    await Promise.all([
      runGuide02Scene06(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene06Config.panel.title,
        Guide02Scene06Config.panel.bullets,
        guide02Scene06PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene06Config.duration);
  }
});

function guide02Scene06Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene06Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g02-enter');
  if(typeof Guide02Scene06Layout !== 'undefined') Guide02Scene06Layout.schedule();
  await wait(860);
  el.classList.remove('g02-enter');
}

async function guide02Scene06RevealPurchaseDone(el){
  if(!el) return;
  showElement(el);
  el.classList.remove('is-leaving');
  el.classList.add('is-shown', 'g02-enter');
  if(typeof Guide02Scene06Layout !== 'undefined') Guide02Scene06Layout.schedule();
  await wait(860);
  el.classList.remove('g02-enter');
  await wait(700);
}

async function guide02Scene06DismissPurchaseDone(el){
  if(!el) return;
  el.classList.add('is-leaving');
  el.classList.remove('is-shown');
  if(typeof Guide02Scene06Layout !== 'undefined') Guide02Scene06Layout.schedule();
  await wait(520);
  el.classList.remove('is-leaving');
  hideElement(el);
  if(typeof Guide02Scene06Layout !== 'undefined') Guide02Scene06Layout.schedule();
}

function guide02Scene06Center(el, root, scale){
  var a = el.getBoundingClientRect();
  var b = root.getBoundingClientRect();
  return {
    x: (a.left + a.width / 2 - b.left) / scale,
    y: (a.top + a.height / 2 - b.top) / scale
  };
}

function guide02Scene06MemberHeadChipPoint(assets, scale){
  var stack = assets.member && assets.member.querySelector('.g02-s06-member-stack');
  var anchor = assets.memberChipAnchor;
  var b = assets.stage.getBoundingClientRect();
  var a;
  if(anchor && anchor.offsetParent !== null){
    a = anchor.getBoundingClientRect();
    if(a.width > 0 || a.height > 0){
      return {
        x: (a.left + a.width / 2 - b.left) / scale,
        y: (a.top + a.height / 2 - b.top) / scale
      };
    }
  }
  if(!stack) return { x: 0, y: 0 };
  a = stack.getBoundingClientRect();
  return {
    x: (a.left + a.width / 2 - b.left) / scale,
    y: (a.top - b.top) / scale - 2
  };
}

async function guide02Scene06Fly(assets, fromEl, toEl, opts){
  var flyer = assets.flyer;
  var scale = parseFloat(assets.inner.style.getPropertyValue('--group-scale')) || 1;
  var start;
  var end;
  if(!flyer || !fromEl) return;
  start = guide02Scene06Center(fromEl, assets.stage, scale);
  if(opts && opts.toMemberHead){
    end = guide02Scene06MemberHeadChipPoint(assets, scale);
  }else if(toEl){
    end = guide02Scene06Center(toEl, assets.stage, scale);
  }else{
    return;
  }
  flyer.textContent = '50만 승급E.P';
  flyer.style.transition = 'none';
  flyer.style.left = start.x + 'px';
  flyer.style.top = start.y + 'px';
  flyer.style.opacity = '1';
  flyer.style.transform = 'translate(-50%, -50%) scale(1)';
  showElement(flyer);
  hideElement(fromEl);
  await wait(420);
  flyer.style.transition = 'left 1100ms ease-in-out, top 1100ms ease-in-out, transform 1100ms ease-in-out, opacity 420ms ease-in-out 760ms';
  flyer.style.left = end.x + 'px';
  flyer.style.top = end.y + 'px';
  flyer.style.opacity = '0';
  flyer.style.transform = 'translate(-50%, -50%) scale(.86)';
  await wait(1160);
  hideElement(flyer);
}

async function guide02Scene06LevelUp(assets){
  if(assets.promote){
    showElement(assets.promote);
    void assets.promote.offsetWidth;
    assets.promote.classList.add('is-play');
  }
  if(assets.rankD){
    assets.rankD.classList.add('is-levelout');
    await wait(280);
    hideElement(assets.rankD);
  }
  if(assets.rankP){
    showElement(assets.rankP);
    assets.rankP.classList.add('is-levelin');
    await wait(980);
  }
}

async function runGuide02Scene06(tl, assets, ctx){
  var T = Guide02Scene06Config.T;
  var i;

  await tl.wait(T.member);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.member);

  await tl.wait(T.left);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.leftPack);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06RevealPurchaseDone(assets.leftPurchaseDone);
  if(guide02Scene06Cancelled(ctx)) return;
  await Promise.all([
    guide02Scene06DismissPurchaseDone(assets.leftPurchaseDone),
    guide02Scene06Reveal(assets.leftChip)
  ]);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Fly(assets, assets.leftChip, null, { toMemberHead: true });
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.headChip);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06LevelUp(assets);

  await tl.wait(T.right);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.rightPack);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06RevealPurchaseDone(assets.rightPurchaseDone);
  if(guide02Scene06Cancelled(ctx)) return;
  await Promise.all([
    guide02Scene06DismissPurchaseDone(assets.rightPurchaseDone),
    guide02Scene06Reveal(assets.rightChip)
  ]);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Fly(assets, assets.rightChip, assets.headChip);
  if(guide02Scene06Cancelled(ctx)) return;
  assets.headChip.classList.add('is-total');
  assets.headChip.innerHTML = '<span>총 100만</span><span>승급E.P 혜택</span>';
  assets.headChip.classList.remove('is-bump');
  void assets.headChip.offsetWidth;
  assets.headChip.classList.add('is-bump');

  await tl.wait(T.panel);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.note);

  for(i = 0; i < assets.lines.length; i++){
    await tl.wait(T.lines[i]);
    if(guide02Scene06Cancelled(ctx)) return;
    assets.lines[i].classList.add('is-on');
  }
}
</script>
