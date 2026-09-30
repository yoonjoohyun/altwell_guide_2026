<script>
var Guide02Scene06Layout = (function(){
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

function setupGuide02Scene06(canvas){
  var zone = Guide02Scene06Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var head = document.createElement('div');
  var row = document.createElement('div');
  var left = document.createElement('div');
  var right = document.createElement('div');
  var note = document.createElement('div');

  function slot(templateId, id){
    var node = Guide02.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.id = id;
    wrap.className = 'g02-slot is-hidden';
    if(node) wrap.appendChild(node);
    return wrap;
  }

  function member(){
    var wrap = document.createElement('div');
    var unit = document.createElement('div');
    var slots = document.createElement('div');
    var rankSlot = document.createElement('div');
    var icon = Guide02.cloneTemplate('member_icon');
    var rankD = Guide02.cloneTemplate('lev_d');
    var rankP = Guide02.cloneTemplate('lev_p');
    var promote = document.createElement('div');
    wrap.id = 'g02-s06-member';
    wrap.className = 'g02-slot g02-s06-member-unit is-hidden';
    unit.className = 'g02-s06-member-stack';
    slots.className = 'g02-s06-member-slots';
    rankSlot.className = 'g02-s06-rank';
    promote.className = 'g02-s06-promote g02-slot is-hidden';
    promote.innerHTML = '<span class="g02-s06-promote-arrow" aria-hidden="true"></span><span>승급</span>';
    if(rankD) rankD.classList.add('g02-slot');
    if(rankP) rankP.classList.add('g02-slot', 'is-hidden');
    if(icon) unit.appendChild(icon);
    if(rankD) rankSlot.appendChild(rankD);
    if(rankP) rankSlot.appendChild(rankP);
    slots.appendChild(rankSlot);
    rankSlot.appendChild(promote);
    unit.appendChild(slots);
    wrap.appendChild(unit);
    return { wrap: wrap, rankD: rankD, rankP: rankP, promote: promote };
  }

  function side(id, templateId){
    var col = document.createElement('div');
    var anchor = document.createElement('div');
    var chip = document.createElement('div');
    var pack = slot(templateId, id);
    col.className = 'g02-s06-side';
    anchor.className = 'g02-s06-chip-anchor';
    chip.className = 'g02_promo_chip g02-slot is-hidden';
    chip.textContent = '50만 승급EP';
    anchor.appendChild(chip);
    col.appendChild(pack);
    col.appendChild(anchor);
    return { col: col, pack: pack, chip: chip };
  }

  function line(text, emphasis){
    var el = document.createElement('div');
    el.className = 'g02_ep_note_line' + (emphasis ? ' is-emphasis' : '');
    el.textContent = text;
    return el;
  }

  stack.id = 'g02-s06-stack';
  stack.className = 'g02-stack g01-zone-wrap lo-zone-place';
  Guide02.placeAtZone(stack, zone);
  inner.className = 'g02-stack-inner';
  stage.className = 'g02-s06';
  head.className = 'g02-s06-head';
  row.className = 'g02-s06-row';
  note.id = 'g02-s06-note';
  note.className = 'g02_ep_note g02-slot is-hidden';

  var who = member();
  var leftSide = side('g02-s06-nouvel', 'startpack_nouvel_card');
  var rightSide = side('g02-s06-signature', 'startpack_signature_card');
  var headChip = document.createElement('div');
  headChip.id = 'g02-s06-head-chip';
  headChip.className = 'g02_promo_chip g02-slot is-hidden';
  headChip.innerHTML = '<span class="g02_promo_num">50만</span> 승급EP';

  var flyer = document.createElement('div');
  flyer.className = 'g02_promo_chip g02_promo_flyer g02-slot is-hidden';
  flyer.textContent = '50만 승급EP';

  var lineBuy = line('스타트팩 구매', false);
  var lineSplit = line("= 50만 승급EP & 약 30만 수당EP", false);
  var lineOnly = line('*승급만을 위한 승급EP 혜택', true);
  note.appendChild(lineBuy);
  note.appendChild(lineSplit);
  note.appendChild(lineOnly);

  head.appendChild(headChip);
  row.appendChild(leftSide.col);
  row.appendChild(who.wrap);
  row.appendChild(rightSide.col);
  stage.appendChild(head);
  stage.appendChild(row);
  stage.appendChild(note);
  stage.appendChild(flyer);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide02Scene06Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide02Scene06Layout.schedule();

  return {
    inner: inner,
    stage: stage,
    member: who.wrap,
    rankD: who.rankD,
    rankP: who.rankP,
    promote: who.promote,
    leftPack: leftSide.pack,
    leftChip: leftSide.chip,
    rightPack: rightSide.pack,
    rightChip: rightSide.chip,
    head: head,
    headChip: headChip,
    headNum: headChip.querySelector('.g02_promo_num'),
    flyer: flyer,
    note: note,
    lines: [lineBuy, lineSplit, lineOnly]
  };
}
</script>
