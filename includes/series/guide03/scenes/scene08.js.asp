<script>
var Guide03Scene08 = defineScene({
  id: Guide03Scene08Config.id,
  title: Guide03Scene08Config.title,
  duration: Guide03Scene08Config.duration,
  mediaSequence: Guide03Scene08Config.media.sequence,
  mediaFallbackMs: Guide03Scene08Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide03Scene08Config.panelCls);
    if(typeof Guide03Scene08Layout !== 'undefined') Guide03Scene08Layout.unbind();
    Guide03.resetScene(Guide03Scene08Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide03Scene08Config.panelCls);
    tl = Guide03.timeline(ctx);
    Guide03.resetScene(Guide03Scene08Config.canvasCls);
    Guide03.mountStage(canvas, Guide03Scene08Config.canvasCls);
    assets = setupGuide03Scene08(canvas);

    await Promise.all([
      runGuide03Scene08(tl, assets, ctx),
      Guide03.panelBulletTimeline(
        tl,
        Guide03Scene08Config.panel.title,
        Guide03Scene08Config.panel.bullets,
        guide03Scene08PanelFlashes(ctx)
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide03.finishSceneHold(tl, ctx.sceneDuration || Guide03Scene08Config.duration);
  }
});

function guide03Scene08Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function guide03Scene08Fit(){
  if(typeof Guide03Scene08Layout !== 'undefined') Guide03Scene08Layout.schedule();
}

async function guide03Scene08Unfold(el){
  await guide03Scene01UnfoldChip(el);
  guide03Scene08Fit();
}

async function guide03Scene08Gather(assets){
  var items = assets.pieces.filter(function(el){ return !!el; });
  var scale = Guide03Scene08Layout.scale();
  var first;
  var last;
  var mid;
  var i;
  var box;
  var dy;
  var turn;
  if(!items.length) return;
  first = items[0].getBoundingClientRect();
  last = items[items.length - 1].getBoundingClientRect();
  mid = (first.top + last.bottom) / 2;
  for(i = 0; i < items.length; i++){
    box = items[i].getBoundingClientRect();
    dy = (mid - (box.top + box.height / 2)) / scale;
    turn = (i % 2 === 0 ? -1 : 1) * (14 + i * 6);
    items[i].style.transition = 'transform 720ms cubic-bezier(.45,0,.2,1), opacity 720ms ease';
    items[i].style.transform = 'translateY(' + dy + 'px) rotate(' + turn + 'deg) scale(.28)';
    items[i].style.opacity = '0';
  }
  await wait(740);
  hideElement(assets.list);
  if(assets.hold) assets.hold.classList.add('is-orb');
}

async function runGuide03Scene08(tl, assets, ctx){
  var T = Guide03Scene08Config.T;
  var at = function(ms){ return guide03Scene08AtMain(ms, ctx); };
  var i;

  await tl.wait(T.badge);
  if(guide03Scene08Cancelled(ctx)) return;
  await guide03Scene08Unfold(assets.badge);

  for(i = 0; i < T.bonuses.length; i++){
    await tl.wait(at(T.bonuses[i]));
    if(guide03Scene08Cancelled(ctx)) return;
    await guide03Scene08Unfold(assets.pieces[i]);
  }

  await tl.wait(at(T.track));
  if(guide03Scene08Cancelled(ctx)) return;
  showElement(assets.pieces[3]);
  assets.pieces[3].classList.add('g03-enter');
  guide03Scene08Fit();
  await wait(760);
  assets.pieces[3].classList.remove('g03-enter');

  await tl.wait(at(T.gather));
  if(guide03Scene08Cancelled(ctx)) return;
  await guide03Scene08Gather(assets);
  showElement(assets.orb);
  assets.orb.classList.add('is-in');
  guide03Scene08Fit();
  await wait(620);
  if(assets.orbText) assets.orbText.classList.add('is-on');
  await wait(460);
}
</script>
