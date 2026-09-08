<script>
/* Scene Mount — 씬 전환·캔버스 마운트 헬퍼 */
var SceneMount = {
  withTransition: function(ctx, canvas, mountFn, options){
    options = options || {};
    if(!canvas || typeof mountFn !== 'function') return Promise.resolve();

    if(ctx && ctx.sceneIndex > 0){
      return transitionCanvas(canvas, mountFn, {
        outDuration: options.outDuration != null ? sceneDur(options.outDuration) : sceneDur(320),
        inDuration: sceneDur(options.inDuration != null ? options.inDuration : 320)
      });
    }

    mountFn(canvas);
    return Promise.resolve();
  },

  firstOrTransition: function(ctx, canvas, mountFn, options){
    options = options || {};
    if(ctx && ctx.sceneIndex > 0){
      return transitionCanvas(canvas, mountFn, {
        outDuration: options.outDuration != null ? sceneDur(options.outDuration) : 0,
        inDuration: sceneDur(options.inDuration != null ? options.inDuration : 550)
      });
    }
    mountFn(canvas);
    return Promise.resolve();
  }
};
</script>
