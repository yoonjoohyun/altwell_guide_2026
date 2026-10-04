<script>
/* guide03 Scene 01 — BASE사업자란?
   badge 만 타이틀 음성 시작 기준.
   그 외 시각은 본문 음성 시작 기준이며, 재생 시 titleMs를 더한다. */
var Guide03Scene01Config = {
  id: 'guide03-scene-01',
  title: 'BASE사업자란?',
  duration: 28000,
  canvasCls: 'g03-scene01-canvas',
  panelCls: 'g03-scene01-panel',

  media: {
    sequence: [
      { part: 'title', file: 'guide03_scene_01_title.mp4' },
      { part: 'main', file: 'guide03_scene_01.mp4' }
    ],
    fallbackMs: [2000, 24000],
    titleMs: 2000
  },

  panel: {
    title: 'BASE사업자란?',
    bullets: [
      '본인 포함 3명으로 구성된 앨트웰 비즈니스의 기본 단위',
      '다양한 보상과 승급을 위한 기본 조건'
    ],
    flashes: [
      { at: 0, index: 0 },
      { at: 13000, index: 1 }
    ]
  },

  T: {
    badge: 0,
    board: 0,
    members: [3000, 4200, 5400],
    self: 8000,
    partners: 10000,
    unit: 13000,
    bonus: 17000,
    rank: 19000
  },

  layout: { anchorZone: 'd4' }
};

function guide03Scene01TitleMs(ctx){
  if(ctx && ctx.mediaTitleMs > 0) return ctx.mediaTitleMs;
  var media = Guide03Scene01Config.media;
  return (media && media.titleMs) || 0;
}

function guide03Scene01AtMain(ms, ctx){
  return guide03Scene01TitleMs(ctx) + ms;
}

function guide03Scene01PanelFlashes(ctx){
  return Guide03Scene01Config.panel.flashes.map(function(f){
    return { at: guide03Scene01AtMain(f.at, ctx), index: f.index };
  });
}
</script>
