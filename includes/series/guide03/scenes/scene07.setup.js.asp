<script>
var Guide03Scene07Layout = (function(){
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

function setupGuide03Scene07(canvas){
  function hide(el){
    el.classList.add('g03-slot', 'is-hidden');
    return el;
  }

  function chip(kind, shown){
    var el = document.createElement('div');
    var icon;
    if(kind === 'auto'){
      el.className = 'g03-s07-auto';
      icon = Guide03.cloneTemplate('autoship_icon');
      if(icon) el.appendChild(icon);
    }else{
      el.className = 'g03-s07-sep';
      el.textContent = 'SEP 30만 이상 달성';
    }
    el.classList.add('g03-slot');
    if(!shown) el.classList.add('is-hidden');
    return el;
  }

  function column(spec){
    var icon = Guide03.cloneTemplate('member_base_partner');
    var wrap = document.createElement('div');
    var col = document.createElement('div');
    var host = document.createElement('div');
    var chips = {};
    var i;
    wrap.className = 'g03-member';
    if(!spec.showPartner) hide(wrap);
    if(icon) wrap.appendChild(icon);
    col.className = 'g03-s07-col';
    host.className = 'g03-s07-host';
    for(i = 0; i < spec.chips.length; i++){
      chips[spec.chips[i].kind] = chip(spec.chips[i].kind, spec.chips[i].show);
      host.appendChild(chips[spec.chips[i].kind]);
    }
    col.appendChild(wrap);
    col.appendChild(host);
    return { wrap: wrap, host: host, col: col, chips: chips };
  }

  function makeCard(spec){
    var card = document.createElement('div');
    var board = document.createElement('div');
    var row = document.createElement('div');
    var left = column(spec.left);
    var right = column(spec.right);
    var checkSlot = document.createElement('div');
    var check = Guide03.cloneTemplate('status_check_icon');
    var ban = null;
    var cross;
    card.className = 'g03-s07-card';
    if(spec.hiddenCard) hide(card);
    board.className = 'g03-board g03-s07-board';
    if(!spec.showBoard) hide(board);
    row.className = 'g03-s07-row';
    row.appendChild(left.col);
    row.appendChild(right.col);
    board.appendChild(row);
    checkSlot.className = 'g03-s07-check-slot';
    if(check){
      check.classList.add('g03-s07-check');
      hide(check);
      checkSlot.appendChild(check);
    }
    card.appendChild(board);
    if(spec.ban){
      ban = document.createElement('div');
      ban.className = 'g03-s07-ban';
      cross = Guide03.cloneTemplate('status_cross_icon');
      if(cross){
        cross.classList.add('g03-s07-ban-icon');
        ban.appendChild(cross);
      }
      hide(ban);
      card.appendChild(ban);
    }
    card.appendChild(checkSlot);
    return {
      card: card,
      board: board,
      left: left,
      right: right,
      ban: ban,
      check: check
    };
  }

  var zone = Guide03Scene07Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var badgeWrap = document.createElement('div');
  var badge = Guide03.cloneTemplate('guide_info_badge_red');
  var text;
  var mixed = makeCard({
    showBoard: false,
    ban: true,
    left: { chips: [{ kind: 'auto' }] },
    right: { chips: [{ kind: 'sep' }, { kind: 'auto' }] }
  });
  var pair = makeCard({
    hiddenCard: true,
    showBoard: true,
    left: { showPartner: true, chips: [{ kind: 'auto', show: true }, { kind: 'sep' }] },
    right: { showPartner: true, chips: [{ kind: 'auto', show: true }, { kind: 'sep' }] }
  });

  stack.id = 'g03-s07-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s07';
  badgeWrap.className = 'g03-s07-badge g03-slot is-hidden';
  if(badge){
    text = badge.querySelector('.guide_info_badge_text');
    if(text) text.textContent = '파트너 실적 유의 사항';
    badge.setAttribute('aria-label', '파트너 실적 유의 사항');
    badgeWrap.appendChild(badge);
  }
  stage.appendChild(badgeWrap);
  stage.appendChild(mixed.card);
  stage.appendChild(pair.card);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene07Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene07Layout.schedule();

  return {
    badge: badgeWrap,
    mixed: mixed,
    pair: pair
  };
}
</script>
