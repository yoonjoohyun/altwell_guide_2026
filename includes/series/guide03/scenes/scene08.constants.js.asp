<script>
/* guide03 Scene 08 — BASE사업자 자격과 보상
   베이스 사업자 뱃지만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene08Config = {
  id: 'guide03-scene-08',
  title: 'BASE사업자 자격과 보상',
  duration: 32000,
  canvasCls: 'g03-scene08-canvas',
  panelCls: 'g03-scene08-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_08_title.mp4' },
      { part: 'main', file: 'guide03_scene_08.mp4' }
    ],
    fallbackMs: [4000, 24000],
    titleMs: 4000
  },

  panel: {
    title: 'BASE사업자 자격과 보상',
    bullets: [
      '각종 보너스 수혜의 기본 조건',
      '2TRACK 승급 조건에 활용',
      '보상과 승급을 연결하는 사업의 핵심 기반'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 12000, index: 1 },
      { at: 18000, index: 2 }
    ]
  },

  T: {
    badge: 0,
    bonuses: [5000, 6000, 7000],
    track: 13000,
    gather: 18000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene08TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene08Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene08AtMain(ms, ctx){
  return guide03Scene08TitleMs(ctx) + ms;
}

function guide03Scene08PanelFlashes(ctx){
  return Guide03Scene08Config.panel.flashes.map(function(f){
    return { at: guide03Scene08AtMain(f.at, ctx), index: f.index };
  });
}
</script>
