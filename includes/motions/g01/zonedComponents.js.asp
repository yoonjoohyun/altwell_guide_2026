<script>
/* G01 Zoned Motion Components — asset_animation_rull.md 규칙 기반 */

var MotionG01ZonedEnterFade = MotionComponent.define('g01.zoned.enterFade', {
  target: null,
  duration: 420
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01ZonedAnim.enterFade(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01ZonedEnterPop = MotionComponent.define('g01.zoned.enterPop', {
  target: null,
  duration: 520
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01ZonedAnim.enterPop(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01ZonedEnterDrop = MotionComponent.define('g01.zoned.enterDrop', {
  target: null,
  duration: 520
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01ZonedAnim.enterDrop(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01ZonedPopScale = MotionComponent.define('g01.zoned.popScale', {
  target: null,
  duration: 480
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01ZonedAnim.popScale(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01ZonedExit = MotionComponent.define('g01.zoned.exit', {
  target: null,
  duration: 280,
  hide: true
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  if(opts.hide === false) return G01ZonedAnim.exit(opts.target, { duration: sceneDur(opts.duration) });
  return G01ZonedAnim.exitHide(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01ZonedIdleStart = MotionComponent.define('g01.zoned.idleStart', {
  target: null
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  G01ZonedAnim.idleStart(opts.target);
  return Promise.resolve();
});

var MotionG01ZonedIdleStop = MotionComponent.define('g01.zoned.idleStop', {
  target: null
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  G01ZonedAnim.idleStop(opts.target);
  return Promise.resolve();
});

var MotionG01ZonedMove = MotionComponent.define('g01.zoned.move', {
  target: null,
  zone: null,
  duration: 720,
  toScale: null
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  if(!opts.zone) return Promise.resolve();
  return G01ZonedAnim.move(opts.target, opts.zone, {
    duration: sceneDur(opts.duration),
    toScale: opts.toScale
  });
});
</script>
