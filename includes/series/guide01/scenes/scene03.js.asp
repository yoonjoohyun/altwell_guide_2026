<script>
/* guide01 Scene 03 — 어떻게 구독하나요? */
var Guide01Scene03 = defineScene({
  id: Scene03Config.id,
  title: Scene03Config.title,
  duration: Scene03Config.duration,
  mediaSequence: Scene03Config.media.sequence,
  mediaFallbackMs: Scene03Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove('scene03-panel');
    if(typeof Scene03Layout !== 'undefined') Scene03Layout.unbindResize();
    Guide01.resetScene(Scene03Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    if(!canvas) return;

    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add('scene03-panel');

    var tl = Guide01.timeline(ctx);

    Guide01.resetScene(Scene03Config.canvasCls);
    Guide01.mountStage(canvas, Scene03Config.canvasCls);

    var assets = setupScene03Assets(canvas);

    await Promise.all([
      runScene03MotionCore(tl, assets, canvas, ctx),
      Guide01.panelBulletTimeline(
        tl,
        Scene03Config.panel.title,
        Scene03Config.panel.bullets,
        scene03PanelFlashes(ctx)
      )
    ]);

    if(ctx.isCancelled && ctx.isCancelled()) return;

    await Guide01.finishSceneHold(tl, ctx.sceneDuration || Scene03Config.duration);
  }
});

function scene03Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

function scene03LayoutSettleMs(){
  return (Scene03Config.motion && Scene03Config.motion.layoutTransition) || 480;
}

async function scene03PrepStackSlot(wrap){
  if(!wrap) return;

  var inner = wrap.parentElement;
  var hasVisibleSibling = false;
  var siblings;
  var i;

  if(inner){
    siblings = inner.querySelectorAll('.scene03-group-child');
    for(i = 0; i < siblings.length; i++){
      if(siblings[i] !== wrap && !siblings[i].classList.contains('is-hidden')){
        hasVisibleSibling = true;
        break;
      }
    }
  }

  wrap.style.opacity = '0';
  showElement(wrap);
  if(typeof Scene03Layout !== 'undefined'){
    Scene03Layout.scheduleLayout(!hasVisibleSibling);
  }

  if(hasVisibleSibling){
    await wait(scene03LayoutSettleMs());
  }

  wrap.style.removeProperty('opacity');
}

async function scene03PrepProductSlot(wrap){
  if(!wrap) return;

  var row = wrap.closest('.s03-product-row');
  var visible;
  var hasVisibleSibling = false;
  var i;

  wrap.style.opacity = '0';
  showElement(wrap);

  if(row){
    visible = row.querySelectorAll('.s03-product-wrap:not(.is-hidden)');
    for(i = 0; i < visible.length; i++){
      if(visible[i] !== wrap){
        hasVisibleSibling = true;
        break;
      }
    }
  }

  if(typeof Scene03Layout !== 'undefined'){
    Scene03Layout.scheduleLayout(!hasVisibleSibling);
  }

  if(hasVisibleSibling){
    await wait(scene03LayoutSettleMs());
  }

  wrap.style.removeProperty('opacity');
}

function scene03StartMemberIdle(memberWrap){
  if(!memberWrap) return;
  var stack = memberWrap.querySelector('.g01-member-stack');
  if(stack) stack.classList.add('g01-idle-float');
}

function scene03StopMemberIdle(memberWrap){
  if(!memberWrap) return;
  var stack = memberWrap.querySelector('.g01-member-stack');
  if(stack) stack.classList.remove('g01-idle-float');
}

async function scene03EnterBadge(wrap, opts){
  if(!wrap) return;
  await Guide01.enterZonedBadge(wrap, opts || scene03BadgeEnter());
  Guide01.startIdleFloat(wrap);
}

async function scene03FoldBadge(wrap){
  if(!wrap) return;
  Guide01.stopIdleFloat(wrap);
  var badge = Guide01.resolveZonedBadge(wrap);
  if(badge && typeof G01BadgeFold !== 'undefined'){
    await G01BadgeFold.fold(badge, { duration: Scene03Config.motion.FOLD.duration || 620 });
  }
}

function scene03SyncRankIdlePhase(memberWrap){
  var icon = memberWrap && memberWrap.querySelector('.member_icon');
  var rank = memberWrap && memberWrap.querySelector('.s03-d-rank-badge');
  var iconAnims;
  var rankAnims;
  var iconAnim = null;
  var i;

  if(!icon || !rank || rank.classList.contains('is-hidden')) return;

  requestAnimationFrame(function(){
    iconAnims = icon.getAnimations();
    rankAnims = rank.getAnimations();
    for(i = 0; i < iconAnims.length; i++){
      if(iconAnims[i].animationName === 's03-member-body-idle'){
        iconAnim = iconAnims[i];
        break;
      }
    }
    if(!iconAnim) return;
    for(i = 0; i < rankAnims.length; i++){
      if(rankAnims[i].animationName === 's03-member-body-idle'){
        rankAnims[i].currentTime = iconAnim.currentTime;
      }
    }
  });
}

