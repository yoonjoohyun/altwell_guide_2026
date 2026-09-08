<script>
/* Motion: member.enter — 멤버 유닛 등장 */
var MotionMemberEnter = MotionComponent.define('member.enter', {
  target: 'member-unit-main',
  duration: 750,
  delay: 0
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  return enterMember(opts.target, {
    duration: sceneDur(opts.duration),
    delay: opts.delay
  });
});
</script>
