<script>
var Guide03Scene06 = defineScene({
  id: Guide03Scene06Config.id,
  title: Guide03Scene06Config.title,
  duration: Guide03Scene06Config.duration,
  mediaSequence: Guide03Scene06Config.media.sequence,
  mediaFallbackMs: Guide03Scene06Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene06Config.panelCls);
    if(typeof Guide03Scene06Layout !== 'undefined') Guide03Scene06Layout.unbind();
    Guide03.resetScene(Guide03Scene06Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene06Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene06Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene06Config.canvasCls);
    assets = setupGuide03Scene06(canvas);

    await Promise.all([
      runGuide03Scene06(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene06Config.panel.title,
        Guide03Scene06Config.panel.bullets,
        guide03Scene06PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene06Config.duration);
  }
});

function guide03Scene06Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function guide03Scene06Fit(){
  if(typeof Guide03Scene06Layout !== 'undefined') Guide03Scene06Layout.schedule();
}

async function guide03Scene06Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  guide03Scene06Fit();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene06Open(slot){
  if(!slot) return;
  slot.classList.add('is-open');
  guide03Scene06Fit();
  await wait(740);
}

async function guide03Scene06Jump(icon){
  if(!icon) return;
  icon.classList.add('is-jump');
  await wait(680);
  icon.classList.remove('is-jump');
}

async function runGuide03Scene06(tl, assets, ctx){
  var T = Guide03Scene06Config.T;
  var at = function(ms){ return guide03Scene06AtMain(ms, ctx); };
  var jumpOrder = [assets.members[1], assets.members[2], assets.members[0]];
  var i;

  await tl.wait(T.board);
  if(guide03Scene06Cancelled(ctx)) return;
  await guide03Scene06Reveal(assets.board);

  await tl.wait(T.self);
  if(guide03Scene06Cancelled(ctx)) return;
  await guide03Scene06Open(assets.members[0].slot);

  for(i = 0; i < assets.members.length - 1; i++){
    await tl.wait(T.partners[i]);
    if(guide03Scene06Cancelled(ctx)) return;
    await guide03Scene06Open(assets.members[i + 1].slot);
  }
  if(guide03Scene06Cancelled(ctx)) return;
  guide03Scene01DrawLines(assets, true);

  for(i = 0; i < assets.seps.length; i++){
    await tl.wait(at(T.seps[i]));
    if(guide03Scene06Cancelled(ctx)) return;
    await guide03Scene06Reveal(assets.seps[i]);
    guide03Scene01DrawLines(assets, false);
  }

  await tl.wait(at(T.sum));
  if(guide03Scene06Cancelled(ctx)) return;
  await guide03Scene06Reveal(assets.sum);

  for(i = 0; i < jumpOrder.length; i++){
    await tl.wait(at(T.jumps[i]));
    if(guide03Scene06Cancelled(ctx)) return;
    await guide03Scene06Jump(jumpOrder[i].icon);
  }
}
</script>
