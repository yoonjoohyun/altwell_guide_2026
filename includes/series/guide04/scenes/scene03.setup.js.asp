<script>
var Guide04Scene03Layout = G04Kit.makeLayout();

function setupGuide04Scene03(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene03Config.layout.anchorZone);
  var badge = K.titleBadge('startpack_badge', 'g04-s03-badge');
  var badgeName = badge.querySelector('.g02_startpack_name');
  if(badgeName) badgeName.textContent = '스타트팩 추천 보너스';
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 3);
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g04-s03-self', label: '본인', cap: 'Base 사업자', kind: 'self' });
  var tag = K.tag(0);
  var tagSlot = K.under(self, K.grow(tag));
  var cols = K.el('div', 'g04-cols');
  var members = [];
  var calNode = Guide04.cloneTemplate('startpack_span_calendar');
  var calHost = K.el('div', 'g04-s03-cal');
  var calSlot;
  var onceSlots = [];
  var kindsWrap = K.el('div', 'g04-s03-kindswrap');
  var kinds = K.el('div', 'g04-s03-kinds');
  var kindsPanel = K.el('div', 'g04-s03-kpanel');
  var kindsSlot;
  var kindCards = [];
  var maxChip = K.chip('한 명당 최대 5 POINT', 'is-red is-wide');
  var maxSlot = K.grow(maxChip);
  maxSlot.style.visibility = 'hidden';
  var flowNode = Guide04.cloneTemplate('business_flow_card');
  var flowHost = K.el('div', 'g04-flow');
  var flowSlot;
  var deny = K.el('div', 'g04-overlay g04-slot is-hidden');

  board.id = 'g04-s03-board';

  deny.setAttribute('aria-hidden', 'true');
  deny.appendChild(K.el('div', 'g04-maxbox', '최대 5포인트'));
  if(calNode){
    var cb = calNode.querySelector('.g02_span_body');
    if(cb) cb.textContent = '~3개월';
    calNode.setAttribute('aria-label', '가입월 포함 3개월');
    calHost.appendChild(calNode);
  }
  calSlot = K.grow(calHost);
  calSlot.classList.add('g04-s03-calslot');
  if(flowNode) flowHost.appendChild(flowNode);
  flowSlot = K.grow(flowHost);

  [0, 1, 2].forEach(function(i){
    var col = K.el('div', 'g04-col g04-s03-colx');
    var mem = K.member({ id: 'g04-s03-m' + i, label: '신규', cap: '신규 추천 회원', kind: 'new', size: 'sm' });
    var prod = K.grow(K.product('pack', { hidden: false }));
    var onceNode = Guide04.cloneTemplate('startpack_once_badge');
    var onceHost = K.el('div', 'g04-once');
    if(onceNode){
      var ot = onceNode.querySelector('.g02_once_text');
      if(ot) ot.textContent = '최초 1회';
      onceNode.setAttribute('aria-label', '최초 1회');
      onceHost.appendChild(onceNode);
    }
    var onceSlot = K.grow(onceHost);
    onceSlots.push(onceSlot);
    var memRow = K.el('div', 'g04-s02-memrow');
    memRow.appendChild(mem.slot);
    if(i === 0){
      var noteHost = K.el('div', 'g04-s02-notehost');
      noteHost.appendChild(calSlot);
      memRow.appendChild(noteHost);
    }
    col.appendChild(memRow);
    col.appendChild(prod);
    col.appendChild(onceSlot);
    cols.appendChild(col);
    members.push({ mem: mem, prod: prod, col: col, prodNode: prod.querySelector('.g04-product') });
  });

  [['누벨마리 스타트팩', '', 'N'], ['시그니처 스타트팩', ' is-sig', 'S']].forEach(function(item){
    var card = K.el('div', 'g04-pack-card' + item[1]);
    card.appendChild(K.el('span', 'g04-pack-dot', item[2]));
    card.appendChild(K.el('span', '', item[0]));
    card.classList.add('is-pre');
    card.setAttribute('role', 'img');
    card.setAttribute('aria-label', item[0]);
    kinds.appendChild(card);
    kindCards.push(card);
  });
  kindsPanel.appendChild(kinds);
  kindsPanel.appendChild(maxSlot);
  kindsWrap.appendChild(kindsPanel);
  kindsSlot = K.grow(kindsWrap);

  selfRow.appendChild(K.el('div'));
  selfRow.appendChild(self.slot);
  selfRow.appendChild(K.el('div'));
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
    self: self, tag: tag, tagSlot: tagSlot, members: members,
    calSlot: calSlot, onceSlots: onceSlots, kindsSlot: kindsSlot, kindCards: kindCards, kinds: kinds, maxChip: maxChip,
    maxSlot: maxSlot, flowSlot: flowSlot, flowNode: flowNode, deny: deny
  };
}
</script>
