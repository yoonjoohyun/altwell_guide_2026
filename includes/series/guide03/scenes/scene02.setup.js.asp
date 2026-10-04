<script>
var Guide03Scene02Layout = (function(){
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

function setupGuide03Scene02(canvas){
  var zone = Guide03Scene02Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var board = document.createElement('div');
  var tree = document.createElement('div');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');

  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g03-grow';
    clip.className = 'g03-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function memberCol(templateId, withDock){
    var icon = Guide03.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    var check = Guide03.cloneTemplate('status_check_icon');
    var col = document.createElement('div');
    var dock = null;
    wrap.className = 'g03-member';
    col.className = 'g03-s02-col';
    if(icon) wrap.appendChild(icon);
    if(check) check.classList.add('g03-s02-check');
    col.appendChild(grow(wrap));
    col.appendChild(grow(check || document.createElement('div')));
    if(withDock){
      dock = document.createElement('div');
      dock.className = 'g03-s02-dock';
      col.appendChild(dock);
    }
    return {
      col: col,
      member: col.children[0],
      icon: icon,
      check: col.children[1],
      dock: dock
    };
  }

  stack.id = 'g03-s02-stack';
  stack.className = 'g03-stack lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s02';
  board.id = 'g03-s02-board';
  board.className = 'g03-board g03-slot is-hidden';
  tree.className = 'g03-tree';
  rowTop.className = 'g03-member-row';
  rowBottom.className = 'g03-member-row';

  var self = memberCol('member_base_self', true);
  var left = memberCol('member_base_partner', false);
  var right = memberCol('member_base_partner', false);
  rowTop.appendChild(self.col);
  rowBottom.appendChild(left.col);
  rowBottom.appendChild(right.col);

  var caption = document.createElement('div');
  caption.className = 'g03-s02-caption';
  caption.textContent = 'BASE 사업자 기본 구성';
  var captionSlot = grow(caption);

  var month = document.createElement('div');
  month.id = 'g03-s02-month';
  month.className = 'g03-slot g03-s02-month is-hidden';
  month.textContent = '매월 조건 충족';

  var badge = Guide03.cloneTemplate('base_business_icon');
  var badgeWrap = document.createElement('div');
  badgeWrap.id = 'g03-s02-badge';
  badgeWrap.className = 'g03-slot g03-s02-badge is-hidden';
  if(badge) badgeWrap.appendChild(badge);

  var qual = document.createElement('div');
  qual.id = 'g03-s02-qual';
  qual.className = 'g03-slot g03-s02-qual is-hidden';
  qual.textContent = '지위가 아닌 사업자 자격';

  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);
  board.appendChild(tree);
  board.appendChild(captionSlot);
  stage.appendChild(month);
  stage.appendChild(board);
  stage.appendChild(badgeWrap);
  stage.appendChild(qual);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene02Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene02Layout.schedule();

  return {
    inner: inner,
    stage: stage,
    month: month,
    board: board,
    caption: captionSlot,
    members: [self, left, right],
    badge: badgeWrap,
    qual: qual,
    dock: self.dock
  };
}
</script>
