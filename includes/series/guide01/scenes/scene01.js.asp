<script>
/* guide01 Scene 01 — 오토십이란? */
var Guide01Scene01 = defineScene({
  id: Scene01Config.id,
  title: Scene01Config.title,
  duration: Scene01Config.duration,
  mediaSequence: Scene01Config.media.sequence,
  mediaFallbackMs: Scene01Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene01-panel');
    if(typeof Scene01Layout !== 'undefined') Scene01Layout.unbindResize();
    Guide01.resetScene(Scene01Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene01-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene01Config.canvasCls);
    Guide01.mountStage(canvas, Scene01Config.canvasCls);

    var assets = setupScene01Assets(canvas);
    Scene01Layout.applyLayout(canvas, assets.group, assets);

    await Promise.all([
      runScene01MotionCore(tl, assets, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene01Config.panel.title,
        Scene01Config.panel.bullets,
        scene01PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene01Config.duration);
  }
});

function scene01Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function scene01EnterFloat(wrap, opts){
  if(!wrap) return;
  await Guide01.fadeZoned(wrap, true, opts || scene01Motion('FADE'));
  Guide01.startIdleFloat(wrap);
}

async function scene01EnterBadge(wrap, opts){
  if(!wrap) return;
  await Guide01.enterZonedBadge(wrap, opts || scene01BadgeEnter());
  Guide01.startIdleFloat(wrap);
}

async function scene01PopPlus(wrap, ctx){
  if(!wrap) return;
  await Guide01.popScaleZoned(wrap, scene01Motion('POP'));
  Guide01.startIdleFloat(wrap);
}

async function scene01ExitFloat(wrap, opts){
  if(!wrap) return;
  Guide01.stopIdleFloat(wrap);
  await Guide01.fadeZoned(wrap, false, opts || scene01Motion('FADE'));
}

function scene01RelayoutBenefitRow(){
  if(typeof Scene01Layout !== 'undefined' && Scene01Layout.scheduleLayout){
    Scene01Layout.scheduleLayout(false);
  }
}

async function scene01EnterBadgeSettled(wrap, opts){
  await scene01EnterBadge(wrap, opts);
  await wait(Scene01Config.motion.relayoutAfterBadge || 400);
  scene01RelayoutBenefitRow();
}

async function runScene01MotionCore(tl, assets, ctx){
  var T = Scene01Config.T.main;
  var at = function(mainMs){ return scene01AtMain(mainMs, ctx); };
  var FADE = scene01Motion('FADE');
  var POP = scene01Motion('POP');
  var BADGE = scene01BadgeEnter();

  /* title — 멤버(d4 그룹 앵커)만 */
  showElement(assets.group);
  await scene01EnterFloat(assets.member, Object.assign({}, POP, { duration: 480 }));
  if(scene01Cancelled(ctx)) return;

  /* main 시작 — 오토십 뱃지 플로팅 */
  await tl.wait(at(T.autoship));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterBadge(assets.autoship, BADGE);
  if(scene01Cancelled(ctx)) return;

  /* main+3s — 3개월 달력 */
  await tl.wait(at(T.calendar));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterFloat(assets.calendar, FADE);

  /* main+8s~ — 할인 → + → 캐시백 → + → 추천 (순차, 간섭 방지) */
  await tl.wait(at(T.discount));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterBadgeSettled(assets.discount, BADGE);
  if(scene01Cancelled(ctx)) return;

  await tl.wait(at(T.plus));
  if(scene01Cancelled(ctx)) return;
  await scene01PopPlus(assets.plus, ctx);
  if(scene01Cancelled(ctx)) return;

  await tl.wait(at(T.cashback));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterBadgeSettled(assets.cashback, BADGE);
  if(scene01Cancelled(ctx)) return;

  await tl.wait(at(T.plusRecommend));
  if(scene01Cancelled(ctx)) return;
  await scene01PopPlus(assets.plusRecommend, ctx);
  if(scene01Cancelled(ctx)) return;

  await tl.wait(at(T.recommend));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterBadgeSettled(assets.recommend, BADGE);
  if(scene01Cancelled(ctx)) return;

  /* main+22s — 베이스 사업자 */
  await tl.wait(at(T.base));
  if(scene01Cancelled(ctx)) return;
  await scene01EnterBadge(assets.base, scene01BadgeEnter({ pop: true }));
}

</script>
