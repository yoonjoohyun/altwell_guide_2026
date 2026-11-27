<script>
var Guide04Scene04 = guide04DefineScene(
  Guide04Scene04Config,
  setupGuide04Scene04,
  function(tl, assets, ctx){ return runGuide04Scene04(tl, assets, ctx); },
  Guide04Scene04Layout
);

async function guide04Scene04Click(A, target){
  var K = G04Kit;
  var ray = A.cursor.querySelector('.cursor_click_icon');
  await K.cursorTo(A.cursor, A.stage, target, 6, 10);
  if(ray){
    ray.classList.add('g04-pulse');
    await wait(660);
    ray.classList.remove('g04-pulse');
  }
}

async function runGuide04Scene04(tl, A, ctx){
  var K = G04Kit;
  var C = Guide04Scene04Config;
  var T = C.T;
  var sch = Guide04Scene04Layout.schedule;
  var X = function(ms){ return guide04WaitMain(tl, C, ms, ctx); };
  var i;

  /* 타이틀 구간: 추천 보너스 뱃지 */
  await tl.wait(T.badge);
  if(guide04Cancelled(ctx)) return;
  await K.unfold(A.badge, sch);

  /* 무대A — 추천관계가 정확하게 등록되어야 한다 */
  if(await X(T.board)) return;
  await K.foldAway(A.badge, sch);
  await K.reveal(A.board, sch);
  if(await X(T.newMember)) return;
  await K.open(A.newMember.slot, sch);
  if(await X(T.ghost)) return;
  await K.open(A.ghostSlot, sch);

  /* 동일 RF그룹 안에서 추천인 지정 */
  if(await X(T.frame)) return;
  await K.closeSlot(A.ghostSlot, sch);
  await K.open(A.frameSlot, sch);
  if(await X(T.pick)) return;
  showElement(A.cursor);
  A.cursor.style.transform = 'translate(20px,-30px)';
  await guide04Scene04Click(A, A.cands[1].fig);
  A.cands[1].wrap.classList.add('g04-s04-picked');
  A.cands[0].wrap.classList.add('is-dim');
  A.cands[2].wrap.classList.add('is-dim');
  await K.fadeIn(A.pickedLabel, sch);
  if(await X(T.link)) return;
  await K.open(A.linkSlot, sch);

  /* 한 번 등록되면 변경 불가 */
  if(await X(T.retry)) return;
  A.cands[2].wrap.classList.remove('is-dim');
  await guide04Scene04Click(A, A.cands[2].fig);
  if(A.linkNode) A.linkNode.classList.add('g04-shake');
  await K.fadeIn(A.crossMark, sch);
  await wait(300);
  await K.flashOverlay(A.stamp, 1500);
  A.cands[2].wrap.classList.add('is-dim');
  A.cursor.classList.add('is-hidden');

  /* 최초 등록 시 추천인 정보를 정확하게 확인 */
  if(await X(T.confirm)) return;
  A.crossMark.classList.add('is-hidden');
  A.cands[1].fig.classList.add('is-ring');
  await K.fadeIn(A.pickedMark, sch);

  /* 무대B로 전환 */
  if(await X(T.leaveA)) return;
  await K.leave(A.stageA, sch);
  await K.reveal(A.stageB, sch);

  /* 3단 추천 체인 */
  if(await X(T.chainMembers[0])) return;
  await K.open(A.upper.slot, sch);
  K.fadeIn(A.baseUp, sch);
  await K.open(A.tagUpSlot, sch);
  if(await X(T.chainMembers[1])) return;
  await K.open(A.linkSlot1, sch);
  await Promise.all([K.open(A.me.slot, sch), K.open(A.tagMeSlot, sch)]);
  K.fadeIn(A.baseMe, sch);
  if(await X(T.chainMembers[2])) return;
  await K.open(A.linkSlot2, sch);
  await Promise.all([K.open(A.low.slot, sch), K.open(A.tagLowSlot, sch)]);
  K.fadeIn(A.baseLow, sch);

  /* 나의 이용 실적은 내 추천포인트에 포함되지 않는다 */
  if(await X(T.badges)) return;
  await Promise.all([K.open(A.myProds[0], sch), K.open(A.myProds[1], sch)]);
  if(await X(T.bounce)) return;
  await K.fly(A.myProds[0], A.tagMe, A.stage, { text: '1P', bounce: true });
  await K.flashOverlay(A.denyB, 800);

  /* 나의 실적은 상위 추천인에게 */
  if(await X(T.up)) return;
  if(A.link1) A.link1.classList.add('is_flow_up');
  K.fly(A.myProds[0], A.tagUp, A.stage, { text: '1P' });
  await wait(260);
  await K.fly(A.myProds[1], A.tagUp, A.stage, { text: '5P' });
  await K.tagCount(A.tagUp, 6, 500);

  /* 내가 직접 추천한 회원의 실적이 내 포인트로 */
  if(await X(T.down)) return;
  await Promise.all([K.open(A.lowProds[0], sch), K.open(A.lowProds[1], sch)]);
  K.fly(A.lowProds[0], A.tagMe, A.stage, { text: '1P' });
  await wait(260);
  await K.fly(A.lowProds[1], A.tagMe, A.stage, { text: '5P' });
  await K.tagCount(A.tagMe, 6, 500);

  if(await X(T.flow)) return;
  [A.link1, A.link2].forEach(function(l){ if(l) l.classList.add('g04-pulse'); });
}
</script>
