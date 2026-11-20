<script>
/* guide04 Scene 04 — 추천관계와 포인트 산정 기준
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준.
   무대A(등록 규칙) → 전환 → 무대B(실적 반영 구조) */
var Guide04Scene04Config = {
  id: 'guide04-scene-04',
  title: '추천관계와 포인트 산정 기준',
  duration: 45000,
  canvasCls: 'g04-scene04-canvas',
  panelCls: 'g04-scene04-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_04_title.mp4' },
      { part: 'main', file: 'guide04_scene_04.mp4' }
    ],
    fallbackMs: [4000, 39000],
    titleMs: 4000
  },

  panel: {
    title: '추천관계와 포인트 산정 기준',
    bullets: [
      '추천인은 동일 RF그룹 내에서 지정, 등록 후 변경 불가',
      '최초 등록 시 추천인 정보를 정확하게 확인',
      '본인의 이용 실적은 내 추천포인트에 포함되지 않음',
      '내 실적은 상위 추천인에게, 내 포인트는 내가 추천한 회원 기준'
    ],
    flashes: [
      { at: 5000, index: 0 },
      { at: 14000, index: 1 },
      { at: 20000, index: 2 },
      { at: 28000, index: 3 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    newMember: 200,
    ghost: 800,
    frame: 5000,
    pick: 7600,
    link: 8600,
    retry: 10000,
    confirm: 14000,
    leaveA: 19000,
    chain: 20000,
    chainMembers: [20000, 20600, 21200],
    badges: 22000,
    bounce: 24000,
    up: 28000,
    down: 32000,
    flow: 36000
  },

  layout: { anchorZone: 'd4' }
};
</script>
