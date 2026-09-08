<script>
/* Motion: effect.floatEnter — 오브젝트 부드러운 등장 + idle float */
var MotionObjectFloatEnter = MotionComponent.define('effect.floatEnter', {
  target: null,
  duration: 720,
  glow: true,
  idleFloat: true,
  useHero: false
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  if(!opts.target) return Promise.resolve();
  var el = _el(opts.target);
  if(!el) return Promise.resolve();

  showElement(el);
  var acquireOpts = {
    duration: sceneDur(opts.duration),
    glow: opts.glow,
    hero: opts.useHero
  };
  return softAcquireElement(el, acquireOpts).then(function(){
    if(opts.idleFloat){
      var floatTarget = el.querySelector('.member-visual') || el.querySelector('img') || el;
      if(floatTarget) floatTarget.classList.add('motion-idle-float');
    }
  });
});
</script>
