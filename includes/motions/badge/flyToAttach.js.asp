<script>
/* Motion: badge.flyToAttach — 중앙 배지 → 멤버 엠블럼 위치 부착 */
var MotionBadgeFlyToAttach = MotionComponent.define('badge.flyToAttach', {
  flyBadge: null,
  flyBadgeId: null,
  targetBadgeId: 'base-business-badge-main',
  flyDuration: 1850,
  fadeDuration: 450,
  acquireDuration: 500
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();

  var canvas = document.getElementById('motion-canvas');
  var flyBadge = opts.flyBadge || (opts.flyBadgeId ? document.getElementById(opts.flyBadgeId) : null);
  var mainBadge = document.getElementById(opts.targetBadgeId);
  if(!canvas || !flyBadge || !mainBadge) return Promise.resolve();

  var canvasRect = canvas.getBoundingClientRect();
  var centerX = canvasRect.width / 2;
  var centerY = canvasRect.height / 2;

  mainBadge.classList.remove('is-hidden');
  mainBadge.style.visibility = 'hidden';
  var targetRect = mainBadge.getBoundingClientRect();
  mainBadge.style.visibility = '';
  mainBadge.classList.add('is-hidden');

  var endX = targetRect.left + targetRect.width / 2 - canvasRect.left;
  var endY = targetRect.top + targetRect.height / 2 - canvasRect.top;

  var flyImg = flyBadge.querySelector('img');
  if(flyImg){
    flyImg.classList.remove('motion-soft-acquire');
    flyImg.style.animation = '';
    flyImg.style.animationDuration = '';
  }

  flyBadge.classList.remove('is-hidden');
  flyBadge.style.position = 'absolute';
  flyBadge.style.left = centerX + 'px';
  flyBadge.style.top = centerY + 'px';
  flyBadge.style.margin = '0';
  flyBadge.style.opacity = '1';
  flyBadge.style.transition = 'none';
  flyBadge.style.transform = 'translate(-50%,-50%) scale(1)';
  void flyBadge.offsetWidth;

  var flyRect = flyBadge.getBoundingClientRect();
  var targetScale = targetRect.width / Math.max(flyRect.width, 1);
  var flyDur = sceneDur(opts.flyDuration);

  flyBadge.style.transition = 'left ' + flyDur + 'ms var(--ease-smooth), top ' + flyDur + 'ms var(--ease-smooth), transform ' + flyDur + 'ms var(--ease-smooth)';

  return sceneWait(50).then(function(){
    if(MotionComponent.cancelled(ctx)) return;
    flyBadge.style.left = endX + 'px';
    flyBadge.style.top = endY + 'px';
    flyBadge.style.transform = 'translate(-50%,-50%) scale(' + targetScale + ')';
    return sceneWait(opts.flyDuration);
  }).then(function(){
    if(MotionComponent.cancelled(ctx)) return;
    var fadeDur = sceneDur(opts.fadeDuration);
    flyBadge.style.transition = 'opacity ' + fadeDur + 'ms var(--ease-smooth)';
    flyBadge.style.opacity = '0';
    return sceneWait(opts.fadeDuration);
  }).then(function(){
    if(flyBadge.parentNode) flyBadge.parentNode.removeChild(flyBadge);
    showElement(mainBadge);
    return softAcquireElement(mainBadge, {
      duration: sceneDur(opts.acquireDuration),
      glow: true
    });
  });
});
</script>
