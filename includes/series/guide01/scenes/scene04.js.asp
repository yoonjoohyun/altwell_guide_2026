<script>
/* guide01 Scene 04 — 결제와 배송 */
var Guide01Scene04 = defineScene({
  id: Scene04Config.id,
  title: Scene04Config.title,
  duration: Scene04Config.duration,
  mediaSequence: Scene04Config.media.sequence,
  mediaFallbackMs: Scene04Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene04-panel');
    if(typeof Scene04Layout !== 'undefined') Scene04Layout.unbindResize();
    Guide01.resetScene(Scene04Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene04-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene04Config.canvasCls);
    Guide01.mountStage(canvas, Scene04Config.canvasCls);

    var assets = setupScene04Assets(canvas);

    await Promise.all([
      runScene04MotionCore(tl, assets, canvas, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene04Config.panel.title,
        Scene04Config.panel.bullets,
        scene04PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene04Config.duration);
  }
});

function scene04Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene04LayoutSettleMs(){
  return (Scene04Config.motion && Scene04Config.motion.layoutTransition) || 480;
}

async function scene04PrepStackSlot(wrap){
  if(!wrap) return;

  var inner = wrap.parentElement;
  var hasVisibleSibling = false;
  var siblings;
  var i;

  if(inner){
    siblings = inner.querySelectorAll('.scene04-group-child');
    for(i = 0; i < siblings.length; i++){
      if(siblings[i] !== wrap && !siblings[i].classList.contains('is-hidden')){
        hasVisibleSibling = true;
        break;
      }
    }
  }

  wrap.style.opacity = '0';
  showElement(wrap);
  if(typeof Scene04Layout !== 'undefined'){
    Scene04Layout.scheduleLayout(!hasVisibleSibling);
  }

  if(hasVisibleSibling){
    await wait(scene04LayoutSettleMs());
  }

  wrap.style.removeProperty('opacity');
}

async function scene04EnterAutoship(wrap, opts){
  if(!wrap) return;
  await scene04PrepStackSlot(wrap);
  await Guide01.enterZonedBadge(wrap, opts || scene04BadgeEnter());
  Guide01.startIdleFloat(wrap);
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
}

async function scene04EnterCluster(cluster, enterFn){
  if(!cluster) return;
  await scene04PrepStackSlot(cluster);
  if(enterFn) await enterFn();
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
}

async function scene04PaymentTap(paymentBox){
  if(!paymentBox) return;
  var dur = (Scene04Config.motion.cardTap && Scene04Config.motion.cardTap.duration) || 680;
  paymentBox.classList.add('s04-payment-tap-active');
  await wait(dur);
  paymentBox.classList.remove('s04-payment-tap-active');
}

function scene04StopDeliveryProductFloats(productWraps){
  var i;

  if(!productWraps || !productWraps.length) return;

  for(i = 0; i < productWraps.length; i++){
    Guide01.stopIdleFloat(productWraps[i]);
  }
}

function scene04ResetDeliveryCycle(deliveryBox, productWraps, track){
  var i;

  scene04StopDeliveryProductFloats(productWraps);

  for(i = 0; i < productWraps.length; i++){
    hideElement(productWraps[i]);
  }

  if(track){
    track.style.removeProperty('transition');
    track.style.removeProperty('transform');
    track.style.removeProperty('--s04-delivery-base-x');
  }

  if(deliveryBox) deliveryBox.classList.remove('is-delivery-loop');
}

function scene04CenterDeliveryTrack(stack, track){
  var baseX = Math.max(0, (stack.clientWidth - track.scrollWidth) / 2);
  track.style.transform = 'translateX(' + baseX + 'px)';
  track.style.setProperty('--s04-delivery-base-x', String(baseX));
  return baseX;
}

async function scene04SlideDeliveryTrackOut(track, slideDur){
  var exitX = -track.scrollWidth;

  track.style.transition = 'transform ' + slideDur + 'ms linear';
  requestAnimationFrame(function(){
    track.style.transform = 'translateX(' + exitX + 'px)';
  });
  await wait(slideDur);
  track.style.removeProperty('transition');
}

async function scene04PlayDeliveryCycle(deliveryBox, productWraps, stack, track, cfg){
  var fadeOpts = Object.assign({}, scene04Motion('FADE'), { duration: cfg.fadeDuration });
  var i;

  scene04ResetDeliveryCycle(deliveryBox, productWraps, track);
  deliveryBox.classList.add('is-delivery-loop');

  for(i = 0; i < productWraps.length; i++){
    showElement(productWraps[i]);
    await Guide01.fadeZoned(productWraps[i], true, fadeOpts);
    Guide01.startIdleFloat(productWraps[i]);
    scene04CenterDeliveryTrack(stack, track);
    if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
    if(i < productWraps.length - 1) await wait(cfg.stagger);
  }

  await wait(cfg.floatHold);
  scene04StopDeliveryProductFloats(productWraps);
  scene04CenterDeliveryTrack(stack, track);
  await scene04SlideDeliveryTrackOut(track, cfg.slideDuration);
  scene04ResetDeliveryCycle(deliveryBox, productWraps, track);
}

function scene04StartDeliveryProductLoop(deliveryBox, productWraps, ctx){
  var stack;
  var track;
  var stackCfg;
  var loop;
  var cfg;

  if(!deliveryBox || !productWraps || !productWraps.length) return;

  stack = deliveryBox.querySelector('.dbb_stack');
  track = deliveryBox.querySelector('.s04-delivery-track');
  if(!stack || !track) return;

  stackCfg = Scene04Config.motion.deliveryStack || {};
  loop = Scene04Config.motion.deliveryLoop || {};
  cfg = {
    stagger: stackCfg.stagger != null ? stackCfg.stagger : 140,
    fadeDuration: stackCfg.fadeDuration != null ? stackCfg.fadeDuration : 420,
    floatHold: loop.floatHold != null ? loop.floatHold : 360,
    slideDuration: loop.slideDuration != null ? loop.slideDuration : 360,
    cycleGap: loop.cycleGap != null ? loop.cycleGap : 2000
  };

  scene04ResetDeliveryCycle(deliveryBox, productWraps, track);

  (async function run(){
    while(!scene04Cancelled(ctx)){
      await scene04PlayDeliveryCycle(deliveryBox, productWraps, stack, track, cfg);
      if(scene04Cancelled(ctx)) return;
      if(cfg.cycleGap > 0) await wait(cfg.cycleGap);
    }
  })();
}

async function scene04ShowInstallment(host){
  if(!host) return;
  var badge = Scene04Layout.cloneFromTemplate('installment_mini_badge');
  var dur = (Scene04Config.motion.installment && Scene04Config.motion.installment.duration) || 480;
  if(!badge) return;

  host.innerHTML = '';
  badge.classList.add('guide01-asset', 's04-installment-badge');
  host.appendChild(badge);
  showElement(host);
  badge.classList.add('s04-installment-pop');
  await wait(dur);
  badge.classList.add('s04-installment-flash');
  await wait(dur);
  badge.classList.remove('s04-installment-flash');
}

async function scene04ActivateCalendarSteps(assets){
  var flow = assets.subscriptionFlow;
  var checksHost = assets.calendarChecks;
  var months;
  var dur = (Scene04Config.motion.calendarStep && Scene04Config.motion.calendarStep.duration) || 420;
  var stagger = Scene04Config.motion.calendarStep.stagger || 380;
  var i;
  var month;
  var check;

  if(!flow || !checksHost) return;

  months = flow.querySelectorAll('.subscription_flow_month');
  checksHost.innerHTML = '';

  for(i = 0; i < 3 && i < months.length; i++){
    month = months[i];
    month.classList.add('is-active-month');

    check = Scene04Layout.cloneFromTemplate('status_check_icon');
    if(check){
      var cell = document.createElement('div');
      cell.className = 's04-month-check-cell';
      check.classList.add('guide01-asset', 's04-month-check');
      check.setAttribute('data-month-index', String(i));
      cell.appendChild(check);
      checksHost.appendChild(cell);
    }

    if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);

    await wait(stagger);
  }

  await wait(dur);
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(true);
}

