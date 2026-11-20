<script>
var Guide04Scene02Layout = G04Kit.makeLayout();

function setupGuide04Scene02(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene02Config.layout.anchorZone);
  var badge = K.titleBadge('autoship_icon', 'g04-s02-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var tree = K.el('div', 'g04-phase g04-tree');
  var svg = K.svgLayer();
  var paths = K.addPaths(svg, 1);
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g04-s02-self', label: '본인', cap: 'BASE사업자', kind: 'self' });
  var tag = K.tag(0);
  var tagSlot = K.grow(tag);
  var infoNode = K.infoBadge('회원 수 기준', 'i');
  var infoSlot = K.grow(infoNode);

  /* 단일 추천 회원 블록 */
  var single = K.el('div', 'g04-s02-block g04-slot');
  var col = K.el('div', 'g04-col');
  var partner = K.member({ id: 'g04-s02-p', label: '추천', cap: '추천 회원', kind: 'plain', size: 'sm' });
  var checkMark = K.mark(partner.fig, 'check');
  var autos = [0, 1, 2].map(function(){ return K.grow(K.product('auto', { hidden: false, text: '오토십' })); });
  var side = K.el('div', 'g04-s02-side');
  var calNode = Guide04.cloneTemplate('calendar_month_card');
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
  var tagB = K.tag(10);
  var contBadge = K.infoBadge('지속형 보너스', 'R', 'is_green');
  var contSlot = K.grow(contBadge);
  var months = K.el('div', 'g04-s02-months');
  var monthCards = [];

  board.id = 'g04-s02-board';

  if(calNode){
    var head = calNode.querySelector('.calendar_header');
    var title = calNode.querySelector('.calendar_title');
    if(head) head.textContent = 'M1';
    if(title) title.innerHTML = '매월<br>1P';
    calNode.setAttribute('aria-label', '매월 1포인트');
  }
  calSlot = K.grow(calNode || K.chip('매월 1P'));

  col.appendChild(partner.slot);
  autos.forEach(function(slot){ col.appendChild(slot); });
  side.appendChild(calSlot);
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
  selfRow.appendChild(tagSlot);
  tree.appendChild(svg);
  tree.appendChild(selfRow);
  tree.appendChild(single);
  tree.appendChild(gridWrap);

  ['M1', 'M2', 'M3'].forEach(function(label){
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
    single: single, partner: partner, checkMark: checkMark, autos: autos, calSlot: calSlot, oneSlot: oneSlot,
    gridWrap: gridWrap, gridMembers: gridMembers, promoChip: promoChip, promoSlot: promoSlot, medals: medals,
    bphase: bphase, tagB: tagB, contSlot: contSlot, contBadge: contBadge, monthCards: monthCards
  };
}
</script>
