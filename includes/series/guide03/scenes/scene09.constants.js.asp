<script>
/* guide03 Scene 09 — BASE사업자를 늘려야 하는 이유
   멤버 등장만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene09Config = {
  id: 'guide03-scene-09',
  title: 'BASE사업자를 늘려야 하는 이유',
  duration: 29000,
  canvasCls: 'g03-scene09-canvas',
  panelCls: 'g03-scene09-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_09_title.mp4' },
      { part: 'main', file: 'guide03_scene_09.mp4' }
    ],
    fallbackMs: [3000, 26000],
    titleMs: 3000
  },

  panel: {
    title: 'BASE사업자를 늘려야 하는 이유',
    bullets: [
      '개인 활동보다 파트너와 함께하여 체계적이고 안정적인 조직 확장'
    ],
    flashes: [
      { at: 0, index: 0 }
    ]
  },

  T: {
    member: 0,
    row2: [0, 1000],
    selfJump: 2000,
    row3: [9000, 10000],
    row2Jump: 11000,
    row4: [12000, 13000],
    row3Jump: 14000,
    arrow: 22000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene09TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene09Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene09AtMain(ms, ctx){
  return guide03Scene09TitleMs(ctx) + ms;
}

function guide03Scene09PanelFlashes(ctx){
  return Guide03Scene09Config.panel.flashes.map(function(f){
    return { at: guide03Scene09AtMain(f.at, ctx), index: f.index };
  });
}
</script>