async function scene03ShowDRank(dRank, memberWrap){
  if(!dRank) return;
  dRank.classList.add('s03-d-rank-enter');
  showElement(dRank);
  await wait(480);
  dRank.classList.remove('s03-d-rank-enter');
  dRank.classList.add('s03-rank-idle-active');
  scene03SyncRankIdlePhase(memberWrap);
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
}

async function scene03PromoteMemberColor(memberWrap){
  if(!memberWrap) return;
  var icon = memberWrap.querySelector('.member_icon');
  if(!icon) return;

  var dur = (Scene03Config.motion.colorPromote && Scene03Config.motion.colorPromote.duration) || 520;

  memberWrap.classList.add('is-member-promoted');
  icon.classList.remove('s03-toned-as-person');
  await wait(dur);
}

async function scene03PromoteWithDRank(assets){
  await Promise.all([
    scene03ShowDRank(assets.dRank, assets.member),
    scene03PromoteMemberColor(assets.member)
  ]);
}

function scene03SyncAutoshipIdlePhase(memberWrap){
  var icon = memberWrap && memberWrap.querySelector('.member_icon');
  var autoship = memberWrap && memberWrap.querySelector('.s03-autoship-attached');
  var iconAnims;
  var shipAnims;
  var iconAnim = null;
  var i;

  if(!icon || !autoship || autoship.classList.contains('is-hidden')) return;

  requestAnimationFrame(function(){
    iconAnims = icon.getAnimations();
    shipAnims = autoship.getAnimations();
    for(i = 0; i < iconAnims.length; i++){
      if(iconAnims[i].animationName === 's03-member-body-idle'){
        iconAnim = iconAnims[i];
        break;
      }
    }
    if(!iconAnim) return;
    for(i = 0; i < shipAnims.length; i++){
      if(shipAnims[i].animationName === 's03-autoship-follow-idle'){
        shipAnims[i].currentTime = iconAnim.currentTime;
      }
    }
  });
}

async function scene03EnterOpenBadge(wrap, opts){
  if(!wrap) return;
  var badge = Guide01.resolveZonedBadge(wrap);
  if(badge) Guide01.badgeToOpen(badge);
  await Guide01.fadeZoned(wrap, true, opts || scene03BadgeEnter());
}

async function scene03FlyOpenBadgeToSlot(ctx, canvas, plan, floatWrap){
  var attached = plan.attached;
  var canvasRect = canvas.getBoundingClientRect();
  var startRect = floatWrap.getBoundingClientRect();
  var targetRect;
  var flyDur = 900;
  var fadeDur = 240;
  var endX;
  var endY;

  if(!attached || !canvasRect) return;

  Guide01.badgeToOpen(attached);
  attached.classList.remove('is-hidden');
  attached.style.visibility = 'hidden';
  targetRect = attached.getBoundingClientRect();
  attached.style.visibility = '';
  attached.classList.add('is-hidden');

  Guide01.stopIdleFloat(floatWrap);

  floatWrap.classList.add('g01-fly-badge');
  floatWrap.style.position = 'absolute';
  floatWrap.style.left = (startRect.left + startRect.width / 2 - canvasRect.left) + 'px';
  floatWrap.style.top = (startRect.top + startRect.height / 2 - canvasRect.top) + 'px';
  floatWrap.style.transform = 'translate(-50%,-50%)';
  floatWrap.classList.remove('lo-zone-place');
  floatWrap.removeAttribute('data-zone');
  floatWrap.style.removeProperty('--zone-row');
  floatWrap.style.removeProperty('--zone-col');

  endX = targetRect.left + targetRect.width / 2 - canvasRect.left;
  endY = targetRect.top + targetRect.height / 2 - canvasRect.top;

  floatWrap.style.transition =
    'left ' + flyDur + 'ms cubic-bezier(.22,1,.36,1), ' +
    'top ' + flyDur + 'ms cubic-bezier(.22,1,.36,1)';

  await wait(40);
  if(ctx && ctx.isCancelled && ctx.isCancelled()) return;

  floatWrap.style.left = endX + 'px';
  floatWrap.style.top = endY + 'px';
  await wait(flyDur);
  if(ctx && ctx.isCancelled && ctx.isCancelled()) return;

  floatWrap.style.transition = 'opacity ' + fadeDur + 'ms ease';
  floatWrap.style.opacity = '0';
  await wait(fadeDur);

  hideElement(floatWrap);
  if(floatWrap.parentNode) floatWrap.parentNode.removeChild(floatWrap);

  showElement(attached);
  Guide01.badgeToOpen(attached);
}

