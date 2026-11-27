<script>
var Guide04Scene03 = guide04DefineScene(
  Guide04Scene03Config,
  setupGuide04Scene03,
  function(tl, assets, ctx){ return runGuide04Scene03(tl, assets, ctx); },
  Guide04Scene03Layout
);

function guide04Scene03Lines(A, count, animateFrom){
  var icons = [];
  var i;
  for(i = 0; i < count; i++) icons.push(A.members[i].mem.icon);
  G04Kit.drawLines(A.tree, A.svg, A.paths, A.self.wrap, icons, animateFrom, 1, 0.12);
}

async function guide04Scene03Coin(A, index){
  await G04Kit.fly(A.members[index].prodNode, A.tag, A.stage, { text: '5P' });
  G04Kit.tagSet(A.tag, A.tag.value + 5, true);
}

async function runGuide04Scene03(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene03Config;
  var T = C.T;
  var sch = Guide04Scene03Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 스타트팩 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 등록 후 3개월 이내 스타트팩 → 5포인트 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  if(await X(T.member)) return;
  await K.open(A.members[0].mem.slot, sch);
  if(await X(T.line)) return;
  guide04Scene03Lines(A, 1, true);
  if(await X(T.span)) return;
  await K.open(A.calSlot, sch);
  if(await X(T.pack)) return;
  await K.open(A.members[0].prod, sch);
  guide04Scene03Lines(A, 1, false);
  if(await X(T.tag)) return;
  await K.open(A.tagSlot, sch);
  if(await X(T.coin)) return;
  await guide04Scene03Coin(A, 0);

  /* 스타트팩 2종을 모두 이용해도 최대 5포인트 */
  if(await X(T.kinds)) return;
  await K.open(A.kindsSlot, sch);
  await wait(500);
  for(i = 0; i < A.kindCards.length; i++){
    A.kindCards[i].classList.remove('is-pre');
    A.kindCards[i].classList.add('g04-popin-soft');
    await wait(900);
  }
  A.maxChip.style.width = A.kinds.offsetWidth + 'px';
  if(await X(T.over)) return;
  await K.tagCount(A.tag, 10, 700);
  await wait(2500);
  await K.flashOverlay(A.deny, 2500, 620);
  K.tagSet(A.tag, 5, true);
  A.members[0].col.classList.add('is-note-gone');
  A.maxSlot.style.visibility = 'visible';
  await Promise.all([K.closeSlot(A.calSlot, sch), K.open(A.maxSlot, sch)]);

  /* 개수가 아닌 신규 추천 회원 수 */
  if(await X(T.fewer)) return;
  A.kindCards.forEach(function(card){ card.classList.add('is-dim'); });
  await wait(900);
  await K.closeSlot(A.kindsSlot, sch);
  for(i = 0; i < T.members.length; i++){
    if(await X(T.members[i])) return;
    await Promise.all([K.open(A.members[i + 1].mem.slot, sch), K.open(A.members[i + 1].prod, sch)]);
    guide04Scene03Lines(A, i + 2, i + 1);
    await guide04Scene03Coin(A, i + 1);
  }

  /* 제품·비즈니스 안내 → 초기 제품 이용 연결 */
  if(await X(T.flow)) return;
  await K.open(A.flowSlot, sch);
  if(await X(T.pulse)) return;
  var arrows = A.flowNode ? A.flowNode.querySelectorAll('.business_flow_arrow') : [];
  for(i = 0; i < arrows.length; i++) arrows[i].classList.add('is-pulse');
  if(await X(T.once)) return;
  for(i = 0; i < A.onceSlots.length; i++){
    await K.open(A.onceSlots[i], sch);
    await wait(450);
  }
}
</script>
