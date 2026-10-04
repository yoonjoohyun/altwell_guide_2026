<script>
/* guide03 Scene 03 — BASE사업자 본인 조건
   본인·접힌 뱃지만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene03Config = {
  id: 'guide03-scene-03',
  title: 'BASE사업자 본인 조건',
  duration: 24000,
  canvasCls: 'g03-scene03-canvas',
  panelCls: 'g03-scene03-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_03_title.mp4' },
      { part: 'main', file: 'guide03_scene_03.mp4' }
    ],
    fallbackMs: [4000, 16000],
    titleMs: 4000
  },

  panel: {
    title: 'BASE사업자 본인 조건',
    bullets: [
      '매월 S.E.P 30만 이상 달성',
      '오토십 1개 이상 유지',
      'S.E.P 실적에 오토십 필수 포함'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 4000, index: 1 },
      { at: 9000, index: 2 }
    ]
  },

  T: {
    member: 0,
    badge: 720,
    circle: 0,
    autoship: 1000,
    merge: 9000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene03TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene03Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene03AtMain(ms, ctx){
  return guide03Scene03TitleMs(ctx) + ms;
}

function guide03Scene03PanelFlashes(ctx){
  return Guide03Scene03Config.panel.flashes.map(function(f){
    return { at: guide03Scene03AtMain(f.at, ctx), index: f.index };
  });
}
</script>
