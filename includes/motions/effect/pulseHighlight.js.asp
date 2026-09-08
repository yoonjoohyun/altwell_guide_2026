<script>
/* Motion: effect.pulseHighlight — 요소 하이라이트 펄스 */
var MotionEffectPulseHighlight = MotionComponent.define('effect.pulseHighlight', {
  target: null,
  duration: 700
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  var el = typeof opts.target === 'string' ? document.querySelector(opts.target) : opts.target;
  if(!el) return Promise.resolve();

  el.style.animation = 'kf-highlight-pulse ' + sceneDur(opts.duration) + 'ms ease forwards';
  return sceneWait(opts.duration).then(function(){
    el.style.animation = '';
  });
});
</script>
