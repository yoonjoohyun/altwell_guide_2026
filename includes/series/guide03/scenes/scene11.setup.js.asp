<script>
var Guide03Scene11Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide03 === 'undefined') return;
    Guide03.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
  }

  function schedule(){ requestAnimationFrame(applyFit); }

  function bind(ctx){
    _ctx = ctx;
    if(_resizeBound) return;
    _resizeBound = true;
    window.addEventListener('resize', schedule);
  }

  function unbind(){
    _resizeBound = false;
    _ctx = null;
  }

  return { schedule: schedule, flush: applyFit, bind: bind, unbind: unbind };
})();

function setupGuide03Scene11(canvas){
  var zone = Guide03Scene11Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var panel;

  stack.className = 'g03-stack g01-zone-wrap lo-zone-place';
  inner.className = 'g03-stack-inner';
  Guide03.placeAtZone(stack, zone);
  panel = GuideClosePanel.mount(inner, {
    id: 'g03-s11-close',
    title: 'BASE사업자 이해하기',
    zoneWrap: false,
    hidden: true,
    titleOpen: false
  });
  stack.appendChild(inner);
  canvas.appendChild(stack);
  Guide03Scene11Layout.bind({ canvas: canvas, inner: inner, stage: panel.wrap });
  return panel;
}
</script>
