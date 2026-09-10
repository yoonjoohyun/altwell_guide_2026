<script>
/* G01 Badge Fold Motion Components */

var MotionG01BadgeUnfold = MotionComponent.define('g01.badge.unfold', {
  target: null,
  duration: 620
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01BadgeFold.unfold(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01BadgeFold = MotionComponent.define('g01.badge.fold', {
  target: null,
  duration: 744
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01BadgeFold.fold(opts.target, { duration: sceneDur(opts.duration) });
});

var MotionG01BadgeToggle = MotionComponent.define('g01.badge.toggle', {
  target: null,
  duration: 744,
  unfoldDuration: 620,
  foldDuration: 744
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return G01BadgeFold.toggle(opts.target, {
    unfoldDuration: sceneDur(opts.unfoldDuration),
    foldDuration: sceneDur(opts.foldDuration)
  });
});
</script>
