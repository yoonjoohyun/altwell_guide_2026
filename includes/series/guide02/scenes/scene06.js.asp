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

function guide02Scene06Center(el, root, scale){
  var a = el.getBoundingClientRect();
  var b = root.getBoundingClientRect();
  return {
    x: (a.left + a.width / 2 - b.left) / scale,
    y: (a.top + a.height / 2 - b.top) / scale
  };
}

async function guide02Scene06Fly(assets, fromEl, toEl){
  var flyer = assets.flyer;
  var scale = parseFloat(assets.inner.style.getPropertyValue('--group-scale')) || 1;
  var start;
  var end;
  if(!flyer || !fromEl || !toEl) return;
  start = guide02Scene06Center(fromEl, assets.stage, scale);
  end = guide02Scene06Center(toEl, assets.stage, scale);
  flyer.textContent = '50만 승급EP';
  flyer.style.transition = 'none';
  flyer.style.left = start.x + 'px';
  flyer.style.top = start.y + 'px';
  flyer.style.opacity = '1';
  flyer.style.transform = 'translate(-50%, -50%) scale(1)';
  showElement(flyer);
  hideElement(fromEl);
  await wait(420);
  flyer.style.transition = 'left 1100ms cubic-bezier(.16,1,.3,1), top 1100ms cubic-bezier(.16,1,.3,1), transform 1100ms cubic-bezier(.16,1,.3,1), opacity 420ms ease 760ms';
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
    await wait(900);
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
  await guide02Scene06Reveal(assets.leftChip);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Fly(assets, assets.leftChip, assets.head);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.headChip);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06LevelUp(assets);

  await tl.wait(T.right);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.rightPack);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Reveal(assets.rightChip);
  if(guide02Scene06Cancelled(ctx)) return;
  await guide02Scene06Fly(assets, assets.rightChip, assets.headChip);
  if(guide02Scene06Cancelled(ctx)) return;
  assets.headChip.classList.add('is-total');
  assets.headChip.innerHTML = '<span>총 100만</span><span>승급EP 혜택</span>';
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
