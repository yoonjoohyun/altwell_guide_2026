<script>
var Guide02Scene05Layout = (function(){
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

  return { schedule: schedule, bind: bind, unbind: unbind };
})();

function setupGuide02Scene05(canvas){
  var zone = Guide02Scene05Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var spCol = document.createElement('div');
  var pointsSlot = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var row = document.createElement('div');
  var left = document.createElement('div');
  var right = document.createElement('div');
  var leftPacks = document.createElement('div');
  var rightPacks = document.createElement('div');

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  function member(id, rankId){
    var wrap = document.createElement('div');
    var stack = document.createElement('div');
    var slots = document.createElement('div');
    var rankSlot = document.createElement('div');
    var icon = Guide02.cloneTemplate('member_icon');
    var rank = Guide02.cloneTemplate(rankId);
    wrap.id = id;
    wrap.className = 'g02-slot g02-s05-member-unit is-hidden';
    stack.className = 'g02-s05-member-stack';
    slots.className = 'g02-s05-member-slots';
    rankSlot.className = 'g02-s05-rank';
    if(icon) stack.appendChild(icon);
    if(rank) rankSlot.appendChild(rank);
    slots.appendChild(rankSlot);
    stack.appendChild(slots);
    wrap.appendChild(stack);
    return wrap;
  }

  function packCol(packId, tagText, tagClass){
    var col = document.createElement('div');
    var tag = document.createElement('div');
    var pack = slot(packId, packId + '-' + tagText);
    col.className = 'g02-s05-packcol';
    tag.className = 'g02_point_tag g02-slot is-hidden' + (tagClass ? ' ' + tagClass : '');
    tag.textContent = tagText;
    col.appendChild(tag);
    col.appendChild(pack);
    return { col: col, tag: tag, pack: pack };
  }

  stack.id = 'g02-s05-stack';
  stack.className = 'g02-stack lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s05';
  spCol.className = 'g02-s05-sp';
  pointsSlot.className = 'g02_ref_points_slot';
  row.className = 'g02-s05-row';
  left.className = 'g02-s05-branch';
  right.className = 'g02-s05-branch';
  leftPacks.className = 'g02-s05-packs';
  rightPacks.className = 'g02-s05-packs';

  lines.setAttribute('class', 'g02-s05-lines');
  lines.setAttribute('viewBox', '0 0 278 52');
  lines.setAttribute('aria-hidden', 'true');
  lines.innerHTML = '<path d="M139 0 L0 52"/><path d="M139 0 L278 52"/>';

  var sp = member('g02-s05-sp', 'lev_sp');
  var dLeft = member('g02-s05-d-left', 'lev_d');
  var dRight = member('g02-s05-d-right', 'lev_d');
  var points = document.createElement('div');
  points.id = 'g02-s05-points';
  points.className = 'g02_ref_points g02-slot is-hidden';
  points.innerHTML = '<span class="g02_ref_points_num">5</span> 추천 포인트';

  var leftNouvel = packCol('startpack_nouvel_card', '5포인트 발생', '');
  var leftSignature = packCol('startpack_signature_card', '0포인트', 'is-zero');
  var rightSignature = packCol('startpack_signature_card', '5포인트 발생', '');
  leftNouvel.pack.id = 'g02-s05-left-nouvel';
  leftSignature.pack.id = 'g02-s05-left-signature';
  rightSignature.pack.id = 'g02-s05-right-signature';

  var coin = document.createElement('div');
  coin.className = 'g02_ref_coin g02-slot is-hidden';
  coin.textContent = '5';

  pointsSlot.appendChild(points);
  spCol.appendChild(sp);
  spCol.appendChild(pointsSlot);
  leftPacks.appendChild(leftNouvel.col);
  leftPacks.appendChild(leftSignature.col);
  rightPacks.appendChild(rightSignature.col);
  left.appendChild(dLeft);
  left.appendChild(leftPacks);
  right.appendChild(dRight);
  right.appendChild(rightPacks);
  row.appendChild(left);
  row.appendChild(right);
  stage.appendChild(spCol);
  stage.appendChild(lines);
  stage.appendChild(row);
  stage.appendChild(coin);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene05Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene05Layout.schedule();

  return {
    inner: inner,
    stage: stage,
    sp: sp,
    dLeft: dLeft,
    dRight: dRight,
    lines: lines,
    points: points,
    pointsNum: points.querySelector('.g02_ref_points_num'),
    leftPacks: leftPacks,
    leftNouvel: leftNouvel.pack,
    leftSignature: leftSignature.pack,
    rightSignature: rightSignature.pack,
    tagLeft: leftNouvel.tag,
    tagRight: rightSignature.tag,
    tagZero: leftSignature.tag,
    coin: coin
  };
}
</script>
