<script>
var Guide04Scene05 = guide04DefineScene(
  Guide04Scene05Config,
  setupGuide04Scene05,
  function(tl, assets, ctx){ return runGuide04Scene05(tl, assets, ctx); },
  Guide04Scene05Layout
);

async function runGuide04Scene05(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene05Config;
  var T = C.T;
  var sch = Guide04Scene05Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var batches = [[0], [1, 2], [3, 4, 5], [6, 7, 8]];
  var counts = [1, 3, 6, 9];
  var i;
  var j;

  /* 타이틀 구간: 추천 보너스 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* ① 첫 번째 조건 — BASE사업자 자격 유지 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.base)) return;
  await K.unfold(A.baseWrap, sch);
  if(await X(T.check)) return;
  await K.fadeIn(A.checkWrap, sch);

  /* ② 포인트 발생 기준 */
  if(await X(T.cards[0])) return;
  await K.leave(A.p1, sch);
  await K.reveal(A.p2, sch);
  await K.reveal(A.cardA, sch);
  if(await X(T.cards[1])) return;
  await K.reveal(A.cardB, sch);

  /* ③ 추천 회원이 늘수록 포인트 증가, 상한 없음 */
  if(await X(T.grow)) return;
  await K.leave(A.p2, sch);
  await K.reveal(A.p3, sch);
  await K.open(A.self.slot, sch);
  await K.open(A.tagSlot, sch);
  for(i = 0; i < batches.length; i++){
    if(await X(T.batches[i])) return;
    for(j = 0; j < batches[i].length; j++){
      A.gridMembers[batches[i][j]].wrap.style.opacity = '1';
      K.fly(A.gridMembers[batches[i][j]].fig, A.tag, A.stage, { text: '1P' });
      await wait(120);
    }
    await K.tagCount(A.tag, counts[i], 600);
  }
  if(await X(T.cap)) return;
  await K.open(A.capSlot, sch);

  /* ④ 1포인트 = 최대 1만원 */
  if(await X(T.cash)) return;
  await K.leave(A.p3, sch);
  await K.reveal(A.p4, sch);

  /* ⑤ 핵심 3가지 */
  if(await X(T.three)) return;
  await K.leave(A.p4, sch);
  await K.reveal(A.three.host, sch);
  for(i = 0; i < T.slots.length; i++){
    if(await X(T.slots[i])) return;
    await K.fillSlot(A.three.slots[i], sch);
  }
  if(await X(T.glow)) return;
  A.three.slots.forEach(function(node){ node.classList.add('is_glow'); });
}
</script>
