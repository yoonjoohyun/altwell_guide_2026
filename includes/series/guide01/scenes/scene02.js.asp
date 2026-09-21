<script>
/* guide01 Scene 02 — 오토십의 장점 */
var Guide01Scene02 = defineScene({
  id: Scene02Config.id,
  title: Scene02Config.title,
  duration: Scene02Config.duration,
  mediaSequence: Scene02Config.media.sequence,
  mediaFallbackMs: Scene02Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene02-panel');
    if(typeof Scene02Layout !== 'undefined') Scene02Layout.unbindResize();
    Guide01.resetScene(Scene02Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene02-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene02Config.canvasCls);
    Guide01.mountStage(canvas, Scene02Config.canvasCls);

    var assets = setupScene02Assets(canvas);

    await Promise.all([
      runScene02MotionCore(tl, assets, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene02Config.panel.title,
        Scene02Config.panel.bullets,
        scene02PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene02Config.duration);
  }
});

function scene02Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene02LayoutSettleMs(){
  return (Scene02Config.motion && Scene02Config.motion.layoutTransition) || 480;
}

async function scene02PrepStackSlot(wrap){
  if(!wrap) return;

  var inner = wrap.parentElement;
  var hasVisibleSibling = false;
  if(inner){
    var siblings = inner.querySelectorAll('.scene02-group-child');
    for(var i = 0; i < siblings.length; i++){
      if(siblings[i] !== wrap && !siblings[i].classList.contains('is-hidden')){
        hasVisibleSibling = true;
        break;
      }
    }
  }

  wrap.style.opacity = '0';
  showElement(wrap);
  if(typeof Scene02Layout !== 'undefined'){
    Scene02Layout.scheduleLayout(!hasVisibleSibling);
  }

  if(hasVisibleSibling){
    await wait(scene02LayoutSettleMs());
  }

  wrap.style.removeProperty('opacity');
}

async function scene02EnterBadge(wrap, opts){
  if(!wrap) return;
  await scene02PrepStackSlot(wrap);
  await Guide01.enterZonedBadge(wrap, opts || scene02BadgeEnter());
  Guide01.startIdleFloat(wrap);
  if(typeof Scene02Layout !== 'undefined') Scene02Layout.scheduleLayout(false);
}

async function scene02EnterFloat(wrap, opts){
  if(!wrap) return;
  await scene02PrepStackSlot(wrap);
  await Guide01.fadeZoned(wrap, true, opts || scene02Motion('FADE'));
  Guide01.startIdleFloat(wrap);
  if(typeof Scene02Layout !== 'undefined') Scene02Layout.scheduleLayout(false);
}

async function scene02FoldAutoship(wrap){
  if(!wrap) return;
  Guide01.stopIdleFloat(wrap);
  wrap.classList.add('is-autoship-folded');
  var badge = Guide01.resolveZonedBadge(wrap);
  if(badge && typeof G01BadgeFold !== 'undefined'){
    await G01BadgeFold.fold(badge, { duration: Scene02Config.motion.FOLD.duration || 620 });
  }
  Scene02Layout.scheduleLayout(false);
  Guide01.startIdleFloat(wrap);
}

async function scene02FoldBadge(wrap){
  if(!wrap) return;
  Guide01.stopIdleFloat(wrap);
  var badge = Guide01.resolveZonedBadge(wrap);
  if(badge && typeof G01BadgeFold !== 'undefined'){
    await G01BadgeFold.fold(badge, { duration: Scene02Config.motion.FOLD.duration || 620 });
  }
}

function scene02CaptureRect(el){
  if(!el) return { left: 0, top: 0 };
  var r = el.getBoundingClientRect();
  return { left: r.left, top: r.top };
}

async function scene02FlipBadgesIntoBox(assets){
  var keys = ['base', 'cashback', 'recommend'];
  var wraps = [];
  var i;

  for(i = 0; i < keys.length; i++){
    if(assets[keys[i]]) wraps.push(assets[keys[i]]);
  }
  if(!wraps.length) return;

  var first = wraps.map(scene02CaptureRect);
  Scene02Layout.collapseBenefitsIntoBox(assets);
  Scene02Layout.scheduleLayout(true);
  void (assets.benefitsBox && assets.benefitsBox.offsetHeight);

  var motion = Scene02Config.motion.benefitsFlyIn || { duration: 720 };
  var dur = motion.duration || 720;
  var easing = motion.easing || 'cubic-bezier(.22,1,.36,1)';
  var last = wraps.map(scene02CaptureRect);

  var flights = wraps.map(function(wrap, idx){
    var dx = first[idx].left - last[idx].left;
    var dy = first[idx].top - last[idx].top;

    wrap.classList.add('scene02-badge-flip');
    wrap.style.transform = 'translate(' + dx + 'px,' + dy + 'px)';
    wrap.style.transition = 'none';

    return new Promise(function(resolve){
      var settled = false;
      function finish(){
        if(settled) return;
        settled = true;
        wrap.classList.remove('scene02-badge-flip');
        wrap.style.removeProperty('transform');
        wrap.style.removeProperty('transition');
        resolve();
      }

      requestAnimationFrame(function(){
        requestAnimationFrame(function(){
          wrap.style.transition = 'transform ' + dur + 'ms ' + easing;
          wrap.style.transform = 'translate(0,0)';
          wrap.addEventListener('transitionend', function onEnd(e){
            if(e.propertyName !== 'transform') return;
            wrap.removeEventListener('transitionend', onEnd);
            finish();
          });
          setTimeout(finish, dur + 80);
        });
      });
    });
  });

  await Promise.all(flights);
}

async function scene02CollapseBenefitsIntoBox(assets){
  if(!assets) return;

  await Promise.all([
    scene02FoldBadge(assets.base),
    scene02FoldBadge(assets.cashback),
    scene02FoldBadge(assets.recommend)
  ]);

  Scene02Layout.scheduleLayout(false);
  await wait(scene02LayoutSettleMs());

  await scene02PrepStackSlot(assets.benefitsBox);
  await Guide01.fadeZoned(assets.benefitsBox, true, scene02Motion('FADE'));
  Scene02Layout.scheduleLayout(false);
  await wait(scene02LayoutSettleMs());

  await scene02FlipBadgesIntoBox(assets);

  Guide01.startIdleFloat(assets.benefitsBox);
  Scene02Layout.scheduleLayout(false);
  await wait(scene02LayoutSettleMs());
}

function scene02RevealSummaryRow(wrap, rowNum){
  if(!wrap) return;
  var card = wrap.querySelector('.autoship_discount_summary_card');
  if(!card) return;
  var row = card.querySelector('.ads_row[data-row="' + rowNum + '"]');
  if(row) row.classList.add('is-visible');
  Scene02Layout.scheduleLayout(false);
}

async function runScene02MotionCore(tl, assets, ctx){
  var T = Scene02Config.T.main;
  var at = function(mainMs){ return scene02AtMain(mainMs, ctx); };
  var FADE = scene02Motion('FADE');
  var BADGE = scene02BadgeEnter();

  /* title — 오토십 d4 */
  showElement(assets.group);
  await scene02EnterBadge(assets.autoship, BADGE);
  if(scene02Cancelled(ctx)) return;

  /* main+3s — 오토십 fold + 할인가 정리 빈 패널 */
  await tl.wait(at(T.foldAutoship));
  if(scene02Cancelled(ctx)) return;
  await scene02FoldAutoship(assets.autoship);
  await scene02EnterFloat(assets.summary, FADE);
  if(scene02Cancelled(ctx)) return;

  /* main+6s~ — 할인가 4행 순차 */
  await tl.wait(at(T.revealRow1));
  if(scene02Cancelled(ctx)) return;
  scene02RevealSummaryRow(assets.summary, 1);

  await tl.wait(at(T.revealRow2));
  if(scene02Cancelled(ctx)) return;
  scene02RevealSummaryRow(assets.summary, 2);

  await tl.wait(at(T.revealRow3));
  if(scene02Cancelled(ctx)) return;
  scene02RevealSummaryRow(assets.summary, 3);

  await tl.wait(at(T.revealRow4));
  if(scene02Cancelled(ctx)) return;
  scene02RevealSummaryRow(assets.summary, 4);

  /* main+21s — BASE 사업자 */
  await tl.wait(at(T.base));
  if(scene02Cancelled(ctx)) return;
  Scene02Layout.tightenAutoshipSummaryGap(10);
  Scene02Layout.scheduleLayout(true);
  Guide01.startIdleFloat(assets.autoship);
  Guide01.startIdleFloat(assets.summary);
  await scene02EnterBadge(assets.base, BADGE);
  if(scene02Cancelled(ctx)) return;

  /* main+24s — 캐시백 */
  await tl.wait(at(T.cashback));
  if(scene02Cancelled(ctx)) return;
  await scene02EnterBadge(assets.cashback, BADGE);
  if(scene02Cancelled(ctx)) return;

  /* main+27s — 추천 보너스 */
  await tl.wait(at(T.recommend));
  if(scene02Cancelled(ctx)) return;
  await scene02EnterBadge(assets.recommend, BADGE);
  if(scene02Cancelled(ctx)) return;

  /* main+30s — BASE·캐시백·추천보너스 접힘 → 보상 플랜의 기준 박스 */
  await tl.wait(at(T.benefitsCollapse));
  if(scene02Cancelled(ctx)) return;
  await scene02CollapseBenefitsIntoBox(assets);
}

</script>
