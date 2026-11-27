<script>
var Guide04Scene05Layout = G04Kit.makeLayout();

function setupGuide04Scene05(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene05Config.layout.anchorZone);
  var badge = K.titleBadge('recommend_bonus_icon', 'g04-s05-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 3);
  var i;

  /* 본인 멤버 — 전체 씬에서 유지 */
  var selfRow = K.el('div', 'g04-selfrow g04-s05-selfrow');
  var self = K.member({ id: 'g04-s05-self', label: '본인', cap: 'Base 사업자', kind: 'self' });
  var baseDock = K.dock(self.fig, 'g04-s05-base', 'base_business_icon', true);
  var checkMark = K.mark(self.fig, 'check');
  var tag = K.tag(0);
  var tagSlot = K.under(self, K.grow(tag));
  var cashBox = K.el('div', 'g04-cashbox', '1P = 최대 10,000원');
  var cashSlot = K.grow(cashBox);

  /* ② 추천 회원 A(오토십 · 매월 1P) / B(스타트팩 · 최초 1회 5P) */
  var stageA = K.el('div', 'g04-cols g04-s05-ab g04-slot is-hidden');
  var colA = K.el('div', 'g04-col');
  var memA = K.member({ id: 'g04-s05-a', label: '추천', cap: '추천 회원', kind: 'plain', size: 'sm' });
  var prodA = K.grow(K.product('auto', { hidden: false, text: '오토십' }));
  var monthRow = K.el('div', 'g04-s05-months');
  var monthSlots = ['1개월', '2개월', '3개월'].map(function(label){
    var chip = K.grow(K.el('div', 'g04-monthchip', label));
    monthRow.appendChild(chip);
    return chip;
  });
  var noteA = K.grow(K.el('div', 'g04-monthnote', '매월 1P'));
  var colB = K.el('div', 'g04-col');
  var memB = K.member({ id: 'g04-s05-b', label: '추천', cap: '추천 회원', kind: 'plain', size: 'sm' });
  var prodB = K.grow(K.product('pack', { hidden: false }));
  var noteB = K.grow(K.el('div', 'g04-monthnote', '등록 후 3개월 이내 · 최초 1회 5P'));

  /* ③ 추천 회원 증가 */
  var gridWrap = K.el('div', 'g04-slot is-hidden');
  var grid = K.el('div', 'g04-s05-grid');
  var gridMembers = [];

  /* ⑤ 핵심 3가지 — 좌측 번호 + 구분선 행 */
  var sum = K.el('div', 'g04-s05-sum g04-slot is-hidden');
  var sumRows = [];
  function sumRow(n, build){
    var inner = K.el('div', 'g04-s05-sumrow');
    inner.appendChild(K.el('div', 'g04-num', String(n)));
    var body = K.el('div', 'g04-s05-sumbody');
    build(body);
    inner.appendChild(body);
    var slot = K.grow(inner);
    sum.appendChild(slot);
    sumRows.push(slot);
  }
  sumRow(1, function(body){
    var mm = K.member({ label: '본인', cap: 'x', kind: 'self', size: 'sm' });
    var oldCap = mm.wrap.querySelector('.g04-cap');
    if(oldCap) oldCap.parentNode.removeChild(oldCap);
    var ck = K.mark(mm.fig, 'check');
    ck.classList.remove('is-hidden');
    var col1 = K.el('div', 'g04-s05-col1');
    col1.appendChild(mm.wrap);
    col1.appendChild(Guide04.cloneTemplate('base_business_icon'));
    body.appendChild(col1);
  });
  sumRow(2, function(body){
    var me = K.member({ label: '본인', cap: '본인(추천인)', kind: 'self', size: 'sm' });
    var link = K.el('div', 'g04-s05-link');
    var nw = K.member({ label: '신규', cap: '신규 추천 회원', kind: 'new', size: 'sm' });
    body.appendChild(me.wrap);
    body.appendChild(link);
    body.appendChild(nw.wrap);
  });
  sumRow(3, function(body){
    var nm = K.member({ label: '신규', cap: '신규 추천 회원', kind: 'new', size: 'sm' });
    var prods = K.el('div', 'g04-s05-sumprods');
    prods.appendChild(K.product('auto', { hidden: false, text: '오토십' }));
    prods.appendChild(K.product('pack', { hidden: false }));
    body.appendChild(nm.wrap);
    body.appendChild(prods);
  });

  board.id = 'g04-s05-board';

  colA.appendChild(memA.slot);
  colA.appendChild(prodA);
  colA.appendChild(monthRow);
  colA.appendChild(noteA);
  colB.appendChild(memB.slot);
  colB.appendChild(prodB);
  colB.appendChild(noteB);
  stageA.appendChild(colA);
  stageA.appendChild(colB);

  for(i = 0; i < 9; i++){
    var gm = K.member({ label: '추천', kind: 'plain', size: 'xs' });
    var d = K.dock(gm.fig, null, 'autoship_icon', true);
    d.classList.remove('is-hidden');
    gm.wrap.style.opacity = '0';
    gm.wrap.style.transition = 'opacity 520ms ease';
    grid.appendChild(gm.wrap);
    gridMembers.push(gm);
  }
  gridWrap.appendChild(grid);


  selfRow.appendChild(self.slot);
  selfRow.appendChild(cashSlot);
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(stageA);
  tree.appendChild(gridWrap);

  board.appendChild(tree);
  board.appendChild(sum);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide04Scene05Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene05Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    self: self, baseDock: baseDock, checkMark: checkMark, tag: tag, tagSlot: tagSlot,
    cashSlot: cashSlot,
    stageA: stageA, memA: memA, prodA: prodA, monthSlots: monthSlots, noteA: noteA,
    memB: memB, prodB: prodB, noteB: noteB,
    gridWrap: gridWrap, gridMembers: gridMembers,
    sum: sum, sumRows: sumRows
  };
}
</script>
