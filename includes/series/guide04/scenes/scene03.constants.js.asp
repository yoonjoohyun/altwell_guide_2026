<script>
/* guide04 Scene 03 — 스타트팩 추천보너스
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide04Scene03Config = {
  id: 'guide04-scene-03',
  title: '스타트팩 추천보너스',
  duration: 43000,
  canvasCls: 'g04-scene03-canvas',
  panelCls: 'g04-scene03-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_03_title.mp4' },
      { part: 'main', file: 'guide04_scene_03.mp4' }
    ],
    fallbackMs: [3000, 38000],
    titleMs: 3000
  },

  panel: {
    title: '스타트팩 추천보너스',
    bullets: [
      '등록 후 3개월 내 스타트팩 구매 시 1명당 5P',
      '2종을 모두 이용해도 1명당 최대 5P (기준은 이용 회원 수)',
      '초기 제품 이용을 연결하는 일회성 보상'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 7000, index: 1 },
      { at: 25000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 300,
    member: 1000,
    line: 1900,
    span: 2300,
    pack: 3300,
    tag: 4700,
    coin: 5000,
    kinds: 7000,
    over: 12000,
    fewer: 18000,
    members: [20000, 21600],
    flow: 25000,
    pulse: 32000,
    once: 33500
  },

  layout: { anchorZone: 'd4' }
};
</script>
