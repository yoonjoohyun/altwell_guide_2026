<script>
/* guide04 Scene 01 — 추천보너스란 무엇일까요?
   badge 만 타이틀 음성 시작 기준.
   그 외 시각(T)은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide04Scene01Config = {
  id: 'guide04-scene-01',
  title: '추천보너스란 무엇일까요?',
  duration: 47000,
  canvasCls: 'g04-scene01-canvas',
  panelCls: 'g04-scene01-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_01_title.mp4' },
      { part: 'main', file: 'guide04_scene_01.mp4' }
    ],
    fallbackMs: [2000, 43000],
    titleMs: 2000
  },

  panel: {
    title: '추천보너스란 무엇일까요?',
    bullets: [
      'BASE사업자의 직접 추천 활동을 보상하는 제도',
      '추천 회원의 오토십·스타트팩 이용 시 포인트 발생',
      '지속적인 활동에 대한 권리소득의 성격',
      'BASE사업자 자격을 갖추고 유지해야 수령 가능',
      'BASE 유지 · 신규 추천 · 제품 이용 지원이 기본 구조'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 5000, index: 1 },
      { at: 14000, index: 2 },
      { at: 27000, index: 3 },
      { at: 33000, index: 4 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 300,
    partners: [1000, 1800],
    lines: 2600,
    products: 5000,
    tag: 8700,
    coins: 9000,
    right: 14000,
    more: [14800, 16600, 18400, 20200],
    coinsMore: 21000,
    deny: 22000,
    base: 27000,
    summary: 33000,
    slots: [34000, 37000, 40000],
    glow: 43000
  },

  layout: { anchorZone: 'd4' }
};
</script>
