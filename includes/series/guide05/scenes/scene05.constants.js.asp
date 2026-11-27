<script>
/* guide05 Scene 05 — 왜 Base 사업자를 육성하는 것이 중요할까요?
   badge 만 타이틀 음성 시작 기준. 그 외 시각(T)은 본문 음성 시작 기준. */
var Guide05Scene05Config = {
  id: 'guide05-scene-05',
  title: '왜 Base 사업자를 육성할까요?',
  duration: 49500,
  canvasCls: 'g05-scene05-canvas',
  panelCls: 'g04-scene-g05-05',

  media: {
    sequence: [
      { part: 'title', file: 'guide05_scene_05_title.mp4' },
      { part: 'main', file: 'guide05_scene_05.mp4' }
    ],
    fallbackMs: [3470, 44180],
    titleMs: 3470
  },

  panel: {
    title: '왜 Base 사업자를 육성할까요?',
    bullets: [
      '추천·매칭 보너스 모두 Base 사업자와 연결',
      '추천=제품 이용 / 매칭=Base 사업자 성장·유지',
      '등록→이용→Base 사업자→육성이 확대의 핵심'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 11500, index: 1 },
      { at: 31000, index: 2 }
    ]
  },

  T: {
    /* 타이틀 구간(씬 시작 기준) */
    self: 300,
    kids: [1500, 2300],
    /* 이하 본문 음성 시작 기준 */
    links: 300,
    toNew: [1800, 2500],
    prodN: [3600, 6000],
    fly: [8400, 9300],
    rec: 8700,
    match: 11500,
    expand3: 12100,
    mFloat: [12600, 13100, 13600, 14100],
    linksM: 14800,
    toNewM: 15500,
    prodM: [16000, 17500],
    growN: [19700, 20700],
    capsN: 21700,
    expand4: 23000,
    kFloat: [23500, 23750, 24000, 24250, 24500, 24750, 25000, 25250],
    linksK: 25900,
    growM: 26700,
    capsM: 29700,
    phaseOut: 30800,
    flow: [31200, 34200, 37200, 40200],
    key: 43300
  },

  layout: { anchorZone: 'd4' }
};
</script>
