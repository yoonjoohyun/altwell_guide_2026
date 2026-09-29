<script>
/* guide01 Scene 06 — 구독 중 추가·변경·해지 */
var Guide01Scene06 = defineScene({
  id: Scene06Config.id,
  title: Scene06Config.title,
  duration: Scene06Config.duration,
  mediaSequence: Scene06Config.media.sequence,
  mediaFallbackMs: Scene06Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene06-panel');
    if(typeof Scene06Layout !== 'undefined') Scene06Layout.unbindResize();
    Guide01.resetScene(Scene06Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene06-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene06Config.canvasCls);
    Guide01.mountStage(canvas, Scene06Config.canvasCls);

    var assets = setupScene06Assets(canvas);

    await Promise.all([
      runScene06MotionCore(tl, assets, canvas, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene06Config.panel.title,
        Scene06Config.panel.bullets,
        scene06PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene06Config.duration);
  }
});

function scene06Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene06LayoutSettleMs(){
  return (Scene06Config.motion && Scene06Config.motion.layoutTransition) || 480;
}

async function scene06PrepBlock(wrap, assets){
  var inner = assets.group && assets.group._scene06Inner;
  var hasVisibleSibling = false;
  var siblings;
  var i;

  if(!wrap) return;

  if(inner){
    siblings = inner.querySelectorAll('.scene06-group-child');
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
  if(typeof Scene06Layout !== 'undefined'){
    Scene06Layout.scheduleLayout(!hasVisibleSibling);
  }
  if(hasVisibleSibling) await wait(scene06LayoutSettleMs());
  wrap.style.removeProperty('opacity');
}

async function scene06PopEl(el, opts){
  if(!el) return;
  showElement(el);
  el.classList.add('s06-pop-in');
  await wait((opts && opts.duration) || scene06Motion('POP').duration || 520);
  el.classList.remove('s06-pop-in');
}

async function scene06EnterProduct(wrap){
  var FADE = scene06Motion('FADE');

  if(!wrap) return;

  wrap.style.opacity = '0';
  showElement(wrap);
  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
  await wait(scene06LayoutSettleMs());
  wrap.style.removeProperty('opacity');

  await Guide01.fadeZoned(wrap, true, FADE);
  Guide01.startIdleFloat(wrap);
  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
}

async function scene06EnterTitleIntro(tl, canvas, assets, ctx){
  var T = Scene06Config.T.title;
  var BADGE = scene06BadgeEnter();
  var primary = assets.primary;

  showElement(assets.group);
  await scene06PrepBlock(assets.member, assets);
  await Guide01.showMemberWrap(assets.member);
  if(typeof scene03StartMemberIdle === 'function') scene03StartMemberIdle(assets.member);
  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
  if(scene06Cancelled(ctx)) return;

  await tl.wait(T.dRank != null ? T.dRank : 0);
  if(scene06Cancelled(ctx)) return;
  if(typeof scene03PromoteWithDRank === 'function') await scene03PromoteWithDRank(assets);
  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);

  await tl.wait(T.autoshipAttach != null ? T.autoshipAttach : 0);
  if(scene06Cancelled(ctx)) return;
  if(typeof scene03AttachAutoshipOpen === 'function'){
    await scene03AttachAutoshipOpen(canvas, assets, { ctx: ctx, BADGE: BADGE });
  }
  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);

  await tl.wait(T.productA != null ? T.productA : 0);
  if(scene06Cancelled(ctx)) return;

  await scene06PrepBlock(primary.block, assets);
  showElement(primary.productRow);
  await scene06EnterProduct(primary.products.A);
}

async function scene06EnterBcdeAndBadge(assets){
  var primary = assets.primary;
  var letters = ['B', 'C', 'D', 'E'];
  var stagger = (Scene06Config.motion && Scene06Config.motion.productStagger) || 320;
  var badge;
  var i;

  if(!primary) return;

  for(i = 0; i < letters.length; i++){
    await scene06EnterProduct(primary.products[letters[i]]);
    if(i < letters.length - 1) await wait(stagger);
  }

  if(primary.addBadgeHost){
    var floatInner = document.createElement('div');
    var dur = (Scene06Config.motion.unavailable && Scene06Config.motion.unavailable.duration) || 520;

    badge = Scene06Layout.createAddBadge();
    if(badge){
      floatInner.className = 'g01-float-inner s03-stamp-float-inner s06-add-badge-float';
      floatInner.style.setProperty('--g01-base-scale', '0.8');
      floatInner.appendChild(badge);
      primary.addBadgeHost.textContent = '';
      primary.addBadgeHost.appendChild(floatInner);
      primary.addBadgeFloat = floatInner;
      showElement(primary.addBadgeHost);
      primary.addBadgeHost.classList.add('is-visible');
      floatInner.classList.add('g01-anim-pop');
      await wait(dur);
      floatInner.classList.remove('g01-anim-pop');
      floatInner.classList.add('g01-idle-float');
    }
  }

  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
}

