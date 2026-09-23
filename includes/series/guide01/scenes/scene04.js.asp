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
  var tap = Scene04Config.motion.cardTap || {};
  var coinMotion = Scene04Config.motion.paymentCoin || {};
  var dur = tap.duration != null ? tap.duration : 680;
  var popDur = coinMotion.popDuration != null ? coinMotion.popDuration : 420;
  var floatHold = tap.paymentFloatHold != null ? tap.paymentFloatHold : 360;
  var fadeDur = tap.paymentFade != null ? tap.paymentFade : 200;
  var host;
  var inner;

  if(!paymentBox) return;

  host = paymentBox.querySelector('#s04-tap-payment-host');
  paymentBox.classList.add('s04-payment-tap-active');

  await Promise.all([
    wait(dur),
    (async function runTapPaymentCoin(){
      if(!host) return;

      host.innerHTML = '<span class="s04-tap-payment-coin-inner">결제</span>';
      showElement(host);
      inner = host.querySelector('.s04-tap-payment-coin-inner');
      if(!inner) return;

      inner.classList.add('s04-tap-payment-coin-pop');
      await scene04WaitAnimEnd(inner, 's04-payment-coin-pop', popDur + 80);
      inner.classList.remove('s04-tap-payment-coin-pop');
      host.classList.add('s04-soft-idle-float');
      await wait(floatHold);
      host.classList.remove('s04-soft-idle-float');
      inner.classList.add('s04-tap-payment-coin-out');
      await wait(fadeDur);
      hideElement(host);
      host.innerHTML = '';
    })()
  ]);

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

async function scene04PlayDeliveryCycle(deliveryBox, productWraps, stack, track, cfg, opts){
  var fadeOpts = Object.assign({}, scene04Motion('FADE'), { duration: cfg.fadeDuration });
  var withSlideOut = !opts || opts.withSlideOut !== false;
  var i;

  scene04ResetDeliveryCycle(deliveryBox, productWraps, track);
  deliveryBox.classList.add('is-delivery-loop');

  for(i = 0; i < productWraps.length; i++){
    showElement(productWraps[i]);
    await Guide01.fadeZoned(productWraps[i], true, fadeOpts);
    Guide01.startIdleFloat(productWraps[i]);
    scene04CenterDeliveryTrack(stack, track);
    if(i < productWraps.length - 1) await wait(cfg.stagger);
  }

  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);

  await wait(cfg.floatHold);
  if(!withSlideOut) return;

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
    var cycleCount = 0;
    var totalCycles = loop.totalCycles != null ? loop.totalCycles : 2;

    while(!scene04Cancelled(ctx)){
      cycleCount++;
      await scene04PlayDeliveryCycle(deliveryBox, productWraps, stack, track, cfg, {
        withSlideOut: cycleCount < totalCycles
      });
      if(scene04Cancelled(ctx)) return;
      if(cycleCount >= totalCycles) return;
      if(cfg.cycleGap > 0) await wait(cfg.cycleGap);
    }
  })();
}

function scene04WaitAnimEnd(el, animName, fallbackMs){
  return new Promise(function(resolve){
    var done = false;
    var finish = function(){
      if(done) return;
      done = true;
      el.removeEventListener('animationend', onEnd);
      resolve();
    };
    var onEnd = function(e){
      if(e.target !== el) return;
      if(animName && e.animationName !== animName) return;
      finish();
    };

    el.addEventListener('animationend', onEnd);
    if(fallbackMs != null) setTimeout(finish, fallbackMs);
  });
}

async function scene04RevealDeliveryBox(deliveryBox){
  if(!deliveryBox) return;

  deliveryBox.classList.remove('is-hidden');
  await new Promise(function(resolve){
    requestAnimationFrame(function(){
      requestAnimationFrame(resolve);
    });
  });
  deliveryBox.classList.remove('s04-delivery-pending');
  await wait(scene04LayoutSettleMs());
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
}