async function scene03AttachAutoshipOpen(canvas, assets, opts){
  var plan = assets.autoshipAttach;
  if(!plan || !plan.attached || !canvas) return;
  opts = opts || {};

  var floatWrap = Guide01.addZonedAsset(canvas, 'autoship_icon', 's03-autoship-float', Scene03Config.layout.anchorZone, {
    scale: 1
  });
  if(!floatWrap) return;

  await scene03EnterOpenBadge(floatWrap, opts.BADGE || scene03BadgeEnter());
  if(scene03Cancelled(opts.ctx)) return;

  await scene03FlyOpenBadgeToSlot(opts.ctx, canvas, plan, floatWrap);

  plan.attached.classList.add('s03-autoship-attached', 's03-autoship-idle-active');
  scene03SyncAutoshipIdlePhase(assets.member);

  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
}

async function scene03RevealProductRow(assets){
  await scene03PrepStackSlot(assets.productRow);
}

async function scene03EnterProduct(wrap, opts){
  if(!wrap) return;
  await scene03PrepProductSlot(wrap);
  await Guide01.fadeZoned(wrap, true, opts || scene03Motion('FADE'));
  Guide01.startIdleFloat(wrap);
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
}

function scene03DuplicateTargets(){
  return ['B', 'C', 'D'];
}

function scene03RestoreAnimScale(){
  var speed = Scene03Config.motion.restoreCheckSpeed;
  if(speed == null || speed <= 0) return 1;
  return 1 / speed;
}

function scene03RestoreCheckTimings(){
  var scale = scene03RestoreAnimScale();
  var checkDur = (Scene03Config.motion.check && Scene03Config.motion.check.duration) || 480;
  var stagger = Scene03Config.motion.checkStagger != null ? Scene03Config.motion.checkStagger : 120;
  var renameDur = (Scene03Config.motion.rename && Scene03Config.motion.rename.duration) || 480;

  return {
    check: Math.round(checkDur * scale),
    hold: Math.round(120 * scale),
    stagger: Math.round(stagger * scale),
    rename: Math.round(renameDur * scale)
  };
}

async function scene03RenameDuplicates(assets){
  var letters = scene03DuplicateTargets();
  var dur = (Scene03Config.motion.rename && Scene03Config.motion.rename.duration) || 480;
  var i;
  var wrap;

  for(i = 0; i < letters.length; i++){
    wrap = assets.products[letters[i]];
    if(!wrap) continue;
    wrap.classList.add('s03-letter-swapping', 'is-duplicate-a');
    scene03SetProductDisplay(wrap, 'A');
  }

  await wait(dur);

  for(i = 0; i < letters.length; i++){
    wrap = assets.products[letters[i]];
    if(!wrap) continue;
    wrap.classList.remove('s03-letter-swapping');
  }
}

async function scene03ShowUnavailable(assets){
  var letters = scene03DuplicateTargets();
  var host = assets.stampHost;
  var floatInner = host && host.querySelector('.s03-stamp-float-inner');
  var dur = (Scene03Config.motion.unavailable && Scene03Config.motion.unavailable.duration) || 520;
  var i;
  var wrap;

  for(i = 0; i < letters.length; i++){
    wrap = assets.products[letters[i]];
    if(!wrap) continue;
    wrap.classList.add('is-grayscale', 'is-unavailable');
  }

  if(host && floatInner){
    showElement(host);
    host.classList.add('is-visible');
    floatInner.classList.add('g01-anim-pop');
    await wait(dur);
    floatInner.classList.remove('g01-anim-pop');
    floatInner.classList.add('g01-idle-float');
  }

  Scene03Layout.scheduleLayout(false);
}

async function scene03HideUnavailable(assets){
  var host = assets.stampHost;
  var floatInner = host && host.querySelector('.s03-stamp-float-inner');
  var dur = (Scene03Config.motion.unavailable && Scene03Config.motion.unavailable.duration) || 520;

  if(!host) return;

  host.classList.remove('is-visible');
  if(floatInner) floatInner.classList.remove('g01-idle-float');

  await wait(dur);
  hideElement(host);
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
}

