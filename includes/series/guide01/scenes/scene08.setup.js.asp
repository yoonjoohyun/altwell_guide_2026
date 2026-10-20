<script>
var Scene08Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var slots;
    var closed = [];
    var stageHidden = false;
    var prevOpacity = '';
    var i;
    var rect;
    if(!canvas || !inner || !stage) return;
    stageHidden = stage.classList.contains('is-hidden');
    prevOpacity = stage.style.opacity;
    if(stageHidden) stage.classList.remove('is-hidden');
    stage.style.opacity = '0';
    slots = stage.querySelectorAll('.g-close-slot');
    for(i = 0; i < slots.length; i++){
      if(!slots[i].classList.contains('is-open')){
        closed.push(slots[i]);
        slots[i].classList.add('is-open');
      }
    }
    inner.style.setProperty('--group-scale', '1');
    rect = stage.getBoundingClientRect();
    Guide01.noteFillState(inner, Guide01.localEdges(inner, [stage]));
    for(i = 0; i < closed.length; i++) closed[i].classList.remove('is-open');
    if(stageHidden) stage.classList.add('is-hidden');
    if(prevOpacity) stage.style.opacity = prevOpacity;
    else stage.style.removeProperty('opacity');
    Guide01.applyNotedFill(canvas, inner);
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

function setupScene08Assets(canvas){
  var zone = Scene08Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var center = document.createElement('div');
  var panel;

  stack.className = 's08-stack g01-zone-wrap';
  inner.className = 's08-stack-inner';
  center.className = 's08-close-center';
  Guide01.placeAtZone(stack, zone);
  panel = GuideClosePanel.mount(center, {
    id: 's08-close',
    title: '오토십 알아보기',
    zoneWrap: false,
    hidden: true,
    titleOpen: false,
    simulatorHref: (window.GUIDE_ROOT || '') + '/guide01_simulator.asp'
  });
  inner.appendChild(center);
  stack.appendChild(inner);
  canvas.appendChild(stack);
  Scene08Layout.bind({ canvas: canvas, inner: inner, stage: panel.wrap });
  return panel;
}
</script>
