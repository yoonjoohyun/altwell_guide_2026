<script>
/* guide03 Scene 04 — 파트너 2명의 조건
   히어로 파트너와 조건 문구만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene04Config = {
  id: 'guide03-scene-04',
  title: '파트너 2명의 조건',
  duration: 42000,
  canvasCls: 'g03-scene04-canvas',
  panelCls: 'g03-scene04-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_04_title.mp4' },
      { part: 'main', file: 'guide03_scene_04.mp4' }
    ],
    fallbackMs: [5000, 34000],
    titleMs: 5000
  },

  panel: {
    title: '파트너 2명의 조건',
    bullets: [
      'GEP라인 + 직1대 디슈머',
      '파트너 각각 오토십 1개 이상 유지',
      '파트너 각각 S.E.P 30만 이상 달성',
      '파트너가 FC승급 시 파트너 자격 상실'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 10000, index: 1 },
      { at: 15000, index: 2 },
      { at: 28000, index: 3 }
    ]
  },

  T: {
    hero: 0,
    heroNote: 1000,
    panelA: 0,
    ranks: [700, 1300, 1900, 2500],
    gepLine: 3500,
    clear: 7000,
    panel1: 8000,
    pair1: 8600,
    autos: [10000, 11000],
    panel2: 16000,
    pair2: 16600,
    seps: 17600,
    tracks: [21000, 22000],
    promote: 28000,
    exit: 29000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene04TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene04Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene04AtMain(ms, ctx){
  return guide03Scene04TitleMs(ctx) + ms;
}

function guide03Scene04PanelFlashes(ctx){
  return Guide03Scene04Config.panel.flashes.map(function(f){
    return { at: guide03Scene04AtMain(f.at, ctx), index: f.index };
  });
}
</script>
