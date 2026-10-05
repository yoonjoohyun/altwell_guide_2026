<script>
var Guide03Scene05Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    var canvas = _ctx && _ctx.canvas;
    var inner = _ctx && _ctx.inner;
    var stage = _ctx && _ctx.stage;
    var fit = 1;
    if(!canvas || !inner || !stage) return;
    var w = stage.offsetWidth || 1;
    var h = stage.offsetHeight || 1;
    fit = Math.min(1, (canvas.clientWidth - 16) / w, (canvas.clientHeight - 16) / h);
    if(fit < 0.4) fit = 0.4;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
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

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide03Scene05(canvas){
  function hidden(el, cls){
    el.className = cls + ' g03-slot is-hidden';
    return el;
  }

  function column(){
    var icon = Guide03.cloneTemplate('member_base_partner');
    var wrap = document.createElement('div');
    var col = document.createElement('div');
    var foot = document.createElement('div');
    var auto = Guide03.cloneTemplate('autoship_icon');
    var boxes = document.createElement('div');
    var letters = ['A', 'B', 'C'];
    var boxEls = [];
    var i;
    var box;
    wrap.className = 'g03-member g03-slot is-hidden';
    if(icon) wrap.appendChild(icon);
    col.className = 'g03-s05-col';
    foot.className = 'g03-s05-auto';
    if(auto) foot.appendChild(auto);
    hidden(foot, foot.className);
    boxes.className = 'g03-s05-boxes';
    for(i = 0; i < letters.length; i++){
      box = Guide03.cloneTemplate('product_swap_box');
      if(!box) box = document.createElement('div');
      box.textContent = letters[i];
      box.setAttribute('aria-label', '제품 ' + letters[i]);
      box.classList.add('g03-s05-box');
      hidden(box, box.className);
      boxes.appendChild(box);
      boxEls.push(box);
    }
    col.appendChild(wrap);
    col.appendChild(foot);
    col.appendChild(boxes);
    return { col: col, wrap: wrap, foot: foot, boxes: boxEls };
  }

  var zone = Guide03Scene05Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var row = document.createElement('div');
  var left = column();
  var right = column();
  var gauge = document.createElement('div');
  var label = document.createElement('div');
  var track = document.createElement('div');
  var fill = document.createElement('div');
  var stable = document.createElement('div');

  stack.id = 'g03-s05-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s05';
  row.className = 'g03-s05-row';
  row.appendChild(left.col);
  row.appendChild(right.col);

  gauge.className = 'g03-s05-gauge';
  label.className = 'g03-s05-gauge-label';
  label.textContent = 'SEP 30만 이상 달성';
  track.className = 'g03-s05-gauge-track';
  fill.className = 'g03-s05-gauge-fill';
  track.appendChild(fill);
  gauge.appendChild(label);
  gauge.appendChild(track);
  hidden(gauge, gauge.className);

  stable.className = 'g03-s05-stable';
  stable.textContent = '안정적인 조건 달성 구조';
  hidden(stable, stable.className);

  stage.appendChild(row);
  stage.appendChild(gauge);
  stage.appendChild(stable);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene05Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene05Layout.schedule();

  return {
    partners: [left.wrap, right.wrap],
    autos: [left.foot, right.foot],
    boxes: [left.boxes, right.boxes],
    gauge: gauge,
    fill: fill,
    stable: stable
  };
}
</script>