async function scene04ShowRenewArrow(assets){
  var flow = assets.subscriptionFlow;
  if(!flow) return;
  flow.classList.add('s04-renew-arrow-visible');

  if(assets.renewBadgeHost){
    var badge = Scene04Layout.cloneFromTemplate('guide_info_badge');
    if(badge){
      badge.classList.add('guide01-asset', 's04-auto-renew-badge');
      assets.renewBadgeHost.innerHTML = '';
      assets.renewBadgeHost.appendChild(badge);
      showElement(assets.renewBadgeHost);
    }
  }

  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(true);

  await wait(520);
}

async function scene04ShowRenewCalendar(assets, opts){
  if(!assets.renewWrap) return;
  await scene04PrepStackSlot(assets.renewWrap);
  await Guide01.fadeZoned(assets.renewWrap, true, opts || scene04Motion('FADE'));
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
}

async function scene04MergeSummary(assets){
  if(typeof Scene04Layout !== 'undefined'){
    Scene04Layout.ensureSummaryWrap(assets);
    Scene04Layout.setLayoutMode('summary');
  }

  var summary = assets.quarterSummary;
  if(!summary || !assets.summaryWrap) return;

  hideElement(assets.autoship);
  hideElement(assets.payDelCluster);
  hideElement(assets.calendarWrap);
  hideElement(assets.renewWrap);

  if(typeof Scene04Layout !== 'undefined'){
    Scene04Layout.scheduleLayout(false);
    await wait(scene04LayoutSettleMs());
  }

  await scene04PrepStackSlot(assets.summaryWrap);
  summary.classList.add('s04-summary-enter');
  await wait((Scene04Config.motion.merge && Scene04Config.motion.merge.duration) || 620);
  summary.classList.add('s04-orbit-spin');
  await wait(900);
  summary.classList.add('s04-summary-emphasis');
}

