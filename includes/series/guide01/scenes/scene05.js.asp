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
  else if(phaseKey === 'memberProduct') wrap = assets.memberProduct && assets.memberProduct.phase;
  else if(phaseKey === 'dual') wrap = assets.dual && assets.dual.phase;
  else if(phaseKey === 'summary') wrap = assets.summary && assets.summary.phase;

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
    else if(key === 'memberProduct') wrap = assets.memberProduct && assets.memberProduct.phase;
    else if(key === 'dual') wrap = assets.dual && assets.dual.phase;
    else if(key === 'summary') wrap = assets.summary && assets.summary.phase;
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

async function scene05PaymentTap(paymentBox, paymentFloat){
  var tap = Scene05Config.motion.cardTap || {};
  var coinMotion = Scene05Config.motion.paymentCoin || {};
  var dur = tap.duration != null ? tap.duration : 680;
  var popDur = coinMotion.popDuration != null ? coinMotion.popDuration : 420;
  var floatHold = tap.paymentFloatHold != null ? tap.paymentFloatHold : 360;
  var fadeDur = tap.paymentFade != null ? tap.paymentFade : 200;
  var host;
  var inner;

  if(!paymentBox) return;

  if(paymentFloat) paymentFloat.classList.remove('g01-idle-float');

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
  if(paymentFloat) paymentFloat.classList.add('g01-idle-float');
}

