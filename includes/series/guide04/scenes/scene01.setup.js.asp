<script>
var Guide04Scene01Layout = G04Kit.makeLayout();

function setupGuide04Scene01(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene01Config.layout.anchorZone);
  var badge = K.titleBadge('recommend_bonus_icon', 'g04-s01-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 6);
  var selfRow = K.el('div', 'g04-selfrow');
  var cols = K.el('div', 'g04-cols g04-s01-cols');
  var kinds = ['auto', 'pack', 'auto', 'pack', 'auto', 'pack'];
  var partners = [];
  var self = K.member({ id: 'g04-s01-self', label: '본인', cap: 'BASE사업자', kind: 'self' });
  var baseDock = K.dock(self.fig, 'g04-s01-base', 'base_business_icon', true);
  var tag = K.tag(0);
  var rightChip = K.infoBadge('권리소득', 'R', 'is_green');
  var chipSlot = K.grow(rightChip || K.chip('권리소득'));
  var tagSlot = K.grow(tag);
  var deny = K.overlay('status_cross_icon');
  var sum;

  board.id = 'g04-s01-board';
  tag.classList.remove('is-hidden');

  kinds.forEach(function(kind, i){
    var col = K.el('div', 'g04-col');
    var mem = K.member({ id: 'g04-s01-p' + i, label: '추천', kind: 'plain', size: 'sm' });
    var prod = K.grow(K.product(kind, { hidden: false }));
    col.appendChild(mem.slot);
    col.appendChild(prod);
    cols.appendChild(col);
    partners.push({ mem: mem, prod: prod, prodNode: prod.querySelector('.g04-product'), kind: kind });
  });

  selfRow.appendChild(chipSlot);
  selfRow.appendChild(self.slot);
  selfRow.appendChild(tagSlot);
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(cols);

  sum = K.threeSlots([
    { text: 'BASE 유지', build: function(body){ body.appendChild(K.compact('base_business_icon')); } },
    { text: '신규 회원 추천', build: function(body){ body.appendChild(K.member({ label: '신규', kind: 'new' }).wrap); } },
    { text: '제품 이용 지원', build: function(body){
        body.appendChild(K.compact('autoship_icon'));
        body.appendChild(K.product('pack', { hidden: false, mini: true }));
      } }
  ], 'g04-sum g04-phase is-hidden');

  board.appendChild(tree);
  board.appendChild(sum.host);
  board.appendChild(deny);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide04Scene01Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene01Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree,
    svg: svg, paths: paths, self: self, baseDock: baseDock, tag: tag, tagSlot: tagSlot,
    chipSlot: chipSlot, partners: partners, deny: deny, sum: sum
  };
}
</script>
