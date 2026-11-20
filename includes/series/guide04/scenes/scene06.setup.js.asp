<script>
var Guide04Scene06Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide04 === 'undefined') return;
    Guide04.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
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

function setupGuide04Scene06(canvas){
  var zone = Guide04Scene06Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var panel;

  stack.className = 'g04-stack g01-zone-wrap lo-zone-place';
  inner.className = 'g04-stack-inner';
  Guide04.placeAtZone(stack, zone);
  panel = GuideClosePanel.mount(inner, {
    id: 'g04-s06-close',
    title: '추천보너스 알아보기',
    zoneWrap: false,
    hidden: true,
    titleOpen: false,
    simulatorHref: (window.GUIDE_ROOT || '') + '/sim.asp'
  });
  stack.appendChild(inner);
  canvas.appendChild(stack);
  Guide04Scene06Layout.bind({ canvas: canvas, inner: inner, stage: panel.wrap });
  return panel;
}
</script>
