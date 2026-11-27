<script>
/* guide05 Scene 01 — 매칭보너스란 무엇인가요?
   badge 만 타이틀 음성 시작 기준.
   그 외 시각(T)은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide05Scene01Config = {
  id: 'guide05-scene-01',
  title: '매칭보너스란 무엇인가요?',
  duration: 37000,
  canvasCls: 'g05-scene01-canvas',
  panelCls: 'g04-scene-g05-01',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_01_title.mp4' },
      { part: 'main', file: 'guide05_scene_01.mp4' }
    ],
    fallbackMs: [2500, 32600],
    titleMs: 2500
  },

  panel: {
    title: '매칭보너스란 무엇인가요?',
    bullets: [
      'Base 사업자 육성을 보상하는 제도',
      '추천보너스의 다음 단계',
      '조건: Base 사업자 유지 + SP 이상 지위'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 8000, index: 1 },
      { at: 20000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 300,
    partners: [2000, 2900],
    lines: 3800,
    grow: 5200,
    cmpLeft: 7700,
    A: { link: 9000, coin: 10200, out: 11600 },
    B: { head: 12300, kids: 13300, grow: 15600, chip: 19000 },
    base: 21200,
    sp: 24500,
    start: [28000, 28800, 29500]
  },

  layout: { anchorZone: 'd4' }
};
</script>
