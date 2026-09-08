<script>
/* Motion: member.promoteHero — 메인 멤버 히어로 위치 이동 */
var MotionMemberPromoteHero = MotionComponent.define('member.promoteHero', {
  target: 'member-unit-main',
  heroClass: 'scene02-main-hero',
  duration: 1400
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  var main = document.getElementById(opts.target);
  if(!main) return Promise.resolve();

  var dur = sceneDur(opts.duration);
  main.style.transition = 'left ' + dur + 'ms var(--ease-smooth), top ' + dur + 'ms var(--ease-smooth), transform ' + dur + 'ms var(--ease-smooth)';
  void main.offsetWidth;
  if(opts.heroClass) main.classList.add(opts.heroClass);

  return sceneWait(opts.duration).then(function(){
    main.style.transition = '';
  });
});
</script>
