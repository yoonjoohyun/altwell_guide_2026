<script>
var Guide03Scene04 = defineScene({
  id: Guide03Scene04Config.id,
  title: Guide03Scene04Config.title,
  duration: Guide03Scene04Config.duration,
  mediaSequence: Guide03Scene04Config.media.sequence,
  mediaFallbackMs: Guide03Scene04Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene04Config.panelCls);
    if(typeof Guide03Scene04Layout !== 'undefined') Guide03Scene04Layout.unbind();
    Guide03.resetScene(Guide03Scene04Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene04Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene04Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene04Config.canvasCls);
    assets = setupGuide03Scene04(canvas);

    await Promise.all([
      runGuide03Scene04(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene04Config.panel.title,
        Guide03Scene04Config.panel.bullets,
        guide03Scene04PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene04Config.duration);
  }
});

function guide03Scene04Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function guide03Scene04Fit(){
  if(typeof Guide03Scene04Layout !== 'undefined') Guide03Scene04Layout.schedule();
}

async function guide03Scene04Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  guide03Scene04Fit();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene04Open(slot){
  if(!slot) return;
  slot.classList.add('is-open');
  guide03Scene04Fit();
  await wait(700);
}

async function guide03Scene04Clear(phase){
  phase.classList.add('is-leaving');
  await wait(420);
  hideElement(phase);
  guide03Scene04Fit();
}

async function guide03Scene04Promote(assets){
  if(assets.spIcon) assets.spIcon.classList.add('is-jump');
  await wait(260);
  if(assets.spRank){
    assets.spRank.classList.add('g03-slot');
    hideElement(assets.spRank);
  }
  if(assets.fcRank){
    showElement(assets.fcRank);
    assets.fcRank.classList.add('is-pop');
  }
  await wait(420);
  if(assets.spIcon) assets.spIcon.classList.remove('is-jump');
}

async function guide03Scene04Exit(assets){
  var col = assets.spCol;
  var panel = assets.panel2;
  var row = col && col.parentElement;
  var from;
  var pad;
  var to;
  var left;
  var top;
  if(!col || !panel || !row) return;
  from = panel.offsetWidth;
  pad = from - row.offsetWidth;
  if(panel.parentElement && panel.parentElement.parentElement){
    panel.parentElement.parentElement.style.alignItems = 'flex-start';
  }
  panel.style.width = from + 'px';
  panel.style.boxSizing = 'border-box';
  row.style.position = 'relative';
  left = col.offsetLeft;
  top = col.offsetTop;
  col.style.position = 'absolute';
  col.style.left = left + 'px';
  col.style.top = top + 'px';
  to = (assets.jpCol ? assets.jpCol.offsetWidth : 0) + pad;
  if(to < 80) to = 80;
  panel.style.transition = 'width 720ms cubic-bezier(.16,1,.3,1)';
  col.style.transition = 'transform 720ms cubic-bezier(.16,1,.3,1)';
  await wait(40);
  panel.style.width = to + 'px';
  col.style.transform = 'translateX(56px)';
  guide03Scene04Reveal(assets.loss);
  await wait(760);
}

async function runGuide03Scene04(tl, assets, ctx){
  var T = Guide03Scene04Config.T;
  var at = function(ms){ return guide03Scene04AtMain(ms, ctx); };
  var i;

  await tl.wait(T.hero);
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.hero);

  await tl.wait(T.heroNote);
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.heroNote);

  await tl.wait(at(T.panelA));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.panelA);

  for(i = 0; i < assets.ranks.length; i++){
    await tl.wait(at(T.ranks[i]));
    if(guide03Scene04Cancelled(ctx)) return;
    await guide03Scene04Open(assets.ranks[i]);
  }

  await tl.wait(at(T.gepLine));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Open(assets.gep);

  await tl.wait(at(T.clear));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Clear(assets.phaseA);

  await tl.wait(at(T.panel1));
  if(guide03Scene04Cancelled(ctx)) return;
  showElement(assets.phaseB);
  await guide03Scene04Reveal(assets.panel1);

  await tl.wait(at(T.pair1));
  if(guide03Scene04Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene04Reveal(assets.pair1[0]),
    guide03Scene04Reveal(assets.pair1[1])
  ]);

  for(i = 0; i < assets.autos.length; i++){
    await tl.wait(at(T.autos[i]));
    if(guide03Scene04Cancelled(ctx)) return;
    await guide03Scene04Reveal(assets.autos[i]);
  }

  await tl.wait(at(T.panel2));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.panel2);

  await tl.wait(at(T.pair2));
  if(guide03Scene04Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene04Reveal(assets.pair2[0]),
    guide03Scene04Reveal(assets.pair2[1])
  ]);

  await tl.wait(at(T.seps));
  if(guide03Scene04Cancelled(ctx)) return;
  await Promise.all([
    guide03Scene04Reveal(assets.seps[0]),
    guide03Scene04Reveal(assets.seps[1])
  ]);

  await tl.wait(at(T.tracks[0]));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.track1);

  await tl.wait(at(T.tracks[1]));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Reveal(assets.track2);

  await tl.wait(at(T.promote));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Promote(assets);

  await tl.wait(at(T.exit));
  if(guide03Scene04Cancelled(ctx)) return;
  await guide03Scene04Exit(assets);
}
</script>
