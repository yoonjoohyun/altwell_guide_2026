<script>
/* guide01 Scene 05 — E.P와 추천포인트 발생 */
var Scene05Config = {
  id: 'guide01-scene-05',
  title: 'E.P와 추천포인트 발생',
  duration: 42600,
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
      { atMain: 2000, index: 0 },
      { atMain: 12000, index: 1 },
      { atMain: 27000, index: 2 }
    ]
  },

  T: {
    title: {
      autoship: 0,
      paymentAfterAutoship: 120
    },
    main: {
      paymentTap: 0,
      epStackRise: 2700,
      denyEp: 4100,
      calendarLayout: 7100,
      epDistribute: 8100,
      monthBadge: 12100,
      cashback: 14100,
      memberProducts: 25600,
      productDeny: 28600,
      dualCompare: 32600,
      multiProductBracket: 34600,
      summary: 36600,
      holdFloat: 38600
    }
  },

  layout: {
    anchorZone: 'd4',
    calendarMonths: ['1개월 차', '2개월 차', '3개월 차'],
    gaps: {
      introAutoshipPayment: 12,
      introPayEp: 16,
      calendarRow: 14,
      calendarTight: 8,
      stackGap: 12,
      memberProduct: 44,
      dualGroup: 24,
      productGap: 10
    },
    scales: {
      autoship: 0.88,
      payment: 1,
      epCoin: 0.88,
      calendar: 0.82,
      cashback: 0.936,
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
      riseDuration: 820,
      risePeak: 26,
      riseSettle: 12,
      floatAfterPayment: 1000,
      enterDuration: 520,
      enterStagger: 90
    },
    epFly: { duration: 720, stagger: 240 },
    calendarTight: { duration: 520 },
    benefitReveal: { fadeDuration: 480, stagger: 420 },
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
