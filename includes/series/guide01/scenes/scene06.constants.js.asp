<script>
/* guide01 Scene 06 — 구독 중 추가·변경·해지 */
var Scene06Config = {
  id: 'guide01-scene-06',
  title: '구독 중 추가·변경·해지',
  duration: 32000,
  canvasCls: 'scene06-canvas',

  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_06_title.mp4' },
      { part: 'main', file: 'guide01_scene_06.mp4' }
    ],
    fallbackMs: [4000, 24000],
    titleMs: 4000
  },

  panel: {
    title: '추가·변경·해지',
    bullets: [
      '최대 5품목 다른 상품 구독 가능',
      '동일 상품 중복 및 상품 변경 불가',
      '해지 시 4개월 차 자동결제부터 중단'
    ],
    flashes: [
      { atMain: 1000, index: 0 },
      { atMain: 5000, index: 1 },
      { atMain: 15000, index: 2 }
    ]
  },

  T: {
    title: {
      dRank: 1500,
      autoshipAttach: 3000,
      productA: 3800
    },
    main: {
      addBcde: 0,
      duplicateRow: 5000,
      swapPanel: 9000,
      cancelFlow: 15000,
      holdFloat: 22000
    }
  },

  layout: {
    anchorZone: 'd4',
    productLetters: ['A', 'B', 'C', 'D', 'E'],
    duplicateLetters: ['A', 'A', 'A', 'A', 'E'],
    gaps: {
      memberContent: 24,
      memberProductAutoship: 42,
      sectionGap: 14,
      productGap: 10,
      stackGap: 10
    },
    scales: {
      member: 1.15,
      autoship: 0.88,
      product: 0.88,
      dRank: 1,
      stamp: 0.72,
      calendar: 1,
      minFit: 0.4
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    FOLD: { duration: 620 },
    layoutTransition: 480,
    colorPromote: { duration: 520 },
    unavailable: { duration: 520 },
    productStagger: 320
  }
};

function scene06Motion(preset){
  preset = preset || 'FADE';
  var base = Scene06Config.motion[preset] || Scene06Config.motion.FADE;
  return Object.assign({}, base);
}

function scene06BadgeEnter(extra){
  return Object.assign({}, Scene06Config.motion.POP, Scene06Config.motion.BADGE, extra || {});
}

function scene06TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene06Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene06AtMain(mainMs, ctx){
  return scene06TitleMs(ctx) + mainMs;
}

function scene06AtTitle(titleMs, ctx){
  return titleMs;
}

function scene06PanelFlashes(ctx){
  var off = scene06TitleMs(ctx);
  return Scene06Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