async function scene03FlashProductCheck(wrap){
  var host = wrap && wrap.querySelector('.s03-product-check');
  var check;
  var timings = scene03RestoreCheckTimings();
  var dur = timings.check;
  var hold = timings.hold;
  var scale = (Scene03Config.layout.scales && Scene03Config.layout.scales.check) || 0.85;

  if(!host) return;

  host.innerHTML = '';
  check = Scene03Layout.cloneFromTemplate('status_check_icon');
  if(!check) return;

  check.classList.add('guide01-asset', 's03-restore-check');
  check.style.setProperty('--size', Math.round(32 * scale) + 'px');
  host.appendChild(check);
  showElement(host);
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);

  check.style.opacity = '0';
  check.style.transform = 'translateY(8px) scale(0.88)';
  check.style.transition = 'opacity ' + dur + 'ms cubic-bezier(.22,1,.36,1), transform ' + dur + 'ms cubic-bezier(.22,1,.36,1)';
  void check.offsetWidth;
  check.style.opacity = '1';
  check.style.transform = 'translateY(0) scale(1)';

  await wait(dur + hold);

  check.style.opacity = '0';
  check.style.transform = 'translateY(-6px) scale(0.92)';
  await wait(dur);

  hideElement(host);
  host.innerHTML = '';
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
}

async function scene03RestoreProducts(assets){
  var letters = scene03DuplicateTargets();
  var timings = scene03RestoreCheckTimings();
  var renameDur = timings.rename;
  var stagger = timings.stagger;
  var i;
  var wrap;
  var checkJobs = [];
  var row = assets.productRow;

  await scene03HideUnavailable(assets);

  if(row){
    row.style.setProperty('--s03-letter-swap-dur', renameDur + 'ms');
  }

  for(i = 0; i < letters.length; i++){
    wrap = assets.products[letters[i]];
    if(!wrap) continue;
    wrap.classList.add('s03-letter-swapping');
    wrap.classList.remove('is-grayscale', 'is-unavailable', 'is-duplicate-a');
    scene03SetProductDisplay(wrap, letters[i]);
  }

  Scene03Layout.scheduleLayout(false);

  for(i = 0; i < letters.length; i++){
    wrap = assets.products[letters[i]];
    if(!wrap) continue;
    checkJobs.push((function(productWrap, delay){
      return wait(delay).then(function(){
        return scene03FlashProductCheck(productWrap);
      });
    })(wrap, i * stagger));
  }

  checkJobs.push(wait(renameDur).then(function(){
    var j;
    for(j = 0; j < letters.length; j++){
      wrap = assets.products[letters[j]];
      if(!wrap) continue;
      wrap.classList.remove('s03-letter-swapping');
    }
  }));

  await Promise.all(checkJobs);
}

async function runScene03MotionCore(tl, assets, canvas, ctx){
  var T = Scene03Config.T.main;
  var at = function(mainMs){ return scene03AtMain(mainMs, ctx); };
  var BADGE = scene03BadgeEnter();
  var FADE = scene03Motion('FADE');
  var letters = Scene03Config.layout.productLetters;
  var stagger = T.productStagger != null ? T.productStagger : 400;
  var i;

  /* title — 멤버(피플 톤) 등장 */
  showElement(assets.group);
  await scene03PrepStackSlot(assets.member);
  await Guide01.showMemberWrap(assets.member);
  scene03StartMemberIdle(assets.member);
  if(typeof Scene03Layout !== 'undefined') Scene03Layout.scheduleLayout(false);
  if(scene03Cancelled(ctx)) return;

  /* main+2s — D 지위 + 멤버 컬러 복원 */
  await tl.wait(at(T.dRank));
  if(scene03Cancelled(ctx)) return;
  await scene03PromoteWithDRank(assets);

  /* main+5s — 오토십(펼침) 플로팅 → 멤버 하단 중앙 부착 */
  await tl.wait(at(T.autoshipAttach));
  if(scene03Cancelled(ctx)) return;
  await scene03AttachAutoshipOpen(canvas, assets, { ctx: ctx, BADGE: BADGE });

  /* main+7s~ — A~E 제품 순차 */
  await tl.wait(at(T.productStart));
  if(scene03Cancelled(ctx)) return;
  await scene03RevealProductRow(assets);

  for(i = 0; i < letters.length; i++){
    if(i > 0){
      await tl.wait(stagger);
      if(scene03Cancelled(ctx)) return;
    }
    await scene03EnterProduct(assets.products[letters[i]], FADE);
    if(scene03Cancelled(ctx)) return;
  }

  /* main+12s — B,C,D 타이틀 A로 변경 */
  await tl.wait(at(T.duplicateRename));
  if(scene03Cancelled(ctx)) return;
  await scene03RenameDuplicates(assets);

  /* main+14s — B,C,D 회색 + 사용불가 스탬프 플로팅 */
  await tl.wait(at(T.duplicateUnavailable));
  if(scene03Cancelled(ctx)) return;
  await scene03ShowUnavailable(assets);

  /* main+18s — B,C,D 타이틀 복원 + 체크 */
  await tl.wait(at(T.restoreProducts));
  if(scene03Cancelled(ctx)) return;
  await scene03RestoreProducts(assets);
}

</script>
