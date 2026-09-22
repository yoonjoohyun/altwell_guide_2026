<script>
/* guide01 Scene 04 — 결제와 배송 */
var Scene04Config = {
  id: 'guide01-scene-04',
  title: '결제와 배송',
  duration: 33000,
  canvasCls: 'scene04-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_04_title.mp4' },
      { part: 'main', file: 'guide01_scene_04.mp4' }
    ],
    fallbackMs: [3000, 30000],
    titleMs: 3000
  },

  panel: {
    title: '결제와 배송',
    bullets: [
      '3개월분 일괄 결제 및 배송',
      '카드사 할부 가능',
      '4개월 차 3개월 단위 자동 갱신'
    ],
    flashes: [
      { atMain: 2000, index: 0 },
      { atMain: 9000, index: 1 },
      { atMain: 17000, index: 2 }
    ]
  },

  T: {
    main: {
      autoship: 0,
      paymentBox: 1000,
      paymentTap: 3000,
      delivery: 5000,
      installment: 8000,
      splitLayout: 11000,
      calendarSteps: 13000,
      renewArrow: 18000,
      renewCalendar: 20000,
      mergeSummary: 23000,
      finalCompare: 27000
    }
  },

  layout: {
    anchorZone: 'd4',
    gaps: {
      autoshipPayment: 18,
      calendarRenew: 14,
      stackGap: 12,
      payDelGap: 16
    },
    offsets: {
      calendarWrap: { y: 40 }
    },
    scales: {
      autoship: 1,
      paymentBox: 1,
      deliveryBox: 1,
      deliveryProduct: 1,
      calendar: 1,
      renewWrap: 1,
      summary: 1,
      minFit: 0.42
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    layoutTransition: 480,
    connector: { duration: 700 },
    cardTap: { duration: 680 },
    deliveryStack: { stagger: 140, fadeDuration: 420 },
    deliveryLoop: { floatHold: 360, slideDuration: 360, cycleGap: 2000 },
    installment: { duration: 480 },
    calendarStep: { duration: 420, stagger: 380 },
    merge: { duration: 620 },
    compare: { duration: 520 }
  }
};

function scene04Motion(preset){
  preset = preset || 'FADE';
  var base = Scene04Config.motion[preset] || Scene04Config.motion.FADE;
  return Object.assign({}, base);
}

function scene04BadgeEnter(extra){
  return Object.assign({}, Scene04Config.motion.POP, Scene04Config.motion.BADGE, extra || {});
}

function scene04TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene04Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene04AtMain(mainMs, ctx){
  return scene04TitleMs(ctx) + mainMs;
}

function scene04PanelFlashes(ctx){
  var off = scene04TitleMs(ctx);
  return Scene04Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
