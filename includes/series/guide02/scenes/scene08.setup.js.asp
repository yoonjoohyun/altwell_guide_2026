<script>
var Guide02Scene08Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function badgeOnly(){
    var nodes;
    var i;
    var shown = 0;
    if(!_ctx || !_ctx.stage || !_ctx.badge) return false;
    if(_ctx.badge.classList.contains('is-hidden')) return false;
    nodes = _ctx.stage.children;
    for(i = 0; i < nodes.length; i++){
      if(!nodes[i].classList.contains('is-hidden')) shown++;
    }
    return shown <= 1;
  }

  function fitHero(canvas, inner, hero){
    var w = hero.offsetWidth || 0;
    var h = hero.offsetHeight || 0;
    var fit;
    if(w < 2 || h < 2 || !canvas.clientWidth || !canvas.clientHeight) return;
    fit = Math.min((canvas.clientWidth * 0.42) / w, (canvas.clientHeight * 0.28) / h);
    if(!(fit > 0)) return;
    inner.style.setProperty('--group-scale', String(Math.round(fit * 1000) / 1000));
  }

  function applyFit(){
    if(!_ctx) return;
    if(!_ctx.fitted) _ctx.inner.style.transition = 'none';
    if(badgeOnly()) fitHero(_ctx.canvas, _ctx.inner, _ctx.badge);
    else Guide02.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, 0.88);
    if(!_ctx.fitted){
      void _ctx.inner.offsetWidth;
      _ctx.inner.style.transition = '';
      _ctx.fitted = true;
    }
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
  period.textContent = '가입월 포함 3개월 이내 구매 가능';
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

  var once = textSlot('g02-s08-once', 'g02-s08-line', '· 각각 1회 구매 가능');
  var price = textSlot('g02-s08-price', 'g02-s08-line', '· 파격적인 50% 할인가 제공');
  var ep = textSlot('g02-s08-ep', 'g02-s08-line', '· 각각 50만 승급E.P 혜택');
  var points = slot('g02-s08-points');
  var pointsNode = Guide02.cloneTemplate('startpack_recommend_points');
  var pointsTitle;
  var pointsValue;
  if(pointsNode){
    pointsTitle = pointsNode.querySelector('.recommend_bonus_text_1');
    pointsValue = pointsNode.querySelector('.recommend_bonus_text_2');
    if(pointsTitle) pointsTitle.textContent = '추천 포인트';
    if(pointsValue) pointsValue.textContent = '최초 1회 5Point';
    pointsNode.setAttribute('aria-label', '추천 포인트 최초 1회 5Point');
    points.appendChild(pointsNode);
  }

  panel.appendChild(row);
  panel.appendChild(once);
  panel.appendChild(price);
  panel.appendChild(ep);
  panel.appendChild(points);

  stage.appendChild(badge);
  stage.appendChild(panel);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene08Layout.bind({ canvas: canvas, inner: inner, stage: stage, badge: badge });
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
