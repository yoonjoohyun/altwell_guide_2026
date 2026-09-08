<script>
/* Motion: canvas.transitionMount — 씬 전환 + 캔버스 재구성 */
var MotionCanvasTransitionMount = MotionComponent.define('canvas.transitionMount', {
  outDuration: 320,
  inDuration: 320,
  firstSceneInDuration: 550,
  firstSceneOutDuration: 0
}, function(ctx, opts){
  var canvas = opts.canvas || ctx.canvas;
  var mountFn = opts.mount;
  if(!canvas || typeof mountFn !== 'function') return Promise.resolve();

  if(ctx && ctx.sceneIndex > 0){
    return transitionCanvas(canvas, mountFn, {
      outDuration: sceneDur(opts.outDuration),
      inDuration: sceneDur(opts.inDuration)
    });
  }

  return transitionCanvas(canvas, mountFn, {
    outDuration: opts.firstSceneOutDuration,
    inDuration: sceneDur(opts.firstSceneInDuration)
  });
});
</script>
