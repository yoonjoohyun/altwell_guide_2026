<script>
/* guide03 Scene 05 — 오토십으로 BASE사업자 만들기
   파트너 두 명만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene05Config = {
  id: 'guide03-scene-05',
  title: '오토십으로 BASE사업자 만들기',
  duration: 28000,
  canvasCls: 'g03-scene05-canvas',
  panelCls: 'g03-scene05-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_05_title.mp4' },
      { part: 'main', file: 'guide03_scene_05.mp4' }
    ],
    fallbackMs: [4000, 19000],
    titleMs: 4000
  },

  panel: {
    title: '오토십으로 BASE사업자 만들기',
    bullets: [
      '직 1대 파트너 2명 모두 오토십 1개 이상 유지',
      'S.E.P 30만 달성 조건의 부담을 오토십 구독으로 완화'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 8000, index: 1 }
    ]
  },

  T: {
    partners: [0, 800],
    autos: [0, 1000],
    gauge: 7000,
    boxes: [9000, 11000, 13000],
    stable: 15000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene05TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene05Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene05AtMain(ms, ctx){
  return guide03Scene05TitleMs(ctx) + ms;
}

function guide03Scene05PanelFlashes(ctx){
  return Guide03Scene05Config.panel.flashes.map(function(f){
    return { at: guide03Scene05AtMain(f.at, ctx), index: f.index };
  });
}
</script>
