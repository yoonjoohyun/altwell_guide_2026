<script>
var Guide03Scene05Layout = (function(){
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
  var board = document.createElement('div');
  var gauge = document.createElement('div');
  var label = document.createElement('div');
  var track = document.createElement('div');
  var fill = document.createElement('div');
  var stable = document.createElement('div');

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

  function autoChip(){
    var chip = Guide03.cloneTemplate('autoship_icon');
    var wrap = document.createElement('div');
    wrap.className = 'g03-s05-coda-auto g03-slot is-hidden';
    if(chip){
      chip.setAttribute('aria-label', '오토십 구독');
      wrap.appendChild(chip);
    }
    return wrap;
  }

  stack.id = 'g03-s05-stack';
  stack.className = 'g03-stack g01-zone-wrap lo-zone-place';
  Guide03.placeAtZone(stack, zone);
  inner.className = 'g03-stack-inner';
  stage.className = 'g03-s05-stage';
  row.className = 'g03-s05-row';
  row.appendChild(left.col);
  row.appendChild(right.col);

  gauge.className = 'g03-s05-gauge';
  label.className = 'g03-s05-gauge-label';
  label.textContent = 'S.E.P 30만 이상 달성';
  track.className = 'g03-s05-gauge-track';
  fill.className = 'g03-s05-gauge-fill';
  track.appendChild(fill);
  gauge.appendChild(label);
  gauge.appendChild(track);
  hidden(gauge, gauge.className);

  stable.className = 'g03-s05-stable';
  stable.textContent = '안정적인 조건 달성 구조';
  hidden(stable, stable.className);

  var opening = document.createElement('div');
  var coda = document.createElement('div');
  var codaBoard = document.createElement('div');
  var note = document.createElement('div');
  var noteInner = document.createElement('div');
  var tree = document.createElement('div');
  var lines = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  var rowTop = document.createElement('div');
  var rowBottom = document.createElement('div');
  var self = person('member_base_self');
  var selfHost = self.slot.querySelector('.g03-member');
  var selfDock = document.createElement('div');
  var selfBadge = document.createElement('div');
  var selfBadgeIcon = Guide03.cloneTemplate('base_business_icon');
  var codaLeft = person('member_base_partner');
  var codaRight = person('member_base_partner');
  var leftCol = document.createElement('div');
  var rightCol = document.createElement('div');
  var leftAuto = autoChip();
  var rightAuto = autoChip();

  opening.className = 'g03-s05';
  board.className = 'g03-board';
  board.appendChild(row);
  board.appendChild(gauge);
  board.appendChild(stable);
  opening.appendChild(board);

  coda.className = 'g03-s05-coda g03-slot is-hidden';
  codaBoard.className = 'g03-board g03-slot is-hidden';
  note.className = 'g03-s05-note g03-slot is-hidden';
  noteInner.className = 'g03-s05-note-inner';
  noteInner.innerHTML = '구성원 합산 조건 등<span class="g03-s05-note-em">추가 조건 없음</span>';
  note.appendChild(noteInner);
  tree.className = 'g03-tree';
  lines.setAttribute('class', 'g03-lines');
  lines.setAttribute('aria-hidden', 'true');
  [0, 1].forEach(function(){
    lines.appendChild(document.createElementNS('http://www.w3.org/2000/svg', 'path'));
  });
  if(selfHost) selfHost.classList.add('g03-s05-coda-self');
  selfDock.className = 'g03-s05-coda-badge-dock';
  selfBadge.className = 'g03-s05-coda-badge g03-slot is-hidden';
  if(selfBadgeIcon){
    selfBadgeIcon.classList.remove('base_business_icon_o');
    selfBadgeIcon.classList.add('base_business_icon_c');
    selfBadge.appendChild(selfBadgeIcon);
  }
  selfDock.appendChild(selfBadge);
  if(selfHost) selfHost.appendChild(selfDock);
  rowTop.className = 'g03-member-row';
  rowBottom.className = 'g03-member-row';
  leftCol.className = 'g03-s05-coda-col';
  rightCol.className = 'g03-s05-coda-col';
  rowTop.appendChild(self.slot);
  leftCol.appendChild(codaLeft.slot);
  leftCol.appendChild(leftAuto);
  rightCol.appendChild(codaRight.slot);
  rightCol.appendChild(rightAuto);
  rowBottom.appendChild(leftCol);
  rowBottom.appendChild(rightCol);
  tree.appendChild(lines);
  tree.appendChild(rowTop);
  tree.appendChild(rowBottom);
  codaBoard.appendChild(tree);
  coda.appendChild(codaBoard);
  coda.appendChild(note);

  stage.appendChild(opening);
  stage.appendChild(coda);
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
    stable: stable,
    opening: opening,
    coda: {
      root: coda,
      board: codaBoard,
      note: note,
      badge: selfBadge,
      tree: tree,
      lines: lines,
      members: [
        { slot: self.slot, icon: self.icon },
        { slot: codaLeft.slot, icon: codaLeft.icon },
        { slot: codaRight.slot, icon: codaRight.icon }
      ],
      autos: [leftAuto, rightAuto]
    }
  };
}
</script>
