<script>
var Guide04Scene01 = guide04DefineScene(
  Guide04Scene01Config,
  setupGuide04Scene01,
  function(tl, assets, ctx){ return runGuide04Scene01(tl, assets, ctx); },
  Guide04Scene01Layout
);

function guide04Scene01Lines(A, count, animateFrom){
  var icons = [];
  var i;
  for(i = 0; i < count; i++) icons.push(A.partners[i].mem.icon);
  G04Kit.drawLines(A.tree, A.svg, A.paths, A.self.icon, icons, animateFrom, 0.94, 0.18);
}

async function guide04Scene01Coin(A, p){
  var gain = p.kind === 'pack' ? 5 : 1;
  await G04Kit.fly(p.prodNode, A.tag, A.stage, { text: gain + 'P' });
  G04Kit.tagSet(A.tag, A.tag.value + gain, true);
}

async function guide04Scene01BaseOnto(A){
  var K = G04Kit;
  var sch = Guide04Scene01Layout.schedule;
  var temp = K.titleBadge('base_business_icon');
  temp.classList.add('g04-base-fly');
  A.stage.appendChild(temp);
  await K.unfold(temp, sch);
  await wait(420);
  await K.foldAway(temp, sch);
  if(temp.parentNode) temp.parentNode.removeChild(temp);
  A.self.icon.classList.remove('g04-nobase');
  await K.fadeIn(A.baseDock, sch);
}

async function runGuide04Scene01(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene01Config;
  var T = C.T;
  var sch = Guide04Scene01Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 추천 보너스 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 직접 추천 활동 보상 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  K.fadeIn(A.baseDock, sch);
  for(i = 0; i < 2; i++){
    if(await X(T.partners[i])) return;
    await K.open(A.partners[i].mem.slot, sch);
  }
  if(await X(T.lines)) return;
  guide04Scene01Lines(A, 2, true);

  /* 오토십·스타트팩 이용 → 포인트 */
  if(await X(T.products)) return;
  await Promise.all([K.open(A.partners[0].prod, sch), K.open(A.partners[1].prod, sch)]);
  if(await X(T.coins)) return;
  await K.open(A.tagSlot, sch);
  await guide04Scene01Coin(A, A.partners[0]);
  await guide04Scene01Coin(A, A.partners[1]);

  /* 권리소득 + 추천 회원이 늘어남 */
  if(await X(T.right)) return;
  await K.open(A.chipSlot, sch);
  for(i = 0; i < T.more.length; i++){
    if(await X(T.more[i])) return;
    await Promise.all([K.open(A.partners[i + 2].mem.slot, sch), K.open(A.partners[i + 2].prod, sch)]);
    guide04Scene01Lines(A, i + 3, i + 2);
  }
  if(await X(T.coinsMore)) return;
  for(i = 2; i < 6; i++){
    guide04Scene01Coin(A, A.partners[i]);
    await wait(260);
  }
  await wait(700);

  /* 누구나 받는 것은 아님 — BASE 자격이 없으면 포인트가 닿지 않는다 */
  if(await X(T.deny)) return;
  A.board.classList.add('is-muted');
  A.self.icon.classList.add('g04-nobase');
  K.leave(A.baseDock, sch);
  await K.fly(A.partners[2].prodNode, A.self.icon, A.stage, { text: '1P', bounce: true });
  await K.flashOverlay(A.deny, 900);
  A.board.classList.remove('is-muted');

  /* BASE사업자 자격 유지 */
  if(await X(T.base)) return;
  await guide04Scene01BaseOnto(A);
  guide04Scene01Lines(A, 6, false);
  await guide04Scene01Coin(A, A.partners[0]);

  /* 기본 구조 정리 */
  if(await X(T.summary)) return;
  await K.leave(A.tree, sch);
  await K.reveal(A.sum.host, sch);
  for(i = 0; i < T.slots.length; i++){
    if(await X(T.slots[i])) return;
    await K.fillSlot(A.sum.slots[i], sch);
  }
  if(await X(T.glow)) return;
  A.sum.slots.forEach(function(node){ node.classList.add('is_glow'); });
}
</script>
