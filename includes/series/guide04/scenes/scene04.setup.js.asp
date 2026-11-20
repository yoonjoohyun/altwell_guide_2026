<script>
var Guide04Scene04Layout = G04Kit.makeLayout();

function setupGuide04Scene04(canvas){
  var K = G04Kit;
  var m = K.mountStack(canvas, Guide04Scene04Config.layout.anchorZone);
  var badge = K.titleBadge('recommend_bonus_icon', 'g04-s04-badge');
  var board = K.el('div', 'g04-board g04-slot is-hidden');

  /* 무대A: 추천관계 등록 */
  var stageA = K.el('div', 'g04-phase g04-s04-a');
  var ghost = K.el('div', 'g04-ghost', '추천인');
  var ghostSlot = K.grow(ghost);
  var frameNode = Guide04.cloneTemplate('rf_group_frame');
  var frameBody = frameNode ? frameNode.querySelector('.rf_group_frame_body') : null;
  var frameSlot = K.grow(frameNode || K.el('div'));
  var cands = [];
  var linkNode = Guide04.cloneTemplate('referral_link_line');
  var linkSlot = K.grow(linkNode || K.el('div'));
  var newMember = K.member({ id: 'g04-s04-new', label: '신규', cap: '신규 회원', kind: 'new', size: 'sm' });
  var stamp = K.overlay('unavailable_stamp', '추천인 변경 불가');
  var cursorHost = K.el('div', 'g04-cursor g04-slot is-hidden');
  var cursorNode = Guide04.cloneTemplate('cursor_click_icon');
  var pickedLabel = K.el('div', 'g04-picked-label g04-slot is-hidden', '추천인');
  var pickedMark;
  var crossMark;

  /* 무대B: 실적 반영 구조 */
  var stageB = K.el('div', 'g04-phase is-hidden');
  var chain = K.el('div', 'g04-chain');
  var upper = K.member({ id: 'g04-s04-up', label: '상위', cap: '상위 추천인', kind: 'up' });
  var me = K.member({ id: 'g04-s04-me', label: '나', cap: '나', kind: 'self' });
  var low = K.member({ id: 'g04-s04-low', label: '추천', cap: '추천 회원', kind: 'plain' });
  var tagUp = K.tag(0);
  var tagMe = K.tag(0);
  var tagLow = K.tag(0);
  var sideUp = K.el('div', 'g04-side');
  var sideMe = K.el('div', 'g04-side');
  var sideLow = K.el('div', 'g04-side');
  var prodsMe = K.el('div', 'g04-prods');
  var prodsLow = K.el('div', 'g04-prods');
  var myProds = [K.grow(K.product('auto', { hidden: false, mini: true })), K.grow(K.product('pack', { hidden: false, mini: true }))];
  var lowProds = [K.grow(K.product('auto', { hidden: false, mini: true })), K.grow(K.product('pack', { hidden: false, mini: true }))];
  var link1 = Guide04.cloneTemplate('referral_link_line');
  var link2 = Guide04.cloneTemplate('referral_link_line');
  var linkSlot1 = K.grow(link1 || K.el('div'));
  var linkSlot2 = K.grow(link2 || K.el('div'));
  var denyB = K.overlay('status_cross_icon');
  var tagUpSlot = K.grow(tagUp);
  var tagMeSlot = K.grow(tagMe);
  var tagLowSlot = K.grow(tagLow);
  var i;

  board.id = 'g04-s04-board';

  for(i = 0; i < 3; i++){
    var c = K.member({ id: 'g04-s04-c' + i, label: '회원', kind: 'plain', size: 'sm' });
    if(frameBody) frameBody.appendChild(c.wrap);
    cands.push(c);
  }
  pickedMark = K.mark(cands[1].fig, 'check');
  crossMark = K.mark(cands[2].fig, 'cross');
  cands[1].wrap.appendChild(pickedLabel);

  if(cursorNode) cursorHost.appendChild(cursorNode);

  stageA.appendChild(ghostSlot);
  stageA.appendChild(frameSlot);
  stageA.appendChild(linkSlot);
  stageA.appendChild(newMember.slot);
  stageA.appendChild(stamp);

  linkNode && linkNode.classList.add('is_flow_up');
  link1 && link1.classList.add('is_flow_up');
  link2 && link2.classList.add('is_flow_up');
  me.wrap.classList.add('g04-me');

  prodsMe.appendChild(myProds[0]);
  prodsMe.appendChild(myProds[1]);
  prodsLow.appendChild(lowProds[0]);
  prodsLow.appendChild(lowProds[1]);
  sideUp.appendChild(tagUpSlot);
  sideMe.appendChild(tagMeSlot);
  sideMe.appendChild(prodsMe);
  sideLow.appendChild(tagLowSlot);
  sideLow.appendChild(prodsLow);

  chain.appendChild(upper.slot);
  chain.appendChild(sideUp);
  chain.appendChild(linkSlot1);
  chain.appendChild(K.el('div'));
  chain.appendChild(me.slot);
  chain.appendChild(sideMe);
  chain.appendChild(linkSlot2);
  chain.appendChild(K.el('div'));
  chain.appendChild(low.slot);
  chain.appendChild(sideLow);
  stageB.appendChild(chain);
  stageB.appendChild(denyB);

  board.appendChild(stageA);
  board.appendChild(stageB);
  m.stage.appendChild(badge);
  m.stage.appendChild(board);
  m.stage.appendChild(cursorHost);

  Guide04Scene04Layout.bind({ canvas: canvas, inner: m.inner, stage: m.stage, badge: badge });
  Guide04Scene04Layout.schedule();

  return {
    inner: m.inner, stage: m.stage, badge: badge, board: board,
    stageA: stageA, ghostSlot: ghostSlot, frameSlot: frameSlot, cands: cands, linkSlot: linkSlot, linkNode: linkNode,
    newMember: newMember, stamp: stamp, cursor: cursorHost, pickedMark: pickedMark, crossMark: crossMark, pickedLabel: pickedLabel,
    stageB: stageB, chain: chain, upper: upper, me: me, low: low, tagUp: tagUp, tagMe: tagMe, tagLow: tagLow,
    tagUpSlot: tagUpSlot, tagMeSlot: tagMeSlot, tagLowSlot: tagLowSlot,
    myProds: myProds, lowProds: lowProds, linkSlot1: linkSlot1, linkSlot2: linkSlot2, link1: link1, link2: link2, denyB: denyB
  };
}
</script>
