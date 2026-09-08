<script>
/* Motion: badge.childAutoshipAcquire — 하위 오토십 획득 + 위치 이동 */
var MotionBadgeChildAutoshipAcquire = MotionComponent.define('badge.childAutoshipAcquire', {
  emblemId: null,
  acquireDuration: 720,
  slideDuration: 1000,
  slideLeft: '30%'
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  var el = document.getElementById(opts.emblemId);
  if(!el) return Promise.resolve();

  el.classList.remove('is-hidden');
  el.style.left = '50%';
  el.style.transform = 'translateX(-50%)';
  el.style.transition = 'none';

  var img = el.querySelector('img');
  var acquirePromise = Promise.resolve();

  if(img){
    _clearAnim(img);
    img.style.animationDuration = sceneDur(opts.acquireDuration) + 'ms';
    img.classList.add('motion-soft-acquire');
    acquirePromise = new Promise(function(resolve){
      function onEnd(){
        img.removeEventListener('animationend', onEnd);
        img.classList.remove('motion-soft-acquire');
        img.style.animationDuration = '';
        resolve();
      }
      img.addEventListener('animationend', onEnd);
    });
  }

  return acquirePromise.then(function(){
    if(MotionComponent.cancelled(ctx)) return;
    el.style.transition = 'left ' + sceneDur(opts.slideDuration) + 'ms var(--ease-smooth)';
    return sceneWait(40);
  }).then(function(){
    if(MotionComponent.cancelled(ctx)) return;
    el.style.left = opts.slideLeft;
    return sceneWait(opts.slideDuration);
  }).then(function(){
    el.style.transition = '';
  });
});
</script>
