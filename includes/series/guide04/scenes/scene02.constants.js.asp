<script>
/* guide04 Scene 02 — 오토십 추천보너스
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide04Scene02Config = {
  id: 'guide04-scene-02',
  title: '오토십 추천보너스',
  duration: 52000,
  canvasCls: 'g04-scene02-canvas',
  panelCls: 'g04-scene02-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_02_title.mp4' },
      { part: 'main', file: 'guide04_scene_02.mp4' }
    ],
    fallbackMs: [3000, 47000],
    titleMs: 3000
  },

  panel: {
    title: '오토십 추천보너스',
    bullets: [
      '추천 회원 1명당 매월 1P',
      '기준은 상품 수가 아닌 이용 회원 수 · 1명당 1P (10명 = 10P)',
      '동급·추월·RF 독립 후에도 추천관계 유지',
      '꾸준한 이용을 돕는 지속형 보너스'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 7000, index: 1 },
      { at: 23000, index: 2 },
      { at: 34000, index: 3 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 300,
    partner: 1000,
    line: 1900,
    auto: 2300,
    boxA: 2800,
    check: 3000,
    cal: 3300,
    tag: 3600,
    coin: 4000,
    count: 7000,
    extra: [13000, 13500],
    one: 15500,
    grid: 18000,
    gridCoins: 19600,
    promote: 23000,
    medals: [24000, 27000, 30000],
    months: 34000,
    monthLit: [35200, 37600, 40000],
    cont: 41600
  },

  layout: { anchorZone: 'd4' }
};
</script>