async function scene04ShowInstallment(host){
  if(!host) return;
  var badge = Scene04Layout.cloneFromTemplate('installment_mini_badge');
  var inst = Scene04Config.motion.installment || {};
  var popDur = inst.popDuration != null ? inst.popDuration : 480;
  var flashDur = inst.flashDuration != null ? inst.flashDuration : (inst.duration || 480);
  var cardSlot;
  if(!badge) return;

  host.innerHTML = '';
  badge.classList.add('guide01-asset', 's04-installment-badge');
  host.appendChild(badge);
  showElement(host);
  badge.classList.add('s04-installment-pop');
  await scene04WaitAnimEnd(badge, 's04-installment-pop', popDur + 80);
  badge.classList.remove('s04-installment-pop');
  badge.classList.add('s04-installment-flash');
  await scene04WaitAnimEnd(badge, 's04-emphasis-flash', flashDur + 80);
  badge.classList.remove('s04-installment-flash');
  cardSlot = host.closest('.pbb_card-slot');
  if(cardSlot) cardSlot.classList.add('s04-soft-idle-float');
}

async function scene04RevealPaymentCoin(coin){
  var motion = Scene04Config.motion.paymentCoin || {};
  var popDur = motion.popDuration != null ? motion.popDuration : 420;
  var inner;

  if(!coin) return;

  inner = coin.querySelector('.s04-flow-payment-coin-inner');
  if(!inner) return;

  inner.classList.remove('s04-soft-idle-float');
  coin.classList.remove('s04-payment-coin-pop');
  coin.classList.remove('is-hidden');
  coin.classList.add('s04-payment-coin-pop');
  await scene04WaitAnimEnd(inner, 's04-payment-coin-pop', popDur + 80);
  coin.classList.remove('s04-payment-coin-pop');
  inner.classList.add('s04-soft-idle-float');
}

function scene04GetFlowMonthEntries(flow){
  var slots = flow.querySelectorAll('.s04-flow-month-slot');
  var entries = [];
  var months;
  var i;
  var slot;
  var month;

  if(slots.length){
    for(i = 0; i < slots.length; i++){
      slot = slots[i];
      month = slot.querySelector('.subscription_flow_month');
      if(!month) continue;
      entries.push({
        month: month,
        coin: slot.querySelector('.s04-flow-payment-coin'),
        index: i
      });
    }
    return entries;
  }

  months = flow.querySelectorAll('.subscription_flow_track .subscription_flow_month');
  for(i = 0; i < months.length; i++){
    entries.push({ month: months[i], coin: null, index: i });
  }
  return entries;
}

function scene04RunMonthJump(month, jumpDur){
  var motion = Scene04Config.motion.calendarStep || {};
  var slot = month && month.closest('.s04-flow-month-slot');
  var target = slot || month;
  var peak = motion.jumpPeak != null ? motion.jumpPeak : -5;
  var settle = motion.jumpSettle != null ? motion.jumpSettle : 2;
  var scalePeak = motion.jumpScalePeak != null ? motion.jumpScalePeak : 1.015;
  var scaleSettle = motion.jumpScaleSettle != null ? motion.jumpScaleSettle : 0.995;

  if(!target) return Promise.resolve();

  target.style.transform = 'translate3d(0,0,0)';

  if(typeof target.animate === 'function'){
    return target.animate([
      { transform: 'translate3d(0,0,0) scale(1)', offset: 0 },
      { transform: 'translate3d(0,' + peak + 'px,0) scale(' + scalePeak + ')', offset: 0.38 },
      { transform: 'translate3d(0,' + settle + 'px,0) scale(' + scaleSettle + ')', offset: 0.68 },
      { transform: 'translate3d(0,0,0) scale(1)', offset: 1 }
    ], {
      duration: jumpDur,
      easing: 'cubic-bezier(.33,1,.42,1)',
      fill: 'none'
    }).finished.then(function(){
      target.style.transform = '';
    }).catch(function(){
      target.style.transform = '';
    });
  }

  return wait(jumpDur).then(function(){
    target.style.transform = '';
  });
}

function scene04PositionPaymentProgress(track, progress){
  var slots;
  var slot0;
  var slot3;
  var trackRect;
  var s0Rect;
  var s3Rect;
  var leftCenter;
  var rightCenter;

  if(!track || !progress) return;

  slots = track.querySelectorAll('.s04-flow-month-slot');
  slot0 = slots[0];
  slot3 = slots[3];
  if(!slot0 || !slot3) return;

  trackRect = track.getBoundingClientRect();
  s0Rect = slot0.getBoundingClientRect();
  s3Rect = slot3.getBoundingClientRect();
  leftCenter = s0Rect.left + s0Rect.width / 2 - trackRect.left;
  rightCenter = s3Rect.left + s3Rect.width / 2 - trackRect.left;

  progress.style.left = leftCenter + 'px';
  progress.style.width = Math.max(0, rightCenter - leftCenter) + 'px';
}

