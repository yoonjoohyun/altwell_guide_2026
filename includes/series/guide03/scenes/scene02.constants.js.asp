<script>
/* guide03 Scene 02 — BASE사업자의 기본 구성
   패널·구성 문구만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene02Config = {
  id: 'guide03-scene-02',
  title: 'BASE사업자의 기본 구성',
  duration: 30000,
  canvasCls: 'g03-scene02-canvas',
  panelCls: 'g03-scene02-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_02_title.mp4' },
      { part: 'main', file: 'guide03_scene_02.mp4' }
    ],
    fallbackMs: [3000, 23000],
    titleMs: 3000
  },

  panel: {
    title: 'BASE사업자의 기본 구성',
    bullets: [
      '본인과 직 1대 파트너 2명 구성',
      '특정 지위가 아닌 기본 사업자 자격',
      '매월 조건을 충족하며 자격 유지'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 7000, index: 1 },
      { at: 17000, index: 2 }
    ]
  },

  T: {
    board: 0,
    caption: 760,
    members: [0, 900, 1800],
    badge: 6000,
    fold: 8000,
    checks: [12000, 13000],
    selfCheck: 14000,
    move: 15000,
    month: 19000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene02TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene02Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene02AtMain(ms, ctx){
  return guide03Scene02TitleMs(ctx) + ms;
}

function guide03Scene02PanelFlashes(ctx){
  return Guide03Scene02Config.panel.flashes.map(function(f){
    return { at: guide03Scene02AtMain(f.at, ctx), index: f.index };
  });
}
</script>
