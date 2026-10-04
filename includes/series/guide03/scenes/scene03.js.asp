<script>
var Guide03Scene03 = defineScene({
  id: Guide03Scene03Config.id,
  title: Guide03Scene03Config.title,
  duration: Guide03Scene03Config.duration,
  mediaSequence: Guide03Scene03Config.media.sequence,
  mediaFallbackMs: Guide03Scene03Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene03Config.panelCls);
    if(typeof Guide03Scene03Layout !== 'undefined') Guide03Scene03Layout.unbind();
    Guide03.resetScene(Guide03Scene03Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene03Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene03Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene03Config.canvasCls);
    assets = setupGuide03Scene03(canvas);

    await Promise.all([
      runGuide03Scene03(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene03Config.panel.title,
        Guide03Scene03Config.panel.bullets,
        guide03Scene03PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene03Config.duration);
  }
});

function guide03Scene03Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide03Scene03Reveal(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-enter');
  if(typeof Guide03Scene03Layout !== 'undefined') Guide03Scene03Layout.schedule();
  await wait(760);
  el.classList.remove('g03-enter');
}

async function guide03Scene03ShowBadge(el){
  if(!el) return;
  showElement(el);
  el.classList.add('g03-fade');
  if(typeof Guide03Scene03Layout !== 'undefined') Guide03Scene03Layout.schedule();
  await wait(760);
  el.classList.remove('g03-fade');
}

async function guide03Scene03FoldAway(wrap){
  var badge = wrap && wrap.querySelector('.autoship_icon_o');
  var track = badge && badge.querySelector('.g03-fold-track');
  var text = badge && badge.querySelector('.autoship_text');
  if(track && text){
    text.style.transition = 'opacity 240ms cubic-bezier(.25,.1,.25,1)';
    track.style.transition = 'max-width 560ms cubic-bezier(.22,1,.36,1)';
    text.style.opacity = '0';
    await wait(120);
    track.style.maxWidth = '0px';
    await wait(560);
  }
  wrap.style.transition = 'opacity 280ms ease';
  wrap.style.opacity = '0';
  await wait(300);
  hideElement(wrap);
}

async function runGuide03Scene03(tl, assets, ctx){
  var T = Guide03Scene03Config.T;
  var at = function(ms){ return guide03Scene03AtMain(ms, ctx); };

  await tl.wait(T.member);
  if(guide03Scene03Cancelled(ctx)) return;
  await guide03Scene03Reveal(assets.member);

  await tl.wait(T.badge);
  if(guide03Scene03Cancelled(ctx)) return;
  await guide03Scene03ShowBadge(assets.badge);

  await tl.wait(at(T.circle));
  if(guide03Scene03Cancelled(ctx)) return;
  await guide03Scene03Reveal(assets.sep);

  await tl.wait(at(T.autoship));
  if(guide03Scene03Cancelled(ctx)) return;
  await guide03Scene01UnfoldChip(assets.autoship);
  if(typeof Guide03Scene03Layout !== 'undefined') Guide03Scene03Layout.schedule();

  await tl.wait(at(T.merge));
  if(guide03Scene03Cancelled(ctx)) return;
  await guide03Scene03FoldAway(assets.autoship);
  if(guide03Scene03Cancelled(ctx)) return;
  assets.sep.classList.add('is-slice');
  await guide03Scene03Reveal(assets.sliceLabel);
}
</script>
