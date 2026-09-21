<script>
/* guide01 Scene 03 — 어떻게 구독하나요? */
var Scene03Config = {
  id: 'guide01-scene-03',
  title: '어떻게 구독하나요?',
  duration: 29000,
  canvasCls: 'scene03-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_03_title.mp4' },
      { part: 'main', file: 'guide01_scene_03.mp4' }
    ],
    fallbackMs: [3000, 26000],
    titleMs: 3000
  },

  panel: {
    title: '구독 방법',
    bullets: [
      '앨트웰 전 회원 신청 가능',
      '최대 5개 품목 선택',
      '동일 상품 중복 구독 불가'
    ],
    flashes: [
      { atMain: 2000, index: 0 },
      { atMain: 7000, index: 1 },
      { atMain: 13000, index: 2 }
    ]
  },

  T: {
    main: {
      dRank: 2000,
      autoshipAttach: 5000,
      productStart: 7000,
      productStagger: 400,
      duplicateBlock: 12000,
      restoreProducts: 18000
    }
  },

  layout: {
    anchorZone: 'd4',
    productLetters: ['A', 'B', 'C', 'D', 'E'],
    gaps: {
      memberProduct: 24,
      memberProductAutoship: 42,
      productGap: 12,
      stackGap: 10
    },
    scales: {
      member: 1.15,
      autoship: 0.88,
      product: 0.88,
      dRank: 1,
      stamp: 0.72,
      check: 0.85
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    FOLD: { duration: 620 },
    layoutTransition: 480,
    colorPromote: { duration: 520 },
    stack: { duration: 520 },
    check: { duration: 480 }
  }
};

function scene03Motion(preset){
  preset = preset || 'FADE';
  var base = Scene03Config.motion[preset] || Scene03Config.motion.FADE;
  return Object.assign({}, base);
}

function scene03BadgeEnter(extra){
  return Object.assign({}, Scene03Config.motion.POP, Scene03Config.motion.BADGE, extra || {});
}

function scene03TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene03Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene03AtMain(mainMs, ctx){
  return scene03TitleMs(ctx) + mainMs;
}

function scene03PanelFlashes(ctx){
  var off = scene03TitleMs(ctx);
  return Scene03Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
