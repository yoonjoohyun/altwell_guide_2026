<script>
/* Motion: panel.revealBullets — 패널 불릿 순차 등장 */
var MotionPanelRevealBullets = MotionComponent.define('panel.revealBullets', {
  listId: 'scene-bullets',
  itemDuration: 880,
  gap: 420,
  initialDelay: 300
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();

  return wait(opts.initialDelay).then(function(){
    if(MotionComponent.cancelled(ctx)) return;
    showElement('#' + opts.listId);
    var items = document.querySelectorAll('#' + opts.listId + ' .bullet-item');
    var chain = Promise.resolve();

    for(var i = 0; i < items.length; i++){
      (function(item, index){
        chain = chain.then(function(){
          if(MotionComponent.cancelled(ctx)) return;
          showElement(item);
          return slideUpElement(item, { duration: sceneDur(opts.itemDuration) });
        }).then(function(){
          if(index < items.length - 1 && !MotionComponent.cancelled(ctx)){
            return wait(sceneDur(opts.gap));
          }
        });
      })(items[i], i);
    }

    return chain;
  });
});
</script>