function scene04EnsureProgressDotCount(progress){
  var motion = Scene04Config.motion.calendarStep || {};
  var target = motion.progressDotCount != null ? motion.progressDotCount : 7;
  var dots;
  var dot;

  if(!progress) return;

  while(progress.querySelectorAll('.s04-flow-progress-dot').length < target){
    dot = document.createElement('span');
    dot.className = 's04-flow-progress-dot';
    progress.appendChild(dot);
  }
  dots = progress.querySelectorAll('.s04-flow-progress-dot');
  while(dots.length > target){
    progress.removeChild(dots[dots.length - 1]);
    dots = progress.querySelectorAll('.s04-flow-progress-dot');
  }
}

function scene04ResetProgressDots(progress){
  var dots;
  var i;

  if(!progress) return;

  scene04EnsureProgressDotCount(progress);
  dots = progress.querySelectorAll('.s04-flow-progress-dot');
  for(i = 0; i < dots.length; i++){
    dots[i].classList.remove('is-active', 'is-lit');
  }
}

function scene04ClearProgressDotTimers(progress){
  if(!progress) return;

  progress._progressRunning = false;
  if(progress._progressBlinkTimer){
    clearTimeout(progress._progressBlinkTimer);
    progress._progressBlinkTimer = null;
  }
  if(progress._progressGapTimer){
    clearTimeout(progress._progressGapTimer);
    progress._progressGapTimer = null;
  }
  progress.classList.remove('is-running');
}

function scene04FreezeProgressDots(progress){
  var dots;
  var i;

  if(!progress) return;

  scene04ClearProgressDotTimers(progress);
  dots = progress.querySelectorAll('.s04-flow-progress-dot');
  for(i = 0; i < dots.length; i++){
    dots[i].classList.remove('is-active');
    dots[i].classList.add('is-lit');
  }
}

function scene04StopProgressDots(progress, hide){
  if(!progress) return;

  scene04ClearProgressDotTimers(progress);
  scene04ResetProgressDots(progress);
  if(hide) hideElement(progress);
}

function scene04StartProgressDots(progress, ctx){
  var motion = Scene04Config.motion.calendarStep || {};
  var blinkMs = motion.progressDotBlink != null ? motion.progressDotBlink : 260;
  var gapMs = motion.progressDotGap != null ? motion.progressDotGap : 90;
  var dots;
  var step = 0;

  if(!progress) return;

  scene04StopProgressDots(progress);
  dots = progress.querySelectorAll('.s04-flow-progress-dot');
  if(!dots.length) return;

  progress.classList.add('is-running');
  progress._progressRunning = true;

  (function tick(){
    var idx;
    var j;

    if(!progress._progressRunning || scene04Cancelled(ctx)){
      scene04StopProgressDots(progress);
      return;
    }

    if(step >= dots.length){
      for(j = 0; j < dots.length; j++){
        dots[j].classList.remove('is-active');
        dots[j].classList.add('is-lit');
      }
      progress._progressRunning = false;
      progress.classList.remove('is-running');
      return;
    }

    idx = step;
    for(j = 0; j < dots.length; j++){
      if(j !== idx) dots[j].classList.remove('is-active');
    }
    dots[idx].classList.add('is-active');

    progress._progressBlinkTimer = setTimeout(function(){
      if(!progress._progressRunning) return;
      dots[idx].classList.remove('is-active');
      dots[idx].classList.add('is-lit');
      step++;
      progress._progressGapTimer = setTimeout(tick, gapMs);
    }, blinkMs);
  })();
}

