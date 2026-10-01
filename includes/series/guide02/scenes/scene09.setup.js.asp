<script>
var Guide02Scene09Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    var w;
    var h;
    if(!canvas || !inner || !stage) return;
    w = stage.offsetWidth || 1;
    h = stage.offsetHeight || 1;
    if(w < 2 || h < 2) return;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.42) fit = 0.42;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function schedule(){
    requestAnimationFrame(applyFit);
  }

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

function setupGuide02Scene09(canvas){
  var zone = Guide02Scene09Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var panel;

  stack.className = 'g02-s09-stack g02-stack g01-zone-wrap';
  inner.className = 'g02-stack-inner';
  Guide02.placeAtZone(stack, zone);
  panel = GuideClosePanel.mount(inner, {
    id: 'g02-s09-close',
    title: '스타트팩 알아보기',
    zoneWrap: false,
    hidden: true,
    titleOpen: false
  });
  stack.appendChild(inner);
  canvas.appendChild(stack);
  Guide02Scene09Layout.bind({ canvas: canvas, inner: inner, stage: panel.wrap });
  return panel;
}
</script>
