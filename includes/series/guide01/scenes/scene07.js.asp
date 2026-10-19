<script>
/* guide01 Scene 07 — 오토십 핵심 요약 */
var Guide01Scene07 = defineScene({
  id: Scene07Config.id,
  title: Scene07Config.title,
  duration: Scene07Config.duration,
  mediaSequence: Scene07Config.media.sequence,
  mediaFallbackMs: Scene07Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene07-panel');
    if(typeof Scene07Layout !== 'undefined') Scene07Layout.unbindResize();
    Guide01.resetScene(Scene07Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;

    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene07-panel');

    tl = Guide01.timeline(ctx);
    Guide01.resetScene(Scene07Config.canvasCls);
    Guide01.mountStage(canvas, Scene07Config.canvasCls);
    assets = setupScene07Assets(canvas);

    await Promise.all([
      runScene07Motion(tl, assets, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene07Config.panel.title,
        Scene07Config.panel.bullets,
        scene07PanelFlashes()
      )
    ]);

    if(scene07Cancelled(ctx)) return;
    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene07Config.duration);
  }
});

function scene07Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene07LayoutSettleMs(){
  return (Scene07Config.motion && Scene07Config.motion.layoutTransition) || 480;
}

function scene07Relayout(immediate){
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(!!immediate);
}

async function scene07Reveal(el, floatIt){
  var dur = (Scene07Config.motion.FADE && Scene07Config.motion.FADE.duration) || 720;
  var inner;
  if(!el) return;
  inner = el._float;
  showElement(el);
  if(inner) inner.classList.add('s07-float-in');
  else el.classList.add('s07-fade-in');
  scene07Relayout(false);
  await wait(dur);
  if(inner) inner.classList.remove('s07-float-in');
  el.classList.remove('s07-fade-in');
  if(floatIt && inner) Guide01.startIdleFloat(el);
}

async function runScene07Motion(tl, assets, ctx){
  var T = Scene07Config.T;
  var at = function(ms){ return scene07AtMain(ms, ctx); };
  var i;

  await tl.wait(T.autoship);
  if(scene07Cancelled(ctx)) return;
  showElement(assets.group);
  await Guide01.enterZonedBadge(assets.autoship, scene07BadgeEnter());
  Guide01.startIdleFloat(assets.autoship);
  scene07Relayout(false);

  await tl.wait(at(T.member));
  if(scene07Cancelled(ctx)) return;
  showElement(assets.stage);
  showElement(assets.member);
  if(typeof scene03StartMemberIdle === 'function') scene03StartMemberIdle(assets.member);
  else Guide01.startIdleFloat(assets.member);
  scene07Relayout(false);
  await wait(T.drank);
  if(scene07Cancelled(ctx)) return;
  if(typeof scene03PromoteWithDRank === 'function') await scene03PromoteWithDRank(assets);

  await tl.wait(at(T.calendar));
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.calendar, true);

  await tl.wait(at(T.discount));
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.discount && assets.discount.wrap, true);
  for(i = 0; i < assets.discount.rows.length; i++){
    await wait(T.discountStep);
    if(scene07Cancelled(ctx)) return;
    assets.discount.rows[i].classList.add('is-visible');
    scene07Relayout(false);
  }

  await tl.wait(at(T.swap));
  if(scene07Cancelled(ctx)) return;
  if(assets.calendar){
    assets.calendar.classList.add('s07-fade-out');
    await wait((Scene07Config.motion.FADE && Scene07Config.motion.FADE.duration) || 720);
    hideElement(assets.calendar);
    assets.calendar.classList.remove('s07-fade-out');
  }
  await scene07Reveal(assets.payment, true);
  await wait(T.benefitStep);
  if(scene07Cancelled(ctx)) return;
  showElement(assets.ship);
  await scene07Reveal(assets.delivery, true);
  if(typeof scene04StartDeliveryProductLoop === 'function'){
    scene04StartDeliveryProductLoop(assets.delivery && assets.delivery._deliveryBox, assets.delivery && assets.delivery._deliveryProducts, ctx);
  }
  await wait(T.benefitStep);
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.benefit && assets.benefit.wrap, true);
  await wait(T.benefitStep);
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.benefit.epRow, false);
  await wait(T.benefitStep);
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.benefit.cbRow, false);
  await wait(T.benefitStep);
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.benefit.caption, false);

  await tl.wait(at(T.recommend));
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.recommend, true);
  await wait(T.baseStep);
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.base, true);

  await tl.wait(at(T.finale));
  if(scene07Cancelled(ctx)) return;
  if(assets.stage){
    assets.stage.classList.add('is-leaving');
    await wait(900);
    hideElement(assets.stage);
    assets.stage.classList.remove('is-leaving');
  }
  scene07Relayout(false);
  await wait(scene07LayoutSettleMs());
  if(scene07Cancelled(ctx)) return;
  await scene07Reveal(assets.finale && assets.finale.wrap, true);
  for(i = 0; i < assets.finale.lines.length; i++){
    await wait(T.finaleStep);
    if(scene07Cancelled(ctx)) return;
    showElement(assets.finale.lines[i]);
    assets.finale.lines[i].classList.add('s07-fade-in');
    scene07Relayout(false);
  }
}
</script>
