<script>
/* Motion: connector.draw — SVG 연결선 표시 */
var MotionConnectorDraw = MotionComponent.define('connector.draw', {
  lineId: null,
  duration: 900
}, function(ctx, opts){
  if(MotionComponent.cancelled(ctx)) return Promise.resolve();
  var line = document.getElementById(opts.lineId);
  if(!line) return Promise.resolve();

  return new Promise(function(resolve){
    line.classList.remove('is-visible');
    void line.getBoundingClientRect();
    line.classList.add('is-visible');
    setTimeout(resolve, sceneDur(opts.duration));
  });
});
</script>
