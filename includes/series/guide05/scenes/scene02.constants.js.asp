<script>
/* guide05 Scene 02 — 지위별 매칭포인트
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide05Scene02Config = {
  id: 'guide05-scene-02',
  title: '지위별 매칭포인트',
  duration: 39000,
  canvasCls: 'g05-scene02-canvas',
  panelCls: 'g04-scene-g05-02',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_02_title.mp4' },
      { part: 'main', file: 'guide05_scene_02.mp4' }
    ],
    fallbackMs: [3600, 33300],
    titleMs: 3600
  },

  panel: {
    title: '지위별 매칭포인트',
    bullets: [
      '본인 지위에 따라 하위 Base 사업자 1명당 포인트 상이',
      'SP 3P · FC 4P · GC·DC·RF 5P',
      '예: FC × 하위 Base 사업자 3명 = 12포인트'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 },
      { at: 18000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    header: 500,
    self: 300,
    empty: 1500,
    label: 2200,
    rates: [6800, 9500, 12000],
    jump: 18000,
    kids: [19000, 19700, 20400],
    lines: 21000,
    note: 21500,
    tag: 22000,
    coins: 22400,
    emphasis: 28000
  },

  layout: { anchorZone: 'd4' }
};
</script>
