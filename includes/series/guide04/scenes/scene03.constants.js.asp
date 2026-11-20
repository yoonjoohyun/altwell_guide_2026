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
      '등록 후 3개월 이내 스타트팩 구매 시 1명당 5포인트',
      '스타트팩 2종을 모두 이용해도 최대 5포인트',
      '구매 개수가 아닌 이용한 신규 추천 회원 수가 기준',
      '초기 제품 이용까지 연결하는 일회성 보상'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 7000, index: 1 },
      { at: 18000, index: 2 },
      { at: 25000, index: 3 }
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
    refpts: 4200,
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
