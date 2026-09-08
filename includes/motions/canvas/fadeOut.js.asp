<script>
/* Motion: canvas.fadeOut — 캔버스 페이드 아웃 후 정리 */
var MotionCanvasFadeOut = MotionComponent.define('canvas.fadeOut', {
  opacity: 0,
  duration: 400,
  clear: true
}, function(ctx, opts){
  var canvas = opts.canvas || ctx.canvas;
  if(!canvas) return Promise.resolve();
  return fadeCanvas(canvas, opts.opacity, sceneDur(opts.duration)).then(function(){
    if(opts.clear){
      canvas.innerHTML = '';
      canvas.style.opacity = '';
    }
  });
});
</script>
