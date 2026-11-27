<script>
/* guide05 Scene 03 — 매칭포인트 산정 기준
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide05Scene03Config = {
  id: 'guide05-scene-03',
  title: '매칭포인트 산정 기준',
  duration: 43500,
  canvasCls: 'g05-scene03-canvas',
  panelCls: 'g04-scene-g05-03',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_03_title.mp4' },
      { part: 'main', file: 'guide05_scene_03.mp4' }
    ],
    fallbackMs: [3970, 37240],
    titleMs: 3970
  },

  panel: {
    title: '매칭포인트 산정 기준',
    bullets: [
      '하위 조직 Base 사업자만 산정 (단순 합산 아님)',
      '본인 Base 사업자 실적은 제외',
      '동급·추월 조직의 Base 사업자도 제외'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 5500, index: 1 },
      { at: 18500, index: 2 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 300,
    lines: [1600, 2300, 3000],
    drawLines: 3700,
    notSum: 800,
    notSumOut: 4800,
    qual: 5500,
    qualChip: 6600,
    only: 14000,
    same: 18500,
    over: 23500,
    summary: 30000
  },

  layout: { anchorZone: 'd4' }
};
</script>
