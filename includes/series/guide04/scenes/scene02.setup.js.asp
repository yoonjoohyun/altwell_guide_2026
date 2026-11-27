<script>
var Guide04Scene02Layout = G04Kit.makeLayout();

function setupGuide04Scene02(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene02Config.layout.anchorZone);
  var badge = K.titleBadge('autoship_icon', 'g04-s02-badge', '오토십 추천 보너스');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 2);
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g04-s02-self', label: '본인', cap: 'Base 사업자', kind: 'self' });
  var tag = K.tag(0);
  var tagSlot = K.under(self, K.grow(tag));
  var infoNode = K.infoBadge('회원 수 기준', 'i');
  var infoText = infoNode && infoNode.querySelector('.guide_info_badge_text');
  if(infoText) infoText.innerHTML = '오토십 구독중인<br>회원 수 기준';
  if(infoNode) infoNode.classList.add('g04-s02-info');
  var infoSlot = K.grow(infoNode);

  /* 단일 추천 회원 블록 */
  var single = K.el('div', 'g04-s02-block g04-slot');
  var col = K.el('div', 'g04-col');
  var partner = K.member({ id: 'g04-s02-p', label: '추천', cap: '추천 회원', kind: 'plain', size: 'sm' });
  var checkMark = K.mark(partner.fig, 'check');
  var autos = [K.grow(K.product('auto', { hidden: false, text: '오토십' }))];
  var boxRow = K.el('div', 'g04-s02-boxes');
  var boxes = ['A', 'B', 'C'].map(function(letter){
    var node = Guide04.cloneTemplate('product_swap_box');
    if(node){ node.textContent = letter; node.setAttribute('aria-label', '상품 ' + letter); }
    var slot = K.grow(node || K.chip(letter));
    boxRow.appendChild(slot);
    return slot;
  });
  var side = K.el('div', 'g04-s02-side');
  var calNode = K.el('div', 'g04-monthnote', '매월 1Point 발생');
  var calSlot;
  var oneSlot = K.grow(K.chip('1명 = 1P', 'is-red'));

  /* 10명 그리드 */
  var gridWrap = K.el('div', 'g04-s02-gridwrap g04-slot is-hidden');
  var promoChip = K.chip('동급', 'is-red');
  var promoSlot = K.grow(promoChip);
  var grid = K.el('div', 'g04-s02-grid');
  var gridMembers = [];
  var medals = [];
  var i;

  /* 월 반복 단계 */
  var bphase = K.el('div', 'g04-phase g04-s02-bphase is-hidden');
  var tagB = K.tag(0);
  var contBadge = K.el('div', 'g04-paneltitle', '지속형 보너스');
  contBadge.setAttribute('aria-label', '지속형 보너스');
  var contSlot = K.grow(contBadge);
  var months = K.el('div', 'g04-s02-months');
  var monthCards = [];

  board.id = 'g04-s02-board';

  calNode.setAttribute('aria-label', '매월 1포인트 발생');
  calSlot = K.grow(calNode);

  var memRow = K.el('div', 'g04-s02-memrow');
  var noteHost = K.el('div', 'g04-s02-notehost');
  noteHost.appendChild(calSlot);
  memRow.appendChild(partner.slot);
  memRow.appendChild(noteHost);
  col.appendChild(memRow);
  autos.forEach(function(slot){ col.appendChild(slot); });
  col.appendChild(boxRow);
  side.appendChild(oneSlot);
  single.appendChild(col);
  single.appendChild(side);

  for(i = 0; i < 10; i++){
    var gm = K.member({ label: '추천', kind: 'plain', size: 'xs' });
    var d = K.dock(gm.fig, null, 'autoship_icon', true);
    d.classList.remove('is-hidden');
    gm.wrap.style.opacity = '0';
    gm.wrap.style.transition = 'opacity 520ms ease';
    grid.appendChild(gm.wrap);
    gridMembers.push(gm);
  }
  [['lev_sp', '동급'], ['lev_dc', '추월'], ['lev_rf', 'RF 독립']].forEach(function(pair){
    var md = K.medal(gridMembers[0].fig, pair[0]);
    md.setAttribute('data-label', pair[1]);
    medals.push(md);
  });
  gridWrap.appendChild(promoSlot);
  gridWrap.appendChild(grid);

  selfRow.appendChild(infoSlot);
  selfRow.appendChild(self.slot);
  selfRow.appendChild(K.el('div'));
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(single);
  tree.appendChild(gridWrap);

  ['1개월', '2개월', '3개월'].forEach(function(label){
    var card = Guide04.cloneTemplate('calendar_month_card');
    if(!card) return;
    var h = card.querySelector('.calendar_header');
    var t = card.querySelector('.calendar_title');
    if(h) h.textContent = label;
    if(t) t.innerHTML = '+10P';
    card.setAttribute('aria-label', label + ' 매월 10포인트');
    months.appendChild(card);
    monthCards.push(card);
  });
  bphase.appendChild(contSlot);
  bphase.appendChild(K.grow(tagB));
  bphase.appendChild(months);

  board.appendChild(tree);
  board.appendChild(bphase);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide04Scene02Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene02Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board, tree: tree, svg: svg, paths: paths,
    self: self, tag: tag, tagSlot: tagSlot, infoNode: infoNode, infoSlot: infoSlot,
    single: single, partner: partner, checkMark: checkMark, autos: autos, boxes: boxes, calSlot: calSlot, oneSlot: oneSlot,
    gridWrap: gridWrap, gridMembers: gridMembers, promoChip: promoChip, promoSlot: promoSlot, medals: medals,
    bphase: bphase, tagB: tagB, contSlot: contSlot, contBadge: contBadge, monthCards: monthCards
  };
}
</script>
