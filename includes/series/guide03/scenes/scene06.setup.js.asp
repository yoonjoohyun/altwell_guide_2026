<script>
var Guide03Scene06Layout = (function(){
  var _ctx = null;
  var _resizeBound = false;

  function applyFit(){
    if(!_ctx || typeof Guide03 === 'undefined') return;
    Guide03.fitGroup(_ctx.canvas, _ctx.inner, _ctx.stage, _ctx.badge);
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

function setupGuide03Scene06(canvas){
  function grow(child){
    var slot = document.createElement('div');
    var clip = document.createElement('div');
    slot.className = 'g03-grow';
    clip.className = 'g03-grow-clip';
    clip.appendChild(child);
    slot.appendChild(clip);
    return slot;
  }

  function person(templateId){
    var icon = Guide03.cloneTemplate(templateId);
    var wrap = document.createElement('div');
    wrap.className = 'g03-member';
    if(icon) wrap.appendChild(icon);
    return { slot: grow(wrap), icon: icon };
  }

  var zone = Guide03Scene06Config.layout.anchorZone;
  var stack = document.createElement('div');
  var inner = document.createElement('div');
  var stage = document.createElement('div');
  var board = document.createElement('div');
  var sum = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');
  var self = person('member_base_self');
  var left = person('member_base_partner');
  var right = person('member_base_partner');
  var leftCol = document.createElement('div');
  var rightCol = document.createElement('div');
  var leftSep = document.createElement('div');
  var rightSep = document.createElement('div');

  stack.id = 'g03-s06-stack';
  stack.className = 'g03-stack g01-zone-wrap lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s06';
  board.className = 'g03-board g03-slot is-hidden';
  sum.className = 'g03-s06-sum g03-slot is-hidden';
  sum.innerHTML = '구성원 모두의 S.E.P 합<br>매월 100만 이상 달성';
  tree.className = 'g03-tree';
  lines.setAttribute('class', 'g03-lines');
  lines.setAttribute('aria-hidden', 'true');
  [0, 1].forEach(function(){
    lines.appendChild(document.createElementNS('http://www.w3.org/2000/svg', 'path'));
  });
  rowTop.className = 'g03-member-row';
  rowBottom.className = 'g03-member-row';
  leftCol.className = 'g03-s06-col';
  rightCol.className = 'g03-s06-col';
  leftSep.className = 'g03-s06-sep g03-slot is-hidden';
  rightSep.className = 'g03-s06-sep g03-slot is-hidden';
  leftSep.textContent = 'S.E.P 30만 이상 달성';
  rightSep.textContent = 'S.E.P 30만 이상 달성';

  rowTop.appendChild(self.slot);
  leftCol.appendChild(left.slot);
  leftCol.appendChild(leftSep);
  rightCol.appendChild(right.slot);
  rightCol.appendChild(rightSep);
  rowBottom.appendChild(leftCol);
  rowBottom.appendChild(rightCol);
  tree.appendChild(lines);
  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);
  board.appendChild(sum);
  board.appendChild(tree);
  stage.appendChild(board);
  inner.appendChild(stage);
  stack.appendChild(inner);
  canvas.appendChild(stack);

  Guide03Scene06Layout.bind({ canvas: canvas, inner: inner, stage: stage });
  Guide03Scene06Layout.schedule();

  return {
    board: board,
    sum: sum,
    tree: tree,
    lines: lines,
    members: [
      { slot: self.slot, icon: self.icon },
      { slot: left.slot, icon: left.icon },
      { slot: right.slot, icon: right.icon }
    ],
    seps: [leftSep, rightSep]
  };
}
</script>
