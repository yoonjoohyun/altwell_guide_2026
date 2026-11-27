<script>
var Guide05Scene05 = guide04DefineScene(
  Guide05Scene05Config,
  setupGuide05Scene05,
  function(tl, assets, ctx){ return runGuide05Scene05(tl, assets, ctx); },
  Guide05Scene05Layout
);

async function runGuide05Scene05(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene05Config;
  var T = C.T;
  var sch = Guide05Scene05Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;
  var F = A.fl;

  function show(node){ node.classList.add('g05-ps'); }
  function hide(node){ node.classList.remove('g05-ps'); }
  function link(n, a, b){ K.drawLine(A.tree, A.svg, A.paths, n, a.mem.icon, b.mem.icon, 1, 0.12, true); }
  function toNew(o){
    o.mem.icon.classList.remove('g04-nobase');
    o.mem.icon.classList.add('g04-new', 'g04-popin');
  }
  function toBase(o){
    o.mem.icon.classList.remove('g04-new');
    o.mem.icon.classList.add('member_base_partner', 'g04-popin');
  }
  function clearPop(list){
    list.forEach(function(o){ (o.mem ? o.mem : o).icon.classList.remove('g04-popin'); });
  }
  /* 큰 에셋이 플로팅된 뒤 접혀서 멤버 우하단에 겹쳐 붙는다 */
  async function dock(p){
    var cl = p.closest('.g05-s05-cell');
    if(cl) cl.style.zIndex = '9';
    p.classList.add('is-in');
    await wait(700);
    p.classList.add('is-fold', 'is-docked');
    await wait(550);
    if(cl) cl.style.zIndex = '';
  }
  /* 두 뱃지가 한 번에 플로팅되고 한 번에 접혀 붙는다 */
  async function dockPair(pp){
    await Promise.all([dock(pp.auto), dock(pp.pack)]);
  }
  /* Base 사업자 자격 획득 -> 본인에게 포인트 */
  function earnP(o){
    K.fly(o.mem.icon, A.self.mem.icon, A.stage, { text: 'P' });
  }

  /* 타이틀 구간: 3인 구조 하나씩 플로팅 (신규 회원은 일반인으로) */
  await tl.wait(0);
  if(guide04Cancelled(ctx)) return;
  await K.reveal(A.board, sch);
  await tl.wait(T.self);
  if(guide04Cancelled(ctx)) return;
  show(A.self.mem.wrap);
  for(i = 0; i < 2; i++){
    await tl.wait(T.kids[i]);
    if(guide04Cancelled(ctx)) return;
    if(i === 0) A.tree.classList.add('is-two');
    show(A.n[i].mem.wrap);
  }

  /* 추천보너스: 일반인 -> 신규 회원, 오토십/스타트팩 이용 */
  if(await X(T.links)) return;
  link(0, A.self, A.n[0]); link(1, A.self, A.n[1]);
  for(i = 0; i < 2; i++){
    if(await X(T.toNew[i])) return;
    toNew(A.n[i]);
  }
  for(i = 0; i < 2; i++){
    if(await X(T.prodN[i])) return;
    await dockPair(A.pn[i]);
  }
  clearPop(A.n);
  for(i = 0; i < 2; i++){
    if(await X(T.fly[i])) return;
    await K.fly(A.pn[i].auto, A.self.mem.icon, A.stage, { text: 'P' });
    if(i === 0) show(A.recB);
  }
  A.recB.classList.add('g04-pulse');

  /* 매칭보너스: 추천보너스 에셋이 사라지고 같은 자리에 매칭보너스 */
  if(await X(T.match)) return;
  A.recB.classList.remove('g04-pulse');
  hide(A.recB);
  await wait(300);
  show(A.matchB);

  /* 2단 하위 4명 등장 -> 신규 -> 오토십/스타트팩 이용 */
  if(await X(T.expand3)) return;
  A.tree.classList.add('is-two', 'is-three');
  for(i = 0; i < 4; i++){
    if(await X(T.mFloat[i])) return;
    show(A.m[i].mem.wrap);
  }
  if(await X(T.linksM)) return;
  link(2, A.n[0], A.m[0]); link(3, A.n[0], A.m[1]); link(4, A.n[1], A.m[2]); link(5, A.n[1], A.m[3]);
  if(await X(T.toNewM)) return;
  A.m.forEach(toNew);
  for(i = 0; i < 2; i++){
    if(await X(T.prodM[i])) return;
    await Promise.all([dockPair(A.pm[i]), dockPair(A.pm[i + 2])]);
  }
  clearPop(A.m);

  /* 1단 하위 2명 Base 사업자 자격 획득 */
  for(i = 0; i < 2; i++){
    if(await X(T.growN[i])) return;
    toBase(A.n[i]);
    earnP(A.n[i]);
  }
  if(await X(T.capsN)) return;
  A.n.forEach(function(o){ show(o.cap); });
  await wait(600);
  clearPop(A.n);

  /* 3단 하위 8명: Base 사업자 파트너 색상, 오토십/스타트팩 뱃지 부착 상태로 등장 */
  if(await X(T.expand4)) return;
  A.tree.classList.add('is-full');
  for(i = 0; i < 8; i++){
    if(await X(T.kFloat[i])) return;
    show(A.k[i].mem.wrap);
  }
  if(await X(T.linksK)) return;
  for(i = 0; i < 8; i++) link(6 + i, A.m[i >> 1], A.k[i]);

  /* 2단 하위 4명 Base 사업자 자격 획득 */
  if(await X(T.growM)) return;
  for(i = 0; i < 4; i++){
    toBase(A.m[i]);
    earnP(A.m[i]);
    await wait(700);
  }
  if(await X(T.capsM)) return;
  A.m.forEach(function(o){ show(o.cap); });
  await wait(600);
  clearPop(A.m);

  /* 4단계 흐름 */
  if(await X(T.phaseOut)) return;
  await K.leave(A.phaseA, sch);
  A.phaseA.classList.add('is-hidden');
  function sw(mem, from, to){
    if(from) mem.icon.classList.remove(from);
    mem.icon.classList.add(to, 'g04-popin');
  }
  for(i = 0; i < A.flow.slots.length; i++){
    if(await X(T.flow[i])) return;
    await K.reveal(A.flow.slots[i], sch);
    await K.fillSlot(A.flow.slots[i], sch);
    if(i === 0){
      await wait(500);
      sw(F.m1, 'g04-nobase', 'g04-new');
      F.m1.icon.querySelector('.member_face_label').textContent = '신규';
    } else if(i === 1){
      show(F.auto);
      await wait(700);
      show(F.pack);
    } else if(i === 2){
      await wait(400);
      sw(F.m3, 'g04-new', 'member_base_self');
      F.m3.icon.querySelector('.member_face_label').textContent = '';
      await wait(500);
      show(F.m3cap);
    } else {
      await wait(500);
      show(F.row4);
      await wait(900);
      for(var k = 0; k < 2; k++){
        if(k) await wait(700);
        sw(F.m4[k], 'g04-new', 'member_base_partner');
        F.m4[k].icon.querySelector('.member_face_label').textContent = '';
      }
      await wait(400);
      show(F.m4cap[0]);
      show(F.m4cap[1]);
    }
  }

  /* 확대의 핵심 */
  if(await X(T.key)) return;
  await K.open(A.keyChip, sch);
}
</script>
