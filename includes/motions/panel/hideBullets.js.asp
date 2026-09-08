<script>
/* Motion: panel.hideBullets — 패널 불릿 숨김 */
var MotionPanelHideBullets = MotionComponent.define('panel.hideBullets', {
  listId: 'scene-bullets'
}, function(ctx, opts){
  var items = document.querySelectorAll('#' + opts.listId + ' .bullet-item');
  for(var i = 0; i < items.length; i++){
    items[i].classList.add('is-hidden');
  }
  return Promise.resolve();
});
</script>
