<script>
/* Motion: member.replaceImage — 멤버 이미지 교체 (페이드) */
var MotionMemberReplaceImage = MotionComponent.define('member.replaceImage', {
  imageId: 'member-image-main',
  newSrc: null,
  newAlt: '',
  fadeOutMs: 750,
  fadeInMs: 760
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  var img = document.getElementById(opts.imageId);
  if(!img || !opts.newSrc) return Promise.resolve();

  var d1 = sceneDur(opts.fadeOutMs);
  var d2 = sceneDur(opts.fadeInMs);

  return new Promise(function(resolve){
    img.style.transition = 'opacity ' + d1 + 'ms var(--ease-smooth), transform ' + d1 + 'ms var(--ease-smooth)';
    img.style.transform = 'scale(0.95)';
    img.style.opacity = '0';

    setTimeout(function(){
      if(MotionComponent.cancelled(ctx)){ resolve(); return; }
      img.src = opts.newSrc;
      if(opts.newAlt) img.alt = opts.newAlt;
      void img.offsetWidth;
      img.style.transform = 'scale(1)';
      img.style.opacity = '1';

      setTimeout(function(){
        img.style.transition = '';
        img.style.transform = '';
        resolve();
      }, d2);
    }, d1);
  });
});
</script>
