<script>
var Guide05Scene04 = guide04DefineScene(
  Guide05Scene04Config,
  setupGuide05Scene04,
  function(tl, assets, ctx){ return runGuide05Scene04(tl, assets, ctx); },
  Guide05Scene04Layout
);

async function runGuide05Scene04(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene04Config;
  var T = C.T;
  var sch = Guide05Scene04Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;
  var order = [A.base, A.sp, A.gc];
  /* 코인은 복제 없이 그대로 이동: 출발 즉시 원본을 숨기고 이동 코인만 보이게 한다 */
  function moveCoin(coin, target, text){
    var p = K.fly(coin, target, A.stage, { text: text });
    setTimeout(function(){ coin.style.visibility = 'hidden'; }, 120);
    return p;
  }
  var fillers = [A.fillers[0], A.fillers[1], A.partner, A.fillers[2]];

  /* 타이틀 구간 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 하위 Base 사업자 1명당 최대 5포인트 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.header)) return;
  await K.reveal(A.topBadge, sch);
  if(await X(T.max)) return;
  await K.open(A.maxSlot, sch);
  /* Base 사업자 멤버에서 5포인트 생성 */
  if(await X(T.fill)) return;
  await K.open(A.base.slot, sch);
  await wait(300);
  A.coin5.classList.add('g05-ps');
  A.base.icon.classList.add('g04-pulse');
  await wait(700);
  A.base.icon.classList.remove('g04-pulse');

  /* 실제 수령분은 본인 지위에 따라 */
  if(await X(T.label)) return;
  await K.open(A.labelSlot, sch);

  /* 하위 → 상위 스택 */
  /* 피라미드: 일반 회원·파트너 회원을 먼저, 이어서 Base 사업자 1명 → SP → GC */
  if(await X(T.fillers)) return;
  await Promise.all(fillers.map(function(f){ return K.open(f.slot, sch); }));
  for(i = 1; i < 3; i++){
    if(await X(T.stack[i])) return;
    await K.open(order[i].slot, sch);
  }
  await Promise.all([K.fadeIn(A.spMedal, sch), K.fadeIn(A.gcMedal, sch)]);
  if(await X(T.links)) return;
  A.svg.style.zIndex = '0';
  [[A.gc, A.partner], [A.gc, A.sp], [A.partner, A.fillers[0]], [A.partner, A.fillers[1]], [A.sp, A.base], [A.sp, A.fillers[2]]].forEach(function(l, n){
    K.drawLine(A.rows, A.svg, A.paths, n, l[0].icon, l[1].icon, 1, 0.12, true);
  });

  /* 5P 가 SP 사업자에게 가서 3P(SP 수령) + 2P(잔여)로 나뉜다 */
  if(await X(T.sp)) return;
  await moveCoin(A.coin5, A.sp.fig, '5P');
  A.coin3.classList.add('g05-ps');
  A.coin2.classList.add('g05-ps');
  await wait(700);
  await K.open(A.tagSpSlot, sch);
  await moveCoin(A.coin3, A.tagSp, '3P');
  K.tagSet(A.tagSp, 3, true);

  /* 남은 2포인트: 소멸 없이 상위로 */
  if(await X(T.remain)) return;
  A.coin2.classList.add('g04-pulse');
  await K.open(A.remainSlot, sch);

  /* GC: 한도 5포인트 → 나머지 2포인트 */
  if(await X(T.gcHi)) return;
  A.gc.icon.classList.add('g04-pulse');
  if(await X(T.gc)) return;
  A.coin2.classList.remove('g04-pulse');
  await K.open(A.tagGcSlot, sch);
  await moveCoin(A.coin2, A.tagGc, '2P');
  K.tagSet(A.tagGc, 2, true);

  /* GC 는 SP 본인분(1명당 최대 5포인트)도 받아 합계 7포인트 */
  if(await X(T.gcSelf)) return;
  A.sp.icon.classList.add('g04-pulse');
  await K.fly(A.sp.fig, A.tagGc, A.stage, { text: '5' });
  K.tagSet(A.tagGc, 7, true);
  A.sp.icon.classList.remove('g04-pulse');

  /* 요약 */
  if(await X(T.sum)) return;
  /* 이전 오브젝트는 보드째 한 번에 스르륵 사라진다 */
  await K.leave(A.board, sch);
  [A.topBadge, A.maxSlot, A.body, A.labelSlot, A.remainSlot].forEach(function(n){ n.style.display = 'none'; });
  A.board.classList.add('g05-s04-bare');
  sch();
  await Promise.all([K.reveal(A.board, sch), K.reveal(A.sum, sch)]);
  await K.open(A.sumA, sch);
  if(await X(T.sumGc)) return;
  await K.open(A.sumB, sch);
}
</script>