async function scene04FinalCompare(summary){
  if(!summary) return;
  var dur = (Scene04Config.motion.compare && Scene04Config.motion.compare.duration) || 520;
  summary.classList.add('is-compare-active');
  await wait(dur);
}

async function runScene04MotionCore(tl, assets, canvas, ctx){
  var T = Scene04Config.T.main;
  var at = function(mainMs){ return scene04AtMain(mainMs, ctx); };
  var BADGE = scene04BadgeEnter();
  var FADE = scene04Motion('FADE');

  /* 0s — 오토십 @d4 */
  showElement(assets.group);
  await scene04EnterAutoship(assets.autoship, BADGE);
  if(scene04Cancelled(ctx)) return;

  /* 1s — 결제 박스 + d4 중앙 스택 */
  await tl.wait(at(T.paymentBox));
  if(scene04Cancelled(ctx)) return;
  await scene04EnterCluster(assets.payDelCluster, async function(){
    await wait(240);
  });
  if(scene04Cancelled(ctx)) return;

  /* 3s — 결제 박스 내부 카드·단말기 */
  await tl.wait(at(T.paymentTap));
  if(scene04Cancelled(ctx)) return;
  await scene04PaymentTap(assets.paymentBox);

  /* 5s — 배송 박스 + A제품 1열 플로팅 */
  await tl.wait(at(T.delivery));
  if(scene04Cancelled(ctx)) return;
  if(assets.deliveryBox){
    assets.deliveryBox.classList.remove('is-hidden', 's04-delivery-pending');
    if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
    await wait(120);
    scene04StartDeliveryProductLoop(assets.deliveryBox, assets.deliveryProducts, ctx);
    if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
  }

  /* 8s — 할부 가능 */
  await tl.wait(at(T.installment));
  if(scene04Cancelled(ctx)) return;
  await scene04ShowInstallment(assets.installmentHost);

  /* 11s — d4 스택 여유 확보 (캘린더 등장 전) */
  await tl.wait(at(T.splitLayout));
  if(scene04Cancelled(ctx)) return;
  if(typeof Scene04Layout !== 'undefined'){
    Scene04Layout.scheduleLayout(false);
    await wait(scene04LayoutSettleMs());
  }

  /* 13s — 캘린더 1~3개월 활성 + 체크 */
  await tl.wait(at(T.calendarSteps));
  if(scene04Cancelled(ctx)) return;
  await scene04PrepStackSlot(assets.calendarWrap);
  await Guide01.fadeZoned(assets.calendarWrap, true, FADE);
  Guide01.startIdleFloat(assets.calendarWrap);
  await scene04ActivateCalendarSteps(assets);
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);

  /* 18s — 3→4 화살표 + 자동 연장 */
  await tl.wait(at(T.renewArrow));
  if(scene04Cancelled(ctx)) return;
  await scene04ShowRenewArrow(assets);

  /* 20s — 연장 캘린더 + 자동 결제 */
  await tl.wait(at(T.renewCalendar));
  if(scene04Cancelled(ctx)) return;
  await scene04ShowRenewCalendar(assets, FADE);

  /* 23s — 통합 요약 */
  await tl.wait(at(T.mergeSummary));
  if(scene04Cancelled(ctx)) return;
  await scene04MergeSummary(assets);

  /* 27s — 매월 주문 취소선 / 3개월 정기구독 */
  await tl.wait(at(T.finalCompare));
  if(scene04Cancelled(ctx)) return;
  await scene04FinalCompare(assets.quarterSummary);
}

</script>
