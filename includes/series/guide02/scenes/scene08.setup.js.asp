<script>
var Guide02Scene08Layout = (function(){
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

function setupGuide02Scene08(canvas){
  var zone = Guide02Scene08Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');

  function slot(id, cls){
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden' + (cls ? ' ' + cls : '');
    return wrap;
  }

  function textSlot(id, cls, text){
    var wrap = slot(id, cls);
    wrap.textContent = text;
    return wrap;
  }

  stack.id = 'g02-s08-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s08';

  var badge = slot('g02-s08-badge');
  var badgeNode = Guide02.cloneTemplate('startpack_badge');
  if(badgeNode) badge.appendChild(badgeNode);

  var panel = slot('g02-s08-panel', 'g02-s08-panel');
  var period = document.createElement('div');
  period.id = 'g02-s08-period';
  period.className = 'g02-s08-period g02-slot is-hidden';
  period.textContent = '가입월 포함 3개월이내 구매 가능';
  panel.appendChild(period);

  var row = document.createElement('div');
  row.className = 'g02-s08-row g02-slot is-hidden';
  var nouvel = slot('g02-s08-nouvel');
  var signature = slot('g02-s08-signature');
  var nouvelNode = Guide02.cloneTemplate('startpack_nouvel_card');
  var signatureNode = Guide02.cloneTemplate('startpack_signature_card');
  if(nouvelNode) nouvel.appendChild(nouvelNode);
  if(signatureNode) signature.appendChild(signatureNode);
  row.appendChild(nouvel);
  row.appendChild(signature);

  var once = textSlot('g02-s08-once', 'g02-s08-once', '각각 1회 구매 가능');
  var price = textSlot('g02-s08-price', 'g02-s08-line', '파격적인 할인가 제공');
  var ep = textSlot('g02-s08-ep', 'g02-s08-line', '각각 50만 승급EP 혜택');
  var points = slot('g02-s08-points', 'g02-s08-points');
  points.innerHTML = '추천 포인트<br>5Point';

  stage.appendChild(badge);
  stage.appendChild(panel);
  stage.appendChild(row);
  stage.appendChild(once);
  stage.appendChild(price);
  stage.appendChild(ep);
  stage.appendChild(points);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene08Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene08Layout.schedule();

  return {
    badge: badge,
    panel: panel,
    period: period,
    row: row,
    nouvel: nouvel,
    signature: signature,
    once: once,
    price: price,
    ep: ep,
    points: points
  };
}
</script>
