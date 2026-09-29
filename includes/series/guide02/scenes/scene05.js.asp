<script>
var Guide02Scene05 = defineScene({
  id: Guide02Scene05Config.id,
  title: Guide02Scene05Config.title,
  duration: Guide02Scene05Config.duration,
  mediaSequence: Guide02Scene05Config.media.sequence,
  mediaFallbackMs: Guide02Scene05Config.media.fallbackMs,

  reset: function(){
    var panel = document.getElementById('lo-panel');
    if(panel) panel.classList.remove(Guide02Scene05Config.panelCls);
    if(typeof Guide02Scene05Layout !== 'undefined') Guide02Scene05Layout.unbind();
    Guide02.resetScene(Guide02Scene05Config.canvasCls);
  },

  play: async function(ctx){
    var canvas = ctx.canvas;
    var panel;
    var tl;
    var assets;
    if(!canvas) return;
    panel = document.getElementById('lo-panel');
    if(panel) panel.classList.add(Guide02Scene05Config.panelCls);
    tl = Guide02.timeline(ctx);
    Guide02.resetScene(Guide02Scene05Config.canvasCls);
    Guide02.mountStage(canvas, Guide02Scene05Config.canvasCls);
    assets = setupGuide02Scene05(canvas);

    await Promise.all([
      runGuide02Scene05(tl, assets, ctx),
      Guide02.panelBulletTimeline(
        tl,
        Guide02Scene05Config.panel.title,
        Guide02Scene05Config.panel.bullets,
        guide02Scene05PanelFlashes()
      )
    ]);
    if(ctx.isCancelled && ctx.isCancelled()) return;
    await Guide02.finishSceneHold(tl, ctx.sceneDuration || Guide02Scene05Config.duration);
  }
});

function guide02Scene05Cancelled(ctx){
  return ctx && ctx.isCancelled && ctx.isCancelled();
}

async function guide02Scene05Reveal(el, fromAbove){
  if(!el) return;
  showElement(el);
  el.classList.add(fromAbove ? 'g02-s05-drop' : 'g02-enter');
  if(typeof Guide02Scene05Layout !== 'undefined') Guide02Scene05Layout.schedule();
  await wait(960);
  el.classList.remove('g02-s05-drop', 'g02-enter');
}

function guide02Scene05Center(el, root, scale){
  var a = el.getBoundingClientRect();
  var b = root.getBoundingClientRect();
  return {
    x: (a.left + a.width / 2 - b.left) / scale,
    y: (a.top + a.height / 2 - b.top) / scale
  };
}

async function guide02Scene05FlyCoin(assets, fromEl, toEl){
  var coin = assets.coin;
  var scale = parseFloat(assets.inner.style.getPropertyValue('--group-scale')) || 1;
  var start;
  var end;
  if(!coin || !fromEl || !toEl) return;
  start = guide02Scene05Center(fromEl, assets.stage, scale);
  end = guide02Scene05Center(toEl, assets.stage, scale);
  coin.style.transition = 'none';
  coin.style.left = start.x + 'px';
  coin.style.top = start.y + 'px';
  coin.style.opacity = '1';
  coin.style.transform = 'translate(-50%, -50%) scale(1)';
  showElement(coin);
  await wait(480);
  coin.style.transition = 'left 1200ms cubic-bezier(.16,1,.3,1), top 1200ms cubic-bezier(.16,1,.3,1), transform 1200ms cubic-bezier(.16,1,.3,1), opacity 460ms ease 760ms';
  coin.style.left = end.x + 'px';
  coin.style.top = end.y + 'px';
  coin.style.opacity = '0';
  coin.style.transform = 'translate(-50%, -50%) scale(.72)';
  await wait(1240);
  hideElement(coin);
}

function guide02Scene05Count(el, from, to, ms){
  var start = performance.now();
  return new Promise(function(resolve){
    function frame(now){
      var t = Math.min(1, (now - start) / ms);
      var eased = 1 - Math.pow(1 - t, 3);
      el.textContent = String(Math.round(from + (to - from) * eased));
      if(t < 1) requestAnimationFrame(frame);
      else resolve();
    }
    requestAnimationFrame(frame);
  });
}

async function runGuide02Scene05(tl, assets, ctx){
  var T = Guide02Scene05Config.T;

  await tl.wait(T.tree);
  if(guide02Scene05Cancelled(ctx)) return;
  await Promise.all([
    guide02Scene05Reveal(assets.sp),
    guide02Scene05Reveal(assets.dLeft),
    guide02Scene05Reveal(assets.dRight)
  ]);

  await tl.wait(T.leftPack);
  if(guide02Scene05Cancelled(ctx)) return;
  await guide02Scene05Reveal(assets.leftNouvel, true);
  if(guide02Scene05Cancelled(ctx)) return;
  await guide02Scene05FlyCoin(assets, assets.leftNouvel, assets.sp);
  if(guide02Scene05Cancelled(ctx)) return;
  await guide02Scene05Reveal(assets.points);

  await tl.wait(T.rightPack);
  if(guide02Scene05Cancelled(ctx)) return;
  await guide02Scene05Reveal(assets.rightSignature, true);
  if(guide02Scene05Cancelled(ctx)) return;
  await guide02Scene05FlyCoin(assets, assets.rightSignature, assets.sp);
  if(guide02Scene05Cancelled(ctx)) return;
  if(assets.pointsNum) await guide02Scene05Count(assets.pointsNum, 5, 10, 560);

  await tl.wait(T.gainTags);
  if(guide02Scene05Cancelled(ctx)) return;
  await Promise.all([
    guide02Scene05Reveal(assets.tagLeft),
    guide02Scene05Reveal(assets.tagRight)
  ]);

  await tl.wait(T.zeroPack);
  if(guide02Scene05Cancelled(ctx)) return;
  if(assets.leftPacks) assets.leftPacks.classList.add('is-centered');
  await Promise.all([
    guide02Scene05Reveal(assets.leftSignature, true),
    guide02Scene05Reveal(assets.tagZero)
  ]);
}
</script>
