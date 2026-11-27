<script>
var Guide05Scene03 = guide04DefineScene(
  Guide05Scene03Config,
  setupGuide05Scene03,
  function(tl, assets, ctx){ return runGuide05Scene03(tl, assets, ctx); },
  Guide05Scene03Layout
);

async function runGuide05Scene03(tl, A, ctx){
  var K = G04Kit;
  var C = Guide05Scene03Config;
  var T = C.T;
  var sch = Guide05Scene03Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: '!' 매칭포인트 산정 기준 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.reveal(A.badge, sch);

  /* 조직 트리: 본인(GC) + 하위 3개 라인 */
  if(await X(T.board)) return;
  await K.leave(A.badge, sch);
  await K.reveal(A.board, sch);
  /* 모든 Base 사업자 단순 합산 아님: 다른 연출과 병행해 좌상단에 플로팅, 이후 유지 */
  X(T.notSum).then(function(cancelled){ if(!cancelled) K.open(A.notSum, sch); });
  if(await X(T.self)) return;
  await K.open(A.self.slot, sch);
  await K.fadeIn(A.selfMedal, sch);
  for(i = 0; i < A.lines.length; i++){
    if(await X(T.lines[i])) return;
    await K.open(A.lines[i].top.slot, sch);
    K.fadeIn(A.lines[i].medal, sch);
    await Promise.all(A.lines[i].kids.map(function(k){ return K.open(k.slot, sch); }));
  }
  if(await X(T.drawLines)) return;
  K.drawLines(A.tree, A.svg, A.paths, A.self.wrap, A.lines.map(function(l){ return l.top.icon; }), true, 1, 0.12);

  /* 모든 Base 사업자 단순 합산 아님: 패널 좌상단에 플로팅 후 계속 유지 */
  /* 본인 실적 제외: 붉은 안내 뱃지만 본인 좌측에 */
  if(await X(T.qual)) return;
  await K.open(A.qualSlot, sch);

  /* 하위 조직 Base 사업자만 산정 */
  if(await X(T.only)) return;
  A.lines.forEach(function(l){ l.col.classList.add('g05-hl'); });
  await K.open(A.onlyChip, sch);

  /* 동급(GC) → 추월(DC) 라인은 산정 제외 */
  async function exclude(line, tpl, text){
    G05.setLevel(line.medal, tpl, text);
    line.medal.firstElementChild.classList.add('g04-pulse');
    await wait(900);
    line.col.classList.remove('g05-hl');
    line.col.classList.add('g05-out');
  }
  if(await X(T.same)) return;
  await exclude(A.lines[1], 'lev_gc', 'GC');
  if(await X(T.over)) return;
  await exclude(A.lines[2], 'lev_dc', 'DC');
  /* 2열·3열 사이에 '산정 제외' 스탬프 */
  var l1 = A.lines[1].col;
  var l2 = A.lines[2].col;
  A.cut.style.left = Math.round((l1.offsetLeft + l1.offsetWidth + l2.offsetLeft) / 2) + 'px';
  await K.fadeIn(A.cut, sch);

  /* 남은 동급 미만 라인 요약 */
  if(await X(T.summary)) return;
  await K.open(A.sumChip, sch);
  A.lines[0].col.classList.add('g04-pulse');
}
</script>
