<script>
/* Motion Component Factory — 씬별 옵션 병합, 공유 defaults 불변 */
var MotionComponent = (function(){
  function merge(target){
    var sources = Array.prototype.slice.call(arguments, 1);
    for(var s = 0; s < sources.length; s++){
      var src = sources[s] || {};
      for(var key in src){
        if(Object.prototype.hasOwnProperty.call(src, key)){
          target[key] = src[key];
        }
      }
    }
    return target;
  }

  function define(id, defaults, runFn){
    var frozenDefaults = merge({}, defaults || {});
    return {
      id: id,
      defaults: frozenDefaults,
      create: function(overrides){
        var opts = merge({}, frozenDefaults, overrides || {});
        return {
          id: id,
          options: opts,
          run: function(ctx){
            return runFn(ctx || {}, opts);
          }
        };
      },
      run: function(ctx, overrides){
        return this.create(overrides).run(ctx);
      }
    };
  }

  function cancelled(ctx){
    return !!(ctx && ctx.isCancelled && ctx.isCancelled());
  }

  return { define: define, merge: merge, cancelled: cancelled };
})();
</script>
