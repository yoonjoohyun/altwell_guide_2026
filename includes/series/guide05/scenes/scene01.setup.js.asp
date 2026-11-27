<script>
var Guide05Scene01Layout = G04Kit.makeLayout();

function setupGuide05Scene01(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene01Config.layout.anchorZone);
  var badge = K.titleBadge('matching_bonus_icon', 'g05-s01-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 2);
  var selfRow = K.el('div', 'g04-selfrow');
  var cols = K.el('div', 'g04-cols g04-s01-cols');
  var partners = [];
  var self = K.member({ id: 'g05-s01-self', label: '본인', cap: 'x', kind: 'self' });
  var selfCap = G05.baseCap(self, false, false);
  var startChip = K.el('div', 'g04-chip-text g05-start g05-start-one');
  var startParts = ['출발점', '=', 'Base 사업자 유지'].map(function(t, n){
    var sp = K.el('span', 'g05-st is-pre' + (n === 1 ? ' is-eq' : ''), t);
    startChip.appendChild(sp);
    return sp;
  });
  var startSlot = K.grow(startChip);
  var growBadge = K.el('div', 'g04-overlay g04-slot is-hidden');
  var compare = K.el('div', 'g04-phase g05-compare is-hidden');

  /* 장면2 — 추천보너스(A) */
  var paneA = K.el('div', 'g04-phase g05-pane');
  var badgeA = G05.badgeSlot('recommend_bonus_icon', 'is-small');
  var rowA = K.el('div', 'g05-cmp-row');
  var meA = K.member({ id: 'g05-s01-ma', label: '본인', cap: 'x', kind: 'self', size: 'sm' });
  var meACap = G05.baseCap(meA, true, false);
  var tagA = K.tag(0);
  var tagWrap = K.el('div', 'g05-tagwrap');
  var tagASlot;
  tagWrap.appendChild(tagA);
  tagASlot = K.grow(tagWrap);
  meA.wrap.appendChild(tagASlot);   /* Base 사업자 뱃지 하단 */
  var linkA = K.grow(K.el('div', 'g04-s05-link'));
  var newA = K.member({ id: 'g05-s01-na', label: '신규', cap: '신규 추천 회원', kind: 'new', size: 'sm' });
  var newACol = K.el('div', 'g05-newcol');
  var prodRowA = K.el('div', 'g04-prods');
  var prodsA = [K.grow(K.product('auto', { hidden: false, mini: true })), K.grow(K.product('pack', { hidden: false, mini: true }))];

  /* 장면2 — 매칭보너스: 본인 아래 신규 멤버가 Base 사업자로 변한 뒤, Base 유지 강조 + 본인 SP 이상까지 (한 화면에서 통합) */
  var treeB = K.el('div', 'g04-phase g04-tree g05-treeB is-hidden');
  var svgB = K.svgLayer();
  var pathsB = K.addPaths(svgB, 2);
  var headerB = G05.badgeSlot('matching_bonus_icon', 'is-strong');
  var selfRowB = K.el('div', 'g04-selfrow');
  var selfB = K.member({ id: 'g05-s01-sb', label: '본인', cap: 'x', kind: 'self' });
  var selfBCap = G05.baseCap(selfB, false, false);
  var spMedal = G05.chestMedal(selfB.fig, 'lev_sp', 'SP');
  var spArrow = G05.arrowUp();
  var colsB = K.el('div', 'g04-cols g04-s01-cols');
  var kidsB = [];
  var chipB = K.grow(K.chip('Base 사업자 육성'));

  board.id = 'g05-s01-board';
  growBadge.setAttribute('aria-hidden', 'true');
  growBadge.appendChild(K.el('div', 'g05-growbadge', '조직 성장 보상'));

  [0, 1].forEach(function(i){
    var col = K.el('div', 'g04-col');
    var mem = K.member({ id: 'g05-s01-p' + i, label: '하위', cap: 'x', kind: 'partner', size: 'sm' });
    G05.baseCap(mem, true, false);
    col.appendChild(mem.slot);
    cols.appendChild(col);
    partners.push({ mem: mem });
  });

  /* 가슴 지위: 메달 + 상승 화살표 */
  spMedal.appendChild(spArrow);

  [0, 1].forEach(function(i){
    var col = K.el('div', 'g04-col g05-memcol');
    var mem = K.member({ id: 'g05-s01-kb' + i, label: '신규', cap: '', kind: 'new', size: 'sm' });
    var capSlot = G05.baseCap(mem, true, false);
    capSlot.classList.add('g05-ph');
    col.appendChild(mem.slot);
    colsB.appendChild(col);
    kidsB.push({ mem: mem, capSlot: capSlot });
  });

  selfRow.appendChild(K.el('div'));
  selfRow.appendChild(self.slot);
  selfRow.appendChild(K.el('div'));
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(cols);

  /* A */
  prodRowA.appendChild(prodsA[0]);
  prodRowA.appendChild(prodsA[1]);
  newACol.appendChild(newA.slot);
  newACol.appendChild(prodRowA);
  rowA.appendChild(meA.slot);
  rowA.appendChild(linkA);
  rowA.appendChild(newACol);
  paneA.appendChild(badgeA);
  paneA.appendChild(rowA);

  /* B: 통합 트리 */
  selfRowB.appendChild(K.el('div'));
  selfRowB.appendChild(selfB.slot);
  selfRowB.appendChild(K.el('div'));
  treeB.appendChild(svgB);
  treeB.appendChild(headerB);
  treeB.appendChild(selfRowB);
  treeB.appendChild(colsB);
  var swapB = K.el('div', 'g05-swap');
  swapB.appendChild(chipB);
  swapB.appendChild(startSlot);
  treeB.appendChild(swapB);

  compare.appendChild(paneA);
  compare.appendChild(treeB);

  board.appendChild(tree);
  board.appendChild(compare);
  board.appendChild(growBadge);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide05Scene01Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide05Scene01Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    self: self, selfCap: selfCap, partners: partners, startSlot: startSlot, startParts: startParts, growBadge: growBadge,
    compare: compare, paneA: paneA,
    badgeA: badgeA, meA: meA, tagA: tagA, tagASlot: tagASlot, linkA: linkA, newA: newA, prodsA: prodsA,
    treeB: treeB, svgB: svgB, pathsB: pathsB, headerB: headerB, selfB: selfB, spMedal: spMedal, kidsB: kidsB, chipB: chipB
  };
}
</script>
