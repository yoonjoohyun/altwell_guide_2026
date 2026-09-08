<script>
/* Motion: badge.heroAcquire — 배지 히어로 등장 (softAcquire + glow) */
var MotionBadgeHeroAcquire = MotionComponent.define('badge.heroAcquire', {
  target: null,
  duration: 1100,
  glow: true,
  hero: true
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  if(!opts.target) return Promise.resolve();
  return softAcquireElement(opts.target, {
    duration: sceneDur(opts.duration),
    glow: opts.glow,
    hero: opts.hero
  });
});
</script>
