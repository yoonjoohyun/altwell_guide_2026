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

async function scene07PrepRow(row, assets){
  var inner = assets.group && assets.group._inner;
  var siblings;
  var hasVisibleSibling = false;
  var i;
  if(!row) return;
  if(inner){
    siblings = inner.querySelectorAll('.scene07-group-child');
    for(i = 0; i < siblings.length; i++){
      if(siblings[i] !== row && !siblings[i].classList.contains('is-hidden')){
        hasVisibleSibling = true;
        break;
      }
    }
  }
  row.style.opacity = '0';
  showElement(row);
  showElement(assets.group);
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(!hasVisibleSibling);
  if(hasVisibleSibling) await wait(scene07LayoutSettleMs());
  row.style.removeProperty('opacity');
}

async function scene07OpenRow(row, slot, assets){
  if(slot) showElement(slot);
  await scene07PrepRow(row, assets);
  if(!slot) return;
  slot.classList.add('s07-fade-in');
  Guide01.startIdleFloat(slot);
  await wait((Scene07Config.motion.FADE && Scene07Config.motion.FADE.duration) || 420);
  slot.classList.remove('s07-fade-in');
}

async function scene07RevealSlot(slot, assets){
  if(!slot) return;
  slot.style.opacity = '0';
  showElement(slot);
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(false);
  await wait(scene07LayoutSettleMs());
  slot.style.removeProperty('opacity');
  slot.classList.add('s07-fade-in');
  Guide01.startIdleFloat(slot);
  await wait((Scene07Config.motion.FADE && Scene07Config.motion.FADE.duration) || 420);
  slot.classList.remove('s07-fade-in');
}

async function scene07RevealLine(line){
  if(!line) return;
  showElement(line);
  line.classList.add('is-emphasis', 's07-line-flash');
  await wait(680);
  line.classList.remove('s07-line-flash');
}

async function runScene07Motion(tl, assets, ctx){
  var T = Scene07Config.T;
  var i;

  await tl.wait(T.badge);
  if(scene07Cancelled(ctx)) return;
  await scene07PrepRow(assets.badgeRow, assets);
  if(scene07Cancelled(ctx)) return;
  await Guide01.enterZonedBadge(assets.autoship, scene07BadgeEnter());
  Guide01.startIdleFloat(assets.autoship);
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(false);

  await tl.wait(T.calendar);
  if(scene07Cancelled(ctx)) return;
  await scene07OpenRow(assets.calRow, assets.calendar, assets);

  await tl.wait(T.discount);
  if(scene07Cancelled(ctx)) return;
  await scene07RevealSlot(assets.discount, assets);

  await tl.wait(T.delivery);
  if(scene07Cancelled(ctx)) return;
  await scene07OpenRow(assets.shipRow, assets.delivery, assets);

  await tl.wait(T.ep);
  if(scene07Cancelled(ctx)) return;
  await scene07RevealSlot(assets.ep, assets);

  await tl.wait(T.recommend);
  if(scene07Cancelled(ctx)) return;
  await scene07OpenRow(assets.benefitRow, assets.recommend, assets);

  await tl.wait(T.cashback);
  if(scene07Cancelled(ctx)) return;
  showElement(assets.cashback);
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(false);
  await wait(scene07LayoutSettleMs());
  await Guide01.enterZonedBadge(assets.cashback, scene07BadgeEnter());
  Guide01.startIdleFloat(assets.cashback);
  if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(false);

  await tl.wait(T.base);
  if(scene07Cancelled(ctx)) return;
  await scene07OpenRow(assets.baseRow, assets.base, assets);

  await tl.wait(T.summary);
  if(scene07Cancelled(ctx)) return;
  await scene07OpenRow(assets.summaryRow, assets.summary, assets);
  for(i = 0; i < assets.summaryLines.length; i++){
    await tl.wait(T.summaryLines[i]);
    if(scene07Cancelled(ctx)) return;
    await scene07RevealLine(assets.summaryLines[i]);
    if(typeof Scene07Layout !== 'undefined') Scene07Layout.scheduleLayout(false);
  }

  await tl.wait(T.outro);
  if(scene07Cancelled(ctx)) return;
  if(assets.group){
    assets.group.classList.add('s07-fade-out');
    await wait(420);
    hideElement(assets.group);
  }
  showElement(assets.outro);
  assets.outro.classList.add('s07-fade-in');
  await wait(420);

  await tl.wait(T.simButton);
  if(scene07Cancelled(ctx)) return;
  GuideClosePanel.open(assets.simSlot, { ms: 420, float: false, ease: 'ease' });

  await tl.wait(T.replayButton);
  if(scene07Cancelled(ctx)) return;
  GuideClosePanel.open(assets.replaySlot, { ms: 420, float: false, ease: 'ease' });
}
</script>
