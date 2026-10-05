<script>
/* guide03 Scene 06 — S.E.P실적으로 BASE사업자 만들기
   패널·본인·파트너·점선만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene06Config = {
  id: 'guide03-scene-06',
  title: 'S.E.P실적으로 BASE사업자 만들기',
  duration: 28000,
  canvasCls: 'g03-scene06-canvas',
  panelCls: 'g03-scene06-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_06_title.mp4' },
      { part: 'main', file: 'guide03_scene_06.mp4' }
    ],
    fallbackMs: [4000, 20000],
    titleMs: 4000
  },

  panel: {
    title: 'S.E.P실적으로 BASE사업자 만들기',
    bullets: [
      '각각 SEP 30만 이상 달성',
      '구성원 모두의 SEP 총 합이 100만 이상'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 6000, index: 1 }
    ]
  },

  T: {
    board: 0,
    self: 760,
    partners: [1600, 2400],
    seps: [0, 1000],
    sum: 6000,
    jumps: [15000, 16000, 17000]
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene06TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene06Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene06AtMain(ms, ctx){
  return guide03Scene06TitleMs(ctx) + ms;
}

function guide03Scene06PanelFlashes(ctx){
  return Guide03Scene06Config.panel.flashes.map(function(f){
    return { at: guide03Scene06AtMain(f.at, ctx), index: f.index };
  });
}
</script>
