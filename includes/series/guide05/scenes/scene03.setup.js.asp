<script>
var Guide05Scene03Layout = G04Kit.makeLayout();

function setupGuide05Scene03(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide05Scene03Config.layout.anchorZone);
  var badgeNode = K.infoBadge('매칭포인트 산정 기준', '!');
  var badge = K.el('div', 'g04-slot g04-bonus-badge g05-s03-badge is-hidden');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 3);
  var notSumBadge = K.infoBadge('모든 Base 사업자 단순 합산 아님', 'i', 'is_red');
  var notSum = K.grow(notSumBadge);
  notSum.classList.add('g05-notsum');
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g05-s03-self', label: '본인', cap: 'x', kind: 'self' });
  var selfCap = G05.baseCap(self, false, false);
  var selfMedal = G05.chestMedal(self.fig, 'lev_gc', 'GC');
  var qualBadge = K.infoBadge('본인 실적 제외', 'i', 'is_red');
  var qualSlot = K.grow(qualBadge);
  qualSlot.classList.add('g05-qualabs');
  var cols = K.el('div', 'g04-cols g04-s01-cols g05-s03-cols');
  var lines = [];
  var onlyChip = K.grow(K.chip('하위 조직 Base 사업자만 산정', 'g05-key'));
  var sumChip = K.grow(K.chip('동급 미만에서 육성한 Base 사업자 규모', 'g05-key'));
  var levels = [['lev_sp', 'SP'], ['lev_sp', 'SP'], ['lev_fc', 'FC']];

  board.id = 'g05-s03-board';
  if(badgeNode) badge.appendChild(badgeNode);
  levels.forEach(function(lv, i){
    var col = K.el('div', 'g04-col g05-line');
    var top = K.member({ id: 'g05-s03-l' + i, label: '하위', cap: 'x', kind: 'partner', size: 'sm' });
    var topCap = G05.baseCap(top, true, false);
    var medal = G05.chestMedal(top.fig, lv[0], lv[1]);
    var kidsRow = K.el('div', 'g05-linekids');
    var kids = [];
    [0, 1].forEach(function(k){
      var kid = K.member({ id: 'g05-s03-l' + i + 'k' + k, label: '', kind: 'partner', size: 'xs' });
      kidsRow.appendChild(kid.slot);
      kids.push(kid);
    });
    col.appendChild(top.slot);
    col.appendChild(kidsRow);
    cols.appendChild(col);
    lines.push({ col: col, top: top, medal: medal, kids: kids });
  });

  selfRow.appendChild(K.el('div'));
  selfRow.appendChild(self.slot);
  selfRow.appendChild(K.el('div'));
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  var cut = G05.stamp('산정 제외');
  cols.appendChild(cut);
  tree.appendChild(cols);

  board.appendChild(notSum);
  board.appendChild(qualSlot);
  board.appendChild(tree);
  board.appendChild(onlyChip);
  board.appendChild(sumChip);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide05Scene03Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide05Scene03Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    notSum: notSum, self: self, selfMedal: selfMedal, qualSlot: qualSlot, cols: cols, cut: cut,
    lines: lines, onlyChip: onlyChip, sumChip: sumChip
  };
}
</script>