async function scene05EnterIntro(assets){
  var intro = assets.intro;
  var FADE = scene05Motion('FADE');
  var i;

  await scene05PrepPhase(assets, 'intro');

  if(intro.paymentHost){
    await scene05FadeEl(intro.paymentHost, FADE);
    if(intro.paymentFloat) intro.paymentFloat.classList.add('g01-idle-float');
  }

  if(intro.epStack){
    showElement(intro.epStack);
    for(i = 0; i < intro.epCoins.length; i++){
      showElement(intro.epCoins[i]);
    }
    intro.epStack.classList.add('s05-ep-stack-idle');
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05DenyEpStack(assets){
  var intro = assets.intro;
  var motion = Scene05Config.motion.epStack || {};
  var riseDur = motion.riseDuration != null ? motion.riseDuration : 680;
  var denyBadge;

  if(!intro || !intro.epStack) return;

  intro.epStack.classList.remove('s05-ep-stack-idle');
  intro.epStack.classList.add('s05-ep-stack-rise');
  await wait(riseDur);
  intro.epStack.classList.remove('s05-ep-stack-rise');
  intro.epStack.classList.add('is-denied');

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

  await scene05SwitchPhase(assets, ['intro'], 'calendar');

  if(cal && cal.paymentHost){
    showElement(cal.paymentHost);
    if(cal.paymentMiniFloat) cal.paymentMiniFloat.classList.add('g01-idle-float');
  }
  if(cal && cal.calendarBody) showElement(cal.calendarBody);
  if(cal && cal.calendarRow) showElement(cal.calendarRow);
  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05DistributeEpCoins(assets){
  var cal = assets.calendar;
  var slots = cal && cal.slots;
  var introCoins = assets.intro && assets.intro.epCoins;
  var motion = Scene05Config.motion.epFly || {};
  var flyDur = motion.duration != null ? motion.duration : 620;
  var stagger = motion.stagger != null ? motion.stagger : 280;
  var i;
  var slot;
  var coin;
  var epCoin;
  var floatInner;

  if(!slots || !introCoins) return;

  for(i = 0; i < slots.length; i++){
    slot = slots[i];
    coin = introCoins[i];
    if(!slot || !coin) continue;

    epCoin = Scene05Layout.createEpCoin((Scene05Config.layout.scales && Scene05Config.layout.scales.epCoin) || 0.88);
    if(!epCoin) continue;

    slot.epHost.textContent = '';
    slot.epHost.appendChild(epCoin);
    showElement(slot.epHost);
    epCoin.classList.add('s05-ep-fly-in');
    await wait(flyDur);
    epCoin.classList.remove('s05-ep-fly-in');
    floatInner = epCoin.querySelector('.g01-float-inner');
    if(floatInner) floatInner.classList.add('g01-idle-float');

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

async function scene05RevealCashbacks(assets){
  var slots = assets.calendar && assets.calendar.slots;
  var motion = Scene05Config.motion.cashback || {};
  var stagger = motion.stagger != null ? motion.stagger : 380;
  var i;
  var slot;
  var badge;
  var wrap;
  var floatInner;

  if(!slots) return;

  for(i = 0; i < slots.length; i++){
    slot = slots[i];
    if(!slot) continue;

    showElement(slot.connector);
    slot.connector.classList.add('is-visible');

    badge = Scene05Layout.cloneFromTemplate('cashback_icon_c');
    if(!badge) continue;

    wrap = document.createElement('div');
    wrap.className = 's05-cashback-wrap';
    floatInner = document.createElement('div');
    floatInner.className = 'g01-float-inner';
    floatInner.style.setProperty('--g01-base-scale', String((Scene05Config.layout.scales && Scene05Config.layout.scales.cashback) || 0.78));
    floatInner.style.transform = 'scale(' + ((Scene05Config.layout.scales && Scene05Config.layout.scales.cashback) || 0.78) + ')';
    badge.classList.add('guide01-asset');
    floatInner.appendChild(badge);
    wrap.appendChild(floatInner);

    slot.cashbackHost.textContent = '';
    slot.cashbackHost.appendChild(wrap);
    showElement(slot.cashbackHost);
    await scene05PopEl(wrap, { duration: stagger });
    wrap.querySelector('.g01-float-inner').classList.add('g01-idle-float');
    await wait(stagger);
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05ShowMemberSide(assets){
  var cal = assets.calendar;
  var pointBadge;

  if(!cal) return;

  cal.phase.classList.add('has-member-side');
  showElement(cal.memberSide);
  showElement(cal.member);
  await Guide01.showMemberWrap(cal.member);
  scene05StartMemberIdle(cal.member);

  pointBadge = Scene05Layout.createPointBadge();
  if(pointBadge && cal.pointBadgeHost){
    await scene05EnterBadgeEl(cal.pointBadgeHost, pointBadge);
    cal.pointBadgeHost.classList.add('s05-soft-idle-float');
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterMemberProducts(assets){
  var mp = assets.memberProduct;
  var letters = ['A', 'B', 'C'];
  var i;
  var wrap;

  await scene05SwitchPhase(assets, ['calendar'], 'memberProduct');

  if(mp.member){
    showElement(mp.member);
    await Guide01.showMemberWrap(mp.member);
    scene05StartMemberIdle(mp.member);
  }

  showElement(mp.productRow);
  for(i = 0; i < letters.length; i++){
    wrap = mp.products[letters[i]];
    if(!wrap) continue;
    showElement(wrap);
    await scene05PopEl(wrap, scene05Motion('POP'));
    var inner = wrap.querySelector('.g01-float-inner');
    if(inner) inner.classList.add('g01-idle-float');
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05ProductPointDeny(assets){
  var mp = assets.memberProduct;
  var motion = Scene05Config.motion.pointAttempt || {};
  var dur = motion.duration != null ? motion.duration : 420;
  var stagger = motion.stagger != null ? motion.stagger : 160;
  var letters = ['A', 'B', 'C'];
  var personBadge;
  var i;
  var wrap;
  var pointHost;
  var token;

  if(!mp) return;

  for(i = 0; i < letters.length; i++){
    wrap = mp.products[letters[i]];
    if(!wrap) continue;
    pointHost = wrap.querySelector('.s05-product-point-host');
    if(!pointHost) continue;

    token = Scene05Layout.cloneFromTemplate('point_token_icon');
    if(token){
      token.classList.add('guide01-asset', 's05-product-point-token');
      pointHost.appendChild(token);
      showElement(pointHost);
      pointHost.classList.add('s05-point-attempt');
      await wait(dur);
      pointHost.classList.remove('s05-point-attempt');
      pointHost.classList.add('is-denied');
      wrap.classList.add('is-grayscale');
    }
    await wait(stagger);
  }

  personBadge = Scene05Layout.createInfoBadge('1인', 'is_green');
  if(personBadge && mp.personBadgeHost){
    mp.personBadgeHost.textContent = '';
    mp.personBadgeHost.appendChild(personBadge);
    showElement(mp.personBadgeHost);
    personBadge.classList.add('s05-person-badge-pop');
    await wait(scene05Motion('POP').duration || 520);
    mp.personBadgeHost.classList.add('s05-soft-idle-float');
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterDualCompare(assets){
  var dual = assets.dual;
  var sides = [dual.left, dual.right];
  var i;
  var side;
  var pointBadge;

  await scene05SwitchPhase(assets, ['memberProduct'], 'dual');

  for(i = 0; i < sides.length; i++){
    side = sides[i];
    if(!side) continue;

    showElement(side.group);
    showElement(side.member);
    await Guide01.showMemberWrap(side.member);
    scene05StartMemberIdle(side.member);

    showElement(side.productRow);
    var keys = Object.keys(side.products);
    var j;
    for(j = 0; j < keys.length; j++){
      showElement(side.products[keys[j]]);
    }

    pointBadge = Scene05Layout.createPointBadge();
    if(pointBadge && side.pointHost){
      await scene05EnterBadgeEl(side.pointHost, pointBadge);
    }
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05ShowMultiProductBracket(assets){
  var right = assets.dual && assets.dual.right;
  var bracket;

  if(!right || !right.bracketHost) return;

  bracket = Scene05Layout.cloneFromTemplate('group_bracket');
  if(!bracket) return;

  bracket.classList.add('guide01-asset');
  right.bracketHost.textContent = '';
  right.bracketHost.appendChild(bracket);
  showElement(right.bracketHost);
  bracket.classList.add('s05-bracket-pop');
  await wait(scene05Motion('POP').duration || 520);

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05EnterSummary(assets){
  var summary = assets.summary;
  var card;
  var pointEl;
  var motion = Scene05Config.motion.summaryEmphasis || {};

  await scene05SwitchPhase(assets, ['dual'], 'summary');

  if(summary.card){
    await scene05FadeEl(summary.card, scene05Motion('FADE'));
    summary.card.classList.add('s05-soft-idle-float');

    pointEl = summary.card.querySelector('.member_basis_point');
    if(pointEl){
      pointEl.classList.add('s05-point-emphasis');
      await wait(motion.duration != null ? motion.duration : 680);
      pointEl.classList.remove('s05-point-emphasis');
    }
  }

  if(typeof Scene05Layout !== 'undefined') Scene05Layout.scheduleLayout(false);
}

async function scene05HoldWithIdleFloat(assets){
  var cal = assets.calendar;
  var mp = assets.memberProduct;
  var dual = assets.dual;
  var summary = assets.summary;

  if(summary && summary.card) summary.card.classList.add('s05-soft-idle-float');
}

async function runScene05MotionCore(tl, assets, canvas, ctx){
  var T = Scene05Config.T;
  var at = function(mainMs){ return scene05AtMain(mainMs, ctx); };

  await tl.wait(T.title.intro || 0);
  if(scene05Cancelled(ctx)) return;
  await scene05EnterIntro(assets);

  await tl.wait(at(T.main.paymentTap));
  if(scene05Cancelled(ctx)) return;
  await scene05PaymentTap(assets.intro && assets.intro.payment, assets.intro && assets.intro.paymentFloat);

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

  await tl.wait(at(T.main.memberSide));
  if(scene05Cancelled(ctx)) return;
  await scene05ShowMemberSide(assets);

  await tl.wait(at(T.main.memberProducts));
  if(scene05Cancelled(ctx)) return;
  await scene05EnterMemberProducts(assets);

  await tl.wait(at(T.main.productDeny));
  if(scene05Cancelled(ctx)) return;
  await scene05ProductPointDeny(assets);

  await tl.wait(at(T.main.dualCompare));
  if(scene05Cancelled(ctx)) return;
  await scene05EnterDualCompare(assets);

  await tl.wait(at(T.main.multiProductBracket));
  if(scene05Cancelled(ctx)) return;
  await scene05ShowMultiProductBracket(assets);

  await tl.wait(at(T.main.summary));
  if(scene05Cancelled(ctx)) return;
  await scene05EnterSummary(assets);

  await tl.wait(at(T.main.holdFloat));
  if(scene05Cancelled(ctx)) return;
  await scene05HoldWithIdleFloat(assets);
}

</script>
