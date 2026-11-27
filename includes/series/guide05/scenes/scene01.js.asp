<script>
var Guide05Scene01 = guide04DefineScene(
  Guide05Scene01Config,
  setupGuide05Scene01,
  function(tl, assets, ctx){ return runGuide05Scene01(tl, assets, ctx); },
  Guide05Scene01Layout
);

async function runGuide05Scene01(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene01Config;
  var T = C.T;
  var sch = Guide05Scene01Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 매칭 보너스 뱃지(팝업) */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await G05.popBadge(A.badge, sch);

  /* 하위 조직 Base 사업자 성장·유지를 보상 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  for(i = 0; i < 2; i++){
    if(await X(T.partners[i])) return;
    await K.open(A.partners[i].mem.slot, sch);
  }
  if(await X(T.lines)) return;
  K.drawLines(A.tree, A.svg, A.paths, A.self.wrap, [A.partners[0].mem.icon, A.partners[1].mem.icon], true, 1, 0.12);

  /* 패널 정중앙: '조직 성장 보상' 플로팅 → 2초 뒤 사라짐 (다른 연출 타이밍과 무관하게 병행) */
  if(await X(T.grow)) return;
  K.flashOverlay(A.growBadge, 2000, 450);

  /* 장면2: 추천보너스(신규 추천) → 매칭보너스(Base 사업자 육성). 전환 딜레이 최소화 */
  if(await X(T.cmpLeft)) return;
  await K.leave(A.tree, sch);
  K.reveal(A.compare, sch);
  K.reveal(A.paneA, sch);
  /* 본인 멤버 + Base 사업자 뱃지(멤버에 포함) + 헤더 뱃지를 한 번에 */
  await Promise.all([K.open(A.badgeA, sch), K.open(A.meA.slot, sch)]);
  /* 신규 멤버 + 오토십 + 스타트팩 한 번에 */
  if(await X(T.A.link)) return;
  await Promise.all([K.open(A.linkA, sch), K.open(A.newA.slot, sch), K.open(A.prodsA[0], sch), K.open(A.prodsA[1], sch)]);
  /* 추천포인트 1P: Base 사업자 뱃지 하단 */
  if(await X(T.A.coin)) return;
  await K.open(A.tagASlot, sch);
  await K.fly(A.prodsA[1].querySelector('.g04-product') || A.prodsA[1], A.tagA, A.stage, { text: '1P' });
  K.tagSet(A.tagA, 1, true);

  if(await X(T.A.out)) return;
  await K.leave(A.paneA, sch);

  /* 매칭보너스: 본인 아래 신규 멤버가 Base 사업자로 변함 → Base 유지 강조 → 본인 SP 이상 (한 화면에서 통합) */
  K.reveal(A.treeB, sch);
  await Promise.all([K.open(A.headerB, sch), K.open(A.selfB.slot, sch)]);
  if(await X(T.B.kids)) return;
  await Promise.all([K.open(A.kidsB[0].mem.slot, sch), K.open(A.kidsB[1].mem.slot, sch)]);
  K.drawLines(A.treeB, A.svgB, A.pathsB, A.selfB.wrap, [A.kidsB[0].mem.icon, A.kidsB[1].mem.icon], true, 1, 0.12);
  if(await X(T.B.grow)) return;
  /* 신규 회원 → Base 사업자로 성장 (두 멤버 동시에) */
  for(i = 0; i < 2; i++){
    if(i) await wait(900);
    var kb = A.kidsB[i];
    kb.mem.icon.classList.remove('g04-new');
    kb.mem.icon.classList.add('member_base_partner', 'g04-popin');
    var lab = kb.mem.icon.querySelector('.member_face_label');
    if(lab) lab.textContent = '하위';
  }
  await wait(500);
  A.kidsB.forEach(function(k){ k.capSlot.classList.add('g05-ps'); });
  await wait(600);
  for(i = 0; i < 2; i++) A.kidsB[i].mem.icon.classList.remove('g04-popin');
  if(await X(T.B.chip)) return;
  await K.open(A.chipB, sch);

  /* Base 사업자 유지 다시 강조: 본인 + 하위 뱃지 */
  if(await X(T.base)) return;
  var caps = A.treeB.querySelectorAll('.g05-basecap');
  for(i = 0; i < caps.length; i++) caps[i].classList.add('g05-pulse');
  await wait(1900);
  for(i = 0; i < caps.length; i++) caps[i].classList.remove('g05-pulse');

  /* 본인은 SP 이상 지위여야 함 */
  if(await X(T.sp)) return;
  await K.fadeIn(A.spMedal, sch);

  /* 출발점 = Base 사업자 유지 : 하나의 오브젝트, 텍스트만 순차 플로팅 */
  if(await X(T.start[0])) return;
  A.startParts[0].classList.remove('is-pre');
  A.startParts[0].classList.add('g04-popin');
  K.leave(A.chipB, sch).then(function(){ A.chipB.style.visibility = 'hidden'; });
  await K.open(A.startSlot, sch);
  for(i = 1; i < 3; i++){
    if(await X(T.start[i])) return;
    A.startParts[i].classList.remove('is-pre');
    A.startParts[i].classList.add('g04-popin');
    await wait(560);
  }
}
</script>
