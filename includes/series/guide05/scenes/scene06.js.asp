<script>
var Guide05Scene06 = guide04DefineScene(
  Guide05Scene06Config,
  setupGuide05Scene06,
  function(tl, assets, ctx){ return runGuide05Scene06(tl, assets, ctx); },
  Guide05Scene06Layout
);

async function runGuide05Scene06(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene06Config;
  var T = C.T;
  var sch = Guide05Scene06Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 매칭 보너스 뱃지 → 2초 뒤 접힘 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);
  await wait(T.badgeHold);
  if(guide04Cancelled(ctx)) return;
  await K.foldAway(A.badge, sch);

  /* A: Base 사업자 유지 + SP 이상 */
  if(await X(T.board)) return;
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  if(await X(T.medal)) return;
  await K.fadeIn(A.selfMedal, sch);
  if(await X(T.keep)) return;
  await K.open(A.keepChip, sch);

  /* B: 지위별 포인트 3열 */
  if(await X(T.phaseB)) return;
  await K.leave(A.phaseA, sch);
  A.phaseA.classList.add('is-hidden');
  K.reveal(A.phaseB, sch);
  for(i = 0; i < 3; i++){
    if(await X(T.cards[i])) return;
    await K.open(A.rateSlots[i], sch);
  }

  function show(node){ node.classList.add('g05-ps'); }
  function link(host, svg, paths, n, a, b){ K.drawLine(host, svg, paths, n, a.icon, b.icon, 1, 0.12, true); }

  /* C: 피라미드 — 제외 대상 */
  if(await X(T.phaseC)) return;
  await K.leave(A.phaseB, sch);
  A.phaseB.classList.add('is-hidden');
  K.reveal(A.phaseC, sch);
  if(await X(T.cSelf)) return;
  show(A.cSelf.wrap);
  if(await X(T.cQual)) return;
  A.cSelf.wrap.classList.add('g05-qual');
  show(A.cQualChip);
  if(await X(T.cRow2)) return;
  A.cSelf.wrap.classList.remove('g05-qual');
  A.cTree.classList.add('is-two');
  show(A.cL1.wrap); show(A.cR1.wrap);
  await wait(500);
  link(A.cTree, A.cSvg, A.cPaths, 0, A.cSelf, A.cL1);
  link(A.cTree, A.cSvg, A.cPaths, 1, A.cSelf, A.cR1);
  if(await X(T.cRow3)) return;
  A.cTree.classList.add('is-three');
  A.cK.forEach(function(o){ show(o.wrap); });
  await wait(600);
  if(await X(T.cLinks)) return;
  link(A.cTree, A.cSvg, A.cPaths, 2, A.cL1, A.cK[0]);
  link(A.cTree, A.cSvg, A.cPaths, 3, A.cL1, A.cK[1]);
  link(A.cTree, A.cSvg, A.cPaths, 4, A.cR1, A.cK[2]);
  link(A.cTree, A.cSvg, A.cPaths, 5, A.cR1, A.cK[3]);
  show(A.cLblL); show(A.cLblR);
  /* 정상 라인(동급 미만): 하위 Base 사업자 1명당 3포인트가 본인에게 */
  show(A.cTagW);
  var cSrc = [A.cL1, A.cK[0], A.cK[1]];
  for(i = 0; i < 3; i++){
    if(await X(T.cCoins[i])) return;
    K.fly(cSrc[i].icon, A.cSelf.icon, A.stage, { text: 'P' }).then((function(n){ return function(){ K.tagSet(A.cTag, 3 * (n + 1), true); }; })(i));
  }
  /* 동급·추월 라인은 산정 제외: 흐리게 + 스탬프 */
  if(await X(T.cExcl)) return;
  [A.cR1, A.cK[2], A.cK[3]].forEach(function(o){ o.wrap.classList.add('g05-dim'); });
  [1, 4, 5].forEach(function(n){ A.cPaths[n].style.opacity = '.25'; });
  await K.fadeIn(A.cStamp, sch);

  /* D: 세로 구조 — 발생 포인트에서 하위 수령분을 빼고 남은 포인트가 본인에게 */
  if(await X(T.phaseD)) return;
  await K.leave(A.phaseC, sch);
  A.phaseC.classList.add('is-hidden');
  K.reveal(A.phaseD, sch);
  if(await X(T.dGc)) return;
  show(A.dGc.wrap);
  if(await X(T.dSp)) return;
  A.dTree.classList.add('is-two');
  show(A.dSp.wrap);
  if(await X(T.dBase)) return;
  A.dTree.classList.add('is-three');
  show(A.dBase.wrap);
  await wait(600);
  if(await X(T.dLinks)) return;
  link(A.dTree, A.dSvg, A.dPaths, 0, A.dGc, A.dSp);
  link(A.dTree, A.dSvg, A.dPaths, 1, A.dSp, A.dBase);
  if(await X(T.dCoins)) return;
  show(A.coinRow);
  function used(c){ c.classList.add('is-used'); }
  /* 발생 5포인트 중 SP 수령분 3포인트 */
  if(await X(T.dToSp)) return;
  show(A.tagSpW);
  await wait(400);
  await Promise.all([0, 1, 2].map(function(n){
    return wait(n * 150).then(function(){
      var c = A.coins[n];
      var p = K.fly(c, A.tagSp.tagNode, A.stage, { text: 'P' });
      used(c);
      return p;
    });
  }));
  K.tagSet(A.tagSp, 3, true);
  /* 남은 2포인트는 본인(GC)에게 */
  if(await X(T.dToGc)) return;
  show(A.tagGcW);
  A.coins[3].classList.add('g04-pulse'); A.coins[4].classList.add('g04-pulse');
  await wait(500);
  await Promise.all([3, 4].map(function(n){
    return wait((n - 3) * 150).then(function(){
      var c = A.coins[n];
      c.classList.remove('g04-pulse');
      var p = K.fly(c, A.tagGc.tagNode, A.stage, { text: 'P' });
      used(c);
      return p;
    });
  }));
  K.tagSet(A.tagGc, 2, true);
  if(await X(T.dChip)) return;
  await K.open(A.dChip, sch);

  /* E: 핵심 3가지 — 카드 */
  if(await X(T.phaseE)) return;
  await K.leave(A.phaseD, sch);
  A.phaseD.classList.add('is-hidden');
  K.reveal(A.core.host, sch);
  var F = A.fl;
  function sw(mem, from, to){
    if(from) mem.icon.classList.remove(from);
    mem.icon.classList.add(to, 'g04-popin');
  }
  for(i = 0; i < 3; i++){
    if(await X(T.slots[i])) return;
    await K.reveal(A.core.slots[i], sch);
    await K.fillSlot(A.core.slots[i], sch);
    if(i === 0){
      await wait(300);
      show(F.m1cap);
      F.m1.icon.classList.add('g04-pulse');
    } else if(i === 1){
      await wait(200);
      sw(F.m2, 'g04-nobase', 'g04-new');
      F.m2.icon.querySelector('.member_face_label').textContent = '신규';
      await wait(300);
      /* 오토십·스타트팩: 한 번에 플로팅 후 접혀서 멤버에 붙는다 */
      F.auto.classList.add('is-in'); F.pack.classList.add('is-in');
      await wait(700);
      F.auto.classList.add('is-fold', 'is-docked'); F.pack.classList.add('is-fold', 'is-docked');
      await wait(550);
      sw(F.m2, 'g04-new', 'member_base_partner');
      F.m2.icon.querySelector('.member_face_label').textContent = '';
      await wait(250);
      show(F.m2cap);
    } else {
      await wait(400);
      show(F.row3);
      await wait(800);
      for(var k = 0; k < 2; k++){
        sw(F.m3[k], 'g04-new', 'member_base_partner');
        F.m3[k].icon.querySelector('.member_face_label').textContent = '';
        if(k === 0) await wait(500);
      }
      await wait(300);
      show(F.m3cap[0]); show(F.m3cap[1]);
    }
  }
  if(await X(T.core)) return;
  await K.open(A.coreChip, sch);
}
</script>
