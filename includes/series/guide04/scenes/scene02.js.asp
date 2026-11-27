<script>
var Guide04Scene02 = guide04DefineScene(
  Guide04Scene02Config,
  setupGuide04Scene02,
  function(tl, assets, ctx){ return runGuide04Scene02(tl, assets, ctx); },
  Guide04Scene02Layout
);

async function guide04Scene02Medal(A, index){
  var K = G04Kit;
  var sch = Guide04Scene02Layout.schedule;
  var i;
  for(i = 0; i < A.medals.length; i++){
    if(i !== index) A.medals[i].classList.add('is-hidden');
  }
  A.promoChip.textContent = A.medals[index].getAttribute('data-label');
  A.gridMembers[0].fig.classList.add('is-ring');
  await K.fadeIn(A.medals[index], sch);
  await K.fly(A.gridMembers[0].fig, A.tag, A.stage, { text: '1P' });
  K.tagSet(A.tag, A.tag.value, true);
}

async function runGuide04Scene02(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene02Config;
  var T = C.T;
  var sch = Guide04Scene02Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 오토십 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 오토십을 유지하는 추천 회원 1명 = 매월 1포인트 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  if(await X(T.partner)) return;
  await K.open(A.partner.slot, sch);
  if(await X(T.line)) return;
  K.drawLines(A.tree, A.svg, A.paths, A.self.wrap, [A.partner.icon], true, 1, 0.12);
  if(await X(T.auto)) return;
  await K.open(A.autos[0], sch);
  if(await X(T.boxA)) return;
  await K.open(A.boxes[0], sch);
  if(await X(T.check)) return;
  await K.fadeIn(A.checkMark, sch);
  if(await X(T.cal)) return;
  await K.open(A.calSlot, sch);
  if(await X(T.tag)) return;
  await K.open(A.tagSlot, sch);
  if(await X(T.coin)) return;
  await K.fly(A.autos[0], A.tag, A.stage, { text: '1P' });
  K.tagSet(A.tag, 1, true);

  /* 상품 개수가 아닌 회원 수 */
  if(await X(T.count)) return;
  A.partner.fig.classList.add('is-ring');
  await K.open(A.infoSlot, sch);

  /* 한 명이 여러 상품을 이용해도 1P */
  for(i = 0; i < T.extra.length; i++){
    if(await X(T.extra[i])) return;
    await K.open(A.boxes[i + 1], sch);
  }
  if(await X(T.one)) return;
  await K.open(A.oneSlot, sch);
  await K.fly(A.autos[0], A.tag, A.stage, { text: '1P' });
  K.tagSet(A.tag, 1, true);

  /* 10명이면 10포인트 */
  if(await X(T.grid)) return;
  A.partner.fig.classList.remove('is-ring');
  await K.leave(A.single, sch);
  await K.reveal(A.gridWrap, sch);
  K.drawLines(A.tree, A.svg, A.paths, A.self.wrap, [A.gridWrap], true, 1, 0);
  for(i = 0; i < A.gridMembers.length; i++){
    A.gridMembers[i].wrap.style.opacity = '1';
    await wait(110);
  }
  if(await X(T.gridCoins)) return;
  var flights = [];
  for(i = 0; i < A.gridMembers.length; i++){
    flights.push(K.fly(A.gridMembers[i].fig, A.tag, A.stage, { text: '1P' }).then(function(){
      K.tagSet(A.tag, A.tag.value + 1, true);
    }));
    await wait(200);
  }
  await Promise.all(flights);
  K.tagSet(A.tag, 10, false);

  /* 동급·추월·RF 독립해도 추천관계 유지 */
  if(await X(T.promote)) return;
  await K.open(A.promoSlot, sch);
  A.paths[1].classList.add('is-solid');
  K.drawLine(A.tree, A.svg, A.paths, 1, A.self.wrap, A.gridMembers[0].icon, 1, 0.12, true);
  for(i = 0; i < T.medals.length; i++){
    if(await X(T.medals[i])) return;
    await guide04Scene02Medal(A, i);
  }

  /* 매월 반복되는 지속형 보너스 */
  if(await X(T.months)) return;
  await K.leave(A.tree, sch);
  await K.reveal(A.bphase, sch);
  await K.open(A.bphase.querySelector('.g04-grow:nth-child(2)'), sch);
  for(i = 0; i < T.monthLit.length; i++){
    if(await X(T.monthLit[i])) return;
    A.monthCards[i].classList.add('is-lit');
    await K.fly(A.monthCards[i], A.tagB.tagNode, A.stage, { text: '10P' });
    K.tagSet(A.tagB, 10 * (i + 1), true);
  }
  if(await X(T.cont)) return;
  await K.open(A.contSlot, sch);
}
</script>
