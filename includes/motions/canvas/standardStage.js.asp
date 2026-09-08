<script>
/* Motion: canvas.standardStage — 표준 배경 마운트 */
var MotionCanvasStandardStage = MotionComponent.define('canvas.standardStage', {
  sceneClass: null,
  replace: true
}, function(ctx, opts){
  var canvas = opts.canvas || ctx.canvas;
  if(!canvas) return Promise.resolve(null);
  CanvasStage.mountStandard(canvas, {
    sceneClass: opts.sceneClass,
    replace: opts.replace
  });
  return Promise.resolve(canvas);
});
</script>