async function scene06EnterDuplicateRow(assets){
  var dup = assets.duplicate;
  var keys = ['dup_0', 'dup_1', 'dup_2', 'dup_3', 'dup_4'];
  var dur = (Scene06Config.motion.unavailable && Scene06Config.motion.unavailable.duration) || 520;
  var i;
  var wrap;
  var jobs = [];

  if(!dup) return;

  await scene06PrepBlock(dup.block, assets);
  showElement(dup.row);

  for(i = 0; i < keys.length; i++){
    wrap = dup.products[keys[i]];
    if(!wrap) continue;
    jobs.push(scene06EnterProduct(wrap));
  }
  await Promise.all(jobs);

  for(i = 0; i < 4; i++){
    wrap = dup.products['dup_' + i];
    if(wrap) wrap.classList.add('is-grayscale', 'is-unavailable');
  }

  if(dup.stampHost && dup.stampFloat){
    showElement(dup.stampHost);
    dup.stampHost.classList.add('is-visible');
    dup.stampFloat.classList.add('g01-anim-pop');
    await wait(dur);
    dup.stampFloat.classList.remove('g01-anim-pop');
    dup.stampFloat.classList.add('g01-idle-float');
  }

  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
}

async function scene06EnterSwapPanel(assets){
  var swap = assets.swap;
  if(!swap) return;

  await scene06PrepBlock(swap.block, assets);
  showElement(swap.block);
  swap.block.classList.add('s06-pop-in');
  if(swap.panel) swap.panel.classList.add('s06-soft-idle-float');
  await wait(scene06Motion('POP').duration || 520);
  swap.block.classList.remove('s06-pop-in');

  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
}

function scene06StopPriorFloats(assets){
  var primary = assets.primary;
  var dup = assets.duplicate;
  var swap = assets.swap;
  var key;

  if(assets.member){
    if(typeof scene03StopMemberIdle === 'function') scene03StopMemberIdle(assets.member);
    else Guide01.stopIdleFloat(assets.member);
  }

  if(primary){
    if(primary.products){
      for(key in primary.products){
        if(primary.products[key]) Guide01.stopIdleFloat(primary.products[key]);
      }
    }
    if(primary.addBadgeFloat){
      primary.addBadgeFloat.classList.remove('g01-idle-float', 'g01-anim-pop');
    }
  }

  if(dup){
    if(dup.stampFloat) dup.stampFloat.classList.remove('g01-idle-float', 'g01-anim-pop');
    if(dup.products){
      for(key in dup.products){
        if(dup.products[key]) Guide01.stopIdleFloat(dup.products[key]);
      }
    }
  }

  if(swap && swap.panel){
    swap.panel.classList.remove('s06-soft-idle-float');
  }
}

async function scene06FadeOutEl(el, opts){
  if(!el || el.classList.contains('is-hidden')) return;

  el.classList.add('s06-fade-out');
  await wait((opts && opts.duration) || scene06Motion('FADE').duration || 420);
  el.classList.remove('s06-fade-out');
  hideElement(el);
}

async function scene06FadeOutPriorAssets(assets){
  var targets = [];
  var FADE = scene06Motion('FADE');

  scene06StopPriorFloats(assets);

  if(assets.member && !assets.member.classList.contains('is-hidden')) targets.push(assets.member);
  if(assets.primary && assets.primary.block && !assets.primary.block.classList.contains('is-hidden')){
    targets.push(assets.primary.block);
  }
  if(assets.duplicate && assets.duplicate.block && !assets.duplicate.block.classList.contains('is-hidden')){
    targets.push(assets.duplicate.block);
  }
  if(assets.swap && assets.swap.block && !assets.swap.block.classList.contains('is-hidden')){
    targets.push(assets.swap.block);
  }

  if(!targets.length) return;

  await Promise.all(targets.map(function(el){
    return scene06FadeOutEl(el, FADE);
  }));

  if(typeof Scene06Layout !== 'undefined'){
    Scene06Layout.scheduleLayout(true);
  }
}

function scene06RepositionFlowProgress(track, progress){
  if(!track || !progress || typeof scene04PositionPaymentProgress !== 'function') return;

  return new Promise(function(resolve){
    requestAnimationFrame(function(){
      requestAnimationFrame(function(){
        scene04PositionPaymentProgress(track, progress);
        resolve();
      });
    });
  });
}

