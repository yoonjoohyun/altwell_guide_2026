<script>
var Guide05Scene02 = guide04DefineScene(
  Guide05Scene02Config,
  setupGuide05Scene02,
  function(tl, assets, ctx){ return runGuide05Scene02(tl, assets, ctx); },
  Guide05Scene02Layout
);

async function runGuide05Scene02(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene02Config;
  var T = C.T;
  var sch = Guide05Scene02Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;
  var flights = [];

  /* 타이틀 구간: 매칭 보너스 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 본인 지위에 따라 하위 Base 사업자 1명당 포인트가 달라짐 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  if(await X(T.empty)) return;
  await K.fadeIn(A.emptyMedal, sch);
  if(await X(T.label)) return;
  A.mid.classList.remove('is-hidden');
  sch();
  await K.open(A.labelSlot, sch);

  /* 지위별 포인트 3열 */
  for(i = 0; i < T.rates.length; i++){
    if(await X(T.rates[i])) return;
    await K.open(A.rateSlots[i], sch);
  }

  /* 예: FC 이고 하위 Base 사업자 3명 */
  if(await X(T.jump)) return;
  await K.leave(A.mid, sch);
  A.emptyMedal.classList.add('is-hidden');
  await K.fadeIn(A.fcMedal, sch);
  A.fcMedal.firstElementChild.classList.add('g04-pulse');
  for(i = 0; i < T.kids.length; i++){
    if(await X(T.kids[i])) return;
    if(i === 0){ A.kidsWrap.classList.remove('is-hidden'); sch(); }
    await K.open(A.kids[i].slot, sch);
  }
  if(await X(T.lines)) return;
  K.drawLines(A.tree, A.svg, A.paths, A.self.wrap, A.kids.map(function(k){ return k.icon; }), true, 1, 0.12);
  if(await X(T.note)) return;
  await K.open(A.noteSlot, sch);

  /* 4포인트 코인 × 3명 = 12포인트 */
  if(await X(T.tag)) return;
  await K.open(A.tagSlot, sch);
  if(await X(T.coins)) return;
  for(i = 0; i < A.kids.length; i++){
    flights.push(K.fly(A.kids[i].fig, A.tag, A.stage, { text: '4' }).then(function(){
      K.tagSet(A.tag, A.tag.value + 4, true);
    }));
    await wait(700);
  }
  await Promise.all(flights);

  /* 같은 Base 사업자 수라도 지위에 따라 포인트가 다름 */
  if(await X(T.emphasis)) return;
  await K.open(A.emphSlot, sch);
  A.emphSlot.firstElementChild.firstElementChild.classList.add('g04-pulse');
}
</script>
