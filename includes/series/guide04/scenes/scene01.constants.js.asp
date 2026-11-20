<script>
/* guide04 Scene 01 — 추천보너스란 무엇일까요?
   badge 만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide04Scene01Config = {
  id: 'guide04-scene-01',
  title: '추천보너스란 무엇일까요?',
  duration: 45000,
  canvasCls: 'g04-scene01-canvas',
  panelCls: 'g04-scene01-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide04_scene_01_title.mp4' },
      { part: 'main', file: 'guide04_scene_01.mp4' }
    ],
    fallbackMs: [2000, 43000],
    titleMs: 2000
  },

  panel: {
    title: '추천보너스란 무엇일까요?',
    bullets: [
      'BASE사업자의 직접 추천 활동을 보상',
      '오토십·스타트팩 이용 시 추천포인트 발생',
      '추천인 본인의 BASE사업자 자격 유지 필수',
      'BASE 유지·추천·제품 이용 지원이 기본 구조'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 },
      { at: 24000, index: 2 },
      { at: 34000, index: 3 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    self: 2000,
    partners: [3000, 4000],
    products: 6000,
    coins: 7800,
    right: 15000,
    deny: 24000,
    base: 28000,
    summary: [30000, 32000, 34000]
  },

  layout: { anchorZone: 'd4' }
};

function guide04Scene01TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide04Scene01Config.media;
  return (media && media.titleMs) || 0;
}

function guide04Scene01AtMain(ms, ctx){
  return guide04Scene01TitleMs(ctx) + ms;
}

function guide04Scene01PanelFlashes(ctx){
  return Guide04Scene01Config.panel.flashes.map(function(f){
    return { at: guide04Scene01AtMain(f.at, ctx), index: f.index };
  });
}
</script>