function scene06CalendarStepMotion(){
  if(typeof Scene04Config !== 'undefined' && Scene04Config.motion && Scene04Config.motion.calendarStep){
    return Scene04Config.motion.calendarStep;
  }
  return {
    jumpDuration: 600,
    stagger: 380,
    jumpPeak: -5,
    jumpSettle: 2,
    jumpScalePeak: 1.015,
    jumpScaleSettle: 0.995
  };
}

async function scene06ActivateCalendarSteps(assets, ctx){
  var flow = assets.calendar && assets.calendar.flow;
  var wrap = assets.calendar && assets.calendar.wrap;
  var motion = scene06CalendarStepMotion();
  var jumpDur = motion.jumpDuration != null ? motion.jumpDuration : 600;
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
  if(progress && typeof scene04StopProgressDots === 'function'){
    scene04StopProgressDots(progress, true);
  }

  if(wrap) Guide01.stopIdleFloat(wrap);
  if(typeof scene04GetFlowMonthEntries !== 'function') return;

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

    month.classList.remove('is-payment-month', 'is-active-month', 's06-month-cancelled');
    month.style.transform = '';
    if(coin){
      coin.classList.add('is-hidden');
      coin.classList.remove('s04-payment-coin-pop');
      inner = coin.querySelector('.s04-flow-payment-coin-inner');
      if(inner) inner.classList.remove('s04-soft-idle-float');
    }

    if(typeof scene04RunMonthJump === 'function'){
      await scene04RunMonthJump(month, jumpDur);
    }else{
      await wait(jumpDur);
    }

    if(entry.index === 1 && coin && typeof scene04RevealPaymentCoin === 'function'){
      await scene04RevealPaymentCoin(coin);
      if(progress && track){
        await scene06RepositionFlowProgress(track, progress);
      }
    }

    if(isPaymentMonth){
      if(entry.index === 3){
        month.classList.add('s06-month-cancelled');
      }else{
        month.classList.add('is-payment-month');
      }

      if(coin && typeof scene04RevealPaymentCoin === 'function'){
        if(entry.index === 3 && progress && typeof scene04FreezeProgressDots === 'function'){
          scene04FreezeProgressDots(progress);
          showElement(progress);
        }
        await scene04RevealPaymentCoin(coin);
        if(entry.index === 0 && progress && track){
          if(typeof scene04ResetProgressDots === 'function'){
            scene04ResetProgressDots(progress);
          }
          showElement(progress);
          await scene06RepositionFlowProgress(track, progress);
          if(typeof scene04StartProgressDots === 'function'){
            scene04StartProgressDots(progress, ctx);
          }
        }
      }
    }

    if(i < entries.length - 1) await wait(stagger);
  }
}

async function scene06EnterCancelFlow(assets, ctx){
  var cal = assets.calendar;
  var FADE = scene06Motion('FADE');

  if(!cal) return;

  await scene06FadeOutPriorAssets(assets);

  await scene06PrepBlock(cal.block, assets);
  showElement(cal.block);

  if(cal.wrap){
    showElement(cal.wrap);
    Guide01.stopIdleFloat(cal.wrap);
    await Guide01.fadeZoned(cal.wrap, true, FADE);
    await scene06ActivateCalendarSteps(assets, ctx);
  }

  if(typeof Scene06Layout !== 'undefined') Scene06Layout.scheduleLayout(false);
}

async function scene06HoldWithIdleFloat(assets){
  if(assets.calendar && assets.calendar.wrap){
    Guide01.startIdleFloat(assets.calendar.wrap);
  }
}

async function runScene06MotionCore(tl, assets, canvas, ctx){
  var T = Scene06Config.T.main;
  var at = function(mainMs){ return scene06AtMain(mainMs, ctx); };

  await scene06EnterTitleIntro(tl, canvas, assets, ctx);
  if(scene06Cancelled(ctx)) return;

  await tl.wait(at(T.addBcde));
  if(scene06Cancelled(ctx)) return;
  await scene06EnterBcdeAndBadge(assets);

  await tl.wait(at(T.duplicateRow));
  if(scene06Cancelled(ctx)) return;
  await scene06EnterDuplicateRow(assets);

  await tl.wait(at(T.swapPanel));
  if(scene06Cancelled(ctx)) return;
  await scene06EnterSwapPanel(assets);

  await tl.wait(at(T.cancelFlow));
  if(scene06Cancelled(ctx)) return;
  await scene06EnterCancelFlow(assets, ctx);

  await tl.wait(at(T.holdFloat));
  if(scene06Cancelled(ctx)) return;
  await scene06HoldWithIdleFloat(assets);
}

</script>
