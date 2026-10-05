<script>
/* guide03 Scene 07 — 파트너 실적에서 꼭 기억할 점
   유의 뱃지만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene07Config = {
  id: 'guide03-scene-07',
  title: '파트너 실적에서 꼭 기억할 점',
  duration: 28000,
  canvasCls: 'g03-scene07-canvas',
  panelCls: 'g03-scene07-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_07_title.mp4' },
      { part: 'main', file: 'guide03_scene_07.mp4' }
    ],
    fallbackMs: [4000, 19000],
    titleMs: 4000
  },

  panel: {
    title: '파트너 실적에서 꼭 기억할 점',
    bullets: [
      '두 파트너는 모두 동일한 조건 충족 필요'
    ],
    flashes: [
      { at: 0, index: 0 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    partners: [1000, 2000],
    mixed: [6000, 7000],
    ban: 8000,
    clear: 14000,
    toAuto: 15000,
    checkA: 16000,
    clone: 17000,
    toSep: 18000,
    checkB: 19000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene07TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene07Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene07AtMain(ms, ctx){
  return guide03Scene07TitleMs(ctx) + ms;
}

function guide03Scene07PanelFlashes(ctx){
  return Guide03Scene07Config.panel.flashes.map(function(f){
    return { at: guide03Scene07AtMain(f.at, ctx), index: f.index };
  });
}
</script>
