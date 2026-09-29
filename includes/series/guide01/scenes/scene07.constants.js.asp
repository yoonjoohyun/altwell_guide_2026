<script>
/* guide01 Scene 07 — 오토십 핵심 요약
   시나리오 시각은 타이틀 음성을 포함한 재생 시작 기준(절대 ms) */
var Scene07Config = {
  id: 'guide01-scene-07',
  title: '오토십, 이것만 기억하세요',
  duration: 54000,
  canvasCls: 'scene07-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_07_title.mp4' },
      { part: 'main', file: 'guide01_scene_07.mp4' }
    ],
    fallbackMs: [3000, 49000],
    titleMs: 3000
  },

  panel: {
    title: '오토십 핵심 요약',
    bullets: [
      '3개월 정기 구독 서비스',
      '25%할인된 회원가에 추가 20% 할인',
      '일괄 배송·결제, E.P는 3회 분할 지급',
      '추천포인트 발생 및 BASE사업자 달성',
      '제품 경험 기반의 비즈니스 연결 시스템'
    ],
    flashes: [
      { at: 4000, index: 0 },
      { at: 9000, index: 1 },
      { at: 18000, index: 2 },
      { at: 24000, index: 3 },
      { at: 33000, index: 4 }
    ]
  },

  T: {
    badge: 0,
    calendar: 1000,
    discount: 8000,
    delivery: 18000,
    ep: 21000,
    recommend: 24000,
    cashback: 24700,
    base: 28000,
    summary: 33000,
    summaryLines: [33600, 35800, 38000],
    outro: 45000,
    simButton: 46200,
    replayButton: 47800
  },

  layout: {
    anchorZone: 'd4',
    gaps: { stackGap: 14, rowGap: 16 },
    minFit: 0.42
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    layoutTransition: 480
  },

  links: {
    simulator: '/sim.asp'
  }
};

function scene07Motion(preset){
  preset = preset || 'FADE';
  var base = Scene07Config.motion[preset] || Scene07Config.motion.FADE;
  return Object.assign({}, base);
}

function scene07BadgeEnter(extra){
  return Object.assign({}, Scene07Config.motion.POP, Scene07Config.motion.BADGE, extra || {});
}

function scene07PanelFlashes(){
  return Scene07Config.panel.flashes.map(function(f){
    return { at: f.at, index: f.index };
  });
}
</script>
