<script>
/* guide01 Scene 05 — E.P와 추천포인트 발생 */
var Guide01Scene05 = defineScene({
  id: Scene05Config.id,
  title: Scene05Config.title,
  duration: Scene05Config.duration,
  mediaSequence: Scene05Config.media.sequence,
  mediaFallbackMs: Scene05Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene05-panel');
    if(typeof Scene05Layout !== 'undefined') Scene05Layout.unbindResize();
    Guide01.resetScene(Scene05Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene05-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene05Config.canvasCls);
    Guide01.mountStage(canvas, Scene05Config.canvasCls);

    var assets = setupScene05Assets(canvas);

    await Promise.all([
      runScene05MotionCore(tl, assets, canvas, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene05Config.panel.title,
        Scene05Config.panel.bullets,
        scene05PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene05Config.duration);
  }
});

function scene05Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene05LayoutSettleMs(){
  return (Scene05Config.motion && Scene05Config.motion.layoutTransition) || 480;
}

async function scene05PrepPhase(assets, phaseKey){
  var wrap = null;
  var inner;
  var hasVisibleSibling = false;
  var siblings;
  var i;

  if(phaseKey === 'intro') wrap = assets.intro && assets.intro.phase;
  else if(phaseKey === 'calendar') wrap = assets.calendar && assets.calendar.phase;
  else if(phaseKey === 'recommendStory') wrap = assets.recommendStory && assets.recommendStory.phase;

  if(!wrap) return;

  inner = wrap.parentElement;
  if(inner){
    siblings = inner.querySelectorAll('.scene05-group-child');
    for(i = 0; i < siblings.length; i++){
      if(siblings[i] !== wrap && !siblings[i].classList.contains('is-hidden')){
        hasVisibleSibling = true;
        break;
      }
    }
  }

  wrap.style.opacity = '0';
  showElement(wrap);
  showElement(assets.group);
  if(typeof Scene05Layout !== 'undefined'){
    Scene05Layout.scheduleLayout(!hasVisibleSibling);
  }
  if(hasVisibleSibling) await wait(scene05LayoutSettleMs());
  wrap.style.removeProperty('opacity');
}

async function scene05SwitchPhase(assets, hideKeys, showKey){
  var i;
  var key;
  var wrap;

  for(i = 0; i < hideKeys.length; i++){
    key = hideKeys[i];
    if(key === 'intro') wrap = assets.intro && assets.intro.phase;
    else if(key === 'calendar') wrap = assets.calendar && assets.calendar.phase;
    else if(key === 'recommendStory') wrap = assets.recommendStory && assets.recommendStory.phase;
    if(wrap) hideElement(wrap);
  }

  await scene05PrepPhase(assets, showKey);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05FadeEl(el, opts){
  if(!el) return;
  showElement(el);
  el.classList.add('s05-fade-in');
  await wait((opts && opts.duration) || scene05Motion('FADE').duration || 420);
  el.classList.remove('s05-fade-in');
}

async function scene05FadeOutEl(el, opts){
  if(!el || el.classList.contains('is-hidden')) return;
  el.classList.add('s05-fade-out');
  await wait((opts && opts.duration) || scene05Motion('FADE').duration || 420);
  el.classList.remove('s05-fade-out');
  hideElement(el);
}

async function scene05ExitIntroCluster(assets){
  var intro = assets.intro;
  var FADE = scene05Motion('FADE');
  var targets;
  var i;

  if(!intro) return;

  if(intro.autoshipHost) Guide01.stopIdleFloat(intro.autoshipHost);
  if(intro.paymentHost) Guide01.stopIdleFloat(intro.paymentHost);
  if(intro.denyHost) intro.denyHost.classList.remove('s05-soft-idle-float');
  if(intro.epStack) intro.epStack.classList.remove('s05-ep-stack-idle');

  targets = [];
  if(intro.autoshipHost && !intro.autoshipHost.classList.contains('is-hidden')) targets.push(intro.autoshipHost);
  if(intro.paymentHost && !intro.paymentHost.classList.contains('is-hidden')) targets.push(intro.paymentHost);
  if(intro.denyHost && !intro.denyHost.classList.contains('is-hidden')) targets.push(intro.denyHost);
  if(intro.epStack && !intro.epStack.classList.contains('is-hidden')) targets.push(intro.epStack);

  if(!targets.length) return;

  await Promise.all(targets.map(function(el){
    return scene05FadeOutEl(el, FADE);
  }));

  hideElement(intro.phase);
}

async function scene05PopEl(el, opts){
  if(!el) return;
  showElement(el);
  el.classList.add('s05-pop-in');
  await wait((opts && opts.duration) || scene05Motion('POP').duration || 520);
  el.classList.remove('s05-pop-in');
}

async function scene05EnterBadgeEl(host, badge){
  if(!host || !badge) return;
  host.textContent = '';
  host.appendChild(badge);
  showElement(host);
  badge.classList.add('s05-pop-in');
  await wait(scene05Motion('POP').duration || 520);
  badge.classList.remove('s05-pop-in');
}

function scene05StartMemberIdle(memberWrap){
  if(!memberWrap) return;
  var stack = memberWrap.querySelector('.g01-member-stack');
  if(stack) stack.classList.add('g01-idle-float');
}

function scene05StopMemberIdle(memberWrap){
  if(!memberWrap) return;
  var stack = memberWrap.querySelector('.g01-member-stack');
  if(stack) stack.classList.remove('g01-idle-float');
}

function scene05WaitAnimEnd(el, animName, fallbackMs){
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

async function scene05PaymentTap(paymentBox, paymentHost){
  var tap = Scene05Config.motion.cardTap || {};
  var coinMotion = Scene05Config.motion.paymentCoin || {};
  var dur = tap.duration != null ? tap.duration : 680;
  var popDur = coinMotion.popDuration != null ? coinMotion.popDuration : 420;
  var floatHold = tap.paymentFloatHold != null ? tap.paymentFloatHold : 360;
  var fadeDur = tap.paymentFade != null ? tap.paymentFade : 200;
  var host;
  var inner;

  if(!paymentBox) return;

  if(paymentHost) Guide01.stopIdleFloat(paymentHost);

  host = paymentBox.querySelector('.s04-tap-payment-host');
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
      await scene05WaitAnimEnd(inner, 's04-payment-coin-pop', popDur + 80);
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
  if(paymentHost) Guide01.startIdleFloat(paymentHost);
}

async function scene05EnterIntro(assets){
  var intro = assets.intro;

  if(intro){
    if(intro.autoshipHost) hideElement(intro.autoshipHost);
    if(intro.paymentHost) hideElement(intro.paymentHost);
  }

  await scene05PrepPhase(assets, 'intro');
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterTitleFloatAsset(host){
  var FADE = scene05Motion('FADE');
  var dur = FADE.duration || 420;

  if(!host) return;

  showElement(host);
  host.classList.add('s05-fade-in');
  Guide01.startIdleFloat(host);
  await wait(dur);
  host.classList.remove('s05-fade-in');
}

async function scene05EnterTitleAutoship(assets){
  var intro = assets.intro;
  if(!intro || !intro.autoshipHost) return;

  await Guide01.enterZonedBadge(intro.autoshipHost, scene05BadgeEnter());
  Guide01.startIdleFloat(intro.autoshipHost);

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterTitlePayment(assets){
  var intro = assets.intro;
  if(!intro) return;

  await scene05EnterTitleFloatAsset(intro.paymentHost);

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

function scene05StartEpStackFloat(intro){
  if(!intro || !intro.epStack || intro.epStack.classList.contains('s05-ep-stack-idle')) return;
  intro.epStack.classList.add('s05-ep-stack-idle');
}

async function scene05StartEpStackFloatAfterPayment(intro){
  var motion = Scene05Config.motion.epStack || {};
  var delay = motion.floatAfterPayment != null ? motion.floatAfterPayment : 1000;
  var enterDur = motion.enterDuration != null ? motion.enterDuration : 520;
  var enterStagger = motion.enterStagger != null ? motion.enterStagger : 90;
  var enterTotal = enterDur + enterStagger * Math.max(0, (intro.epCoins.length - 1));
  var i;

  if(!intro || !intro.epStack) return;
  await wait(delay);

  showElement(intro.epStack);
  intro.epStack.classList.add('s05-ep-stack-entering');
  for(i = 0; i < intro.epCoins.length; i++){
    showElement(intro.epCoins[i]);
  }
  scene05StartEpStackFloat(intro);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);

  await wait(enterTotal);
  intro.epStack.classList.remove('s05-ep-stack-entering');
}

async function scene05RiseEpStack(assets){
  var intro = assets.intro;
  var motion = Scene05Config.motion.epStack || {};
  var riseDur = motion.riseDuration != null ? motion.riseDuration : 680;
  var inner = intro && intro.epStackInner;

  if(!intro || !intro.epStack || !inner) return;

  inner.classList.add('s05-ep-stack-rise');
  await scene05WaitAnimEnd(inner, 's05-ep-stack-rise', riseDur + 80);
  inner.classList.remove('s05-ep-stack-rise');
  inner.classList.add('is-raised');
  intro.epStack.classList.add('is-denied');

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05DenyEpStack(assets){
  var intro = assets.intro;
  var denyBadge;

  if(!intro) return;

  denyBadge = Scene05Layout.createInfoBadge('한 번에 발생하지 않음', 'is_red');
  if(denyBadge && intro.denyHost){
    intro.denyHost.textContent = '';
    intro.denyHost.appendChild(denyBadge);
    showElement(intro.denyHost);
    denyBadge.classList.add('s05-deny-badge-pop');
    await wait(scene05Motion('POP').duration || 520);
    denyBadge.classList.remove('s05-deny-badge-pop');
    intro.denyHost.classList.add('s05-soft-idle-float');
  }
}

async function scene05EnterCalendarPhase(assets){
  var cal = assets.calendar;

  await scene05ExitIntroCluster(assets);
  await scene05SwitchPhase(assets, ['intro'], 'calendar');

  if(cal && cal.calendarBody) showElement(cal.calendarBody);
  if(cal && cal.calendarRow) showElement(cal.calendarRow);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05DistributeEpCoins(assets){
  var cal = assets.calendar;
  var slots = cal && cal.slots;
  var motion = Scene05Config.motion.epFly || {};
  var flyDur = motion.duration != null ? motion.duration : 620;
  var stagger = motion.stagger != null ? motion.stagger : 280;
  var i;
  var slot;
  var epCoin;
  var floatInner;

  if(!slots || !slots.length) return;

  for(i = 0; i < slots.length; i++){
    slot = slots[i];
    if(!slot) continue;

    epCoin = Scene05Layout.createEpCoin((Scene05Config.layout.scales && Scene05Config.layout.scales.epCoin) || 0.88);
    if(!epCoin) continue;

    slot.epHost.textContent = '';
    slot.epHost.appendChild(epCoin);
    showElement(slot.epHost);
    epCoin.classList.add('s05-ep-fly-in');
    await scene05WaitAnimEnd(epCoin, 's05-ep-fly-in', flyDur + 80);
    epCoin.classList.remove('s05-ep-fly-in');
    floatInner = epCoin.querySelector('.g01-float-inner');
    if(floatInner) floatInner.classList.add('s05-ep-slot-idle');

    showElement(slot.foot);
    slot.foot.classList.add('s05-foot-pop');
    await wait(stagger);
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05ShowMonthBadge(assets){
  var cal = assets.calendar;
  var badge;
  var row;

  if(!cal) return;

  row = cal.calendarRow;
  if(row){
    row.classList.add('is-tight');
    await wait((Scene05Config.motion.calendarTight && Scene05Config.motion.calendarTight.duration) || 520);
  }

  badge = Scene05Layout.createInfoBadge('매월 1개월분씩 총 3회', 'is_green');
  if(badge && cal.monthBadgeHost){
    cal.monthBadgeHost.textContent = '';
    cal.monthBadgeHost.appendChild(badge);
    showElement(cal.monthBadgeHost);
    badge.classList.add('s05-month-badge-pop');
    await wait(scene05Motion('POP').duration || 520);
    badge.classList.add('s05-month-badge-flash');
    await wait(960);
    badge.classList.remove('s05-month-badge-flash');
    cal.monthBadgeHost.classList.add('s05-soft-idle-float');
  }
}

function scene05MountBenefitFloatWrap(badge, scale){
  var wrap = document.createElement('div');
  var floatInner = document.createElement('div');
  var s = scale != null ? scale : 1;

  wrap.className = 's05-benefit-float-host g01-float-host is-hidden';
  floatInner.className = 'g01-float-inner';
  floatInner.style.setProperty('--g01-base-scale', String(s));
  floatInner.style.transform = 'scale(' + s + ')';

  if(badge){
    badge.classList.add('guide01-asset');
    if(
      typeof Guide01.badgeToOpen === 'function' &&
      !badge.classList.contains('recommend_bonus_icon_ex') &&
      !badge.classList.contains('s05-cal-recommend-badge')
    ){
      Guide01.badgeToOpen(badge);
    }
    floatInner.appendChild(badge);
  }

  wrap.appendChild(floatInner);
  return { wrap: wrap, floatInner: floatInner, badge: badge };
}

async function scene05EnterBenefitFloat(host){
  var motion = Scene05Config.motion.benefitReveal || {};
  var dur = motion.fadeDuration != null ? motion.fadeDuration : 480;

  if(!host) return;

  showElement(host);
  host.classList.add('s05-fade-in');
  Guide01.startIdleFloat(host);
  await wait(dur);
  host.classList.remove('s05-fade-in');
}

async function scene05RevealCashbacks(assets){
  var slots = assets.calendar && assets.calendar.slots;
  var motion = Scene05Config.motion.benefitReveal || {};
  var stagger = motion.stagger != null ? motion.stagger : 420;
  var cashbackScale = (Scene05Config.layout.scales && Scene05Config.layout.scales.cashback) || 0.936;
  var pointScale = (Scene05Config.layout.scales && Scene05Config.layout.scales.pointBadge) || 0.85;
  var i;
  var slot;
  var badge;
  var pointBadge;
  var pack;

  if(!slots) return;

  for(i = 0; i < slots.length; i++){
    slot = slots[i];
    if(!slot) continue;

    showElement(slot.connector);
    slot.connector.classList.add('is-visible');
    await wait((Scene05Config.motion.cashback && Scene05Config.motion.cashback.connectorDuration) || 480);

    badge = Scene05Layout.cloneFromTemplate('cashback_icon');
    if(badge){
      pack = scene05MountBenefitFloatWrap(badge, cashbackScale);
      slot.cashbackHost.textContent = '';
      slot.cashbackHost.appendChild(pack.wrap);
      showElement(slot.cashbackHost);
      await scene05EnterBenefitFloat(pack.wrap);
    }
    await wait(stagger);

    pointBadge = Scene05Layout.createCalendarRecommendBadge();
    if(pointBadge){
      pack = scene05MountBenefitFloatWrap(pointBadge, pointScale);
      if(pack.wrap) pack.wrap.classList.add('s05-cal-recommend-float');
      slot.recommendHost.textContent = '';
      slot.recommendHost.appendChild(pack.wrap);
      showElement(slot.recommendHost);
      await scene05EnterBenefitFloat(pack.wrap);
    }
    await wait(stagger);
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05FadeOutCalendarPhase(assets){
  var cal = assets.calendar;
  var FADE = scene05Motion('FADE');

  if(!cal || !cal.phase || cal.phase.classList.contains('is-hidden')) return;

  await scene05FadeOutEl(cal.phase, FADE);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterRecommendPoint(host){
  var pointBadge;
  var scale = (Scene05Config.layout.scales && Scene05Config.layout.scales.pointBadge) || 0.85;
  var floatInner;
  var motion = Scene05Config.motion.recommendStory || {};
  var delay = motion.pointDelay != null ? motion.pointDelay : 200;

  if(!host) return;

  await wait(delay);

  pointBadge = Scene05Layout.createPointBadge();
  if(!pointBadge) return;

  floatInner = document.createElement('div');
  floatInner.className = 'g01-float-inner';
  floatInner.style.setProperty('--g01-base-scale', String(scale));
  floatInner.style.transform = 'scale(' + scale + ')';
  floatInner.appendChild(pointBadge);

  host.textContent = '';
  host.appendChild(floatInner);
  showElement(host);
  floatInner.classList.add('s05-pop-in');
  await wait(scene05Motion('POP').duration || 520);
  floatInner.classList.remove('s05-pop-in');
  floatInner.classList.add('g01-idle-float');
}

async function scene05RecommendScene1(assets){
  var rec = assets.recommendStory;
  var motion = Scene05Config.motion.recommendStory || {};
  var stagger = motion.productStagger != null ? motion.productStagger : 280;
  var letters = ['A', 'B', 'C'];
  var i;
  var wrap;
  var inner;

  if(!rec) return;

  await scene05SwitchPhase(assets, ['calendar'], 'recommendStory');

  if(rec.member1){
    showElement(rec.member1);
    await Guide01.showMemberWrap(rec.member1);
    scene05StartMemberIdle(rec.member1);
    if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
  }

  showElement(rec.leftProductRow);
  for(i = 0; i < letters.length; i++){
    wrap = rec.products[letters[i]];
    if(!wrap) continue;
    showElement(wrap);
    await scene05PopEl(wrap, scene05Motion('POP'));
    inner = wrap.querySelector('.g01-float-inner');
    if(inner) inner.classList.add('g01-idle-float');
    await wait(stagger);
  }

  await scene05EnterRecommendPoint(rec.leftPointHost);

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05RecommendScene2(assets){
  var rec = assets.recommendStory;
  var wrap;
  var inner;

  if(!rec) return;

  showElement(rec.rightCol);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);

  if(rec.member2){
    showElement(rec.member2);
    await Guide01.showMemberWrap(rec.member2);
    scene05StartMemberIdle(rec.member2);
    if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
  }

  wrap = rec.rightProductWrap;
  if(wrap){
    showElement(wrap);
    await scene05PopEl(wrap, scene05Motion('POP'));
    inner = wrap.querySelector('.g01-float-inner');
    if(inner) inner.classList.add('g01-idle-float');
  }

  await scene05EnterRecommendPoint(rec.rightPointHost);

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05RecommendNotice(assets){
  var rec = assets.recommendStory;
  var notice;
  var motion = Scene05Config.motion.noticeEmphasis || {};
  var flashDur = motion.flashDuration != null ? motion.flashDuration : 960;

  if(!rec || !rec.noticeHost) return;

  notice = Scene05Layout.createRecommendNoticeBadge();
  if(!notice) return;

  rec.noticeHost.textContent = '';
  rec.noticeHost.appendChild(notice);
  showElement(rec.noticeHost);
  notice.classList.add('s05-recommend-notice-pop');
  await wait(scene05Motion('POP').duration || 520);
  notice.classList.remove('s05-recommend-notice-pop');
  notice.classList.add('s05-recommend-notice-flash');
  await wait(flashDur);
  notice.classList.remove('s05-recommend-notice-flash');
  notice.classList.add('s05-soft-idle-float');

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05HoldWithIdleFloat(assets){
  var rec = assets.recommendStory;
  var noticeBadge;
  var i;
  var wraps;
  var inner;

  if(!rec) return;

  noticeBadge = rec.noticeHost && rec.noticeHost.querySelector('.s05-recommend-notice-badge');
  if(noticeBadge && rec.noticeHost && !rec.noticeHost.classList.contains('is-hidden')){
    noticeBadge.classList.add('s05-soft-idle-float');
  }

  wraps = rec.products ? Object.keys(rec.products).map(function(k){ return rec.products[k]; }) : [];
  if(rec.rightProductWrap) wraps.push(rec.rightProductWrap);
  for(i = 0; i < wraps.length; i++){
    inner = wraps[i] && wraps[i].querySelector('.g01-float-inner');
    if(inner && !inner.classList.contains('g01-idle-float')) inner.classList.add('g01-idle-float');
  }
}

async function runScene05MotionCore(tl, assets, canvas, ctx){
  var T = Scene05Config.T;
  var at = function(mainMs){ return scene05AtMain(mainMs, ctx); };

  await scene05EnterIntro(assets);

  await tl.wait(T.title.autoship != null ? T.title.autoship : 0);
  if(scene05Cancelled(ctx)) return;
  await scene05EnterTitleAutoship(assets);

  await wait(T.title.paymentAfterAutoship != null ? T.title.paymentAfterAutoship : 0);
  if(scene05Cancelled(ctx)) return;
  await scene05EnterTitlePayment(assets);

  await tl.wait(at(T.main.paymentTap));
  if(scene05Cancelled(ctx)) return;
  await scene05PaymentTap(assets.intro && assets.intro.payment, assets.intro && assets.intro.paymentHost);
  if(scene05Cancelled(ctx)) return;
  await scene05StartEpStackFloatAfterPayment(assets.intro);

  await tl.wait(at(T.main.epStackRise));
  if(scene05Cancelled(ctx)) return;
  await scene05RiseEpStack(assets);

  await tl.wait(at(T.main.denyEp));
  if(scene05Cancelled(ctx)) return;
  await scene05DenyEpStack(assets);

  await tl.wait(at(T.main.calendarLayout));
  if(scene05Cancelled(ctx)) return;
  await scene05EnterCalendarPhase(assets);

  await tl.wait(at(T.main.epDistribute));
  if(scene05Cancelled(ctx)) return;
  await scene05DistributeEpCoins(assets);

  await tl.wait(at(T.main.monthBadge));
  if(scene05Cancelled(ctx)) return;
  await scene05ShowMonthBadge(assets);

  await tl.wait(at(T.main.cashback));
  if(scene05Cancelled(ctx)) return;
  await scene05RevealCashbacks(assets);

  await tl.wait(at(T.main.calendarFadeOut));
  if(scene05Cancelled(ctx)) return;
  await scene05FadeOutCalendarPhase(assets);

  await tl.wait(at(T.main.recommendScene1));
  if(scene05Cancelled(ctx)) return;
  await scene05RecommendScene1(assets);

  await tl.wait(at(T.main.recommendScene2));
  if(scene05Cancelled(ctx)) return;
  await scene05RecommendScene2(assets);

  await tl.wait(at(T.main.recommendNotice));
  if(scene05Cancelled(ctx)) return;
  await scene05RecommendNotice(assets);

  await tl.wait(at(T.main.holdFloat));
  if(scene05Cancelled(ctx)) return;
  await scene05HoldWithIdleFloat(assets);
}

</script>
