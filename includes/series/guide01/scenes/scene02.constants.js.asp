<script>
/* guide01 Scene 02 — 상수 */
var Scene02Config = {
  id: 'guide01-scene-02',
  title: '오토십의 장점',
  duration: 36503,
  canvasCls: 'scene02-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_02_title.mp4' },
      { part: 'main', file: 'guide01_scene_02.mp4' }
    ],
    fallbackMs: [3103, 33400],
    titleMs: 3103
  },

  panel: {
    title: '오토십의 장점',
    bullets: [
      '25% 할인된 회원가에 추가 20% 할인',
      '제품 경험을 추천으로 연결',
      {
        text: '보상플랜의 기준',
        sub: '캐시백 & 추천포인트 & BASE사업자'
      }
    ],
    flashes: [
      { atMain: 4000, index: 0 },
      { atMain: 15000, index: 1 },
      { atMain: 21000, index: 2 }
    ]
  },

  T: {
    main: {
      foldAutoship: 3000,
      revealRow1: 6000,
      revealRow2: 8000,
      revealRow3: 10000,
      revealRow4: 12000,
      base: 21000,
      cashback: 24000,
      recommend: 27000,
      benefitsCollapse: 30000
    }
  },

  layout: {
    anchorZone: 'd4',
    gaps: {
      autoshipSummaryOverlap: 0,
      autoshipSummaryGap: 5,
      stackGap: 10
    },
    scales: {
      autoship: 1.144,
      summary: 0.82,
      base: 0.88,
      cashback: 0.88,
      recommend: 0.88,
      benefitsBox: 0.82
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    FOLD: { duration: 620 },
    layoutTransition: 480,
    benefitsFlyIn: { duration: 720 }
  }
};

function scene02Motion(preset){
  preset = preset || 'FADE';
  var base = Scene02Config.motion[preset] || Scene02Config.motion.FADE;
  return Object.assign({}, base);
}

function scene02BadgeEnter(extra){
  return Object.assign({}, Scene02Config.motion.POP, Scene02Config.motion.BADGE, extra || {});
}

function scene02TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene02Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene02AtMain(mainMs, ctx){
  return scene02TitleMs(ctx) + mainMs;
}

function scene02PanelFlashes(ctx){
  var off = scene02TitleMs(ctx);
  return Scene02Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
