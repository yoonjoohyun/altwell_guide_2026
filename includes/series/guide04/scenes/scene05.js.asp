<script>
var Guide04Scene05 = guide04DefineScene(
  Guide04Scene05Config,
  setupGuide04Scene05,
  function(tl, assets, ctx){ return runGuide04Scene05(tl, assets, ctx); },
  Guide04Scene05Layout
);

async function guide04Scene05BaseOnto(A){
  var K = G04Kit;
  var sch = Guide04Scene05Layout.schedule;
  var temp = K.titleBadge('base_business_icon');
  temp.classList.add('g04-base-fly');
  A.stage.appendChild(temp);
  await K.unfold(temp, sch);
  await wait(420);
  await K.foldAway(temp, sch);
  if(temp.parentNode) temp.parentNode.removeChild(temp);
  await K.fadeIn(A.baseDock, sch);
}

/* 큰 패널 전환: 페이드 아웃 → 내용 교체 → 레이아웃 재계산 → 부드럽게 등장 */
async function guide04Scene05Swap(A, mutate){
  var layout = Guide04Scene05Layout;
  A.board.classList.add('g04-s05-out');
  await wait(380);
  mutate();
  layout.flush();
  A.board.classList.remove('g04-s05-out');
  A.board.classList.add('g04-s05-in');
  await wait(520);
  A.board.classList.remove('g04-s05-in');
}

function guide04Scene05Show(node){ if(node) node.classList.remove('is-hidden'); }
function guide04Scene05Hide(node){ if(node) node.classList.add('is-hidden'); }

function guide04Scene05HideLines(A){
  A.paths.forEach(function(p){ p.style.opacity = '0'; });
}

async function runGuide04Scene05(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene05Config;
  var T = C.T;
  var sch = Guide04Scene05Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var batches = [[0], [1, 2], [3, 4, 5], [6, 7, 8]];
  var i;
  var j;

  /* 타이틀 구간: 추천 보너스 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* ① 첫 번째 조건 — 본인 멤버에 Base 사업자 뱃지 + 체크 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  if(await X(T.base)) return;
  await guide04Scene05BaseOnto(A);
  if(await X(T.check)) return;
  await K.fadeIn(A.checkMark, sch);

  /* ② 오토십 회원 = 매월 1P / 스타트팩 회원 = 최초 1회 5P */
  if(await X(T.a)) return;
  await guide04Scene05Swap(A, function(){ guide04Scene05Show(A.stageA); });
  await K.open(A.tagSlot, sch);
  await Promise.all([K.open(A.memA.slot, sch), K.open(A.memB.slot, sch)]);
  guide04Scene05Lines(A);
  if(await X(T.aProd)) return;
  await K.open(A.prodA, sch);
  await K.open(A.noteA, sch);
  for(i = 0; i < A.monthSlots.length; i++){
    if(await X(T.months[i])) return;
    await K.open(A.monthSlots[i], sch);
    await K.fly(A.prodA, A.tag, A.stage, { text: '1P' });
    K.tagSet(A.tag, A.tag.value + 1, true);
  }
  if(await X(T.bProd)) return;
  await K.open(A.prodB, sch);
  await K.open(A.noteB, sch);
  if(await X(T.bCoin)) return;
  await K.fly(A.prodB, A.tag, A.stage, { text: '5P' });
  K.tagSet(A.tag, A.tag.value + 5, true);

  /* ③ 추천 회원이 늘수록 포인트 증가, 상한 없음 */
  if(await X(T.grow)) return;
  await guide04Scene05Swap(A, function(){
    guide04Scene05Hide(A.stageA);
    guide04Scene05HideLines(A);
    K.tagSet(A.tag, 0, false);
    guide04Scene05Show(A.gridWrap);
  });
  var flights = [];
  for(i = 0; i < batches.length; i++){
    if(await X(T.batches[i])) return;
    for(j = 0; j < batches[i].length; j++){
      A.gridMembers[batches[i][j]].wrap.style.opacity = '1';
      flights.push(K.fly(A.gridMembers[batches[i][j]].fig, A.tag, A.stage, { text: '1P' }).then(function(){
        K.tagSet(A.tag, A.tag.value + 1, true);
      }));
      await wait(260);
    }
  }
  await Promise.all(flights);
  if(await X(T.cap)) return;
  K.tagCount(A.tag, 36, 2600);

  /* ④ 1포인트 = 최대 1만원 */
  if(await X(T.cash)) return;
  await guide04Scene05Swap(A, function(){
    guide04Scene05Hide(A.gridWrap);
    K.tagSet(A.tag, 1, false);
  });
  await K.open(A.cashSlot, sch);
  await K.fly(A.tag.tagNode || A.tag, A.cashSlot, A.stage, { text: '1P' });

  /* ⑤ 핵심 3가지 — 좌측 번호 + 구분선으로 한눈에 구분 */
  if(await X(T.three)) return;
  await guide04Scene05Swap(A, function(){
    guide04Scene05Hide(A.tree);
    guide04Scene05Show(A.sum);
  });
  for(i = 0; i < 3; i++){
    if(i > 0 && await X(T.slots[i])) return;
    await K.open(A.sumRows[i], sch);
  }
  if(await X(T.glow)) return;
  A.sum.classList.add('is_glow');
}

function guide04Scene05Lines(A){
  var icons = [A.memA.icon, A.memB.icon];
  A.paths.forEach(function(p){ p.style.opacity = ''; });
  G04Kit.drawLines(A.tree, A.svg, A.paths, A.self.wrap, icons, true, 1, 0.12);
}
</script>