async function scene04ActivateCalendarSteps(assets, ctx){
  var flow = assets.subscriptionFlow;
  var motion = Scene04Config.motion.calendarStep || {};
  var jumpDur = motion.jumpDuration != null ? motion.jumpDuration : 520;
  var stagger = motion.stagger != null ? motion.stagger : 380;
  var track;
  var progress;
  var entries;
  var i;
  var entry;
  var month;
  var coin;
  var inner;
  var isPaymentMonth;

  if(!flow) return;

  if(typeof Scene04Layout !== 'undefined' && Scene04Layout.ensureFlowMonthSlots){
    Scene04Layout.ensureFlowMonthSlots(flow);
  }

  track = flow.querySelector('.subscription_flow_track');
  progress = track && track.querySelector('.s04-flow-payment-progress');
  if(progress){
    scene04StopProgressDots(progress, true);
  }

  Guide01.stopIdleFloat(assets.calendarWrap);
  entries = scene04GetFlowMonthEntries(flow);

  if(!entries.length) return;

  await new Promise(function(resolve){
    requestAnimationFrame(function(){
      requestAnimationFrame(resolve);
    });
  });

  for(i = 0; i < entries.length; i++){
    entry = entries[i];
    month = entry.month;
    coin = entry.coin;
    isPaymentMonth = (entry.index === 0 || entry.index === 3);

    month.classList.remove('is-payment-month', 'is-active-month');
    month.style.transform = '';
    if(coin){
      coin.classList.add('is-hidden');
      coin.classList.remove('s04-payment-coin-pop');
      inner = coin.querySelector('.s04-flow-payment-coin-inner');
      if(inner) inner.classList.remove('s04-soft-idle-float');
    }

    await scene04RunMonthJump(month, jumpDur);

    if(isPaymentMonth){
      month.classList.add('is-payment-month');
      if(coin){
        if(entry.index === 3 && progress){
          scene04FreezeProgressDots(progress);
          showElement(progress);
        }
        await scene04RevealPaymentCoin(coin);
        if(entry.index === 0 && progress && track){
          scene04PositionPaymentProgress(track, progress);
          scene04ResetProgressDots(progress);
          showElement(progress);
          scene04StartProgressDots(progress, ctx);
        }
      }
    }

    if(i < entries.length - 1) await wait(stagger);
  }

}

async function scene04ShowRenewArrow(assets){
  var flow = assets.subscriptionFlow;
  if(!flow) return;
  flow.classList.add('s04-renew-arrow-visible');

  await wait(520);
}

function scene04EnsureIdleFloatAll(assets){
  if(!assets) return;
  if(assets.autoship) Guide01.startIdleFloat(assets.autoship);
  if(assets.payDelCluster) Guide01.startIdleFloat(assets.payDelCluster);
  if(assets.calendarWrap) Guide01.startIdleFloat(assets.calendarWrap);
}

async function scene04HoldWithIdleFloat(assets){
  var flow = assets.subscriptionFlow;
  var coins;
  var j;
  var coinInner;
  var cardSlot;

  if(flow){
    coins = flow.querySelectorAll('.s04-flow-payment-coin-inner.s04-soft-idle-float');
    for(j = 0; j < coins.length; j++){
      coins[j].classList.remove('s04-soft-idle-float');
    }
  }

  if(assets.paymentBox){
    cardSlot = assets.paymentBox.querySelector('.pbb_card-slot.s04-soft-idle-float');
    if(cardSlot) cardSlot.classList.remove('s04-soft-idle-float');
  }

  scene04EnsureIdleFloatAll(assets);
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);
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
    await scene04RevealDeliveryBox(assets.deliveryBox);
    scene04StartDeliveryProductLoop(assets.deliveryBox, assets.deliveryProducts, ctx);
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

  /* 13s — 캘린더 1~4개월 순차 활성 */
  await tl.wait(at(T.calendarSteps));
  if(scene04Cancelled(ctx)) return;
  await scene04PrepStackSlot(assets.calendarWrap);
  await Guide01.fadeZoned(assets.calendarWrap, true, FADE);
  await scene04ActivateCalendarSteps(assets, ctx);
  if(typeof Scene04Layout !== 'undefined') Scene04Layout.scheduleLayout(false);

  /* 18s — 3→4 화살표 + 자동 연장 */
  await tl.wait(at(T.renewArrow));
  if(scene04Cancelled(ctx)) return;
  await scene04ShowRenewArrow(assets);

  /* 23s — 전체 에셋 idle float 유지 */
  await tl.wait(at(T.holdFloat));
  if(scene04Cancelled(ctx)) return;
  await scene04HoldWithIdleFloat(assets);
}

</script>
