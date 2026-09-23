<script>
/* guide01 Scene 05 — E.P와 추천포인트 발생 */
var Scene05Config = {
  id: 'guide01-scene-05',
  title: 'E.P와 추천포인트 발생',
  duration: 39100,
  canvasCls: 'scene05-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_05_title.mp4' },
      { part: 'main', file: 'guide01_scene_05.mp4' }
    ],
    fallbackMs: [4000, 35100],
    titleMs: 4000
  },

  panel: {
    title: 'E.P와 추천포인트 발생',
    bullets: [
      'E.P는 3개월간 매월 분할 발생',
      '발생 E.P에 따른 캐시백 매월 분할 지급',
      '추천포인트는 회원 1인당 매월 1Point'
    ],
    flashes: [
      { atMain: 7100, index: 0 },
      { atMain: 21100, index: 1 },
      { atMain: 28100, index: 2 }
    ]
  },

  T: {
    title: {
      intro: 0
    },
    main: {
      paymentTap: 0,
      denyEp: 4100,
      calendarLayout: 7100,
      epDistribute: 8100,
      monthBadge: 12100,
      cashback: 14100,
      memberSide: 18100,
      memberProducts: 22100,
      productDeny: 25100,
      dualCompare: 29100,
      multiProductBracket: 31100,
      summary: 33100,
      holdFloat: 35100
    }
  },

  layout: {
    anchorZone: 'd4',
    calendarMonths: ['1개월 차', '2개월 차', '3개월 차'],
    gaps: {
      introPayEp: 16,
      calendarRow: 14,
      calendarTight: 8,
      stackGap: 12,
      memberProduct: 10,
      dualGroup: 24,
      productGap: 10
    },
    scales: {
      payment: 1,
      paymentMini: 0.72,
      epCoin: 0.88,
      calendar: 0.82,
      cashback: 0.78,
      member: 1.05,
      product: 0.82,
      pointBadge: 0.85,
      summary: 0.92,
      minFit: 0.42
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    layoutTransition: 480,
    cardTap: { duration: 680, paymentFloatHold: 360, paymentFade: 200 },
    paymentCoin: { popDuration: 420 },
    epStack: {
      overlap: 10,
      riseDuration: 680,
      riseOffset: -28
    },
    epFly: { duration: 620, stagger: 280 },
    calendarTight: { duration: 520 },
    cashback: { stagger: 380, connectorDuration: 480 },
    pointAttempt: { duration: 420, stagger: 160 },
    summaryEmphasis: { scalePeak: 1.18, duration: 680 }
  }
};

function scene05Motion(preset){
  preset = preset || 'FADE';
  var base = Scene05Config.motion[preset] || Scene05Config.motion.FADE;
  return Object.assign({}, base);
}

function scene05BadgeEnter(extra){
  return Object.assign({}, Scene05Config.motion.POP, Scene05Config.motion.BADGE, extra || {});
}

function scene05TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene05Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene05AtMain(mainMs, ctx){
  return scene05TitleMs(ctx) + mainMs;
}

function scene05PanelFlashes(ctx){
  var off = scene05TitleMs(ctx);
  return Scene05Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
