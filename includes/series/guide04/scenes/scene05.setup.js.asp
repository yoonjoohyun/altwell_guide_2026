<script>
var Guide04Scene05Layout = G04Kit.makeLayout();

function setupGuide04Scene05(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene05Config.layout.anchorZone);
  var badge = K.titleBadge('recommend_bonus_icon', 'g04-s05-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');
  var i;

  /* ① BASE 자격 */
  var p1 = K.el('div', 'g04-phase g04-s05-base');
  var cond = K.chip('첫 번째 조건', 'is-red');
  var baseRow = K.el('div', 'g04-s05-baserow');
  var baseWrap = K.titleBadge('base_business_icon', 'g04-s05-base');
  var check = Guide04.cloneTemplate('status_check_icon');
  var checkWrap = K.el('div', 'g04-slot is-hidden');

  /* ② 포인트 기준 카드 */
  var p2 = K.el('div', 'g04-phase is-hidden');
  var cardRow = K.el('div', 'g04-s05-cards');
  var cardA = K.el('div', 'g04-info-card g04-slot is-hidden');
  var cardB = K.el('div', 'g04-info-card g04-slot is-hidden');
  var calNode = Guide04.cloneTemplate('calendar_month_card');

  /* ③ 회원 증가 */
  var p3 = K.el('div', 'g04-phase is-hidden');
  var selfRow = K.el('div', 'g04-selfrow');
  var self = K.member({ id: 'g04-s05-self', label: '본인', cap: 'BASE사업자', kind: 'self' });
  var tag = K.tag(0);
  var tagSlot = K.grow(tag);
  var capNode = K.infoBadge('적립 상한 없음', 'R', 'is_green');
  var capSlot = K.grow(capNode || K.chip('적립 상한 없음'));
  var grid = K.el('div', 'g04-s05-grid');
  var gridMembers = [];

  /* ④ 1P = 최대 1만원 */
  var p4 = K.el('div', 'g04-phase g04-s05-cash is-hidden');
  var cashNode = Guide04.cloneTemplate('point_to_cash_card');

  /* ⑤ 핵심 3가지 */
  var three = K.threeSlots([
    { text: 'BASE사업자 자격 유지', build: function(body){ body.appendChild(K.compact('base_business_icon')); } },
    { text: '신규 회원 추천', build: function(body){ body.appendChild(K.member({ label: '신규', kind: 'new' }).wrap); } },
    { text: '추천 회원의 제품 이용 지원', build: function(body){
        body.appendChild(K.compact('autoship_icon'));
        body.appendChild(K.product('pack', { hidden: false, mini: true }));
      } }
  ], 'g04-three g04-phase is-hidden');

  board.id = 'g04-s05-board';

  if(check) checkWrap.appendChild(check);
  baseRow.appendChild(baseWrap);
  baseRow.appendChild(checkWrap);
  p1.appendChild(cond);
  p1.appendChild(baseRow);

  /* 카드 A — 오토십 */
  var aRow = K.el('div', 'g04-info-row');
  var aBadge = Guide04.cloneTemplate('autoship_icon');
  if(aBadge){
    var aText = aBadge.querySelector('.autoship_text');
    if(aText) aText.textContent = '오토십';
    aRow.appendChild(aBadge);
  }
  if(calNode){
    var h = calNode.querySelector('.calendar_header');
    var t = calNode.querySelector('.calendar_title');
    if(h) h.textContent = 'M1';
    if(t) t.innerHTML = '매월';
    calNode.setAttribute('aria-label', '매월');
    aRow.appendChild(calNode);
  }
  cardA.appendChild(aRow);
  cardA.appendChild(K.el('div', 'g04-info-main', '회원 1명당'));
  var aMain = K.el('div', 'g04-info-main');
  aMain.innerHTML = '<b>매월 1P</b>';
  cardA.appendChild(aMain);

  /* 카드 B — 스타트팩 */
  var bRow = K.el('div', 'g04-info-row');
  bRow.appendChild(K.product('pack', { hidden: false }));
  var onceNode = Guide04.cloneTemplate('startpack_once_badge');
  var onceHost = K.el('div', 'g04-once');
  if(onceNode){
    var ot = onceNode.querySelector('.g02_once_text');
    if(ot) ot.textContent = '최초 1회';
    onceNode.setAttribute('aria-label', '최초 1회');
    onceHost.appendChild(onceNode);
  }
  bRow.appendChild(onceHost);
  cardB.appendChild(bRow);
  cardB.appendChild(K.el('div', 'g04-info-main', '3개월 이내'));
  var bMain = K.el('div', 'g04-info-main');
  bMain.innerHTML = '<b>최초 1회 5P</b>';
  cardB.appendChild(bMain);

  cardRow.appendChild(cardA);
  cardRow.appendChild(cardB);
  p2.appendChild(cardRow);

  for(i = 0; i < 9; i++){
    var gm = K.member({ label: '추천', kind: 'plain', size: 'xs' });
    var d = K.dock(gm.fig, null, 'autoship_icon', true);
    d.classList.remove('is-hidden');
    gm.wrap.style.opacity = '0';
    gm.wrap.style.transition = 'opacity 520ms ease';
    grid.appendChild(gm.wrap);
    gridMembers.push(gm);
  }
  selfRow.appendChild(capSlot);
  selfRow.appendChild(self.slot);
  selfRow.appendChild(tagSlot);
  p3.appendChild(selfRow);
  p3.appendChild(grid);

  if(cashNode) p4.appendChild(cashNode);

  board.appendChild(p1);
  board.appendChild(p2);
  board.appendChild(p3);
  board.appendChild(p4);
  board.appendChild(three.host);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);

  Guide04Scene05Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene05Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board,
    p1: p1, baseWrap: baseWrap, checkWrap: checkWrap, cond: cond,
    p2: p2, cardA: cardA, cardB: cardB,
    p3: p3, self: self, tag: tag, tagSlot: tagSlot, capSlot: capSlot, gridMembers: gridMembers,
    p4: p4, cashNode: cashNode, three: three
  };
}
</script>
