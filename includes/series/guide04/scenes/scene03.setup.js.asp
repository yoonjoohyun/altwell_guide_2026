<script>
var Guide04Scene03Layout = G04Kit.makeLayout();

function setupGuide04Scene03(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene03Config.layout.anchorZone);
  var badge = K.titleBadge('startpack_badge', 'g04-s03-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 3);
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g04-s03-self', label: '본인', cap: 'BASE사업자', kind: 'self' });
  var tag = K.tag(0);
  var tagSlot = K.grow(tag);
  var ptsNode = Guide04.cloneTemplate('startpack_recommend_points');
  var ptsHost = K.el('div', 'g04-ref-pts');
  var ptsSlot;
  var cols = K.el('div', 'g04-cols');
  var members = [];
  var calNode = Guide04.cloneTemplate('startpack_span_calendar');
  var calHost = K.el('div', 'g04-s03-cal');
  var calSlot;
  var onceNode = Guide04.cloneTemplate('startpack_once_badge');
  var onceHost = K.el('div', 'g04-once');
  var onceSlot;
  var kindsWrap = K.el('div', 'g04-s03-kindswrap');
  var kinds = K.el('div', 'g04-s03-kinds');
  var kindsSlot;
  var kindCards = [];
  var maxChip = K.chip('한 명당 최대 5 POINT', 'is-red');
  var maxSlot = K.grow(maxChip);
  var flowNode = Guide04.cloneTemplate('business_flow_card');
  var flowHost = K.el('div', 'g04-flow');
  var flowSlot;
  var deny = K.overlay('status_cross_icon');

  board.id = 'g04-s03-board';

  if(ptsNode) ptsHost.appendChild(ptsNode);
  ptsSlot = K.grow(ptsHost);
  if(calNode) calHost.appendChild(calNode);
  calSlot = K.grow(calHost);
  if(onceNode){
    var ot = onceNode.querySelector('.g02_once_text');
    if(ot) ot.textContent = '최초 1회';
    onceNode.setAttribute('aria-label', '최초 1회');
    onceHost.appendChild(onceNode);
  }
  onceSlot = K.grow(onceHost);
  if(flowNode) flowHost.appendChild(flowNode);
  flowSlot = K.grow(flowHost);

  [0, 1, 2].forEach(function(i){
    var col = i === 0 ? K.el('div', 'g04-col g04-s03-col0') : K.el('div', 'g04-col');
    var mem = K.member({ id: 'g04-s03-m' + i, label: '신규', kind: 'new', size: 'sm' });
    var prod = K.grow(K.product('pack', { hidden: false }));
    col.appendChild(mem.slot);
    if(i === 0) col.appendChild(calSlot);
    col.appendChild(prod);
    if(i === 0) col.appendChild(onceSlot);
    cols.appendChild(col);
    members.push({ mem: mem, prod: prod, prodNode: prod.querySelector('.g04-product') });
  });

  [['누벨마리 스타트팩', '', 'N'], ['시그니처 스타트팩', ' is-sig', 'S']].forEach(function(item){
    var card = K.el('div', 'g04-pack-card' + item[1]);
    card.appendChild(K.el('span', 'g04-pack-dot', item[2]));
    card.appendChild(K.el('span', '', item[0]));
    card.setAttribute('role', 'img');
    card.setAttribute('aria-label', item[0]);
    kinds.appendChild(card);
    kindCards.push(card);
  });
  kindsWrap.appendChild(kinds);
  kindsWrap.appendChild(maxSlot);
  kindsSlot = K.grow(kindsWrap);

  selfRow.appendChild(ptsSlot);
  selfRow.appendChild(self.slot);
  selfRow.appendChild(tagSlot);
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(cols);
  tree.appendChild(kindsSlot);
  tree.appendChild(flowSlot);

  board.appendChild(tree);
  board.appendChild(deny);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide04Scene03Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene03Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    self: self, tag: tag, tagSlot: tagSlot, ptsSlot: ptsSlot, members: members,
    calSlot: calSlot, onceSlot: onceSlot, kindsSlot: kindsSlot, kindCards: kindCards,
    maxSlot: maxSlot, flowSlot: flowSlot, flowNode: flowNode, deny: deny
  };
}
</script>
