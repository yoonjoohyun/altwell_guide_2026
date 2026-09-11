<script>
/* guide01 Scene 01 — 상수 */
var Scene01Config = {
  id: 'guide01-scene-01',
  title: '오토십이란?',
  duration: 31131,
  canvasCls: 'scene01-canvas',

  /* voice/guide_season01/guide01/ — title → main 순차 재생 */
  media: {
    sequence: [
      { part: 'title', file: 'guide01_scene_01_title.mp4' },
      { part: 'main', file: 'guide01_scene_01.mp4' }
    ],
    fallbackMs: [2169, 28962],
    titleMs: 2169
  },

  panel: {
    title: '오토십이란?',
    bullets: [
      '3개월 정기 구독 서비스',
      '추가 할인으로 합리적인 제품 경험',
      '캐시백 및 추천 보너스 연계',
      'BASE사업자 & 중요한 비즈니스 기반'
    ],
    /* atMain — 본문 음성 기준(ms), 절대 시각 = titleMs + atMain */
    flashes: [
      { atMain: 2000, index: 0 },
      { atMain: 7000, index: 1 },
      { atMain: 15400, index: 2 },
      { atMain: 23000, index: 3 }
    ]
  },

  /* main — 본문 음성 시작(= titleMs) 기준 모션 타이밍 */
  T: {
    main: {
      autoship: 0,
      calendar: 3000,
      discount: 8000,
      plus: 9300,
      cashback: 11500,
      plusRecommend: 13300,
      recommend: 15200,
      base: 22000
    }
  },

  /* 7×7 — 그룹 앵커(d4)만 사용, 개별 에셋 zone 미사용 */
  layout: {
    anchorZone: 'd4',
    calendarZone: 'd5',
    gaps: {
      memberToAutoship: 2,
      autoshipToBenefit: 6,
      autoshipToBase: 6,
      memberHeadRatio: 0.37,
      memberOverlapAutoship: 2,
      benefitRowGap: 10
    },
    scales: {
      member: 1.5,
      calendar: 0.88,
      autoship: 0.88,
      plus: 0.78,
      discount: 0.88,
      cashback: 0.88,
      recommend: 0.88,
      base: 0.88
    }
  },

  motion: {
    FADE: { duration: 420 },
    POP: { pop: true, duration: 520 },
    DROP: { coinDrop: true, duration: 520 },
    BADGE: { unfoldDuration: 620 },
    relayoutAfterBadge: 400
  }
};

function scene01Motion(preset){
  preset = preset || 'FADE';
  var base = Scene01Config.motion[preset] || Scene01Config.motion.FADE;
  return Object.assign({}, base);
}

function scene01BadgeEnter(extra){
  return Object.assign({}, Scene01Config.motion.POP, Scene01Config.motion.BADGE, extra || {});
}

function scene01TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Scene01Config.media;
  if(media.titleMs > 0) return media.titleMs;
  var fb = media.fallbackMs;
  return (fb && fb[0]) || 0;
}

function scene01AtMain(mainMs, ctx){
  return scene01TitleMs(ctx) + mainMs;
}

function scene01PanelFlashes(ctx){
  var off = scene01TitleMs(ctx);
  return Scene01Config.panel.flashes.map(function(f){
    return { at: off + f.atMain, index: f.index };
  });
}

</script>
