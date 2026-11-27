<script>
/* guide05 Scene 06 — 매칭보너스 핵심 내용
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide05Scene06Config = {
  id: 'guide05-scene-06',
  title: '매칭보너스 핵심 내용',
  duration: 58000,
  canvasCls: 'g05-scene06-canvas',
  panelCls: 'g04-scene-g05-06',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_06_title.mp4' },
      { part: 'main', file: 'guide05_scene_06.mp4' }
    ],
    fallbackMs: [4440, 51450],
    titleMs: 4440
  },

  panel: {
    title: '매칭보너스 핵심 내용',
    bullets: [
      'Base 사업자 유지 + SP 이상 지위',
      'SP 3P · FC 4P · GC·DC·RF 5P',
      '본인·동급·추월 제외, 하위 수령분 뺀 잔여는 상위 적용',
      '핵심 3가지: 유지 · Base 사업자 창출 · 육성'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 7000, index: 1 },
      { at: 16500, index: 2 },
      { at: 40500, index: 3 }
    ]
  },

  T: {
    badge: 0,
    badgeHold: 1800,
    board: 0,
    header: 200,
    self: 500,
    medal: 1800,
    keep: 3800,
    cards: [7500, 10000, 12500],
    phaseB: 7000,
    phaseC: 16200,
    cSelf: 16700,
    cQual: 17400,
    cRow2: 19400,
    cRow3: 20400,
    cLinks: 21200,
    cCoins: [22000, 22500, 23000],
    cExcl: 24800,
    phaseD: 28200,
    dGc: 28700,
    dSp: 29400,
    dBase: 30100,
    dLinks: 30700,
    dCoins: 31500,
    dToSp: 33000,
    dToGc: 36000,
    dChip: 38800,
    phaseE: 40200,
    slots: [40600, 42500, 46200],
    core: 50000
  },

  layout: { anchorZone: 'd4' }
};
</script>
